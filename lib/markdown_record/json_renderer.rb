require "redcarpet"
require "redcarpet/render_strip"

module MarkdownRecord
  class JsonRenderer
    include ::MarkdownRecord::PathUtilities
    include ::MarkdownRecord::ContentDsl

    def initialize(file_saver: ::MarkdownRecord::FileSaver.new, indexer: ::MarkdownRecord.config.indexer_class.new)
      @indexer = indexer
      @json_models = {}
      @described_models = []
      @file_saver = file_saver
    end

    def render_models_for_subdirectory(subdirectory: "", **options)
      content = @indexer.index(subdirectory: subdirectory)
      json_hash, _ = render_models_recursively(subdirectory, content, subdirectory, options)

      save_content_recursively(json_hash, options)
      json_hash
    end

    def render_models_for_file(file_path:, **options)
      file = @indexer.file(file_path)
      
      # render json models
      json = render_models(file, file_path, options)
      
      # save json
      @file_saver.save_to_file(json.to_json, "#{clean_path(file_path)}.json", options)
      
      json
    end

  private

    def render_models_recursively(file_or_directory_name, file_or_directory, full_path, options)
      case file_or_directory.class.name;
      when Hash.name # if it is a directory
        directory_hash, concat_hash = *render_nested_models(file_or_directory, file_or_directory_name, full_path, options)
        
        # concatenate child hashes if :concat = true
        if options[:concat]
          concatenate_nested_models(file_or_directory_name, full_path, directory_hash, concat_hash, options)
        end

        [directory_hash, concat_hash]
      when String.name # if it is a file
        content = render_models(file_or_directory, full_path, options)

        if options[:deep] && options[:render_content_fragment_json]
          add_content_fragment_for_file(content, full_path)
        end

        content_hash = { file_or_directory_name => content }
        result = [{}, {}]
        result[0] = content_hash if options[:deep]
        result[1] = content_hash if options[:concat]
        result
      end
    end

    def render_nested_models(file_or_directory, file_or_directory_name, full_path, options)
      directory_hash = { file_or_directory_name => {} } # hash representing the directory and its contents
      concat_hash = { file_or_directory_name => {} }
      # iterate through directory contents
      file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
        
        # get full path for next recursion
        child_full_path = "#{full_path}/#{child_file_or_directory_name}"

        # get response from next recursion
        child_content_hash, child_concat_hash = render_models_recursively(
                                                  child_file_or_directory_name, 
                                                  child_file_or_directory, 
                                                  child_full_path, 
                                                  options
                                                )
        # merge response hashes                                                  
        concat_hash[file_or_directory_name].merge!(child_concat_hash)
        directory_hash[file_or_directory_name].merge!(child_content_hash)
      end

      [directory_hash, concat_hash]
    end

    def concatenate_nested_models(file_or_directory_name, full_path, directory_hash, concat_hash, options)
      concatenated_json = {}
          
      # add content fragments if render_content_fragment_json = true
      if options[:render_content_fragment_json]
        add_content_fragment_for_file(concat_hash[file_or_directory_name], full_path)
      end

      concatenate_json_recursively(concat_hash, concatenated_json)
      directory_hash["#{file_or_directory_name}.concat"] = concatenated_json
    end

    def render_models(content, full_path, options)
      
      @filename, @subdirectory = full_path_to_parts(full_path)

      @described_models = []
      @json_models = {}
      @fragment_meta = {}

      content.split(HTML_COMMENT_REGEX).each do |text|
        extract_describe_model(text)
        extract_fragment_meta(text)
        extract_describe_model_attribute(text)
        append_to_describe_model_attribute(text)
        pop_describe_model_attribute(text)
        pop_describe_model(text)
      end

      @described_models.each do |model|
        finalize_describe_attribute(model)
      end

      @json_models.dup
    end

    def add_content_fragment_for_file(json, full_path)
      content_fragment = fragment_attributes_path(full_path).merge("meta" => @fragment_meta)

      json["MarkdownRecord::ContentFragment"] ||= []
      json["MarkdownRecord::ContentFragment"] << content_fragment
    end

    def concatenate_json_recursively(directory_hash, concatenated_json)
      directory_hash.each do |key, value|
        case value.class.name
        when Hash.name
          concatenate_json_recursively(value, concatenated_json)
        when Array.name
          concatenated_json[key] ||= []
          concatenated_json[key] += value
        end
      end
    end

    def save_content_recursively(content, options, subdirectory = "")
      if content&.values&.first.is_a?(Array)
        fragments = content.slice("MarkdownRecord::ContentFragment")
        non_fragments = content.except("MarkdownRecord::ContentFragment")
        path = clean_path(subdirectory)
        binding.pry
        @file_saver.save_to_file(non_fragments.to_json, "#{path}.json", options)
        @file_saver.save_to_file(fragments.to_json, "#{path}.json", options, true)
      else
        content.each do |key, value|
          child_path = Pathname.new(subdirectory).join(key)
          save_content_recursively(value, options, child_path)
        end
      end
    end

    def extract_describe_model(html)
      model = describe_model_dsl(html)

      if model
        return unless model["type"].present?

        model["subdirectory"] = clean_path(@subdirectory)
        model["filename"] = clean_path(@filename)

        # reset "type" to not have a prefix, in order to ensure
        # consistent results between the internal only :klass filter
        # which is used as an index in a hash (and has the prefix removed 
        # for consistency and deterministic behavior)
        # and the externally filterable :type field.
        model["type"] = model["type"].delete_prefix("::").strip
        
        @json_models[model["type"]] ||= []
        @json_models[model["type"]] << model
  
        @described_models.push(model)
      end
    end

    def extract_fragment_meta(html)
      meta = fragment_dsl(html)

      if meta
        @fragment_meta = meta
      end
    end

    def extract_describe_model_attribute(text)
      attribute, type = describe_model_attribute_dsl(text)
      type ||= "md"

      if @described_models.last && attribute
        model = @described_models.last
        model[:described_attribute_type] = type
        model[:described_attribute] = attribute
        model[model[:described_attribute]] = []
      end
    end

    def append_to_describe_model_attribute(text)
      return if text.match(HTML_COMMENT_REGEX)

      @described_models.each do |model|
        next unless model[:described_attribute].present?

        model[model[:described_attribute]] ||= []
        model[model[:described_attribute]] << text
      end
    end

    def pop_describe_model_attribute(text)
      if @described_models.last && end_describe_model_attribute_dsl(text)
        finalize_describe_attribute(@described_models.last)
      end
    end

    def pop_describe_model(html)      
      if end_describe_model_dsl(html)
        @described_models.pop
      end
    end

    def finalize_describe_attribute(model)
      return if model[:described_attribute].nil?

      attribute_name = model.delete(:described_attribute)
      attribute = model[attribute_name].join("\n")
      type = model.delete(:described_attribute_type)

      case type
      when "html"
        renderer = Redcarpet::Render::HTML.new
        attribute = Redcarpet::Markdown.new(renderer).render(attribute)
      when "md"
        attribute = attribute.strip
      when "int"
        attribute = attribute.strip.gsub("\n", "").to_i
      when "float"
        attribute = attribute.strip.gsub("\n", "").to_f
      when "string"
        attribute = Redcarpet::Markdown.new(::Redcarpet::Render::StripDown).render(attribute).strip
      end

      model[attribute_name] = attribute
    end
  end
end