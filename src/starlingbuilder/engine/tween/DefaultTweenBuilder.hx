/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.tween;

import Reflect;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

import starlingbuilder.engine.UIBuilder;

/**
     * Default implementation of ITweenBuilder
     *
     * <p>Example data1:</p>
     * <p>{"time":1, "properties":{"scaleX":0.9, "scaleY":0.9, "repeatCount":0, "reverse":true}}</p>
     * <p>Example data2:</p>
     * <p>[{"properties":{"repeatCount":0,"scaleY":0.9,"reverse":true,"scaleX":0.9},"time":1},{"properties":{"repeatCount":0,"alpha":0,"reverse":true},"time":0.5}]</p>
     * <p>Example data3:</p>
     * <p>{"time":0.5,"properties":{"repeatCount":0,"reverse":true},"delta":{"y":-10}}</p>
     *
     * @see ITweenBuilder
     * @see http://wiki.starling-framework.org/builder/tween Using tween
     */
class DefaultTweenBuilder implements ITweenBuilder
{
    private var _saveData:Map<Dynamic, Dynamic>;

    /**
         * Constructor
         */

    public function new()
    {
        _saveData = new Map<DisplayObject, Dynamic>();
    }

    /**
         * @inheritDoc
         */

    public function start(root:DisplayObject, paramsDict:Map<Dynamic, Dynamic>, names:Array<Dynamic> = null):Void
    {
        stop(root, paramsDict, names);

        var array:Array<Dynamic> = getDisplayObjectsByNames(root, paramsDict, names);

        for (obj in array)
        {
            var data:Dynamic = paramsDict[obj];

            var tweenData:Dynamic = data.tweenData;

            if (tweenData)
            {
                if (Std.is(tweenData, Array))
                {
                    for (item in cast(tweenData, Array<Dynamic>))
                        createTweenFrom(obj, item);
                }
                else
                {
                    createTweenFrom(obj, tweenData);
                }
            }
        }
    }

    private function getDisplayObjectsByNames(root:DisplayObject, paramsDict:Map<Dynamic, Dynamic>, names:Array<Dynamic>):Array<Dynamic>
    {
        var array:Array<Dynamic> = [];

        if (names != null)
        {
            for (name in names)
            {
                array.push(UIBuilder.find(cast root, name));
            }
        }
        else
        {
            for (obj in paramsDict.keys())
            {
                if (Reflect.hasField(paramsDict[obj], "tweenData"))
                    array.push(obj);
            }
        }

        return array;
    }

    private function createTweenFrom(obj:DisplayObject, data:Dynamic):Void
    {
        if (!Reflect.hasField(data, "time"))
        {
            trace("Missing tween param: time");
            return;
        }

        var initData:Dynamic = saveInitData(obj, data.properties, data.delta, data.from, data.fromDelta);

        var properties:Dynamic = createProperties(obj, data, initData);

        var tween:Dynamic = Starling.current.juggler.tween(obj, data.time, properties);

        if (!_saveData[obj]) _saveData[obj] = [];

        _saveData[obj].push({tween:tween, init:initData});
    }

    /**
         * @inheritDoc
         */

    public function stop(root:DisplayObject, paramsDict:Map<Dynamic, Dynamic> = null, names:Array<Dynamic> = null):Void
    {
        if (paramsDict == null || names == null)
        {
            stopAll(root);
        }
        else
        {
            var array:Array<Dynamic> = getDisplayObjectsByNames(root, paramsDict, names);

            for (obj in array)
            {
                stopTween(obj);
            }
        }
    }

    private function stopTween(obj:DisplayObject):Void
    {
        var array:Array<Dynamic> = _saveData[obj];

        if (array != null)
        {
            for (data in array)
            {
                var initData:Dynamic = data.init;
                recoverInitData(obj, initData);

                var tween:Dynamic = data.tween;

                if (Std.is(tween, Tween)) //Starling 1.x
                {
                    Starling.current.juggler.remove(cast tween);
                }
                else //Starling 2.x
                {
                    //Starling.current.juggler["removeByID"](cast tween);
                }
            }
        }

        _saveData.remove(obj);
    }

    private function createProperties(obj:Dynamic, data:Dynamic, initData:Dynamic):Dynamic
    {
        var fromData:Dynamic = {};
        var name:String;

        //set from
        if (Reflect.hasField(data, "from"))
        {
            var from:Dynamic = data.from;
            for (name in Reflect.fields(from))
            {
                Reflect.setProperty(obj, name, Reflect.field(from, name));
                Reflect.setField(fromData, name, Reflect.field(initData, name));
            }
        }

        //set fromDelta
        if (Reflect.hasField(data, "fromDelta"))
        {
            var fromDelta:Dynamic = data.fromDelta;
            for (name in Reflect.fields(fromDelta))
            {
                Reflect.setProperty(obj, name, Reflect.getProperty(obj, name) + Reflect.field(fromDelta, name));
                Reflect.setField(fromData, name, Reflect.field(initData, name));
            }
        }

        //clone properties
        var properties:Dynamic;
        if (Reflect.hasField(data, "properties"))
            properties = UIBuilder.cloneObject(data.properties);
        else
            properties = {};

        //set delta
        if (Reflect.hasField(data, "delta"))
        {
            var delta:Dynamic = data.delta;
            for (name in Reflect.fields(delta))
                Reflect.setField(properties, name, Reflect.getProperty(obj, name) + Reflect.field(delta, name));
        }

        //set init data for from and fromDelta (if not exist)
        for (name in Reflect.fields(fromData))
            if (!Reflect.hasField(properties, name))
                Reflect.setField(properties, name, Reflect.field(fromData, name));

        return properties;
    }

    private function recoverInitData(obj:Dynamic, initData:Dynamic):Void
    {
        for (name in Reflect.fields(initData))
        {
            Reflect.setField(obj, name, Reflect.field(initData, name));
        }
    }

    private function saveInitData(obj:Dynamic, properties:Dynamic, delta:Dynamic, from:Dynamic, fromDelta:Dynamic):Dynamic
    {
        var data:Dynamic = {};
        var name:String;

        for (name in Reflect.fields(properties))
        {
            if (Reflect.hasField(obj, name))
            {
                Reflect.setField(data, name, Reflect.field(obj, name));
            }
        }

        for (name in Reflect.fields(delta))
        {
            if (Reflect.hasField(obj, name))
            {
                Reflect.setField(data, name, Reflect.field(obj, name));
            }
        }

        for (name in Reflect.fields(from))
        {
            if (Reflect.hasField(obj, name))
            {
                Reflect.setField(data, name, Reflect.field(obj, name));
            }
        }

        for (name in Reflect.fields(fromDelta))
        {
            if (Reflect.hasField(obj, name))
            {
                Reflect.setField(data, name, Reflect.field(obj, name));
            }
        }

        return data;
    }

    private function stopAll(root:DisplayObject):Void
    {
        var container:DisplayObjectContainer = cast root;

        for (obj in _saveData.keys())
        {
            if (root == obj || container != null && container.contains(cast obj))
                stopTween(cast obj);
        }
    }

}

