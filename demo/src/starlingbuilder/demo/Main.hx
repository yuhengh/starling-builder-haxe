package starlingbuilder.demo;


import starling.events.ResizeEvent;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import starlingbuilder.engine.util.StageUtil;
import starling.core.Starling;
import openfl.display.Sprite;


class Main extends Sprite
{

    public var starling:Starling;
    public var stageUtil:StageUtil;

    public function new()
    {

        super();

        stageUtil = new StageUtil(stage);
        starling = new Starling(UIBuilderDemo, stage);
        starling.showStats = true;
        starling.stage.addEventListener(ResizeEvent.RESIZE, onResize);

        var w:Int = stage.stageWidth;
        var h:Int = stage.stageHeight;
        starling.viewPort = new Rectangle(0, 0, w, h);
        var size:Point = stageUtil.getScaledStageSize(w, h);

        starling.stage.stageWidth = cast size.x;
        starling.stage.stageHeight = cast size.y;

        starling.start();
    }

    private function onResize(event:ResizeEvent):Void
    {
        starling.viewPort = new Rectangle(0, 0, event.width, event.height);

        var size:Point = stageUtil.getScaledStageSize(event.width, event.height);

        starling.stage.stageWidth = cast size.x;
        starling.stage.stageHeight = cast size.y;
    }


}