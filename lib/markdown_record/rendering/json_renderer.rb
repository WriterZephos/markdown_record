require "redcarpet"
require "redcarpet/render_strip"

module MarkdownRecord
  class JsonRenderer
    include ::MarkdownRecord::PathUtilities
    include ::MarkdownRecord::ContentDsl

    def initialize(file_saver: ::MarkdownRecord::FileSaver.new)
      @indexer = MarkdownRecord::Indexer.new
      @json_models = {}
      @described_models = []
      @file_saver = file_saver
    end

    def render_models_for_subdirectory(subdirectory: "", **options)
      @directory_meta = {}
      content = @indexer.index(subdirectory: subdirectory)
      
      opts = options.merge(:concat_top_level => MarkdownRecord.config.always_concatenate_json)
      rendered_subdirectory = base_content_root_name.join(subdirectory)
      json_hash, _ = render_models_recursively(content, rendered_subdirectory, opts, true)

      save_content_recursively(json_hash, opts, Pathname.new(""))
      json_hash
    end

  private

    def render_models_recursively(file_or_directory, full_path, options, top_level = false)
      case file_or_directory.class.name;
      when Hash.name # if it is a directory
        directory_hash, concat_hash = *render_nested_models(file_or_directory, full_path, options)

        # concatenate child hashes if :concat = true or we are at top level
        if options[:concat] || (options[:concat_top_level] && top_level)
          concatenate_nested_models(full_path, directory_hash, concat_hash, options)
        end

        if !options[:concat] && (options[:concat_top_level] && top_level)
          directory_hash = directory_hash.select { |f| f.include?(".concat") }
        end

        [directory_hash, concat_hash]
      when String.name # if it is a file
        content = render_models(file_or_directory, full_path, options)

        if options[:deep] && options[:render_content_fragment_json]
          add_content_fragment_for_file(content, full_path, false, @fragment_meta)
        end

        content_hash = { full_path.basename.to_s => content }
        result = [{}, {}]
        result[0] = content_hash if options[:deep]
        result[1] = content_hash if (options[:concat] || options[:concat_top_level])
        result
      end
    end

    def render_nested_models(file_or_directory, full_path, options)
      directory_hash = { full_path.basename.to_s => {} } # hash representing the directory and its contents
      concat_hash = { full_path.basename.to_s => {} }
      # iterate through directory contents
      file_or_directory.each do |child_file_or_directory_name, child_file_or_directory|
        
        # get full path for next recursion
        child_full_path = full_path.join(child_file_or_directory_name)
        # get response from next recursion
        child_content_hash, child_concat_hash = render_models_recursively(
                                                  child_file_or_directory, 
                                                  child_full_path, 
                                                  options
                                                )
        # merge response hashes                                                  
        concat_hash[full_path.basename.to_s].merge!(child_concat_hash)
        directory_hash[full_path.basename.to_s].merge!(child_content_hash)
      end

      [directory_hash, concat_hash]
    end

    def concatenate_nested_models(full_path, directory_hash, concat_hash, options)
      concatenated_json = {}
      concatenate_json_recursively(concat_hash, concatenated_json)
 
      # add content fragments if render_content_fragment_json = true
      if options[:render_content_fragment_json]
        filename, subdirectory = full_path_to_parts(full_path)
        directory_meta = @directory_meta[clean_path("#{subdirectory}/#{filename}")] || {}

        add_content_fragment_for_file(concat_hash[full_path.basename.to_s], full_path, true, directory_meta)
        add_content_fragment_for_file(concatenated_json, full_path, true, directory_meta)
      end

      directory_hash["#{full_path.basename.to_s}.concat"] = concatenated_json
    end

    def render_models(content, full_path, options)
      
      filename, subdirectory = full_path_to_parts(full_path)

      @described_models = []
      @json_models = {}
      @fragment_meta = {}
      enabled = true

      content.split(HTML_COMMENT_REGEX).each do |text|
        dsl_command = HTML_COMMENT_REGEX =~ text

        if dsl_command 
          enabled = false if disable_dsl(text)
          enabled = true if enable_dsl(text)
        end

        if dsl_command && enabled
          extract_model(text, filename, subdirectory)
          extract_fragment_meta(text, subdirectory)
          extract_attribute(text)
          pop_attribute(text)
          pop_model(text)
        else
          append_to_attribute(text) 
        end
      end

      @described_models.each do |model|
        finalize_attribute(model)
      end

      @json_models.dup
    end

    def add_content_fragment_for_file(json, full_path, concatenated, meta)
      content_fragment = fragment_attributes_from_path(full_path).merge("meta" => meta, "concatenated" => concatenated)

      json["markdown_record/content_fragment"] ||= []
      json["markdown_record/content_fragment"] << content_fragment
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

    def save_content_recursively(content, options, rendered_subdirectory)
      if content&.values&.first.is_a?(Array)
        fragments = content.slice("markdown_record/content_fragment")
        non_fragments = content.except("markdown_record/content_fragment")
        path = clean_path(rendered_subdirectory.to_s)
        @file_saver.save_to_file(non_fragments.to_json, "#{path}.json", options)
        @file_saver.save_to_file(fragments.to_json, "#{path}.json", options, true)
      else
        content.each do |key, value|
          child_path = rendered_subdirectory.join(key)
          save_content_recursively(value, options, child_path)
        end
      end
    end

    def extract_model(html, filename, subdirectory)
      model = model_dsl(html)

      if model
        return unless model["type"].present?

        model["subdirectory"] = clean_path(subdirectory)
        model["filename"] = clean_path(filename)

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

    def extract_fragment_meta(html, subdirectory)
      meta = fragment_dsl(html)

      if meta
        @fragment_meta = meta
      end

      directory_meta = directory_fragment_dsl(html)

      if directory_meta
        @directory_meta[subdirectory] = directory_meta
      end
    end

    def extract_attribute(text)
      attribute, type = attribute_dsl(text)
      type ||= "md"

      if @described_models.last && attribute
        model = @described_models.last
        model[:described_attribute_type] = type
        model[:described_attribute] = attribute
        model[model[:described_attribute]] = []
      end
    end

    def append_to_attribute(text)
      return if text.match(HTML_COMMENT_REGEX)

      @described_models.each do |model|
        next unless model[:described_attribute].present?

        model[model[:described_attribute]] ||= []
        model[model[:described_attribute]] << text
      end
    end

    def pop_attribute(text)
      if @described_models.last && end_attribute_dsl(text)
        finalize_attribute(@described_models.last)
      end
    end

    def pop_model(html)      
      if end_model_dsl(html)
        @described_models.pop
      end
    end

    def finalize_attribute(model)
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