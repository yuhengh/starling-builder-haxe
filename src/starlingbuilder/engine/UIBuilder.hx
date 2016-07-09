/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine;

import openfl.geom.Rectangle;
import haxe.Json;
import openfl.errors.Error;
import starlingbuilder.engine.format.DefaultDataFormatter;
import starlingbuilder.engine.format.IDataFormatter;
import starlingbuilder.engine.localization.DefaultLocalizationHandler;
import starlingbuilder.engine.localization.ILocalization;
import starlingbuilder.engine.localization.ILocalizationHandler;
import starlingbuilder.engine.tween.ITweenBuilder;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;


/**
     * Main class of Starling Builder engine API
     *
     * <p>Exmaple of creating a UIBuilder</p>
     *
     * <listing version="3.0">
     *     var assetManager:AssetManager = new AssetManager();
     *     var assetMediator:AssetMediator = new AssetMediator(assetManager);
     *     var uiBuilder:UIBuilder = new UIBuilder(assetMediator);</listing>
     *
     *
     * <p>A simple example to create display objects from layout</p>
     *
     * <listing version="3.0">
     *     var sprite:Sprite = uiBuilder.create(layoutData) as Sprite;
     *     addChild(sprite);</listing>
     *
     * <p>A more elaborate way to create UI element inside a class, and bind the public underscore property automatically</p>
     *
     * <listing version="3.0">
     *     public class MailPopup extends Sprite
     *     {
     *         //auto bind variables
     *         public var _list:List;
     *         public var _exitButton:Button;
     *         <br>
     *         public function MailPopup()
     *         {
     *             super();
     *             <br>
     *             var sprite:Sprite = uiBuilder.create(ParsedLayouts.mail_popup, true, this) as Sprite;
     *             addChild(sprite);
     *             <br>
     *             _exitButton.addEventListener(Event.TRIGGERED, onExit);
     *         }
     *         <br>
     *         private function onExit(event:Event):Void
     *         {
     *             PopUpManager.removePopUp(this, true);
     *         }
     *     }</listing>
     *
     * @see http://wiki.starling-framework.org/builder/start Starling Builder wiki page
     * @see http://github.com/mindjolt/starling-builder-engine/tree/master/demo Starling Builder demo project
     * @see http://github.com/mindjolt/starling-builder-engine/tree/master/scaffold Starling Builder scaffold project
     *
     */
class UIBuilder implements IUIBuilder
{
    private var _assetMediator:IAssetMediator;

    private var _dataFormatter:IDataFormatter;

    private var _factory:UIElementFactory;

    private var _localization:ILocalization;

    private var _localizationHandler:ILocalizationHandler;

    private var _displayObjectHandler:IDisplayObjectHandler;

    private var _tweenBuilder:ITweenBuilder;

    /**
         * Constructor
         * @param assetMediator asset mediator
         * @param forEditor whether it's used for the editor
         * @param template template for saving layout
         * @param localization optional localization instance
         * @param tweenBuilder optional tween builder instance
         */

    public function new(assetMediator:IAssetMediator, localization:ILocalization = null, tweenBuilder:ITweenBuilder = null)
    {
        _assetMediator = assetMediator;
        _dataFormatter = new DefaultDataFormatter();
        _factory = new UIElementFactory(_assetMediator);
        _localization = localization;
        _localizationHandler = new DefaultLocalizationHandler();
        _tweenBuilder = tweenBuilder;
    }

    /**
         * @copy IUIBuilder#load()
         * @see #create()
         */

    public function load(data:Dynamic, trimLeadingSpace:Bool = true, binder:Dynamic = null):Dynamic
    {
        if (_dataFormatter != null)
            data = _dataFormatter.read(data);

        var paramsDict = new Map<DisplayObject, Dynamic>();

        var root:DisplayObject = loadTree(data.layout, _factory, paramsDict);

        if (trimLeadingSpace && Std.is(root, DisplayObjectContainer))
            doTrimLeadingSpace(cast root);

        localizeTexts(root, paramsDict);

        if (binder)
            bind(binder, paramsDict);

        return {object:root, params:paramsDict, data:data};
    }

    private function loadTree(data:Dynamic, factory:UIElementFactory, paramsDict:Map<Dynamic, Dynamic>):DisplayObject
    {
        var obj:DisplayObject = factory.create(data);
        paramsDict[obj] = data;

        var container:DisplayObjectContainer = null;

        if (Std.is(obj, DisplayObjectContainer))
            container = cast obj;

        if (container != null)
        {
            if (data.children)
            {
                for (item in cast(data.children, Array<Dynamic>))
                {
                    if (item.customParams && item.customParams.forEditor)
                        continue;

                    container.addChild(loadTree(item, factory, paramsDict));
                }
            }

            if (isExternalSource(data))
            {
                var externalData:Dynamic = _dataFormatter.read(_assetMediator.getExternalData(data.customParams.source));
                container.addChild(create(externalData));
                paramsDict[obj] = data;
            }
        }

        if (_displayObjectHandler != null)
            _displayObjectHandler.onCreate(obj, paramsDict);

        return obj;
    }

    /**
         * @private
         */

    private function isExternalSource(param:Dynamic):Bool
    {
        if (param && param.customParams && param.customParams.source)
        {
            return true;
        }
        else
        {
            return false;
        }
    }


    private static var RESOURCE_CLASSES:Array<String> = ["XML", "Object", "feathers.data.ListCollection", "feathers.data.HierarchicalCollection"];


    private function roundToDigit(value:Float, digit:Int = 2):Float
    {
        var a:Float = Math.pow(10, digit);
        return Math.round(value * a) / a;
    }

    private static function doTrimLeadingSpace(container:DisplayObjectContainer):Void
    {
        var minX:Float = Math.POSITIVE_INFINITY;
        var minY:Float = Math.POSITIVE_INFINITY;

        var i:Int;
        var obj:DisplayObject;

        var num:Int = container.numChildren;
        for (i in 0 ... num)
        {
            obj = container.getChildAt(i);

            var rect:Rectangle = obj.getBounds(container);

            if (rect.x < minX)
            {
                minX = rect.x;
            }

            if (rect.y < minY)
            {
                minY = rect.y;
            }
        }

        num = container.numChildren;
        for (i in 0 ... num)
        {
            obj = container.getChildAt(i);
            obj.x -= minX;
            obj.y -= minY;
        }
    }

    /**
         * @private
         */

    public static function cloneObject(object:Dynamic):Dynamic
    {
        return Json.parse(Json.stringify(object));
    }

    /**
         * @inheritDoc
         */

    public function createUIElement(data:Dynamic):Dynamic
    {
        return {object:_factory.create(data), params:data};
    }

    /**
         * @private
         */

    public function get_dataFormatter():IDataFormatter
    {
        return _dataFormatter;
    }

    /**
         * @private
         */

    public function set_dataFormatter(value:IDataFormatter):Void
    {
        _dataFormatter = value;
    }

    /**
         * @copy IUIBuilder#create()
         * @see #load()
         */

    public function create(data:Dynamic, trimLeadingSpace:Bool = true, binder:Dynamic = null):Dynamic
    {
        return load(data, trimLeadingSpace, binder).object;
    }

    /**
         * @inheritDoc
         */

    public function localizeTexts(root:DisplayObject, paramsDict:Map<Dynamic, Dynamic>):Void
    {
        if (_localization != null && _localization.locale != null)
        {
            localizeTree(root, paramsDict);
        }
    }

    private function localizeTree(object:DisplayObject, paramsDict:Map<Dynamic, Dynamic>):Void
    {
        var params:Dynamic = paramsDict[object];

        if (params && params.customParams && params.customParams.localizeKey)
        {
            var text:String = _localization.getLocalizedText(params.customParams.localizeKey);
            if (text == null) text = params.customParams.localizeKey;

            try
            {
                Reflect.setProperty(object, "text", text);
            } catch (e:Error)
            {}

            try
            {
                Reflect.setProperty(object, "label", text);
            } catch (e:Error)
            {}

            if (_localizationHandler != null)
                _localizationHandler.localize(object, text, paramsDict, _localization.locale);
        }


        var container:DisplayObjectContainer = null;

        if (Std.is(object, DisplayObjectContainer))
            container = cast object;

        if (container != null)
        {
            var num:Int = container.numChildren;
            var i:Int;
            for (i in 0 ... num)
            {
                localizeTree(container.getChildAt(i), paramsDict);
            }
        }
    }

    /**
         * @inheritDoc
         */

    public function get_tweenBuilder():ITweenBuilder
    {
        return _tweenBuilder;
    }

    /**
         * @private
         */

    public function set_tweenBuilder(value:ITweenBuilder):ITweenBuilder
    {
        _tweenBuilder = value;
        return value;
    }

    /**
         * @inheritDoc
         */

    public function get_localization():ILocalization
    {
        return _localization;
    }

    /**
         * @private
         */

    public function set_localization(value:ILocalization):ILocalization
    {
        _localization = value;
        return value;
    }

    /**
         * @inheritDoc
         */

    public function get_localizationHandler():ILocalizationHandler
    {
        return _localizationHandler;
    }

    /**
         * @private
         */

    public function set_localizationHandler(value:ILocalizationHandler):ILocalizationHandler
    {
        _localizationHandler = value;
        return value;
    }

    /**
         * @inheritDoc
         */

    public function get_displayObjectHandler():IDisplayObjectHandler
    {
        return _displayObjectHandler;
    }

    /**
         * @private
         */

    public function set_displayObjectHandler(value:IDisplayObjectHandler):IDisplayObjectHandler
    {
        _displayObjectHandler = value;
        return value;
    }

    public var tweenBuilder(get, set):ITweenBuilder;

/**
         * Localization property
         */
    public var localization(get, set):ILocalization;

/**
         * Localization handler
         */
    public var localizationHandler(get, set):ILocalizationHandler;

/**
         * Display object handler
         */
    public var displayObjectHandler(get, set):IDisplayObjectHandler;

    /**
         *  Helper function to find ui element
         * @param container root display object container you want to find
         * @param property path separated by dots (e.g. bottom_container.layout.button1)
         * @return
         */

    public static function find(container:DisplayObjectContainer, path:String):DisplayObject
    {
        var array:Array<String> = path.split(".");

        var obj:DisplayObject = null;

        for (name in array)
        {
            if (container == null) return null;

            obj = container.getChildByName(name);
            container = cast obj;
        }

        return obj;
    }

    /**
         *  Helper function to bind UI elements to properties.
         *  It loops through all the UI elements, if the name starts with "_", then bind to the object property with the same name.
         *
         *  <p>NOTE: This function will ONLY work if your object._xxx is public variable.</p>
         *
         * @param view object you want to bind to
         * @param paramsDict params dictionary of meta data
         */

    public static function bind(view:Dynamic, paramsDict:Map<Dynamic, Dynamic>):Void
    {
        for (obj in paramsDict.keys())
        {
            var name:String = null;

            try
            {
                name = Reflect.getProperty(obj, "name");
            }
            catch (e:Error) {}

            if (name != null && name.charAt(0) == "_")
            {
                try
                {
                    Reflect.setProperty(view, name, obj);
                }
                catch (e:Error) {}
            }
        }
    }

    /***
         * Helper function to find elements by tag
         * @param tag name of the tag
         * @param paramsDict params dictionary of meta data
         * @return array of objects with the tag, if not found then return empty array
         */

    public static function findByTag(tag:String, paramsDict:Map<Dynamic, Dynamic>):Array<Dynamic>
    {
        var result:Array<Dynamic> = [];

        for (obj in Reflect.fields(paramsDict))
        {
            var param:Dynamic = paramsDict[obj];
            if (param && param.customParams && param.customParams.tag == tag)
            {
                result.push(obj);
            }
        }

        return result;
    }
}

