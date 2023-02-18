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

  def verify_pdf_contents(file_1, file_2)
    File.read(file_1) == File.read(file_2)
  end
end