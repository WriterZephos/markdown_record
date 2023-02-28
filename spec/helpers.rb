module Helpers
  def uninstall_engine
    FileUtils.remove_dir("markdown_record", true)
    FileUtils.remove_entry("lib/tasks/render_content.thor", true)
    FileUtils.remove_entry("lib/tasks/render_file.thor", true)
    FileUtils.remove_entry("config/initializers/markdown_record.rb", true)
    FileUtils.remove_entry("Thorfile", true)
    FileUtils.remove_entry("public/ruby.jpeg", true)

    lines = File.readlines("config/routes.rb")
    lines[1] = ""

    File.open("config/routes.rb", "w") do |f|
      lines.each do |line|
        f.write line
      end
    end
  end

  def install_engine
    system "cd spec/dummy && rails g markdown_record"
    FileUtils.cd("spec/dummy")
  end

  def remove_rendered_content
    FileUtils.remove_dir("markdown_record/rendered", true)
    FileUtils.mkdir_p "markdown_record/rendered"
  end

  def verify_files(files, remove = true)
    all_exist = true
    files.each do |file|
      all_exist &= Pathname.new(file).exist?
      FileUtils.remove_entry(file, true) if remove
    end
    all_exist
  end
end