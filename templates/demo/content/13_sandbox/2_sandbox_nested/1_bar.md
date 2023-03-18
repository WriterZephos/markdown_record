<!--directory_fragment { "author": "You", "name": "Sandbox", "parent_id": "content/sandbox/foo" } -->
<!--fragment { "name": "Bar", "author": "You" } -->
<!--use_layout:_custom_layout.html.erb-->

Feel free to use this directory as a sandbox to experiment with the things you learn from the guide, without fear of messing up the guide itself. The things defined here are used for automated tests only, so feel free to  delete/alter anything you want here.

When you are done experimenting and want to start creating for real, feel free to delete the entire guide and use the online hosted version for reference going forward.

*Note: you will need to add the .erb extension to this file to use ERB syntax in it.*

Notice how this file's *parent* is `foo`. This is set using the `fragment` DSL command.

<!--model { "id": 1, "type": "markdown_record/tests/child_model", "model_id": 1, "string_field": "hey", "int_field": 100, "float_field": 95.5, "bool_field": true, "date_field": "03/13/2023", "maybe_field": null, "hash_field": {} }-->

<!--model { "id": 2, "type": "markdown_record/tests/child_model", "model_id": 1, "string_field": "asdf", "int_field": 333, "float_field": 10.5, "bool_field": false, "date_field": "01/01/2000", "maybe_field": 7, "hash_field": {} }-->

<!--model { "id": 3, "type": "markdown_record/tests/child_model", "model_id": 2, "string_field": "qwert", "int_field": 42, "float_field": 1776, "bool_field": true, "date_field": "09/11/2001", "maybe_field": null, "hash_field": { "some_data": { "some_field": 555 }}  }-->

<!--model { "id": 4, "type": "markdown_record/tests/child_model", "model_id": 2, "string_field": "ho", "int_field": 42, "float_field": 99.9, "bool_field": false, "date_field": "12/25/2020", "maybe_field": 50, "hash_field": { "some_data": { "some_field": 999 }}  }-->

<!--model { "id": 1, "type": "markdown_record/tests/other_child_model", "model_id": 2, "string_field": "ho", "int_field": 42, "float_field": 99.9, "bool_field": false, "date_field": "12/25/2020", "maybe_field": 50, "hash_field": { "some_data": { "some_field": 999 }}  }-->