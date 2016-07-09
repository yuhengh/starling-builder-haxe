/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine;

import starling.display.DisplayObject;

import starlingbuilder.engine.localization.ILocalization;

import starlingbuilder.engine.localization.ILocalizationHandler;

import starlingbuilder.engine.tween.ITweenBuilder;

/**
     * Main interface of the Starling Builder engine API
     *
     * @see UIBuilder
     */
interface IUIBuilder
{
    /**
         * Load from layout data, create display objects and the associated meta data
         *
         * @param data
         * layout data
         *
         * @param trimLeadingSpace
         * whether to trim the leading space on the top level elements
         * set to true if loading a popup, set to false if loading a hud
         *
         * @param binder
         * An optional object you want to bind properties with UI components with the same name, if name starts with "_"
         *
         * @return
         * An object with {object:Sprite, params:Dictionary, data:data};
         *
         * <p>object: the sprite to create</p>
         * <p>params: A Dictionary of the mapping of every UIElement to its layout data</p>
         * <p>data: the as3 plain object format of the layout</p>
         *
         * @see #create()
         *
         */
    function load(data:Dynamic, trimLeadingSpace:Bool = true, binder:Dynamic = null):Dynamic;


    /**
         * Create UI element from data
         *
         * @param data
         * data in as3 plain object format
         *
         * @return
         * starling display object
         */
    function createUIElement(data:Dynamic):Dynamic;

    /**
         * Localize texts in display object
         *
         * @param root of the DisplayObject needs to be localize
         * @param A Dictionary of the mapping of every UIElement to its layout data
         */
    function localizeTexts(root:DisplayObject, paramsDict:Map<Dynamic, Dynamic>):Void;


    /**
         * Create display objects from layout.
         * Short cut for load().object
         *
         * @see #load()
         */
    function create(data:Dynamic, trimLeadingSpace:Bool = true, binder:Dynamic = null):Dynamic;


    /**
         * Tween builder property
         */
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

}

