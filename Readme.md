Mustache.hx
===========

> What could be more logical awesome than no logic at all?

[Mustache.hx](https://github.com/dawicorti/Mustache.hx) is an implementation of the [mustache](http://mustache.github.com/) template system in Haxe.

[Mustache](http://mustache.github.com/) is a logic-less template syntax. It can be used for HTML, config files, source code - anything. It works by expanding tags in a template using values provided in a hash or object.

We call it "logic-less" because there are no if statements, else clauses, or for loops. Instead there are only tags. Some tags are replaced with a value, some nothing, and others a series of values.

For a language-agnostic overview of mustache's template syntax, see the `mustache(5)` [manpage](http://mustache.github.com/mustache.5.html).

## Usage

Below is quick example how to use Mustache.hx:

    var view:Dynamic = {
        title: "Joe"
    };

    view.calc = function () {
        return 2 + 4;
    };

    var output:String = Mustache.render("{{title}} spends {{calc}}", view);


In this example, the `Mustache.render` function takes two parameters: 1) the [mustache](http://mustache.github.com/) template and 2) a `view` object that contains the data and code needed to render the template.

## Templates

A [mustache](http://mustache.github.com/) template is a string that contains any number of mustache tags. Tags are indicated by the double mustaches that surround them. `{{person}}` is a tag, as is `{{#person}}`. In both examples we refer to `person` as the tag's key.
