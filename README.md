# MarkdownRecord

MarkdownRecord is a Rails engine that allows you to write markdown with embedded json like this:

```md
<!-- <project_root>/markdown_record/content/my_online_book/title.md-->

# My Online Book

<!--describe_model
{
  "type": "::Book",
  "id":   1,
  "name": "My Online Book"
}
-->
```

```md
<!-- <project_root>/markdown_record/content/my_online_book/part_1/chapter_1/content.md-->

# Chapter One

Lorem ipsum dolor sit amet, consectetur adipiscing elit. In varius neque vel leo aliquet, ac finibus massa venenatis. Praesent nisi turpis...

<!--describe_model
{
  "type": "::Chapter",
  "id":   1,
  "name": "Chapter 1",
  "foo":  23.2,
  "bar":  1234,
  "book_id": 1
}
-->

```

Then compile it into separate HTML files (using whatever ERB layout you want) and JSON files like this:

```bash
thor render_content:all -s
```

```html
<html>
  <head>
    ...
  </head>
  <body>
    <h1>My Online Book</h1>
    <h1>Chapter 1</h1>
    <p>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. In varius neque vel leo aliquet, ac finibus massa venenatis. Praesent nisi turpis...
    </p>
  </body>
</html>
```

```json
{
  "Chapter": [
    {
      "type": "Chapter",
      "id": 1,
      "name": "Chapter 1",
      "foo": 23.2,
      "bar": 1234,
      "book_id": 1,
      "subdirectory": "content/my_online_book/part_1/chapter_1",
      "filename": "content"
    }
  ],
  "Book": [
    {
      "type": "Book",
      "id": 1,
      "name": "My Online Book",
      "subdirectory": "conten/my_online_book",
      "filename": "title"
    }
  ]
}
```

And then render your HTML and JSON from your rails app without writing any extra code, using the built in controllers provided, like so:

```curl
bryantmorrill@bryants-mbp ~ % curl -XGET -H "Accept: application/json" 'http://localhost:3000/mdr/content/my_online_book

{ 
  "Book": [
    {
      ...
    }
  ],
  "Chapter": [
    {
      ...
    }
  ]
}
```

```curl
bryantmorrill@bryants-mbp ~ % curl -XGET -H "Accept: application/html" 'http://localhost:3000/mdr/content/my_online_book/part_1/chapter_1

"<html>
  <head>
    ...
  </head>
  <body>
    <h1>My Online Book</h1>
    <h1>Chapter 1</h1>
    <p>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. In varius neque vel leo aliquet, ac finibus massa venenatis. Praesent nisi turpis...
    </p>
  </body>
</html>"
```

You can also interact with and define associations on your JSON in your application like this:

```ruby
class Book < MarkdownRecord::Base
  attribute :name
  attribute :id

  has_many_content :chapters
end

class Chapter < MarkdownRecord::Base

  attribute :name
  attribute :summary
  attribute :bar, :type => Float
  attribute :foo, :type => Float
  attribute :id
  attribute :book_id

  belongs_to_content :book
end
```

```Ruby
 Chapter.find(1).book.name
   => "My Online Book"
```

Or you can directly reference and read or pass around your written content in your application like this:

```ruby
  ::MarkdownRecord::ContentFragment.find("content/my_online_book/title").read_html
    => "<html> ... </html>"
```

In other words, MarkdownRecord allows you to write your website's content and define static data at the same time, in the same markdown source file. By embedding your static data right inside your markdown, or rather extracting your data from your content, you can cut out the hassle of writing database migrations and building forms just to store data that doesn't need to be updated often or by end users. This approach also helps to keep your application maintainable and consistent, as there will be less code (always a good thing) and only one source of truth for both your written copy and its associated data.

The MarkdownRecord engine is packed with super useful features, such as view helpers and a powerful markdown DSL that lets you extract data models out of your written content without duplication. It is highly customizeable and extensible too, in case you want to tweak the way it works.

---

## Why use MarkdownRecord?

MarkdownRecord is a solution for when you need to render written content in your web application, but also need object oriented and relational representations of your content and the concepts it describes. This is a fairly narrow use case, but there are a few obvious situations where this could come in handy, such as:

- API documentation that is queryable, such that a client could query for available endpoints, required and optional parameters, etc.
- A website containing a blog or other static content, but want to attach meta data to that content such as topic, keywords, etc.
- Hosting the rules for a table top game alongside a character or army building feature which needs to know what options are defined in the rules.
- Any situation where you have written copy and you want to represent the relationships between pieced of it or the concepts it describes in an your application code.

MarkdownRecord could be described as a *server side content management system*, as opposed to client side systems such as WordPress and other common blogging platforms. But it is also something more than just a content management system, as it provides a unique content writing DSL and an alternative way to deal with data.

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

## Writing Content

Utilizing the content writing DSL to define JSON data in your markdown is very straightforward. The DSL uses HTML comments with specific commands that MarkdownRecord recognizes when it renders your content. For example, a comment beginning with `describe_model` immediately after the opening bracket tells MarkdownRecord to expect a JSON object in the comment, which will contain the models attributes. A `type` field is required in each described model, and it must match the fully qualified class name of the model defined in your application that will be populated by it.

```md
<!--describe_model
{
  "type": "<model class name here>",
  ...
}
-->
```

Similarly, an HTML comment such as `<!--describe_model_attribute:<attribute_name>-->` tells MarkdownRecord that the content that follows it should be assigned to the most recent object that was described with `describe_model`, under the attribute name provided. Any content that follows until MarkdownRecord sees `<!--end_describe_model_attribute-->` will then populate that attribute.

You can nest `describe_model` commands as well, in which case MarkdownRecord manages the described models in a first in, last out fashion (using a stack). The `describe_model_attribute` command will always refer to the last model to be described, unless you add an `<!--end_describe_model-->` comment to pop the most recent model out of the stack.

```md
<!--describe_model
{
  "type": "Example",
  ...
}
-->

<!--describe_model_attribute:foo-->

This content will populate the `foo` attribute of Example model defined above.

<!--end_describe_model_attribute-->

<!--describe_model
{
  "type": "NestedExample",
  ...
}
-->

<!--describe_model_attribute:bar-->

This content will populate the `bar` attribute of NestedExample model defined above.

<!--end_describe_model_attribute-->

<!--end_describe_model-->

<!--describe_model_attribute:baz-->

This content will populate the `baz` attribute of Example model at the top (the first `describe_model`).

<!--end_describe_model_attribute-->

```

MarkdownRecord also expects to find an `id` field populated on each model, whether it is defined via  `describe_model` or `describe_model_attribute` does not matter.

*Note: The above example looks quite busy, because this guide is trying to be concise. There would typically be a lot more written copy between the DSL comments, which would make this look better.*

## Rendering

Once your markdown content is written and your models defined within it, you will need to run a Thor task to render your source content into html and/or json, which then gets saved into generated files in a different location (the default location is `<application_root>/markdown_record/rendered`).

The following thor command will render your entire content directory recursively:

```bash
thor render_content:all -s
```
*Note: This task has additional options that are not described here. Omitting the `-s` will cause it to do a dry run, without actually saving any files.*

The newly rendered html and json content will be immediately available for the basic controllers provided by the engine to serve. The routes that the content is accessible by are as follows:

```
<application root_url>/mdr/<relative path>
<application root_url>/mdr/download/<relative path>
<application root_url>/mdr/html/<relative path>
<application root_url>/mdr/html/download/<relative path>
<application root_url>/mdr/json/<relative path>
<application root_url>/mdr/json/download<relative path>
```

In the above routes, `mdr` is the engine's mount path and is configurable, and `<relative path>` is the relative path of the desired content from the `markdown_record/rendered` directory (this location is also configurable).

MarkdownRecord has multiple rendering strategies or modes. They are `full`, `file`, and `directory`. By default, it uses `full` which enables all of its features and endpoints to work properly. That means it renders each file in your content directory individually and also renders the concatenated contents of each directory as well. The `file` rendering strategy only renders files, and the `directory` strategy only renders the concatenated contents of each folder. Using one of these two strategies means that there will be fewer valid routes for rendering your content, and any content models your define will have more limited capabilities, but it also reduces duplication.

You can configure MarkdownRecord to use a different strategy all the time or specify the strategy you want to use when rendering by passing a `--strat` or `-s` argument.

There is also the command: `thor render_file` which can be used to render a single file (in which case the render strategy is implicity `file`, and the rendered content for parent directories will not be updated). 

# Content Models

The greatest benefit of using MarkdownRecord is in the ability to reference your rendered content as well as your defined models in your application code. MarkdownRecord provides the `MarkdownRecord::Base` model for your models to inherit, which will enable them to behave very much like ActiveRecord models but with the your rendered json content as the data store instead of a database. Example:

```ruby
class Chapter < MarkdownRecord::Base
  attribute :name
end
```

For example, you can query for a list of all the models of the type `Chapter` like so:

```ruby
Chapter.all
  => [#<Chapter name: "Chapter One", filename: "content", id: 1, subdirectory: "content/my_online_book/part_1/chapter_1", type: "Chapter">,
       ...
     ]
```

You can also filter them by passing in a hash of filters:

```ruby
Chapter.where(:subdirectory => /.*\/my_online_book\/.*/)
  => [#<Chapter name: "Chapter Two", filename: "content", id: 1, subdirectory: "content/my_online_book/part_1/chapter_1", type: "Chapter">,
       ...
     ]
```

*Note: The above examples assume either the `full` or `directory` rendering strategies are used, as the queries by default look only at a top level, concatenated rendered json file.*

MarkdownRecord's query syntax supports several kinds filters and query methods, but that topic would be too much to cover in this guide. More docs coming soon!

All instances of `MarkdownRecord::Base` have `filename`, `subdirectory`, `type` and `id` attributes. The former two are populated automatically when your content is rendered, but you must define the latter two in your JSON inside your markdown.

## Content Fragments

MarkdownRecord also defines `MarkdownRecord::ContentFragment`, which is a model with a direct one to one correspondenc with your rendered content files. The id of these models is always the relative path of the file they corresponde to. This makes them quite useful in dealing with your rendered static content programatically. For example, you can pass them to view helpers, or query them to get a list of available content in order to populate a navigation bar, etc.

Since the content models you define yourself also have the `filename` and `subdirectory` attributes which should always point to the file in which they are defined, it is trivial to get a reference to their coresponding `MarkdownRecord::ContentFragment`, as shown below:

```ruby
Chapter.find(1).fragment
  => <MarkdownRecord::ContentFragment filename: "content", id: "content/my_online_book/part_1/chapter_1/content", subdirectory: "content/my_online_book/part_1/chapter_1", type: "MarkdownRecord::ContentFragment">
```

Any query of content models returns either `MarkdownRecord::ContentFragment` models or the models defined manually, but not both. Querying off of `MarkdownRecord::ContentFragment` or an instances of it will always return content fragments. But a query on a manually defined model can be turned into a query of content fragment like this:

```ruby
Chapter.where(...).fragments.all
  => [
       #<MarkdownRecord::ContentFragment ...>,
       ...
     ]
```

This allows you to render the content fragments in your ERB very easily, by simply iterating over them:

```erb
  <% Section.all.fragments.each do |frag| %>
    <%= frag.read_html %>
  <% end %>
```

## Associations

All content models come with certain associations built in, such as `siblings`, `children`, `fragment`, `parent_fragment` and others. But you can define associations between your models as well using `belongs_to_content` and `has_many_content`. These DSL methods work as you would expect if you are familiar with ActiveRecord. The only caveats are that you must remember to populate the right attributes in your JSON.

For example, if a Chapter model has a `belongs_to_content :book` association, then you will need to populate a `book_id` field in that models JSON data, and the value should match the `id` of a Book that you also have defined. A `has_many_content :chapters` association on `Book` would likewise require the `book_id` field on the Chapter model.

## Associations with ActiveRecord

ActiveRecord models can also have association to your rendered content. To do this, simply include the `MarkdownRecord::ContentAssociations` module on your ActiveRecord model and use the same methods described above, like so:

```ruby
class Reader < ::ActiveRecord::Base
  include ::MarkdownRecord::ContentAssociations
  
  has_many_content :books
end

class BookMark < ::ActiveRecord::Base
  include ::MarkdownRecord::ContentAssociations
  
  belongs_to :book
end
```

An important difference when using `has_many_content` on an ActiveRecord models, however, is that it uses an array column in the database rather than having the `belongs_to` side of the association have a foreign key pointing to it. This is because MarkdownRecord content models are meant to contain static data that doesn't change programatically, and it would be somewhat contrary to the MarkdownRecord philosophy to have this sort of data referencing the more dynamic type of data you would store via ActiveRecord.

If you use the `has_many_content` association on an ActiveRecord model, simply write a migration to add the needed column:

```ruby
class CreateReader < ActiveRecord::Migration[7.0]
  def change
    add_columne :readers, :book_ids, :string, array: true
  end
end
```

## Contributing
Contribution guides coming soon.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
