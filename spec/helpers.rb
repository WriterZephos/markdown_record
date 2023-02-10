module Helpers
  def uninstall_engine
    FileUtils.remove_dir("markdown_cms/content", true)
    FileUtils.remove_dir("markdown_cms/rendered", true)
    FileUtils.remove_entry("markdown_cms/layouts/_markdown_cms_layout.html.erb", true)
    FileUtils.remove_entry("lib/tasks/render_content.thor", true)
    FileUtils.remove_entry("lib/tasks/render_file.thor", true)
    FileUtils.remove_entry("config/initializers/markdown_cms.rb", true)
    FileUtils.remove_entry("Thorfile", true)
  end

  def install_engine
    system "cd spec/dummy && rails g markdown_cms"
    FileUtils.cd("spec/dummy")
  end

  def verify_and_remove_files(files)
    all_exist = true
    files.each do |file|
      all_exist &= Pathname.new(file).exist?
      FileUtils.remove_entry(file, true)
    end
    all_exist
  end
end