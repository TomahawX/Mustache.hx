class Mustache {

    private var template:String;
    private var data:Map<String, Dynamic>;
    private var context:Map<String, Dynamic>;
    private var stack:Array<Dynamic>;

    private function new(template:String, data:Map<String, Dynamic>) {
        this.template = new String(template);
        this.data = data;
        this.context = data;
        this.stack = [];
    }

    static function main() {
        var info:Map<String, Dynamic> = ["situation"=> "Married"];
        var dude:Map<String, Dynamic> = ["name"=> "john", "age"=> 30, "info"=> info];
        trace(Mustache.render("My name is {{#dude}}{{name}} and I'm {{age}}. I'm {{#info}}{{situation}}{{/info}}{{/dude}}. {{message}}", [ "dude"=> dude, "message"=> "How are you ?"]));
    }

    static function render(template:String, data:Map<String, Dynamic>):String {
        var mustache:Mustache = new Mustache(template, data);
        return mustache._render();
    }

    private function _render():String {
        var canReplace:Bool = true;
        while(canReplace){
            canReplace = _replaceNext();
        }
        return template;
    }

    private function _replaceVariable(pattern:EReg):String {
        var value:String = '';
        var expression:String = pattern.matched(3);

        if (context.exists(expression)) {
            value = Std.string(context.get(expression));
        }

        return value;
    }

    private function _replaceBlockOpener(pattern:EReg) {
        var expression:String = pattern.matched(3);
        
        if (context.exists(expression) && Reflect.isObject(context.get(expression))) {
            stack.push({name: expression, context: context});
            context = context.get(expression);
        }
    }

    private function _replaceBlockCloser(pattern:EReg) {
        var expression:String = pattern.matched(3);

        if (stack.length > 0 && expression == stack[stack.length - 1].name) {
            context = stack.pop().context;
        }
    }

    private function _replacePattern(pattern:EReg) {
        var value:String = '';
        var fullExpression:String = pattern.matched(2);

        if (fullExpression.length == 0) {
            value = _replaceVariable(pattern);
        } else if (fullExpression == '#') {
            _replaceBlockOpener(pattern);
        } else if (fullExpression == '/') {
            _replaceBlockCloser(pattern);
        }

        template = pattern.replace(template, value);
    }

    private function _replaceNext():Bool {
        var pattern:EReg = ~/{{(([#\/]?)([\.\w]+))}}/;
        var replaced:Bool = false; 
        
        if (pattern.match(template)) {
            _replacePattern(pattern);
            replaced = true;
        }

        return replaced;
    }
}

