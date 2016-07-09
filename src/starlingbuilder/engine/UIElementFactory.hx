/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine;

import openfl.geom.Rectangle;
import openfl.errors.Error;

import starling.textures.Texture;

/**
     * @private
     */
class UIElementFactory
{
    private var _assetMediator:IAssetMediator;

    public function new(assetMediator:IAssetMediator)
    {
        _assetMediator = assetMediator;
    }

    private function setDefaultParams(obj:Dynamic, data:Dynamic):Void
    {
    }

    private function setDirectParams(obj:Dynamic, data:Dynamic):Void
    {
        var array:Array<Dynamic> = [];
        var id:String;
        for (id in Reflect.fields(data.params))
        {
            array.push(id);
        }
        sortParams(array, PARAMS);

        for (id in array)
        {
            var item:Dynamic = data.params[id];

            if (item && Reflect.hasField(item, "cls"))
            {
                try
                {
                    Reflect.setProperty(obj, id, create(item));
                }
                catch (e:Error) {}
            }
            else
            {
                try
                {
                    Reflect.setProperty(obj, id, item);
                }
                catch (e:Error) {}
            }
        }
    }

    private function setDefault(obj:Dynamic, data:Dynamic):Void
    {
        setDefaultParams(obj, data);
        setDirectParams(obj, data);
    }

    private function createTexture(param:Dynamic):Dynamic
    {
        var texture:Texture;
        var scaleRatio:Array<Dynamic>;
        var cls:Class<Dynamic>;
        var data:Dynamic;

        var clsName:String = param.cls;

        switch (clsName)
        {
            case "starling.textures.Texture":
                texture = _assetMediator.getTexture(param.textureName);

                if (texture == null)
                    throw new Error("Texture " + param.textureName + " not found");

                return texture;
            case "feathers.textures.Scale3Textures":
                texture = _assetMediator.getTexture(param.textureName);

                if (texture == null)
                    throw new Error("Texture " + param.textureName + " not found");

                scaleRatio = param.scaleRatio;

                var direction:String = "horizontal";

                if (scaleRatio.length == 3)
                {
                    direction = scaleRatio[2];
                }

                var s3t:Dynamic;
                cls = Type.resolveClass("feathers.textures.Scale3Textures");
                if (direction == "horizontal")
                {
                    s3t = Type.createInstance(cls, [texture, texture.width * scaleRatio[0], texture.width * scaleRatio[1], direction]);
                }
                else
                {
                    s3t = Type.createInstance(cls, [texture, texture.height * scaleRatio[0], texture.height * scaleRatio[1], direction]);
                }

                return s3t;
            case "feathers.textures.Scale9Textures":
                texture = _assetMediator.getTexture(param.textureName);

                if (texture == null)
                    throw new Error("Texture " + param.textureName + " not found");

                scaleRatio = param.scaleRatio;
                var rect:Rectangle = new Rectangle(texture.width * scaleRatio[0], texture.height * scaleRatio[1], texture.width * scaleRatio[2], texture.height * scaleRatio[3]);
                cls = Type.resolveClass("feathers.textures.Scale9Textures");
                var s9t:Dynamic = Type.createInstance(cls, [texture, rect]);
                return s9t;
            case "__AS3__.vec.Vector.<starling.textures.Texture>":
                return _assetMediator.getTextures(param.value);
            case "XML":
                data = _assetMediator.getXml(param.name);

                if (data == null)
                    throw new Error("XML " + param.name + " not found");

                return data;
            case "Object":
                data = _assetMediator.getObject(param.name);

                if (data == null)
                    throw new Error("Object " + param.name + " not found");

                return data;
            case "feathers.data.ListCollection":
                cls = Type.resolveClass(clsName);
                return Type.createInstance(cls, [param.data]);
            case "feathers.data.HierarchicalCollection":
                cls = Type.resolveClass(clsName);
                return Type.createInstance(cls, [param.data]);
            default:
                return null;
        }
    }

    public function create(data:Dynamic):Dynamic
    {
        var obj:Dynamic;
        var constructorParams:Array<Dynamic> = data.constructorParams;

        var res:Dynamic = createTexture(data);
        if (res) return res;

        var cls:Class<Dynamic> = null;

        if (data.customParams && data.customParams.customComponentClass && data.customParams.customComponentClass != "null")
        {
            try
            {
                cls = Type.resolveClass(data.customParams.customComponentClass);
            }
            catch (e:Error)
            {
                trace("Class " + data.customParams.customComponentClass + " can't be instantiated.");
            }
        }

        if (cls == null)
        {
            cls = Type.resolveClass(data.cls);
        }

        var args:Array<Dynamic> = createArgumentsFromParams(constructorParams);

        try
        {
            obj = Type.createInstance(cls, args);
        }
        catch (e:Error)
        {
            obj = Type.createInstance(cls, []);
        }

        setDefault(obj, data);
        return obj;
    }

    private function createArgumentsFromParams(params:Array<Dynamic>):Array<Dynamic>
    {
        var args:Array<Dynamic> = [];

        if (params != null)
        {
            for (param in params)
            {

                if (Reflect.field(param, "cls"))
                {
                    args.push(create(param));
                }
                else
                {
                    args.push(param.value);
                }
            }
        }

        return args;

    }

    public static var PARAMS = {x:1, y:1, width:2, height:2, scaleX:3, scaleY:3, rotation:4};

    public static function sortParams(array:Array<Dynamic>, params:Dynamic):Void
    {
        array.sort(function(e1:String, e2:String):Int
        {
            var value:Int = compare(Reflect.field(params, e1), Reflect.field(params, e2));
            if (value != 0) return value;
            return e1 < e2 ? -1 : 1;
        });
    }

    private static function compare(a:String, b:String)
    {return (a < b) ? -1 : (a > b) ? 1 : 0;}
}

