/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import feathers.display.Scale9Image;
import feathers.display.Scale3Image;
import starling.display.Button;
import starlingbuilder.extensions.uicomponents.ContainerButton;
import starling.events.ResizeEvent;
import starlingbuilder.engine.tween.DefaultTweenBuilder;
import starling.display.MovieClip;
import openfl.Assets;
import haxe.Json;
import feathers.core.PopUpManager;
import feathers.layout.AnchorLayout;
import feathers.layout.FlowLayout;
import feathers.layout.HorizontalLayout;
import feathers.layout.TiledRowsLayout;
import feathers.layout.VerticalLayout;

import starling.core.Starling;

import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.utils.AssetManager;

import starlingbuilder.engine.IUIBuilder;
import starlingbuilder.engine.LayoutLoader;
import starlingbuilder.engine.UIBuilder;
import starlingbuilder.engine.localization.DefaultLocalization;
import starlingbuilder.engine.localization.ILocalization;

class UIBuilderDemo extends Sprite
{
    inline public static var SHOW_POPUP:String = "showPopup";
    inline public static var SHOW_LIST:String = "showList";
    inline public static var SHOW_HUD:String = "showHUD";
    inline public static var SHOW_LOCALIZATION:String = "showLocalization";
    inline public static var SHOW_TWEEN:String = "showTween";
    inline public static var SHOW_EXTERNAL_ELEMENT:String = "showExternalElement";
    inline public static var SHOW_MOVIE_CLIP:String = "showMovieClip";
    inline public static var SHOW_LAYOUT:String = "showLayout";
    inline public static var SHOW_ANCHOR_LAYOUT:String = "showAnchorLayout";
    inline public static var SHOW_CONTAINER_BUTTON:String = "showContainerButton";
    inline public static var SHOW_PARTICLE_BUTTON:String = "showParticleButton";
    inline public static var SHOW_PIXEL_MASK:String = "showPixelMask";

    public static var linkers:Array<Dynamic> = [Scale3Image, Scale9Image, AnchorLayout, FlowLayout, HorizontalLayout, VerticalLayout, TiledRowsLayout, BlurFilter];

    private var _assetMediator:starlingbuilder.demo.AssetMediator;
    private var _sprite:Sprite;

    public static var uiBuilder:IUIBuilder;
    public static var assetManager:AssetManager;

    public function new()
    {
        super();

        assetManager = new AssetManager();
        _assetMediator = new starlingbuilder.demo.AssetMediator(assetManager);

        var localization:ILocalization = new DefaultLocalization(Json.parse(Assets.getText("assets/strings.json")), "en_US");
        uiBuilder = new UIBuilder(_assetMediator, localization);
        uiBuilder.localizationHandler = new LocalizationHandler();
        uiBuilder.tweenBuilder = new DefaultTweenBuilder();

        //new MetalWorksMobileTheme(false);

        var loader:LayoutLoader = new LayoutLoader(ParsedLayouts);

        loadAssets();
        assetManager.loadQueue(function(ratio:Float):Void
        {
            if (ratio == 1)
            {
                createButtons();
                complete();
            }
        });

        Starling.current.stage.addEventListener(ResizeEvent.RESIZE, onResize);

        var cb:ContainerButton = new ContainerButton();
        addChild(cb);
    }

    private function createButtons():Void
    {
        _sprite = new Sprite();

        var data:Array<Dynamic> = createButtonData();

        for (i in 0...data.length)
        {
            var button:Button = new Button(assetManager.getTexture("blue_button"));
            button.text = data[i].label;
            button.name = data[i].event;
            button.fontColor = 0xffffff;
            button.fontName = "GrilledCheeseBTN_Size36_ColorFFFFFF";
            button.fontSize = 30;
            button.y = (button.height + 10) * i;
            button.addEventListener(Event.TRIGGERED, onButtonTrigger);
            _sprite.addChild(button);
        }

        addChild(_sprite);

        onResize(null);
    }

    private function createButtonData():Array<Dynamic>
    {
        return [
            {label:"popup", event:SHOW_POPUP},
//                {label:"list", event:SHOW_LIST},
            {label:"HUD", event:SHOW_HUD},
            {label:"localization", event:SHOW_LOCALIZATION},
            {label:"tween", event:SHOW_TWEEN},
            {label:"external element", event:SHOW_EXTERNAL_ELEMENT},
//                {label:"movie clip", event:SHOW_MOVIE_CLIP},
            {label:"layout", event:SHOW_LAYOUT},
            {label:"anchor layout", event:SHOW_ANCHOR_LAYOUT},
            {label:"container button", event:SHOW_CONTAINER_BUTTON}
        ];
    }

    private function onButtonTrigger(event:Event):Void
    {
        var button:Button = cast event.target;

        switch (button.name)
        {
            case SHOW_POPUP:
                createConnectPopup();
            case SHOW_LIST:
                createMailPopup();
            case SHOW_HUD:
                createHUD();
            case SHOW_LOCALIZATION:
                createLocalizationTest();
            case SHOW_TWEEN:
                createTweenTest();
            case SHOW_EXTERNAL_ELEMENT:
                createExternalElement();
            case SHOW_MOVIE_CLIP:
                createMovieClipTest();
            case SHOW_LAYOUT:
                createLayoutTest();
            case SHOW_ANCHOR_LAYOUT:
                createAnchorLayoutTest();
            case SHOW_CONTAINER_BUTTON:
                createContainerButtonTest();
            case SHOW_PARTICLE_BUTTON:
                createParticleTest();
            case SHOW_PIXEL_MASK:
                createPixelMaskTest();
        }
    }

    private function createConnectPopup():Void
    {
        var popup:ConnectPopup = new ConnectPopup();
        PopUpManager.addPopUp(popup);
    }

    private function createMailPopup():Void
    {
        var popup:MailPopup = new MailPopup();
        PopUpManager.addPopUp(popup);
    }

    private function createHUD():Void
    {
        var hud:HUD = new HUD();
        addChild(hud);
    }

    private function createLocalizationTest():Void
    {
        var test:LocalizationTest = new LocalizationTest();
        addChild(test);
    }

    private function createTweenTest():Void
    {
        var test:TweenTest = new TweenTest();
        addChild(test);
    }

    private function createExternalElement():Void
    {
        var test:ExternalElementTest = new ExternalElementTest();
        addChild(test);
    }

    private function createMovieClipTest():Void
    {
        var test:MovieClipTest = new MovieClipTest();
        addChild(test);
    }

    private function createLayoutTest():Void
    {
        var test:LayoutTest = new LayoutTest();
        addChild(test);
    }

    private function createAnchorLayoutTest():Void
    {
        var test:AnchorLayoutTest = new AnchorLayoutTest();
        addChild(test);
    }

    private function createContainerButtonTest():Void
    {
        var popup:ContainerButtonPopup = new ContainerButtonPopup();
        PopUpManager.addPopUp(popup);
    }

    private function createParticleTest():Void
    {
    }

    private function createPixelMaskTest():Void
    {
    }

    private function complete():Void
    {
    }

    private function loadAssets():Void
    {
        assetManager.enqueueWithName(Assets.getBitmapData("assets/ui.png"), "ui");
        assetManager.enqueueWithName(Xml.parse(Assets.getText("assets/ui.xml")), "ui_xml");

        assetManager.enqueueWithName(Assets.getBitmapData("assets/LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B.png"), "LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B");
        assetManager.enqueueWithName(Xml.parse(Assets.getText("assets/LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B.fnt")), "LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B_fnt");

        assetManager.enqueueWithName(Assets.getBitmapData("assets/GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B.png"), "GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B");
        assetManager.enqueueWithName(Xml.parse(Assets.getText("assets/GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B.fnt")), "GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B_fnt");

        assetManager.enqueueWithName(Assets.getBitmapData("assets/GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B.png"), "GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B");
        assetManager.enqueueWithName(Xml.parse(Assets.getText("assets/GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B.fnt")), "GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B_fnt");

        assetManager.enqueueWithName(Assets.getBitmapData("assets/GrilledCheeseBTN_Size36_ColorFFFFFF.png"), "GrilledCheeseBTN_Size36_ColorFFFFFF");
        assetManager.enqueueWithName(Xml.parse(Assets.getText("assets/GrilledCheeseBTN_Size36_ColorFFFFFF.fnt")), "GrilledCheeseBTN_Size36_ColorFFFFFF_fnt");

        assetManager.enqueueWithName(Assets.getBitmapData("assets/background.jpg"), "background");

        assetManager.enqueueWithName(Assets.getBitmapData("assets/blue_button.png"), "blue_button");
    }

    private function movieclipBug():Void
    {
        var args:Array<Dynamic> = new Array<Dynamic>();
        //args.push("abc");

        var t = assetManager.getTextures("meter_");

        args.push(t);


        var mv:MovieClip = new MovieClip(args[0]);

        //var mv:MovieClip = Type.createInstance(Type.resolveClass("starling.display.MovieClip"), args);
        //var mv:MovieClip = new MovieClip(args[0]);

        Starling.current.juggler.add(mv);
        mv.play();
        addChild(mv);

    }

    private function onResize(event:ResizeEvent):Void
    {
        _sprite.x = (Starling.current.stage.stageWidth - _sprite.width) * 0.5;
        _sprite.y = (Starling.current.stage.stageHeight - _sprite.height) * 0.5;
    }

}

