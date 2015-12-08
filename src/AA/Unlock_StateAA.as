package AA {
	import AA.unlock.a.UnlockBlock_StateAA;
	import AA.unlock.b.UnlockCell_StateAA;
	
	import configs.ViewCfg;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.display.FusionAA;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	import d2armor.events.ATouchEvent;
	import d2armor.utils.AMath;
	
	import util.ImageUtil;
	import util.ResUtil;
	
public class Unlock_StateAA extends StateAA {
	
	
	override public function onEnter() : void {
		var stateFusion_A:StateFusionAA;
		var i:int;
		var l:int;
		var gap:Number;
		var imgA:ImageAA;
		var tweenA:ATween;
		
		this.getFusion().touchable = false;
		
		_fusionA = new FusionAA;
		this.getFusion().addNode(_fusionA);
		
		_closeBtn = ImageUtil.createImg("sketch/hotspot.png");
		_closeBtn.scaleX = ViewCfg.HOTSPOT_SCALE;
		_closeBtn.scaleY = ViewCfg.HOTSPOT_SCALE;
		_fusionA.addNode(_closeBtn);
		_closeBtn.addEventListener(ATouchEvent.CLICK, onCloseDesktop);
		
		imgA = ImageUtil.createImg(ResUtil.getTemp("label_A"));
		_fusionA.addNode(imgA);
		imgA.x = 220;
		imgA.y = 1560;
		
		imgA = ImageUtil.createImg(ResUtil.getTemp("label_B"));
		_fusionA.addNode(imgA);
		imgA.x = (this.getRoot().getAdapter().rootWidth - imgA.sourceWidth) * .5;
		imgA.y = 280;
		
		imgA = ImageUtil.createImg(ResUtil.getTemp("label_C"));
		_fusionA.addNode(imgA);
		imgA.x = this.getRoot().getAdapter().rootWidth - imgA.sourceWidth - 220;
		imgA.y = 1560;
		
		tweenA = TweenMachine.from(_fusionA, ViewCfg.DURA_UNLOCK, {alpha:0.0}, ViewCfg.DELAY_UNLOCK);
		tweenA.onComplete = function() : void {
			getFusion().touchable = true;
		}
			
		
		_unlockBlockFN = new StateFusionAA;
		this.getFusion().addNode(_unlockBlockFN);
		_unlockBlockFN.setState(UnlockBlock_StateAA, [onSuccess]);
	
		
		
		
	}
	
	
	
	private var _closeBtn:ImageAA;
	private var _fusionA:FusionAA;
	private var _unlockBlockFN:StateFusionAA;
	
	
	private function onCloseDesktop(e:ATouchEvent):void{
		this.getRoot().closeAllViews();
		
		this.getRoot().getView("launch").activate();
	}
	
	private function onSuccess():void{
		var tweenA:ATween;
		var durationA:Number;
		
		
		this.getFusion().touchable = false;
		
		tweenA = TweenMachine.to(this.getFusion(), ViewCfg.DURA_DESKTOP, {alpha:0.0});
		//tweenA.easing = Quad.easeOut;
		tweenA.onComplete = function() : void {
			
			getFusion().kill();
				
		}
			
		this.getRoot().getView("desktop").activate();
	}
}
}