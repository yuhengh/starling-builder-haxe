/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.util;

/**
     * @private
     */
class ObjectLocaterUtil
{
    public static function set(obj:Dynamic, propertyName:String, value:Dynamic):Void
    {
        //handle dot access (e.g. foo.bar)
        var array:Array<String> = propertyName.split(".");
        var lastName:String = array.pop();

        var res:Dynamic = obj;

        for (name in array)
        {
            res = Reflect.field(res, name);
        }

        Reflect.setField(res, lastName, value);
    }

    public static function get(obj:Dynamic, propertyName:String):Dynamic
    {
        //handle dot access (e.g. foo.bar)
        var array:Array<String> = propertyName.split(".");

        var res:Dynamic = obj;

        for (name in array)
        {
            res = Reflect.field(res, name);
        }

        return res;
    }

    public static function del(obj:Dynamic, propertyName:String):Void
    {
        var array:Array<String> = propertyName.split(".");
        var lastName:String = array.pop();

        var res:Dynamic = obj;

        for (name in array)
        {
            res = Reflect.field(res, name);
        }

        Reflect.deleteField(res, lastName);
    }

    public static function hasProperty(obj:Dynamic, propertyName:String):Bool
    {
        //handle dot access (e.g. foo.bar)
        var array:Array<String> = propertyName.split(".");

        var res:Dynamic = obj;

        for (name in array)
        {
            if (Reflect.hasField(res, name))
            {
                res = Reflect.field(res, name);
            }
            else
            {
                return false;
            }
        }

        return true;
    }
}

