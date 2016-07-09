/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.format;
import haxe.Json;

/**
     * @private
     */
class DefaultDataFormatter implements IDataFormatter
{
    public function new()
    {
    }

    public function read(data:Dynamic):Dynamic
    {
        if (Std.is(data, String))
        {
            return Json.parse(data);
        }
        else
        {
            return data;
        }
    }
}

