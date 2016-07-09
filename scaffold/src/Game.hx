package ;
import openfl.errors.Error;
import openfl.Assets;
import haxe.Json;
import starlingbuilder.engine.UIBuilder;
import starlingbuilder.engine.DefaultAssetMediator;
import starlingbuilder.engine.IUIBuilder;
import starlingbuilder.engine.IAssetMediator;
import starling.utils.AssetManager;
import starling.display.Sprite;
class Game extends Sprite
{
    private var _assetManager:AssetManager;
    private var _assetMediator:IAssetMediator;

    public static var uiBuilder:IUIBuilder;

    public function new()
    {
        super();

        _assetManager = new AssetManager();
        _assetMediator = new DefaultAssetMediator(_assetManager);
        uiBuilder = new UIBuilder(_assetMediator);

        _assetManager.loadQueue(function(ratio:Float):Void{
            if (ratio == 1)
            {
                init();
            }
        });
    }

    private function init():Void
    {
        var data:Dynamic = Json.parse(Assets.getText("assets/hello.json"));
        var sprite:Sprite = cast uiBuilder.create(data);
        //throw new Error("wtf");
        addChild(sprite);
    }
}
