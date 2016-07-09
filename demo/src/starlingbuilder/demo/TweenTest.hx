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

class TweenTest extends Sprite
{
    private var _sprite:Sprite;

    public function new()
    {
        super();

        var data:Dynamic = UIBuilderDemo.uiBuilder.load(ParsedLayouts.tween_test, false);
        _sprite = cast data.object;
        addChild(_sprite);

        UIBuilderDemo.uiBuilder.tweenBuilder.start(_sprite, data.params);

        addEventListener(TouchEvent.TOUCH, onTouchEvent);
    }

    override public function dispose():Void
    {
        UIBuilderDemo.uiBuilder.tweenBuilder.stop(_sprite);
        super.dispose();
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

