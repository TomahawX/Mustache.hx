Mustache.hx
===========

> What could be more logical awesome than no logic at all?

[Mustache.hx](https://github.com/dawicorti/Mustache.hx) is an implementation of the [mustache](http://mustache.github.com/) template system in Haxe.

[Mustache](http://mustache.github.com/) is a logic-less template syntax. It can be used for HTML, config files, source code - anything. It works by expanding tags in a template using values provided in a hash or object.

We call it "logic-less" because there are no if statements, else clauses, or for loops. Instead there are only tags. Some tags are replaced with a value, some nothing, and others a series of values.

For a language-agnostic overview of mustache's template syntax, see the `mustache(5)` [manpage](http://mustache.github.com/mustache.5.html).

## Usage

Below is quick example how to use Mustache.hx:

    import mustache.Mustache;

    var view:Dynamic = {
      title: "Joe",
      calc: function () {
        return 2 + 4;
      }
    };

    var output:String = Mustache.render("{{title}} spends {{calc}}", view);

In this example, the `Mustache.render` function takes two parameters: 1) the [mustache](http://mustache.github.com/) template and 2) a `view` object that contains the data and code needed to render the template.

## Templates

A [mustache](http://mustache.github.com/) template is a string that contains any number of mustache tags. Tags are indicated by the double mustaches that surround them. `{{person}}` is a tag, as is `{{#person}}`. In both examples we refer to `person` as the tag's key.

There are several types of tags available in mustache.js.

### Variables

The most basic tag type is a simple variable. A `{{name}}` tag renders the value of the `name` key in the current context. If there is no such key, nothing is rendered.

All variables are HTML-escaped by default. If you want to render unescaped HTML, use the triple mustache: `{{{name}}}`. You can also use `&` to unescape a variable.

View:

    {
      "name": "Chris",
      "company": "<b>GitHub</b>"
    }

Template:

    * {{name}}
    * {{age}}
    * {{company}}
    * {{{company}}}
    * {{&company}}

Output:

    * Chris
    *
    * &lt;b&gt;GitHub&lt;/b&gt;
    * <b>GitHub</b>
    * <b>GitHub</b>

JavaScript's dot notation may be used to access keys that are properties of objects in a view.

View:

    {
      "name": {
        "first": "Michael",
        "last": "Jackson"
      },
      "age": "RIP"
    }

Template:

    * {{name.first}} {{name.last}}
    * {{age}}

Output:

    * Michael Jackson
    * RIP

### Sections

Sections render blocks of text one or more times, depending on the value of the key in the current context.

A section begins with a pound and ends with a slash. That is, `{{#person}}` begins a `person` section, while `{{/person}}` ends it. The text between the two tags is referred to as that section's "block".

The behavior of the section is determined by the value of the key.

#### False Values or Empty Lists

If the `person` key does not exist, or exists and has a value of `null`, `undefined`, or `false`, or is an empty list, the block will not be rendered.

View:

    {
      "person": false
    }

Template:

    Shown.
    {{#person}}
    Never shown!
    {{/person}}

Output:

    Shown.

#### Non-Empty Lists

If the `person` key exists and is not `null`, `undefined`, or `false`, and is not an empty list the block will be rendered one or more times.

When the value is a list, the block is rendered once for each item in the list. The context of the block is set to the current item in the list for each iteration. In this way we can loop over collections.

View:

    {
      "stooges": [
        { "name": "Moe" },
        { "name": "Larry" },
        { "name": "Curly" }
      ]
    }

Template:

    {{#stooges}}
    <b>{{name}}</b>
    {{/stooges}}

Output:

    <b>Moe</b>
    <b>Larry</b>
    <b>Curly</b>

When looping over an array of strings, a `.` can be used to refer to the current item in the list.

View:

    {
      "musketeers": ["Athos", "Aramis", "Porthos", "D'Artagnan"]
    }

Template:

    {{#musketeers}}
    * {{.}}
    {{/musketeers}}

Output:

    * Athos
    * Aramis
    * Porthos
    * D'Artagnan

If the value of a section variable is a function, it will be called in the context of the current item in the list on each iteration.

View:

    {
      "beatles": [
        { "firstName": "John", "lastName": "Lennon" },
        { "firstName": "Paul", "lastName": "McCartney" },
        { "firstName": "George", "lastName": "Harrison" },
        { "firstName": "Ringo", "lastName": "Starr" }
      ],
      "name": function () {
        return this.firstName + " " + this.lastName;
      }
    }

Template:

    {{#beatles}}
    * {{name}}
    {{/beatles}}

Output:

    * John Lennon
    * Paul McCartney
    * George Harrison
    * Ringo Starr

#### Functions

If the value of a section key is a function, it is called with the section's literal block of text, un-rendered, as its first argument. The second argument is a special rendering function that uses the current view as its view argument. It is called in the context of the current view object.

View:

    {
      "name": "Tater",
      "bold": function () {
        return function (text, render) {
          return "<b>" + render(text) + "</b>";
        }
      }
    }

Template:

    {{#bold}}Hi {{name}}.{{/bold}}

Output:

    <b>Hi Tater.</b>
