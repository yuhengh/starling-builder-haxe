/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import starling.display.Button;
import starling.core.Starling;

import starling.display.Quad;

import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class LocalizationTest extends Sprite
{
    private var _sprite:Sprite;
    private var _params:Map<Dynamic, Dynamic>;

    public function new()
    {
        super();

        var stage:Stage = Starling.current.stage;
        var quad:Quad = new Quad(stage.stageWidth, stage.stageHeight);
        addChild(quad);

        var data:Dynamic = UIBuilderDemo.uiBuilder.load(ParsedLayouts.localization_test, false);
        _sprite = data.object;
        _params = data.params;
        addChild(_sprite);

        var sprite:Sprite = new Sprite();
        var data:Array<Dynamic> = [
            {label:"en_US"},
            {label:"de_DE"},
            {label:"es_ES"},
            {label:"fr_FR"},
            {label:"cn_ZH"}
        ];

        for (i in 0...data.length)
        {
            var button:Button = new Button(UIBuilderDemo.assetManager.getTexture("blue_button"));
            button.text = data[i].label;
            button.fontColor = 0xffffff;
            button.fontName = "GrilledCheeseBTN_Size36_ColorFFFFFF";
            button.fontSize = 30;
            button.y = (button.height + 10) * i;
            button.addEventListener(Event.TRIGGERED, onButton);
            sprite.addChild(button);
        }

        sprite.y = 300;

        addChild(sprite);

        quad.addEventListener(TouchEvent.TOUCH, onTouchEvent);
    }

    private function onTouchEvent(event:TouchEvent):Void
    {
        var touch:Touch = event.getTouch(this);
        if (touch != null && touch.phase == TouchPhase.ENDED)
        {
            removeFromParent(true);
        }
    }

    private function onButton(event:Event, data:Dynamic):Void
    {
        var locale:String = cast(event.target, Button).text;

        UIBuilderDemo.uiBuilder.localization.locale = locale;
        UIBuilderDemo.uiBuilder.localizeTexts(_sprite, _params);
    }
}

