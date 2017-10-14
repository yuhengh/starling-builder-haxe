/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

import starling.text.TextFormat;
import starling.display.DisplayObject;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.TextureAtlas;
import starling.textures.Texture;
import starling.display.Button;
import starlingbuilder.extensions.uicomponents.ContainerButton;
import starling.events.ResizeEvent;
import starlingbuilder.engine.tween.DefaultTweenBuilder;
import openfl.Assets;
import haxe.Json;

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
    inline public static var SHOW_HUD:String = "showHUD";
    inline public static var SHOW_LOCALIZATION:String = "showLocalization";
    inline public static var SHOW_TWEEN:String = "showTween";
    inline public static var SHOW_EXTERNAL_ELEMENT:String = "showExternalElement";
    inline public static var SHOW_MOVIE_CLIP:String = "showMovieClip";
    inline public static var SHOW_CONTAINER_BUTTON:String = "showContainerButton";
    inline public static var SHOW_PARTICLE_BUTTON:String = "showParticleButton";
    inline public static var SHOW_PIXEL_MASK:String = "showPixelMask";

    public static var linkers:Array<Dynamic> = [BlurFilter];

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
            button.textFormat = new TextFormat("GrilledCheeseBTN_Size36_ColorFFFFFF", 30, 0xffffff);
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
            {label:"movie clip", event:SHOW_MOVIE_CLIP},
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
        center(popup);
        addChild(popup);
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

    private function createContainerButtonTest():Void
    {
        var popup:ContainerButtonPopup = new ContainerButtonPopup();
        center(popup);
        addChild(popup);
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


        var ui:Texture = Texture.fromBitmapData(Assets.getBitmapData("assets/ui.png"));
        var xml:Xml = Xml.parse(Assets.getText("assets/ui.xml"));
        assetManager.addTexture("ui", ui);
        assetManager.addTextureAtlas("ui", new TextureAtlas(ui, xml));

        TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(Assets.getBitmapData("assets/LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B.png")), Xml.parse(Assets.getText("assets/LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B.fnt"))), "LobsterTwoRegular_Size54_ColorFFFFFF_StrokeAF384E_DropShadow560D1B");
        TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(Assets.getBitmapData("assets/GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B.png")), Xml.parse(Assets.getText("assets/GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B.fnt"))), "GrilledCheeseBTN_Size18_ColorFFFFFF_StrokeA8364B");
        TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(Assets.getBitmapData("assets/GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B.png")), Xml.parse(Assets.getText("assets/GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B.fnt"))), "GrilledCheeseBTN_Size36_ColorFFFFFF_StrokeA8364B");
        TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(Assets.getBitmapData("assets/GrilledCheeseBTN_Size36_ColorFFFFFF.png")), Xml.parse(Assets.getText("assets/GrilledCheeseBTN_Size36_ColorFFFFFF.fnt"))), "GrilledCheeseBTN_Size36_ColorFFFFFF");


        assetManager.addTexture("background", Texture.fromBitmapData(Assets.getBitmapData("assets/background.jpg")));
        assetManager.addTexture("blue_button", Texture.fromBitmapData(Assets.getBitmapData("assets/blue_button.png")));


        /*

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

        */
    }

    private function onResize(event:ResizeEvent):Void
    {
        center(_sprite);
    }

    private function center(obj:DisplayObject):Void
    {
        obj.x = (Starling.current.stage.stageWidth - obj.width) * 0.5;
        obj.y = (Starling.current.stage.stageHeight - obj.height) * 0.5;
    }

}

