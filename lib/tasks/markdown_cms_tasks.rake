desc "Explaining what the task does"
task :render do 
  # Task goes here
end


def install_engine
  system "cd spec/dummy && rails g markdown_record"
  FileUtils.cd("spec/dummy")
end
