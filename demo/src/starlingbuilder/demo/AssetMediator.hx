package starlingbuilder.demo;
import starling.utils.AssetManager;
import openfl.Assets;
import starlingbuilder.engine.DefaultAssetMediator;

class AssetMediator extends DefaultAssetMediator
{
    public function new(assetManager:AssetManager)
    {
        super(assetManager);
    }

    override public function getExternalData(name:String):Dynamic
    {
        return Assets.getText("assets/" + name + ".json");
    }
}
