/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import feathers.controls.renderers.LayoutGroupListItemRenderer;

import starling.display.Sprite;
import starling.text.TextField;

class MailItemRenderer extends LayoutGroupListItemRenderer
{
    public var _text:TextField;

    private var _sprite:Sprite;

    public function new()
    {
        super();
    }

    override private function initialize():Void
    {
        if (_sprite == null)
        {
            _sprite = cast UIBuilderDemo.uiBuilder.create(ParsedLayouts.mail_item, true, this);
            addChild(_sprite);
        }
    }

    override public function set_data(value:Dynamic):Dynamic
    {
        super.data = value;

        if (_data)
            _text.text = _data.label;

        return value;
    }
}

