/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import starling.events.ResizeEvent;
import starlingbuilder.engine.util.StageUtil;
import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class HUD extends Sprite
{
    private var _sprite:Sprite;

    //auto bind variables
    public var _topContainer:Sprite;
    public var _bottomContainer:Sprite;
    public var _settingsButton:Button;

    public var _background:Image;

    public function new()
    {
        super();

        _background = new Image(UIBuilderDemo.assetManager.getTexture("background"));
        addChild(_background);

        _sprite = cast UIBuilderDemo.uiBuilder.create(ParsedLayouts.hud, false, this);
        addChild(_sprite);

        onResize(null);

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

        _topContainer.x = stage.stageWidth * 0.5;
        _topContainer.y = 0;

        _bottomContainer.x = stage.stageWidth * 0.5;
        _bottomContainer.y = stage.stageHeight;

        _settingsButton.x = stage.stageWidth + 4;
        _settingsButton.y = stage.stageHeight + 4;

        StageUtil.fitBackground(_background);
    }

    override public function dispose():Void
    {
        Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, onResize);
        super.dispose();
    }
}

