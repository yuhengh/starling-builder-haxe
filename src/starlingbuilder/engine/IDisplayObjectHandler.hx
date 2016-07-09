/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine;

import starling.display.DisplayObject;

/**
     * Interface of callback when the display object is created in UIBuilder.
     * It's called internally by UIBuilder.load() or UIBuilder.create().
     *
     * @see starlingbuilder.engine.UIBuilder
     */
interface IDisplayObjectHandler
{
    function onCreate(obj:DisplayObject, paramsDict:Map<Dynamic, Dynamic>):Void;
}

