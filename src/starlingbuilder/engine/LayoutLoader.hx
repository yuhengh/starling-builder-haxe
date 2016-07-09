/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine;

import haxe.Json;
import openfl.Assets;

/**
     * Helper class to load layouts
     *
     * <p>This class provide an easy and efficient way to load layout files from embedded data, parse the data and cached it into memory.
     * The following example load and parse the layout data from EmbeddedLayout class to ParsedLayout class:
     * </p>
     *
     * <listing version="3.0">
     * public class EmbeddedLayout
     * {
     *     [Embed(source="layouts/connect_popup.json", mimeType="application/octet-stream")]
     *     public static const connect_popup:Class;
     *     <br>
     *     [Embed(source="layouts/mail_popup.json", mimeType="application/octet-stream")]
     *     public static const mail_popup:Class;
     * }
     * <br>
     * public class ParsedLayout
     * {
     *     public static var connect_popup:Object;
     *     <br>
     *     public static var mail_popup:Object;
     * }
     * <br>
     * //loader with preload option
     * var loader:LayoutLoader = new LayoutLoader(EmbeddedLayout, ParsedLayout);
     * var sprite:Sprite = uiBuilder.create(ParsedLayout.connect_popup) as Sprite;
     * <br>
     * //loader without preload option
     * var loader2:LayoutLoader = new LayoutLoader(EmbeddedLayout, ParsedLayout, false);
     * var sprite2:Sprite = uiBuilder.create(loader2.loadByClass(EmbeddedLayout.connect_popup));</listing>
     *
     * @see http://github.com/mindjolt/starling-builder-engine/tree/master/demo Starling Builder demo project
     *
     */
    class LayoutLoader
    {
        private var _layoutCls:Class<Dynamic>;
        private var _preload:Bool;

        /**
         * Constructor
         * @param embeddedCls class with embedded layout
         * @param layoutCls class with parsed layout
         * @param preload whether to preload it. If set to true, calling load() or loadByClass() is not necessary
         */
        public function new(layoutCls:Class<Dynamic>, preload:Bool = true)
        {
            _layoutCls = layoutCls;
            _preload = preload;

            if (_preload)
                preloadLayouts();
        }

        /**
         * Load a layout with name, only need to use it when preload = false
         * @param name layout name
         * @return parsed as3 object
         */
        public function load(name:String):Dynamic
        {
            var value:Dynamic = Reflect.getProperty(_layoutCls, name);

            if (value == null)
            {
                value = Json.parse(Assets.getText(name));
                Reflect.setProperty(_layoutCls, name, value);
            }

            return value;
        }

        /**
         * Traverse all the public static variable of the embedded class, parse and assign to the same public static variable of the layout class
         */
        private function preloadLayouts():Void
        {
            for (name in Type.getClassFields(_layoutCls))
            {
                var obj = Reflect.getProperty(_layoutCls, name);

                if (obj == null)
                    Reflect.setField(_layoutCls, name, Json.parse(Assets.getText("assets/" + name + ".json")));
            }
        }
    }

