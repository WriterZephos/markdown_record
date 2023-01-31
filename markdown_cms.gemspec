require_relative "lib/markdown_cms/version"

Gem::Specification.new do |spec|
  spec.name        = "markdown_cms"
  spec.version     = MarkdownCms::VERSION
  spec.authors     = ["Bryant Morrill"]
  spec.email       = ["bryantreadmorrill@gmail.com"]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of MarkdownCms."
  spec.description = "TODO: Description of MarkdownCms."
    spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
  spec.add_dependency "redcarpet", "~> 3.5"
  spec.add_dependency "active_attr", "~> 0.15.4"
  spec.add_dependency "wicked_pdf", "~> 2.6"
  spec.add_dependency "wkhtmltopdf-binary", "~> 0.12.6"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rspec-rails", "~> 6.0"
end
