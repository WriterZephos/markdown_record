require_relative "lib/markdown_record/version"

Gem::Specification.new do |spec|
  spec.name        = "markdown_record"
  spec.version     = MarkdownRecord::VERSION
  spec.authors     = ["Bryant Morrill"]
  spec.email       = ["bryantreadmorrill@gmail.com"]
  spec.homepage    = "https://github.com/WriterZephos/markdown_record"
  spec.summary     = "A markdown + git based content management system."
  spec.description = "MarkdownRecord is a Rails engine that lets you write content and populate models in markdown directly within your application's repo, then generate html and json files for direct rendering in your app."
  spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/WriterZephos/markdown_record"
  spec.metadata["changelog_uri"] = "https://github.com/WriterZephos/markdown_record"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,templates}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_dependency "rails", ">= 7.0.4.2"
  spec.add_dependency "redcarpet", "~> 3.5"
  spec.add_dependency "active_attr", "~> 0.15.4"
  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "htmlbeautifier"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rspec-rails", "~> 6.0"
  spec.add_development_dependency "pg", "~> 1.4"
  spec.add_development_dependency "webrick"
end
