# MarkdownRecord

MarkdownRecord is a Rails engine that allows you to write markdown with embedded json like this:

```md
<!--model { "type": "markdown_record/demo/section", "id":   3, "name": "Content DSL" } -->

# Content DSL

This section describes the Content DSL MarkdownRecord provides to allow you to define application data right alongside your written markdown content.

While writing documentation in your markdown source files, you can define json data using HTML comments which will then be made available to you within your application code...

```

And then interact with your data in your application code like this:

```ruby
MarkdownRecord::Demo::Section.find(3)
 => #<MarkdownRecord::Demo::Section filename: "4_content_dsl", id: 3, name: "Content DSL", subdirectory: "content", type: "markdown_record/demo/section"> 
```

And render your markdown content as HTML (with full ERB support) like this:

```html
<h1>Content DSL</h1>

<p>This section describes the Content DSL MarkdownRecord provides to allow you to define application data right alongside your written markdown content.</p>

<p>While writing documentation in your markdown source files, you can define json data using HTML comments which will then be made available to you within your application code...</p>
```

Or render your markdown content as JSON like this:

```json
{"markdown_record/demo/section":[{"type":"markdown_record/demo/section","id":3,"name":"Content DSL","subdirectory":"content","filename":"4_content_dsl"}]}
```

All without creating a single controller, writing a single migration, creating a single view, or defining a single route.

In other words, MarkdownRecord allows you to write your website's content and define static data at the same time, in the same markdown source file, and have it immediately available to render from your application. By embedding your static data right inside your markdown, or rather extracting your data from your content, you can cut out the hassle of writing database migrations and building forms just to store data that doesn't need to be updated by end users. This approach also helps to keep your application maintainable and consistent, as there will be less code (always a good thing) and only one source of truth for both your written copy and its associated data.

The MarkdownRecord engine is packed with super useful features, such as content fragments which let you interact with your source files from within your application code, a powerful markdown Content DSL that lets you extract data out of your written content and interact with it in an object oriented way, and view helpers to make navigating between your rendered HTML content easy.

---

## Why use MarkdownRecord?

MarkdownRecord is a solution for when you need to render written content in your web application, but also need object oriented and relational representations of your written content and the concepts it describes. This is a fairly narrow use case, but there are a few obvious situations where this could come in handy, such as:

- API documentation that is queryable, such that a client could query for available endpoints, required and optional parameters, etc.
- A website containing a blog or other static written copy where you want to attach meta data to it such as topic, keywords, etc.
- Hosting the rules for a table top game alongside a character or army building feature which needs to know what options are defined in the rules.
- Any situation where you have written copy and you want to represent the relationships between pieces of it or the concepts it describes in an your application code.

MarkdownRecord could be described as a *server side content management system*, as opposed to client side systems such as WordPress and other common blogging platforms, where the writing and editing are done in a browser. With MarkdownRecord you can write content locally without having to worry about converting it to HTML, storing it in a database or integrating a text editor into your web application. It gives you an alternative and way to deal with data with very few compromizes.

## Why not use MarkdownRecord?

MarkdownRecord should not be used if the code repository the host application lives in cannot be pushed to whenever content changes (unless there is some work around in place to fetch updated content and render it automatically). Without additional automation in place, you must run a command to have the engine pre-render your content locally, then push the results to whereever your application is hosted. As such, content that requires creating or editing from the client side is not something this engine should be used for.

---
# Usage

## Installation
Add this line to your application's Gemfile:

```ruby
gem "markdown_record"
```

And then execute:
```bash
$ bundle install
```

Then, from the root directory of your application run:
```bash
$ rails g markdown_record
```

The above command will install the engine, resulting in the following output and changes to your application:
```bash
create  markdown_record/layouts/_concatenated_layout.html.erb
create  markdown_record/layouts/_file_layout.html.erb
create  markdown_record/layouts/_custom_layout.html.erb
create  markdown_record/content
create  markdown_record/rendered
create  markdown_record/content/demo.md
create  markdown_record/content/part_1/chapter_1/content.md
create  markdown_record/content/part_1/chapter_2/content.md
create  public/ruby.jpeg
create  config/initializers/markdown_record.rb
create  Thorfile
create  lib/tasks/render_content.thor
create  lib/tasks/render_file.thor
  gsub  config/routes.rb
```

The files and folders inside `markdown_record/content`, `markdown_record/layouts` and `public` are for demo purposes only, and can be deleted once youare are ready to create your own content.

By default, MarkdownRecord will look in the `markdown_record/content` directory for all your content, and all rendered content will be saved to the `markdown_record/rendered` directory.

The engine will be mounted in `config/routes.rb` under the `mdr` path by default.

An initializer will be created for you, where you will be able to configure the engine to use different directories and change other default settings. A later section of this guide will provide more details on configuration options.

A `Thorfile` and some thor tasks will also be added to your application. These tasks are used to render your content to HTML and JSON.

## Overview

The general workflow while using MarkdownRecord, once installed in your application, is as follows:

1. Write markdown content, using the content writing DSL to define model data within your markdown content.
2. Run the provided Thor task to render your markdown content into HTML and JSON.
3. Use the provided view helpers to link to the rendered content in your application's views, relying on the controllers provided by the engine for serving the content.
4. Use model classes inheritiing from `MarkdownRecord::Base` to interact with your html and json rendered content, taking advantage of the associations you can define manually as well a the automatic associations they have based on content location.
5. Use the built in `MarkdownRecord::ContentFragment` model to directly reference your rendered content inside your application. 



## Contributing
Contribution guides coming soon.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
