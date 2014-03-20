import mustache.Mustache;

class MainNonFalseTest {

    static function main() {
        trace(Mustache.render('{{#non?}}hello{{/non?}}', {"non?": false}));
    }

}
