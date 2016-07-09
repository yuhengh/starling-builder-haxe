/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.util;

import openfl.system.Capabilities;
import openfl.display.Stage;
import openfl.geom.Rectangle;
import openfl.geom.Point;

import starling.core.Starling;

import starling.display.DisplayObject;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;

/**
     * Helper class to support multiple resolution
     *
     * <p>Example usage:</p>
     *
     * <listing version="3.0">
     *     var stageUtil:StageUtil = new StageUtil(stage);
     *     var size:Point = stageUtil.getScaledStageSize();
     *     var starling:Starling = new Starling(Game, stage, new Rectangle(0, 0, stageUtil.stageWidth, stageUtil.stageHeight));
     *     starling.stage.stageWidth = size.x;
     *     starling.stage.stageHeight = size.y;</listing>
     *
     * @see http://wiki.starling-framework.org/builder/multiple_resolution Multiple resolution support
     * @see http://github.com/mindjolt/starling-builder-engine/tree/master/demo Starling Builder demo project
     */
class StageUtil
{
    public var stageWidth(get, null):Int;
    public var stageHeight(get, null):Int;

    private var _stage:Stage;
    private var _designStageWidth:Int;
    private var _designStageHeight:Int;
    private var _supportRotation:Bool;

    /**
         * Constructor
         * @param stage flash stage
         * @param designStageWidth design stage width of the project
         * @param designStageHeight design stage height of the project
         */

    public function new(stage:Stage, designStageWidth:Int = 640, designStageHeight:Int = 960, supportRotation:Bool = false)
    {
        _stage = stage;

        _designStageWidth = designStageWidth;
        _designStageHeight = designStageHeight;

        _supportRotation = supportRotation;
    }

    /**
         * Return stage width of the device
         */

    public function get_stageWidth():Int
    {
        var iOS:Bool = isiOS();
        var android:Bool = isAndroid();

        if (iOS || android)
        {
            return _stage.stageWidth;
        }
        else
        {
            return _stage.stageWidth;
        }
    }

    /**
         * Return stage height of the device
         */

    public function get_stageHeight():Int
    {
        var iOS:Bool = isiOS();
        var android:Bool = isAndroid();

        if (iOS || android)
        {
            return _stage.stageHeight;
        }
        else
        {
            return _stage.stageHeight;
        }
    }

    /**
         * Calculate the scaled starling stage size
         *
         * @param stageWidth stageWidth of flash stage, if not specified then use this.stageWidth
         * @param stageHeight stageHeight of flash stage, if not specified then use this.stageHeight
         * @return the scaled starling stage
         */

    public function getScaledStageSize(stageWidth:Int = 0, stageHeight:Int = 0):Point
    {
        if (stageWidth == 0 || stageHeight == 0)
        {
            stageWidth = this.stageWidth;
            stageHeight = this.stageHeight;
        }

        var designWidth:Int;
        var designHeight:Int;

        var rotated:Bool = _supportRotation && ((stageWidth < stageHeight) != (_designStageWidth < _designStageHeight));

        if (rotated)
        {
            designWidth = _designStageHeight;
            designHeight = _designStageWidth;
        }
        else
        {
            designWidth = _designStageWidth;
            designHeight = _designStageHeight;
        }

        var maxRatio:Float = 1.0 * designWidth / designHeight;

        var width:Float;
        var height:Float;

        var scale:Float;

        if (1.0 * stageWidth / stageHeight <= maxRatio)
        {
            scale = _designStageWidth / stageWidth;
        }
        else
        {
            scale = _designStageHeight / stageHeight;
        }

        width = scale * stageWidth;
        height = scale * stageHeight;

        return new Point(Math.round(width), Math.round(height));
    }

    /**
         * @private
         */

    public static function isAndroid():Bool
    {
        return Capabilities.manufacturer.indexOf("Android") != -1;
    }

    /**
         * @private
         */

    public static function isiOS():Bool
    {
        return Capabilities.manufacturer.indexOf("iOS") != -1;
    }

    /**
         * Fit background to the center of the native stage, If the aspect ratio is different, some cropping may happen.
         * @param object background display object
         * @param stage native stage
         */

    public static function fitNativeBackground(object:flash.display.DisplayObject, stage:Stage):Void
    {
        var objectRect:Rectangle = new Rectangle(0, 0, object.width, object.height);
        var stageRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        var rect:flash.geom.Rectangle = RectangleUtil.fit(objectRect, stageRect, ScaleMode.NO_BORDER);
        object.x = rect.x;
        object.y = rect.y;
        object.width = rect.width;
        object.height = rect.height;
    }

    /**
         * Fit background to the center of the Starling stage. If the aspect ratio is different, some cropping may happen.
         * @param object background display object
         */

    public static function fitBackground(object:DisplayObject):Void
    {
        var stage:starling.display.Stage = Starling.current.stage;
        var objectRect:Rectangle = new Rectangle(0, 0, object.width, object.height);
        var stageRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        var rect:flash.geom.Rectangle = RectangleUtil.fit(objectRect, stageRect, ScaleMode.NO_BORDER);
        object.x = rect.x;
        object.y = rect.y;
        object.width = rect.width;
        object.height = rect.height;
    }
}

