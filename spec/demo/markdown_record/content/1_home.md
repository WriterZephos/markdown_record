<!--fragment
{
  "name": "Home",
  "author": "Bryant Morrill"
}
-->

# MarkdownRecord

Welcome to MarkdownRecord!

This document will walk you through the many powerful features of MarkdownRecord, and is created with MarkdownRecord itself. Hopefully, you are rendering this page locally from your own application, and will be able to get a peak under the hood to see how it all works by looking directly at the source markdown files.

If you haven't installed it locally yet, you can find instructions <%= link_to_markdown_record_html(::MarkdownRecord::ContentFragment.find("content/5_installation"), "here") %>.

## The Basics

After following the installation guide, you should see a `markdown_record` folder inside your application root. This folder contains three subdirectories: `content`, `layouts` and `rendered`.

- `content` is where all your original source files will go. When you write a new markdown file, it will live in here.
- `layouts` is where the layouts used when rendering your markdown source files to HTML should go. This folder should already have a some layouts that you can customize to your liking.
- `rendered` is where all the rendered JSON and HTML files go. You should never have to edit any of the files in here. However, you may want to delete this folder and re-render everything (the folder will be generated again) at certain times, such as when you delete a source file and want to remove the corresponding rendered files and data from your application.

Feel free to poke around and explore the files in directories mentioned above as you go through this guide. They will serve as a great reference to help make the things described here make sense.

The rest of this guide goes over a few different contrived examples to demonstrate MarkdownRecord's features. Each example is described below with links to its section of this guide.

## API Docs

This example demonstrates how to write markdown content and define related to it all in one place, then render that content and query that data without having to do anything outside your markdown files. In fact, the documentation you are reading serves as the example itself, as it is written using MarkdownRecord.

<%= link_to_markdown_record_html(::MarkdownRecord::ContentFragment.find("content/2_api_docs"), "API Docs Example") %>

## Blog

This example demonstrates how to use `::MarkdownRecord::ContentFragment` models in your application code and expands upon the rendering process as well as the view helpers and ERB syntax support provided by MarkdownRecord for use in your markdown source files.

<%= link_to_markdown_record_html(::MarkdownRecord::ContentFragment.find("content/3_blog"), "Blog Example") %>

## Table Top Game

This example demonstrates how to use your own custom MarkdownRecord models in your application code, populated by the data you define inside your markdown source files, to do lots of powerful things similar to ActiveRecord. It will go over defining associations, querying, and more!

<%= link_to_markdown_record_html(::MarkdownRecord::ContentFragment.find("content/4_table_top_rpg"), "Table Top Game Example") %>

<!---describe_model
  {
    "type": "example",
    "id":   2,
    "name": "blog"
  }
-->

<!---describe_model
  {
    "type": "example",
    "id":   3,
    "name": "table_top_rpg"
  }
-->

