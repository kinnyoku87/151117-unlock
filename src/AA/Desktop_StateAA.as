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
		
		//Armor.getTick().timeScale = 0.3
		
		this.getFusion().touchable = false;
		
		_bgA = ImageUtil.createImg("temp/desk_bg.png");
		this.getFusion().addNode(_bgA);
		
		_bgA.pivotX = _bgA.sourceWidth * .5;
		_bgA.pivotY = _bgA.sourceHeight * .5;
		
		_bgA.x = _bgA.sourceWidth * .5;
		_bgA.y = _bgA.sourceHeight * .5;
		_bgA.alpha = 0.0;
		
		_bgB = ImageUtil.createImg("temp/desk.png");
		this.getFusion().addNode(_bgB);
		
		_bgB.pivotX = _bgB.sourceWidth * .5;
		_bgB.pivotY = _bgB.sourceHeight * .5;
		
		_bgB.x = _bgB.sourceWidth * .5;
		_bgB.y = _bgB.sourceHeight * .5;
		
		tweenA = TweenMachine.to(_bgA, ViewCfg.DURA_DESKTOP, {alpha:1.0, scaleX:ViewCfg.DESKTOP_PRE_SCALE_BG, scaleY:ViewCfg.DESKTOP_PRE_SCALE_BG}, ViewCfg.DELAY_DESKTOP);
		//tweenA.easing = Quad.easeOut;
		tweenA = TweenMachine.from(_bgB, ViewCfg.DURA_DESKTOP, {alpha:0.0, scaleX:ViewCfg.DESKTOP_PRE_SCALE_ICON, scaleY:ViewCfg.DESKTOP_PRE_SCALE_ICON}, ViewCfg.DELAY_DESKTOP);
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