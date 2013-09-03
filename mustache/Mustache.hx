package mustache;

class Mustache {

    private var template:String;
    private var data:Dynamic;
    private var context:Dynamic;
    private var stack:Array<Dynamic>;
    private var replacing:Bool;

    private function new(template:String, data:Dynamic) {
        this.template = new String(template);
        this.data = data;
        this.context = data;
        this.stack = [];
        this.replacing = true;
    }

    static public function render(template:String, data:Dynamic):String {
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

    private function _getValue(key:String):Dynamic {
        var raw:Dynamic = Reflect.getProperty(context, key);
        var value:Dynamic = raw;
        if (Reflect.isFunction(raw)) {
            value = raw();
        }
        return value;
    }

    private function _replaceVariable(pattern:EReg):String {
        var expression:String = pattern.matched(3);

        return Std.string(_getValue(expression));
    }

    private function _replaceArray(array:Array<Dynamic>, beginPattern:EReg, endPattern:EReg) {
        var beginPosition:Dynamic = beginPattern.matchedPos();
        var endPosition:Dynamic = endPattern.matchedPos();
        var beforeArray:String = template.substring(0, beginPosition.pos);
        var afterArray:String = template.substring(endPosition.pos + endPosition.len, template.length);
        var arrayString:String = template.substring(beginPosition.pos + beginPosition.len, endPosition.pos);
        var value:String = '';

        for (element in array) {
            value += Mustache.render(arrayString, element);
        }

        template = beforeArray + value + afterArray;
    }

    private function _replaceBlockOpener(pattern:EReg) {
        var expression:String = pattern.matched(3);
        
        if (Std.is(_getValue(expression), Array)) {
            replacing = false;
            var endPattern:EReg = new EReg("{{/" + expression + "}}", 'g');
            if (endPattern.match(template)) {
                _replaceArray(_getValue(expression), pattern, endPattern);
            } else {
                replacing = true;
            }
        } else if (Reflect.isObject(_getValue(expression))) {
            stack.push({name: expression, context: context});
            context = _getValue(expression);
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
        var tag:String = pattern.matched(2);
        replacing = true;

        if (tag.length == 0) {
            value = _replaceVariable(pattern);
        } else if (tag == '#') {
            _replaceBlockOpener(pattern);
        } else if (tag == '/') {
            _replaceBlockCloser(pattern);
        }
        if (replacing) {
            template = pattern.replace(template, value);
        }
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

