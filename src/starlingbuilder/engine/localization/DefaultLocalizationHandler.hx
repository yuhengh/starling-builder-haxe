/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.localization;

import starling.display.DisplayObject;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

/**
     * Default implementation of ILocalizationHandler
     *
     * @see ILocalizationHandler
     */
class DefaultLocalizationHandler implements ILocalizationHandler
{
    public function new()
    {
    }

    /**
         * @inheritDoc
         */

    public function localize(object:DisplayObject, text:String, paramsDict:Map<Dynamic, Dynamic>, locale:String):Void
    {
        //Assuming that TextField with auto size will always have pivot align to center
        if (Std.is(object, TextField))
        {
            var textField:TextField = cast object;

            if (textField.autoSize != TextFieldAutoSize.NONE)
            {
                textField.alignPivot();
            }
        }
    }
}

