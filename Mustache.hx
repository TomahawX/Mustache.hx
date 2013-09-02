class Mustache {

    private var template:String;
    private var data:Map<String, Dynamic>;
    private var context:Map<String, Dynamic>;

    private function new(template:String, data:Map<String, Dynamic>) {
        this.template = new String(template);
        this.data = data;
        this.context = data;
    }

    static function main() {
        var dude:Map<String, Dynamic> = ["name"=> "john", "age"=> 30];
        trace(Mustache.render("My name is {{#dude}} {{name}} and I'm {{age}} {{/dude}}", [ "dude"=> dude]));
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
            context = context.get(expression);
        }
        
    }

    private function _replacePattern(pattern:EReg) {
        var value:String = '';

        if (pattern.matched(2).length == 0) {
            value = _replaceVariable(pattern);
        } else if (pattern.matched(2) == '#') {
            _replaceBlockOpener(pattern);
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

