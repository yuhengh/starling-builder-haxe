/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.localization;

/**
     * Default implementation of ILocalization
     *
     * @see ILocalization
     * @see http://wiki.starling-framework.org/builder/localization Using Localization
     */
import Reflect;

class DefaultLocalization implements ILocalization
{
    private var _data:Dynamic;
    private var _locale:String;

    public var locale(get, set):String;

    /**
         * Constructor
         * @param data localization data
         * @param locale current locale
         */

    public function new(data:Dynamic, locale:String = null):Void
    {
        _data = data;
        _locale = locale;
    }

    /**
         * @inheritDoc
         */

    public function getLocalizedText(key:String):String
    {
        if (_locale != null && Reflect.hasField(_data, key) && Reflect.hasField(Reflect.field(_data, key), _locale))
        {
            return Reflect.field(Reflect.field(_data, key), _locale);
        }
        else
        {
            return null;
        }
    }

    /**
         * @inheritDoc
         */

    public function get_locale():String
    {
        return _locale;
    }

    /**
         * @inheritDoc
         */

    public function set_locale(value:String):String
    {
        _locale = value;
        return _locale;
    }

}

