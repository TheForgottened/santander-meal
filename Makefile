.PHONY: build-android build-ios-archive pre-compilation build-launcher-icons

build-android: pre-compilation
	flutter build apk

build-ios-archive: pre-compilation
	flutter build ipa

pre-build: build-launcher-icons

build-launcher-icons:
	dart run flutter_launcher_icons
