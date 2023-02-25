require "redcarpet"

module MarkdownRecord
  class JsonRenderer < ::MarkdownRecord::NullHtmlRenderer

    def initialize(file_saver: ::MarkdownRecord::FileSaver.new, indexer: ::MarkdownRecord.config.indexer_class.new)
      super(::MarkdownRecord.config.html_render_options)
      @indexer = indexer
      @markdown = ::Redcarpet::Markdown.new(self, ::MarkdownRecord.config.markdown_extensions)
      @json_models = {}
      @described_models = []
      @file_saver = file_saver
      @models = {}
    end

    def render_models_for_subdirectory(subdirectory: "", **options)
      content = @indexer.index(subdirectory: subdirectory)
      json_hash, _ = render_models_recursively(subdirectory, content, subdirectory, options)

      save_content_recursively(json_hash, options)
      @models
    end

    def render_models_for_file(file_path:, **options)
      file = @indexer.file(file_path)
      
      # render json models
      json = render_models(file, file_path, options)
      
      # save json
      @file_saver.save_to_file(json.to_json, "#{file_path.gsub(/(\.concat|\.md)/,"")}.json", options)
      
      @models
    end

    def block_html(raw_html)
      set_described_model(raw_html)
      set_described_model_attribute(raw_html)
      pop_described_model_attribute(raw_html)
      pop_described_model(raw_html)
      nil
    end

    def paragraph(text)
      return if @described_models.empty?

      @described_models.each do |model|
        next unless model[:described_attribute].present?
        model[model[:described_attribute]] ||= []
        model[model[:described_attribute]] << text
      end

      nil
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
      rendered_path = base_content_path.join(full_path.delete_prefix("/"))
      @filename = rendered_path.basename.to_s.gsub(/(\.concat|\.md)/,"").delete_prefix("/")
      @subdirectory = rendered_path.parent.to_s.gsub(/(\.concat|\.md)/,"").delete_prefix("/")
      @described_models = []
      @json_models = {}
      @fragment_meta = {}
      @markdown.render(content)
      @described_models.each do |model|
        next if model[:described_attribute].nil?
        attribute = model.delete(:described_attribute)
        model[attribute] = model[attribute].join("\n")
      end
      @json_models.dup
    end

    def add_content_fragment_for_file(json, full_path)
      rendered_path = base_content_path.join(full_path.delete_prefix("/"))
      filename = rendered_path.basename.to_s.gsub(/(\.concat|\.md)/,"")
      filename = filename.empty? ? base_content_path.to_s : filename
      subdirectory = rendered_path.parent.to_s.gsub(/(\.concat|\.md)/,"").delete_prefix("/")
      
      content_fragment = {
        "id" => rendered_path.to_s.gsub(/(\.concat|\.md)/,"").delete_prefix("/"),
        "type" => "MarkdownRecord::ContentFragment",
        "subdirectory" => subdirectory,
        "filename" => filename,
        "meta" => @fragment_meta
      }

      json["MarkdownRecord::ContentFragment"] ||= []
      json["MarkdownRecord::ContentFragment"] << content_fragment
    end

    def base_content_path
      basename = ::MarkdownRecord.config.content_root.basename

      # must use "/" so that .parent returns correctly
      # for top level paths.
      Pathname.new("/").join(basename)
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
        fragments = content.delete("MarkdownRecord::ContentFragment")
        @file_saver.save_to_file(content.to_json, "#{subdirectory.to_s.gsub(/(\.concat|\.md)/,"")}.json", options)
        @file_saver.save_to_file({ "MarkdownRecord::ContentFragment" => fragments}.to_json, "#{subdirectory.to_s.gsub(/(\.concat|\.md)/,"")}.json", options, true)
      else
        content.each do |key, value|
          child_path = Pathname.new(subdirectory).join(key)
          save_content_recursively(value, options, child_path)
        end
      end
    end

    def set_described_model(html)
      match = html.match(/<!--\s*describe_model\s+({[\s|"|'|\\|\w|:|,|.|\[|\]|\{|\}]*})\s+-->/)

      if match
        model = JSON.parse(match[1])
        model["subdirectory"] = @subdirectory.gsub(/(\.concat|\.md)/,"")
        model["filename"] = @filename.gsub(/(\.concat|\.md)/,"")
  
        return unless model["type"].present?
  
        klass = model["type"].delete_prefix("::")
  
        # reset "type" to not have a prefix, in order to ensure
        # consistent results between the internal only :klass filter
        # which is used as an index in a hash (and has the prefix removed 
        # for consistency and deterministic behavior)
        # and the externally filterable :type field.
        model["type"] = klass
        
        @json_models[klass] ||= []
        @json_models[klass] << model
  
        @described_models.push(model)
        return nil
      end

      match = html.match(/<!--\s*fragment\s+({[\s|"|'|\\|\w|:|,|.|\[|\]|\{|\}]*})\s+-->/)

      if match
        @fragment_meta = JSON.parse(match[1])
      end
    end

    def set_described_model_attribute(html)
      return if @described_models.empty?

      match = html.match(/<!--\s*describe_model_attribute\s*:\s*(.*)\s*-->/)
      return if match.nil?

      attribute = match[1].strip

      model = @described_models.last
      model[:described_attribute] = attribute
      model[model[:described_attribute]] = []
    end

    def pop_described_model_attribute(html)
      return if @described_models.empty?
      
      match = html.match(/<!--\s*end_describe_model_attribute\s+-->/)
      return if match.nil? || model[:described_attribute].nil?

      model = @described_models.last
      attribute = model.delete(:described_attribute)
      model[attribute] = model[attribute].join("\n")
    end

    def pop_described_model(html)
      match = html.match(/<!--\s*end_describe_model\s*-->/)
      return if match.nil?
      
      @described_models.pop
    end
  end
end