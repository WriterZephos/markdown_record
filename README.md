# MarkdownRecord

MarkdownRecord is a Rails engine that allows you to write markdown locally for rendering as html in your Rails app, but with embedded json objects that you can interact with inside your application code in a way similar to ActiveRecord models (including associations such as `belongs_to` or `has_many`, etc). This allows you to keep your written content and its related application data together in the same source files, which eliminates the hassles of setting up database migrations, building user interfaces for creating and editing, and helps you keep your application data consistent with your copy.

The MarkdownRecord engine also provides basic controllers out of the box for serving the html and json that is rendered from your markdown source files, as well as view helpers for easy navigation to your rendered html content.

## Why use MarkdownRecord?

MarkdownRecord is a solution for when you need to render written content in your web application, but also need object oriented and relational representations of your content and the concepts it describes. This is a fairly narrow use case, but there are a few obvious situations where this could come in handy, such as:

- API documentation that is queryable, such that a client could query for available endpoints, required and optional parameters, etc. By embedding the json data returned from such queries directly within the documentation, you don't have to maintain multiple sources of truth. With ready to go, out of the box controllers and routing, the data will be available to query immediately without having to implement any endpoints yourself.
- A website containing a blog or other static content, where you want to objectify the various pieces of content and their hierarchy to more easily navigate between them. Instead of creating a Post model with a table in your database, simply organize your posts as markdown files within a directory structure reflecting your desired hierarchy (for example: `year/month/day`), and use the MarkdownRecord view helpers to build your site navigation to traverse the hierarchy of pre-rendered content. You can easily do all of this without creating a single model class to encapsulate your static content by using the engine's built in `ContentFragment` class. Of course, you can still create more sophisticated models to represent your static data without ever touching a database, if desired.
- Hosting the rules for a table top game in an application that allows you to build characters or assemble armies using the options described by the rules. By using MarkdownRecord for this use case, you can easily populate drop downs and other form elements with the options defined in your markdown without hard coding values in your application code or creating unecessary database tables that will become a maintenance problem as new versions of the rules are released. You can even build a versioning system into your markdown content directory structure, allowing you to release new versions of your content with the utmost ease.
- Any situation where you have relational static content or versioned static content and you want to represent those relationships in an your application code, but putting your static content in the database is overkill or just doesn't make sense given the dynamic nature of a database and the extra overhead involved.

MarkdownRecord is very specifically designed for cases where the content is mostly **static** and **controlled by the developer**. It's goal is to cut out a lot of the boiler plate code and setup needed to host and encapsulate relational static content in your application. While it could be coupled with a user interface to allow client side creating and editing of markdown source files, that is not its intended purpose. MarkdownRecord could be described as a *server side content management system*, as opposed to client side systems such as WordPress, other common blogging platforms, etc.

## Why not use MarkdownRecord?

MarkdownRecord should not be used if the code repository the host application lives in cannot be pushed to whenever content changes (unless there is some work around in place to fetch updated content and render it automatically). Without additional automation in place, you must run a command to have the engine pre-render your content locally, then push the results to whereever your application is hosted. As such, content that requires creating or editing from the client side is not something this engine can handle on its own.

---
# Usage

## Installation
Add this line to your application's Gemfile:

```ruby
gem "markdown_record"
```

And then execute:
```bash
$ bundle
```

Then, from the root directory of your application run:
```bash
$ rails g markdown_record
```

The above command will install the engine, resulting in the following output and changes to your application:
```
create  markdown_record/layouts/_markdown_record_layout.html.erb
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

By default, MarkdownRecord will look in the `markdown_record/content` for all your content, and all rendered content will be saved to `markdown_record/rendered`.

The engine will be mounted in `config/routes.rb` under the `content` path.

An initializer will be created for you, where you will be able to configure the engine to use different directories and change other default settings. A later section of this guide will provide more details on configuration options.

A `Thorfile` and some thor tasks will also be added to your application. These tasks are used to render your content to HTML and JSON.

## Overview

The general workflow while using MarkdownRecord, once installed in your application, is as follows:

1. Write markdown content, using the modeling data DSL provided by MarkdownRecord to define model data within your markdown content.
2. Run the provided Thor task to render your markdown content into HTML and JSON.
3. Use the provided view helpers to link to the rendered content in your application's views, relying on the controllers provided by the engine for serving the content.
4. Use model classes inheritiing from `MarkdownRecord::Base` to interact with your html and json rendered content, taking advantage for user defined associations, automatic associations based on content location, and the built in `ContentFragment` model, 

## Writing Content

 is to write your content in markdown files within a specified directory inside your application (the default directory is `<application_root>/markdown_record/content`). You can use the modeling DSL the engine provides for defining model data alongside your markdown text within html comments, like so:

*markdown_record/content/part_1/chapter_1/content.md*
```md

# Chapter One

...

<!--describe_model
{
  "type": "::Chapter",
  "id":   1,
  "name": "Chapter One",
  "book_id": 1,
  "pages": 37
}
-->

...

```
*Note: The type and id attributes are required for all models.*

### Rendering

Once your markdown content is written and your models defined within it, you will need to run a Thor task to render your source content into html and/or json, which then gets saved into auto generated files in a different location (the default location is `<application_root>/markdown_record/rendered`).

```bash
thor render_content:all -s
```
*Note: This task has additional options that are not described here.*

The newly rendered html and json content will be immediately available for the basic controllers provided by the engine to serve. For the above example, you would be able to load the html file generated by navigating to this url:

```
<application root_url>/<engine mount path>/html/content/part_1/chapter_1/content
```

### Content Models

but the real benefit to using MarkdownRecord is in the ability to reference your rendered content as well as your defined models in your application code.

For example, you can get model representations of all the rendered files by using the built in `MarkdownRecord::ContentFragment` class, like so:

```ruby
MarkdownRecord::ContentFragment.all
```

Running the above line in the rails console will give you an array of models like this:

```ruby
[#<MarkdownRecord::ContentFragment filename: "content", id: "content/part_1/chapter_1/content", subdirectory: "content/part_1/chapter_1", type: "MarkdownRecord::ContentFragment">,
...]
```

As you can see, each `MarkdownRecord::ContentFragment` instance has a `filename` and `subdirectory` attribute, as well as an `id` which is the the combination of the two, and correlates directly to a rendered file's path. They do not have an extension, as each `MarkdownRecord::ContentFragment` instance represents both the `html` and `json` version of the file at the location specified by its `id`.

To get a reference to the models you explicitly define in your markdown, such as the `Chapter` model in the example above, you will need to define a model in your application like so:

```ruby
class Chapter < ::MarkdownRecord::Base
  attribute :name
  attribute :pages

  belongs_to_content :book
end
```

Note that the model must inherit from `::MarkdownRecord::Base`, which is also the parent class of `MarkdownRecord::ContentFragment`. Also note that `id`, `subdirectory` and `filename` are attributes of all models that inherit from `::MarkdownRecord::Base`, and `subdirectory` and `filename` are populated automatically when the model data is rendered to json.

With the `Chapter` model defined, you can now get an object containing the data you defined in your markdown like so:

```ruby
Chapter.find(1)
 => #<Chapter bar: 1234.0, book_id: 1, filename: "content", foo: 23.2, id: 1, name: "Chapter 1", subdirectory: "content/part_1/chapter_1", summary: nil, type: "Chapter">
```

`::MarkdownRecord::Base` provides a DSL for defining associations between MarkdownRecord models as well as methods for querying those associations. In addition, all MarkdownRecord models come with built in associations based on the location of their respective source files to each other. These associations allow you to navigate your static content in an object oriented way, essentially using the models as proxies for the files and folders in your content directory.

In addition to all of the above features, MarkdownRecord also provides view helpers to make it easy to serve your rendered content within your application.

The many features and ways to use MarkdownRecord are too many for a complete guide in this README but a full usage guide is in the works.

## Contributing
Contribution guides coming soon.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
