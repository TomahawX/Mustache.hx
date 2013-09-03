import mustache.Mustache;

class MainTest {

    static function main() {
        var f = function () {
            return 'Hello World !';
        };
        trace(Mustache.render('{{message}}', {message: f}));
    }

}
