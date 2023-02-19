module Helpers
  def uninstall_engine
    FileUtils.remove_dir("markdown_record/content", true)
    FileUtils.remove_dir("markdown_record/rendered", true)
    FileUtils.remove_entry("markdown_record/layouts/_markdown_record_layout.html.erb", true)
    FileUtils.remove_entry("lib/tasks/render_content.thor", true)
    FileUtils.remove_entry("lib/tasks/render_file.thor", true)
    FileUtils.remove_entry("config/initializers/markdown_record.rb", true)
    FileUtils.remove_entry("Thorfile", true)
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

  def verify_file_contents(file, content)
    File.read(file) == content
  end
end