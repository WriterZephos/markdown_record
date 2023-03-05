## Content DSL

While writing documentation in your markdown source files, you can define json data using HTML comments which will then be made available to you within your application code (if you define matching models), or directly served via built in routes.

To do this, simply write an HTML comment like this in your markdown files:

```html
<!--describe_model 
  { 
    "type": "markdown_record/demo/dsl_command",
    "id": 1, 
    "name": 
    "describe_model",
    "example_id": 1
  } 
-->
```
*Note: you can write these JSON object inline as well to be more concise.*

As you can see, all that is required is a JSON object inside a special comment that defines your data. The `describe_model` part of the comment is a DSL commant that tells MarkdownRecord how to process the comment, and in this case it will take your JSON object and include it in its final renderd JSON output, which will automatically make it available via the provided routes and controllers. If this part is missing or unrecognized, then the comment will be treated as a plain HTML comment and nothing will be done with its contents.

There are several different DSL commands that you can use to define application data within your markdown source documents. They are as follows:

<!--describe_model { "type": "markdown_record/demo/dsl_command", "id": 1, "name": "describe_model", "example_id": 1 } -->
<!--describe_model_attribute:description:string-->
- `describe_model` is the main command that tells MarkdownRecord that you want to define a model or JSON object. The only attribute required in the json object you provide is the `type` attribute, which is used as an index in the final JSON output (each index points to an array of objects of that type). The type can be whatever you want if you don't plan on using corresponding Ruby models. If you *do* plan to use corresponding Ruby models, then the `type` attribute should match the fully qualified class name of the model in underscore form (i.e. `Foo::BarBaz` would be `foo/bar_baz`). 
    
    MarkdownRecord puts each model in a stack structure during rendering, and remembers the order in which models are defined within a single markdown file. This is important, as the next command in this list allows you to add additional attributes where the values are taken from your markdown content itself. The model that attributes get assigned to in this way is always the model at the top of the stack.

    See the example above.
<!--end_describe_model_attribute-->

<!--end_describe_model-->
<!--describe_model { "type": "markdown_record/demo/dsl_command", "id": 2, "name": "describe_model_attribute", "example_id": 1 } -->
<!--describe_model_attribute:description:string--> 
- `describe_model_attribute:<attribute_name>:<type>` tells MarkdownRecord that any text that follows should be assigned to the top model on the stack as the value of the given attribute, until it sees the `end_describe_model_attribute` command.
  
    The `type` part of this command can be `html`, `md`, `int`, `float`, `string`, or omitted. MarkdownRecord will process the final value of the attribute differently based on this value. If the type is `html`, it will be rendered into an html string. If it is `md`, then it will be left as is and slightly cleaned up to remove leading and trailing white space. If it is `int` or `float`, it will be parsed accordingly into an numeric value, and if it is `string`, it will be stripped of any markdown syntax and all leading and trailing whitespace will be removed. The `string` option will also cause multiple newlines to be reduced to a single newline. If the type option is omitted, MarkdownRecord will not process the attribute value and it will contain the raw content read from the markdown file.

    Example:

    ```html
    <!--describe_model_attribute:description:string--> 
    ```
<!--end_describe_model_attribute-->
<!--end_describe_model-->
<!--describe_model { "type": "markdown_record/demo/dsl_command", "id": 3, "name": "end_describe_model_attribute", "example_id": 1 } -->
<!--describe_model_attribute:description:string-->
- `end_describe_model_attribute` tells MarkdownRecord to stop assigning text as an attribute value to the top model on the stack. If the top most model is popped before this command is given or the end of the source file is reached, then it implicitly stops assigning text to it.

    Example:

    ```html
    <!--end_describe_model_attribute-->
    ```
<!--end_describe_model_attribute-->
<!--end_describe_model-->
<!--describe_model { "type": "markdown_record/demo/dsl_command", "id": 4, "name": "end_describe_model", "example_id": 1 } -->
<!--describe_model_attribute:description:string-->
- `end_describe_model` tells MarkdownRecord to pop the top model of the stack. This command isn't necessary unless you are defining models in a way that requires you to assign attributes to a model that is no longer the top model on the stack.

    Example:
    
    ```html
    <!--end_describe_model-->
    ```
<!--end_describe_model_attribute-->
<!--end_describe_model-->
<!--describe_model { "type": "markdown_record/demo/dsl_command", "id": 5, "name": "fragment", "example_id": 1 } -->
<!--describe_model_attribute:description:string-->
- `fragment` is similar to `describe_model` in that it expects a JSON object, but the object is assigned to the `meta` attribute of the `ContentFragment` corresponding to the current markdown file. As such, this command should only be used once in each file. This command provides a way of attaching custom data to ContentFragments, such as a layout you want to use for rendering from a controller, details about the content's author, or perhaps who should be able to access it, etc. You can then interact this data in your application code.

    Since content is not just rendered for each individual file, but is also concatenated into rendered files for each directory, the ContentFraments representing these concatenated files will have each file's fragment meta data as a nested object, indexed by the respective file's path.

    Example:
    
    ```html
    <!--fragment { "author": "Bryant Morrill" } -->
    ```
<!--end_describe_model_attribute-->
<!--end_describe_model-->
<!--describe_model { "type": "markdown_record/demo/dsl_command", "id": 6, "name": "use_layout", "example_id": 1 } -->
<!--describe_model_attribute:description:string-->
- `use_layout:<path>` simply specifies a layout by its relative file path to use when rendering the current markdown file to HTML. This is useful for when you have specific markdown files that you want to render using a different layout than the layout configured for use with all other files.
<!--end_describe_model_attribute-->

    Example:
    
    ```html
    <!--use_layout:_custom_layout.html.erb-->
    ```

You can view this document's source files in `markdown_record/content` to see some of the above DSL commands in use.