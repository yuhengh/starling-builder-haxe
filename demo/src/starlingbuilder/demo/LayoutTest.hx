/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class LayoutTest extends Sprite
{
    private var _sprite:Sprite;

    public function new()
    {
        super();

        _sprite = cast UIBuilderDemo.uiBuilder.create(ParsedLayouts.layout_test, false);
        addChild(_sprite);

        addEventListener(TouchEvent.TOUCH, onTouchEvent);
    }

    private function onTouchEvent(event:TouchEvent):Void
    {
        var touch:Touch = event.getTouch(this);
        if (touch != null && touch.phase == TouchPhase.ENDED)
        {
            removeFromParent(true);
        }
    }
}

