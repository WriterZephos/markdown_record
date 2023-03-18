module Helpers
  def uninstall_engine
    FileUtils.remove_dir("markdown_record", true)
    FileUtils.remove_entry("config/initializers/markdown_record.rb", true)
    FileUtils.remove_entry("Thorfile", true)
    FileUtils.remove_entry("lib/tasks/render_content.thor", true)
    FileUtils.remove_entry("app/assets/images/ruby-logo.png", true)

    routes = File.read("config/routes.rb")
    routes = routes.gsub("\n  # Do not change this mount path here! Instead change it in the MarkdownRecord initializer.\n  mount MarkdownRecord::Engine, at: MarkdownRecord.config.mount_path, as: \"markdown_record\"", "")

    File.open("config/routes.rb", "w") do |f|
      f.write routes
    end
  end

  def install_engine
    system "cd spec/dummy && rails g markdown_record -t"
    FileUtils.cd("spec/dummy")
  end

  def remove_rendered_content
    FileUtils.remove_dir("markdown_record/rendered", true)
    FileUtils.mkdir_p "markdown_record/rendered"
  end

  def expect_files(fls, remove = true)
    existing_files = fls.map do |file|
      if Pathname.new(file).exist?
        FileUtils.remove_entry(file, true) if remove
        file
      else
        nil
      end
    end.compact
    
    expect(fls.join("\n")).to eq(existing_files.join("\n"))
  end

  def expect_no_files(fls, remove = true)
    existing_files = fls.map do |file|
      if Pathname.new(file).exist?
        FileUtils.remove_entry(file, true) if remove
        file
      else
        nil
      end
    end.compact

    expect(existing_files.empty?).to eq(true)
  end

  def expect_file_contents(files)
    all_correct = true
    files.each do |f|
      expect(File.read(f)).to eq(File.read(f.gsub("markdown_record/rendered/", "../rendered/")))
    end
  end

  def expect_output(index)
    expect(output_for_dummy).to eq(output_for_spec(index))
  end

  def files(index)
    output_for_spec(index).split("\n").map do |line|
      match = line.match(/rendered: \/(.*)/)
      if match.nil?
        nil
      else
        match[1]
      end
    end.compact
  end

  def reset_output_for_specs
    File.open("../rendered/rendered.txt", "w") do |file|
      file.write("")
    end
  end

  def copy_output_for_specs
    File.open("../rendered/rendered.txt", "a") do |file|
      file.write(File.read("markdown_record/rendered/rendered.txt"))
      file.write("\n\n*****\n\n")
    end
  end

  def output_for_spec(index)
    File.read("../rendered/rendered.txt").split("\n\n*****\n\n")[index]
  end

  def output_for_dummy
    File.read("markdown_record/rendered/rendered.txt")
  end
end