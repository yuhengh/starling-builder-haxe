/**
 * Created by hyh on 4/24/16.
 */
package starlingbuilder.extensions.uicomponents;

#if flash
import flash.ui.MouseCursor;
#end
import openfl.ui.Mouse;
import openfl.geom.Rectangle;
import openfl.errors.ArgumentError;

import starling.display.ButtonState;
import starling.display.DisplayObject;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

//    /** Dispatched when the user triggers the button. Bubbles. */
//    [Event(name="triggered", type="starling.events.Event")]

/**
     * A button as a container, you can layout whatever you want inside ContainerButton
     */
class ContainerButton extends DisplayObjectContainer
{
    inline private static var MAX_DRAG_DIST:Float = 50;

    private static var sRect:Rectangle = new Rectangle();

    private var mContents:Sprite;

    private var mScaleWhenDown:Float;
    private var mScaleWhenOver:Float;
    private var mAlphaWhenDown:Float;
    private var mAlphaWhenDisabled:Float;
    private var mHandCursor:Bool;
    private var mEnabled:Bool;
    private var mState:String;
    private var mTriggerBounds:Rectangle;

    public var state(get, set):String;

    /** Creates a button with a set of state-textures and (optionally) some text.
         *  Any state that is left 'null' will display the up-state texture. Beware that all
         *  state textures should have the same dimensions. */

    public function new()
    {
        super();

        mState = ButtonState.UP;
        mScaleWhenDown = 0.9;
        mScaleWhenOver = mAlphaWhenDown = 1.0;
        mAlphaWhenDisabled = 0.5;
        mEnabled = true;
        mHandCursor = true;
        mTriggerBounds = new Rectangle();

        mContents = new Sprite();
        super.addChildAt(mContents, 0);
        addEventListener(TouchEvent.TOUCH, onTouchEvent);
    }

    /** @inheritDoc */

    public override function dispose():Void
    {
        mContents.dispose();
        super.dispose();
    }

    private function onTouchEvent(event:TouchEvent):Void
    {
        #if flash
        Mouse.cursor = (mHandCursor && mEnabled && event.interactsWith(this)) ?
        MouseCursor.BUTTON : MouseCursor.AUTO;
        #end

        var touch:Touch = event.getTouch(this);
        var isWithinBounds:Bool;

        if (!mEnabled)
        {
            return;
        }
        else if (touch == null)
        {
            state = ButtonState.UP;
        }
        else if (touch.phase == TouchPhase.HOVER)
        {
            state = ButtonState.OVER;
        }
        else if (touch.phase == TouchPhase.BEGAN && mState != ButtonState.DOWN)
        {
            mTriggerBounds = getBounds(stage, mTriggerBounds);
            mTriggerBounds.inflate(MAX_DRAG_DIST, MAX_DRAG_DIST);

            state = ButtonState.DOWN;
        }
        else if (touch.phase == TouchPhase.MOVED)
        {
            isWithinBounds = mTriggerBounds.contains(touch.globalX, touch.globalY);

            if (mState == ButtonState.DOWN && !isWithinBounds)
            {
                // reset button when finger is moved too far away ...
                state = ButtonState.UP;
            }
            else if (mState == ButtonState.UP && isWithinBounds)
            {
                // ... and reactivate when the finger moves back into the bounds.
                state = ButtonState.DOWN;
            }
        }
        else if (touch.phase == TouchPhase.ENDED && mState == ButtonState.DOWN)
        {
            state = ButtonState.UP;
            if (!touch.cancelled) dispatchEventWith(Event.TRIGGERED, true);
        }
    }

    /** The current state of the button. The corresponding strings are found
         *  in the ButtonState class. */

    public function get_state():String
    { return mState; }

    public function set_state(value:String):String
    {
        mState = value;
        refreshState();
        return value;
    }

    private function refreshState():Void
    {
        mContents.x = mContents.y = 0;
        mContents.scaleX = mContents.scaleY = mContents.alpha = 1.0;
        mContents.getBounds(this, sRect);

        switch (mState)
        {
            case ButtonState.DOWN:
                mContents.alpha = mAlphaWhenDown;
                mContents.scaleX = mContents.scaleY = mScaleWhenDown;
                mContents.x = (1 - mScaleWhenDown) * (sRect.x + sRect.width * 0.5);
                mContents.y = (1 - mScaleWhenDown) * (sRect.y + sRect.height * 0.5);
            case ButtonState.UP:
            case ButtonState.OVER:
                mContents.scaleX = mContents.scaleY = mScaleWhenOver;
                mContents.x = (1 - mScaleWhenOver) * (sRect.x + sRect.width * 0.5);
                mContents.y = (1 - mScaleWhenOver) * (sRect.y + sRect.height * 0.5);
            case ButtonState.DISABLED:
                mContents.alpha = mAlphaWhenDisabled;
            default:
                throw new ArgumentError("Invalid button state: " + mState);
        }
    }


    /** The scale factor of the button on touch. Per default, a button without a down state
         *  texture will be made slightly smaller, while a button with a down state texture
         *  remains unscaled. */

    public function get_scaleWhenDown():Float
    { return mScaleWhenDown; }

    public function set_scaleWhenDown(value:Float):Float
    {
        mScaleWhenDown = value;
        if (mState == ButtonState.DOWN) refreshState();
        return value;
    }

    /** The scale factor of the button while the mouse cursor hovers over it. @default 1.0 */

    public function get_scaleWhenOver():Float
    { return mScaleWhenOver; }

    public function set_scaleWhenOver(value:Float):Float
    {
        mScaleWhenOver = value;
        if (mState == ButtonState.OVER) refreshState();
        return value;
    }

    /** The alpha value of the button on touch. @default 1.0 */

    public function get_alphaWhenDown():Float
    { return mAlphaWhenDown; }

    public function set_alphaWhenDown(value:Float):Float
    {
        mAlphaWhenDown = value;
        if (mState == ButtonState.DOWN) refreshState();
        return value;
    }

    /** The alpha value of the button when it is disabled. @default 0.5 */

    public function get_alphaWhenDisabled():Float
    { return mAlphaWhenDisabled; }

    public function set_alphaWhenDisabled(value:Float):Float
    {
        mAlphaWhenDisabled = value;
        if (mState == ButtonState.DISABLED) refreshState();
        return value;
    }

    /** Indicates if the button can be triggered. */

    public function get_enabled():Bool
    { return mEnabled; }

    public function set_enabled(value:Bool):Bool
    {
        if (mEnabled != value)
        {
            mEnabled = value;
            state = value ? ButtonState.UP : ButtonState.DISABLED;
        }
        return mEnabled;
    }

    /** Indicates if the mouse cursor should transform into a hand while it's over the button.
         *  @default true */

    public override function get_useHandCursor():Bool
    { return mHandCursor; }

    public override function set_useHandCursor(value:Bool):Bool
    { mHandCursor = value; return value;}

    override public function get_numChildren():Int
    {
        return mContents.numChildren;
    }

    override public function getChildByName(name:String):DisplayObject
    {
        return mContents.getChildByName(name);
    }

    override public function getChildAt(index:Int):DisplayObject
    {
        return mContents.getChildAt(index);
    }

    override public function addChild(child:DisplayObject):DisplayObject
    {
        return mContents.addChild(child);
    }

    override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
    {
        return mContents.addChildAt(child, index);
    }

    override public function removeChildAt(index:Int, dispose:Bool = false):DisplayObject
    {
        return mContents.removeChildAt(index, dispose);
    }

    override public function getChildIndex(child:DisplayObject):Int
    {
        return mContents.getChildIndex(child);
    }

    override public function setChildIndex(child:DisplayObject, index:Int):Void
    {
        mContents.setChildIndex(child, index);
    }

    override public function swapChildrenAt(index1:Int, index2:Int):Void
    {
        mContents.swapChildrenAt(index1, index2);
    }

    override public function sortChildren(compareFunction:Dynamic):Void
    {
        mContents.sortChildren(compareFunction);
    }
}
