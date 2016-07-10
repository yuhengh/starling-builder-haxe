# Starling Builder Haxe

This is a Haxe port of Starling Builder engine. Starling Builder is an open source UI editor for Starling Framework. The original AS3 version repository is from https://github.com/mindjolt/starling-builder-engine


This Haxe version interprets the same layout format of the AS3 version.
It gives you the ability to target both Flash/AIR and non-Flash/AIR platform (mostly html5).
You can check out the online demo project at

http://starlingbuilder.github.io/demo-haxe/

It should work well on desktop, tablet and phone browsers.

#### Setup OpenFL

    haxelib install openfl 3.6.1
	haxelib run openfl setup

#### Setup Starling and Feathers UI

	haxelib install starling
	haxelib git feathers https://github.com/vroad/feathers-openfl

Currently the Starling port is based on Starling 1.6 and the Feathers UI port is based on Feathers UI 2.2.

#### Run the demo

	cd demo
	openfl test flash
	openfl test html5

#### Documentation

For more information, please visit our wiki page at http://wiki.starling-framework.org/builder/start