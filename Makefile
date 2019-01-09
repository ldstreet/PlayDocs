install:
	swift package update
	swift build -c release -Xswiftc -static-stdlib
	install .build/Release/PlayDocs /usr/local/bin/playdocs