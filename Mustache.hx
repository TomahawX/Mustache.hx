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
        trace(Mustache.render("My name is {{name}} and I'm {{age}}", [ "name"=>"john", "age"=>30 ]));
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

    private function _replacePattern(pattern:EReg) {
        var expression:String = pattern.matched(1);
        var position:Dynamic = pattern.matchedPos();
        var value:String = "";

        if (context.exists(expression)) {
            value = Std.string(context.get(expression));
        }

        template = pattern.replace(template, value);
    }

    private function _replaceNext():Bool {
        var pattern:EReg = ~/{{([#\/]?[\.\w]+)}}/;
        var replaced:Bool = false; 
        
        if (pattern.match(template)) {
            _replacePattern(pattern);
            replaced = true;
        }

        return replaced;
    }
}

