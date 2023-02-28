# API Docs

This document describes the routes and controllers provided automatically by MarkdownRecord and provides an example of how to use its embedded json DSL to define application data right alongside your written content.

While writing documentation for your API (or any other software, like this Rails engine), you can define json data using HTML comments which will then be made available to you within your application if you define matching models, or directly served via the provided routes and controllers.

To do this, simply write an HTML comment like this:

```html
<!--describe_model
  {
    "type": "dsl_command",
    "id":   1,
    "name": "describe_model",
    "example_id": 1
  }
-->
```

As you can see, all that is required is a JSON object inside the comment that defines your data. The `describe_model` part of the comment is a DSL commant that tells MarkdownRecord how to process the comment. If this part is missing or unrecognized, then the comment will be treated as a plain HTML comment and nothing will be done with its contents.

There are several different DSL commands that you can use to define application data within your markdown source documents. They are as follows:

- <!--describe_model_attribute-->`describe_model` is the main command that tells MarkdownRecord that you want to define a model or json object. The only attribute required in the json object you provide is the `type` attribute, which can be anything as long as you don't plan on using coresponding models. If you *do* plan to use corresponding models, then `type` attribute should match the fully qualified class name of the model. <!--end_describe_model_attribute-->
- asdf