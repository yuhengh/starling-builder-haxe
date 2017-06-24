/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import feathers.controls.List;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.PopUpManager;
import feathers.data.ListCollection;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

class MailPopup extends Sprite
{
    //auto bind variables
    public var _list:List;
    public var _exitButton:Button;

    public function new()
    {
        super();

        var sprite:Sprite = cast UIBuilderDemo.uiBuilder.create(ParsedLayouts.mail_popup, true, this);
        addChild(sprite);

        var listCollection:ListCollection = new ListCollection();

        for (i in 1...50)
        {
            listCollection.push({label: ("You received a gift " + i)});
        }

        _list.itemRendererFactory = function():IListItemRenderer
        {
            return new MailItemRenderer();
        }
        _list.dataProvider = listCollection;

        _exitButton.addEventListener(Event.TRIGGERED, onExit);
    }

    private function onExit(event:Event):Void
    {
        removeFromParent(true);
    }
}

