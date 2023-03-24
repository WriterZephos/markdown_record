# MarkdownRecord

Welcome to MarkdownRecord. This project is still in BETA stage, and as such is subject to rapid change. There are many things that still need improving, so bear that in mind. That said, please feel free to test this project out and provide feedback in the form of GitHub issues! Thank you.

You can find the complete usage guide [here](https://markdown-record-docs.herokuapp.com/mdr/content/home).

MarkdownRecord is a Rails engine that allows you to write markdown with embedded json like this:

```md
<!--model
  { 
    "type": "markdown_record/demo/section", 
    "id":   3, 
    "name": "Content DSL"
  } 
-->

# Content DSL

This section describes the Content DSL MarkdownRecord provides to allow you to define application data right alongside your written markdown content.

While writing documentation in your markdown source files, you can define json data using HTML comments which will then be made available to you within your application code...

```

And then interact with your data in your application code like this:

```ruby
MarkdownRecord::Demo::Section.find(3)
 => #<MarkdownRecord::Demo::Section filename: "content_dsl", id: 3, name: "Content DSL", subdirectory: "content", type: "markdown_record/demo/section"> 
```

And render your markdown content as HTML (with full ERB support) like this:

```html
<h1>Content DSL</h1>

<p>This section describes the Content DSL MarkdownRecord provides to allow you to define application data right alongside your written markdown content.</p>

<p>While writing documentation in your markdown source files, you can define json data using HTML comments which will then be made available to you within your application code...</p>
```

Or render your markdown content as JSON like this:

```json
{"markdown_record/demo/section":[{"type":"markdown_record/demo/section","id":3,"name":"Content DSL","subdirectory":"content","filename":"content_dsl"}]}
```

## All without creating a single controller, writing a single migration, creating a single view, or defining a single route.

In other words, MarkdownRecord allows you to write your website's content and define static data at the same time, in the same markdown source file, and have it immediately available to render from your application. By embedding your static data right inside your markdown, or rather extracting your data from your content, you can cut out the hassle of writing database migrations and building forms just to store data that doesn't need to be updated by end users. This approach also helps to keep your application maintainable and consistent, as there will be less code (always a good thing) and only one source of truth for both your written copy and its associated data.

The MarkdownRecord engine is packed with super useful features, such as content fragments which let you interact with your source files from within your application code, a powerful (and soon to be extensible) markdown Content DSL that lets you extract data out of your written content and interact with it in an object oriented way, and view helpers to make navigating between your rendered HTML content easy.

---

## Why use MarkdownRecord?

MarkdownRecord is a solution for when you need to render written content in your web application, but also need object oriented and relational representations of your written content and the concepts it describes. This is a fairly narrow use case, but there are a few obvious situations where this could come in handy, such as:

- API documentation that is queryable, such that a client could query for available endpoints, required and optional parameters, etc.
- A website containing a blog or other static written copy where you want to attach meta data to it such as topic, keywords, etc.
- Hosting the rules for a table top game alongside a character or army building feature which needs to know what options are defined in the rules.
- Any situation where you have written copy and you want to represent the relationships between pieces of it or the concepts it describes in an your application code.

MarkdownRecord could be described as a *server side content management system*, as opposed to client side systems such as WordPress and other common blogging platforms, where the writing and editing are done in a browser. With MarkdownRecord you can write content locally without having to worry about converting it to HTML, storing it in a database or integrating a text editor into your web application. It gives you an alternative and way to deal with data with very few compromises.

## Why not use MarkdownRecord?

MarkdownRecord should not be used if the code repository the host application lives in cannot be pushed to whenever content changes (unless there is some work around in place to fetch updated content and render it automatically). Without additional automation in place, you must run a command to have the engine pre-render your content locally, then push the results to wherever your application is hosted. As such, content that requires creating or editing from the client side is not something this engine should be used for.

---
# Usage

## Installation

This section explains how to install MarkdownRecord into a host application.

First, add this line to your application's Gemfile:

```ruby
gem "markdown_record"
```

And then execute:

```bash
$ bundle install
```

Then, from the root directory of your application run:

```bash
$ rails g markdown_record --demo
```

*Note: if you are already familiar with MarkdownRecord and don't want to install the demo content, you can omit the --demo argument.*

The above command will install the engine, resulting in the following output and changes to your application:

```bash
      create  markdown_record/content
      create  markdown_record/layouts
      create  markdown_record/rendered
       exist  app/models
   identical  app/models/dsl_command.rb
   identical  app/models/section.rb
       exist  markdown_record/content
      create  markdown_record/content/10_custom_models_and_associations.md.erb
      create  markdown_record/content/11_controller_helpers.md.erb
      create  markdown_record/content/12_configuration.md.erb
      create  markdown_record/content/13_sandbox/1_foo.md
      create  markdown_record/content/13_sandbox/2_sandbox_nested/1_bar.md
      create  markdown_record/content/1_home.md.erb
      create  markdown_record/content/2_installation.md.erb
      create  markdown_record/content/3_rendering_basics.md.erb
      create  markdown_record/content/4_content_dsl.md.erb
      create  markdown_record/content/5_routes.md.erb
      create  markdown_record/content/6_model_basics.md.erb
      create  markdown_record/content/7_content_frags.md.erb
      create  markdown_record/content/8_erb_syntax_and_view_helpers.md.erb
      create  markdown_record/content/9_layouts.md.erb
       exist  markdown_record/layouts
      create  markdown_record/layouts/_concatenated_layout.html.erb
      create  markdown_record/layouts/_custom_layout.html.erb
      create  markdown_record/layouts/_file_layout.html.erb
      create  markdown_record/layouts/_global_layout.html.erb
       exist  app/assets/images
      create  app/assets/images/ruby-logo.png
      create  config/initializers/markdown_record.rb
      create  Thorfile
      create  lib/tasks/render_content.thor
        gsub  config/routes.rb
        gsub  config/routes.rb
```

The files and folders inside `markdown_record/content` are for demo purposes only, and can be deleted once you are ready to create your own content.

By default, MarkdownRecord will look in the `markdown_record/content` directory for all your content, and all rendered content will be saved to the `markdown_record/rendered` directory.

The engine will be mounted in `config/routes.rb` under the `mdr` path by default.

An initializer will be created for you, where you will be able to configure the engine to use different directories and change other default settings. A later section of this guide will provide more details on configuration options.

A `Thorfile` and some thor tasks will also be added to your application. These tasks are used to render your content to HTML and JSON.

The final step in the installation process is to render the demo content that was installed in `markdown_record/content`. To do so, run this Thor task in your application's root directory:

```bash
thor render_content:all -s
```

You should see the following output:

```bash
---------------------------------------------------------------
rendering html and json content with options {:concat=>true, :deep=>true, :save=>true, :render_content_fragment_json=>true} ...
---------------------------------------------------------------
rendered: /markdown_record/rendered/content_fragments.json
rendered: /markdown_record/rendered/content.json
rendered: /markdown_record/rendered/content/rendering_basics_fragments.json
rendered: /markdown_record/rendered/content/rendering_basics.json
rendered: /markdown_record/rendered/content/home_fragments.json
rendered: /markdown_record/rendered/content/home.json
rendered: /markdown_record/rendered/content/controller_helpers_fragments.json
rendered: /markdown_record/rendered/content/controller_helpers.json
rendered: /markdown_record/rendered/content/erb_syntax_and_view_helpers_fragments.json
rendered: /markdown_record/rendered/content/erb_syntax_and_view_helpers.json
rendered: /markdown_record/rendered/content/layouts_fragments.json
rendered: /markdown_record/rendered/content/layouts.json
rendered: /markdown_record/rendered/content/configuration_fragments.json
rendered: /markdown_record/rendered/content/configuration.json
rendered: /markdown_record/rendered/content/sandbox_fragments.json
rendered: /markdown_record/rendered/content/sandbox.json
rendered: /markdown_record/rendered/content/sandbox/sandbox_nested_fragments.json
rendered: /markdown_record/rendered/content/sandbox/sandbox_nested.json
rendered: /markdown_record/rendered/content/sandbox/sandbox_nested/bar_fragments.json
rendered: /markdown_record/rendered/content/sandbox/sandbox_nested/bar.json
rendered: /markdown_record/rendered/content/sandbox/foo_fragments.json
rendered: /markdown_record/rendered/content/sandbox/foo.json
rendered: /markdown_record/rendered/content/content_frags_fragments.json
rendered: /markdown_record/rendered/content/content_frags.json
rendered: /markdown_record/rendered/content/content_dsl_fragments.json
rendered: /markdown_record/rendered/content/content_dsl.json
rendered: /markdown_record/rendered/content/routes_fragments.json
rendered: /markdown_record/rendered/content/routes.json
rendered: /markdown_record/rendered/content/model_basics_fragments.json
rendered: /markdown_record/rendered/content/model_basics.json
rendered: /markdown_record/rendered/content/installation_fragments.json
rendered: /markdown_record/rendered/content/installation.json
rendered: /markdown_record/rendered/content/custom_models_and_associations_fragments.json
rendered: /markdown_record/rendered/content/custom_models_and_associations.json
rendered: /markdown_record/rendered/content.html
rendered: /markdown_record/rendered/content/rendering_basics.html
rendered: /markdown_record/rendered/content/home.html
rendered: /markdown_record/rendered/content/controller_helpers.html
rendered: /markdown_record/rendered/content/erb_syntax_and_view_helpers.html
rendered: /markdown_record/rendered/content/layouts.html
rendered: /markdown_record/rendered/content/configuration.html
rendered: /markdown_record/rendered/content/sandbox.html
rendered: /markdown_record/rendered/content/sandbox/sandbox_nested.html
rendered: /markdown_record/rendered/content/sandbox/sandbox_nested/bar.html
rendered: /markdown_record/rendered/content/sandbox/foo.html
rendered: /markdown_record/rendered/content/content_frags.html
rendered: /markdown_record/rendered/content/content_dsl.html
rendered: /markdown_record/rendered/content/routes.html
rendered: /markdown_record/rendered/content/model_basics.html
rendered: /markdown_record/rendered/content/installation.html
rendered: /markdown_record/rendered/content/custom_models_and_associations.html
---------------------------------------------------------------
51 files rendered.
51 files saved.
```

Congratulations! You have installed MarkdownRecord. If you are not viewing this from the host application already, go ahead and start your Rails server with `rails s` and navigate to http://localhost:3000/mdr/content/home to continue following this guide.

Alternatively, you can find the complete usage guide [here](https://markdown-record-docs.herokuapp.com/mdr/content/home).

## Contributing

Contributions to this project are welcome. Please simply fork the project and open MRs into the main repo if you have something you would like to add or fix. Opening issues for any bugs or improvements you want to be considered is also appreciated.

While working within this code base, use `rake spec` to run tests. You can pass `SPEC=<path to spec file>` to run a specific spec file, and you make append `:<line number>` to run a specific example.

Things that need doing:

- Backfill pending tests
- Backfill missing tests
- Reorganize the `lib` folder to not be such a mess
- Write RDoc docs throughout

To test a local version of this gem in a local app, simply add the `path` parameter in your gemfile like so:

```
 gem "markdown_record", path: "../markdown_record"
```

## Roadmap

- Make the Content DSL extensible
- Add support for raw JSON files as source content
- Support semantic versioning in numeric filename prefixes

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
