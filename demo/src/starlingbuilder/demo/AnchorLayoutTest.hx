/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import starling.events.ResizeEvent;
import starling.core.Starling;

import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class AnchorLayoutTest extends Sprite
{
    private var _sprite:Sprite;

    public function new()
    {
        super();

        _sprite = cast UIBuilderDemo.uiBuilder.create(ParsedLayouts.anchorlayout_test, false);

        onResize(null);

        addChild(_sprite);

        addEventListener(TouchEvent.TOUCH, onTouchEvent);

        Starling.current.stage.addEventListener(ResizeEvent.RESIZE, onResize);
    }

    private function onTouchEvent(event:TouchEvent):Void
    {
        var touch:Touch = event.getTouch(this);
        if (touch != null && touch.phase == TouchPhase.ENDED)
        {
            removeFromParent(true);
        }
    }

    private function onResize(event:ResizeEvent):Void
    {
        var stage:Stage = Starling.current.stage;
        _sprite.width = stage.stageWidth;
        _sprite.height = stage.stageHeight;
    }

    override public function dispose():Void
    {
        Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, onResize);
        super.dispose();
    }

}

