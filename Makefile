PACKAGE = mustache

all: test clean

package:
	@zip -r package.zip haxelib.json $(PACKAGE)

local: package
	@haxelib local package.zip

test: local
	@haxe -cp test -main MainTest -neko test/MainTest.n
	@neko test/MainTest.n

clean:
	rm test/MainTest.n package.zip

.PHONY: all test local package clean