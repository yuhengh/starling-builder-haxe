/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.demo;

    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;

    import starlingbuilder.extensions.uicomponents.ContainerButton;

    class ContainerButtonPopup extends Sprite
    {
        //auto bind variables
        public var _closeButton:Button;
        public var _buyButton:ContainerButton;
        public var _claimButton:ContainerButton;

        public function new()
        {
            super();

            var sprite:Sprite = cast UIBuilderDemo.uiBuilder.create(ParsedLayouts.containerbutton_test, true, this);
            addChild(sprite);

            _closeButton.addEventListener(Event.TRIGGERED, onExit);
            _buyButton.addEventListener(Event.TRIGGERED, onBuy);
            _claimButton.addEventListener(Event.TRIGGERED, onClaim);
        }

        private function onExit(event:Event):Void
        {
            removeFromParent(true);
        }

        private function onBuy(event:Event):Void
        {
            trace("onBuy");
        }

        private function onClaim(event:Event):Void
        {
            trace("onClaim");
        }
    }

