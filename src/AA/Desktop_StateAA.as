package AA {
	import configs.ViewCfg;
	
	import d2armor.Armor;
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.animate.easing.Quad;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.events.ATouchEvent;
	
	import util.ImageUtil;
	
public class Desktop_StateAA extends StateAA {
	
	override public function onEnter():void {
		var tweenA:ATween;
		
		this.getFusion().touchable = false;
		
		_bgA = ImageUtil.createImg("temp/desk_bg.png");
		this.getFusion().addNode(_bgA);
		
		_bgB = ImageUtil.createImg("temp/desk.png");
		this.getFusion().addNode(_bgB);
		
		_bgB.pivotX = _bgB.sourceWidth * .5;
		_bgB.pivotY = _bgB.sourceHeight * .5;
		
		_bgB.x = _bgB.sourceWidth * .5;
		_bgB.y = _bgB.sourceHeight * .5;
		
		tweenA = TweenMachine.from(_bgA, ViewCfg.DURA_DESKTOP, {alpha:0.0}, ViewCfg.DELAY_DESKTOP);
		//tweenA.easing = Quad.easeOut;
		tweenA = TweenMachine.from(_bgB, ViewCfg.DURA_DESKTOP, {alpha:0.0, scaleX:ViewCfg.DESKTOP_PRE_SCALE, scaleY:ViewCfg.DESKTOP_PRE_SCALE}, ViewCfg.DELAY_DESKTOP);
		//tweenA.easing = Quad.easeOut;
		tweenA.onComplete = function() : void {
			getFusion().touchable = true;
			
			//Armor.getLog().simplify("desktop...");
		}
		
		_closeBtn = ImageUtil.createImg("sketch/hotspot.png");
		_closeBtn.scaleX = ViewCfg.HOTSPOT_SCALE;
		_closeBtn.scaleY = ViewCfg.HOTSPOT_SCALE;
		this.getFusion().addNode(_closeBtn);
		_closeBtn.addEventListener(ATouchEvent.CLICK, onCloseDesktop);
		
	}
	
	
	
	
	private var _bgA:ImageAA;
	private var _bgB:ImageAA;
	private var _closeBtn:ImageAA;
	
	
	
	private function onCloseDesktop(e:ATouchEvent):void{
		this.getRoot().closeAllViews();
		
		this.getRoot().getView("launch").activate();
	}
	
	
}
}