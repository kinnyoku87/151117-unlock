package AA {
	import flash.geom.Rectangle;
	
	import configs.ViewCfg;
	
	import d2armor.Armor;
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.animate.easing.Bounce;
	import d2armor.animate.easing.Elastic;
	import d2armor.animate.easing.Linear;
	import d2armor.animate.easing.Quad;
	import d2armor.display.AAFacade;
	import d2armor.display.DragFusionAA;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.events.ATouchEvent;
	import d2armor.events.DragEvent;
	import d2armor.utils.AMath;
	
	import util.ImageUtil;
	import util.ResUtil;
	
public class Launch_StateAA extends StateAA {
	
	override public function onEnter() : void {
		_dragFN = new DragFusionAA;
		this.getFusion().addNode(_dragFN);
		_dragFN.addEventListener(DragEvent.START_DRAG, onStartDrag);
		_dragFN.addEventListener(DragEvent.DRAGGING,   onDragging);
		
		_launchBg = new ImageAA;
		_launchBg.textureId = ResUtil.getTemp("launch_bg");
		_dragFN.addNode(_launchBg);
		_launchBg.addEventListener(ATouchEvent.PRESS,     onPreDesktop);
		_launchBg.addEventListener(ATouchEvent.UNBINDING, onPostDesktop);
			
		_cameraBtn = ImageUtil.createSketchImg("temp/cameraBtn.png", false, ViewCfg.HOTSPOT_SCALE);
		_dragFN.addNode(_cameraBtn);
		_cameraBtn.x = this.getRoot().getAdapter().rootWidth - _cameraBtn.sourceWidth * _cameraBtn.scaleX - 30;
		_cameraBtn.y = this.getRoot().getAdapter().rootHeight - _cameraBtn.sourceHeight * _cameraBtn.scaleX - 5;
		_cameraBtn.addEventListener(ATouchEvent.PRESS,     onPreCamera);
		_cameraBtn.addEventListener(ATouchEvent.UNBINDING, onPostCamera);
		
		_desktopBtn = ImageUtil.createSketchImg("temp/desktopBtn.png", false, ViewCfg.HOTSPOT_SCALE);
		_desktopBtn.touchable = false;
		_dragFN.addNode(_desktopBtn);
		_desktopBtn.x = (this.getRoot().getAdapter().rootWidth - _desktopBtn.sourceWidth * _desktopBtn.scaleX) / 2;
		_desktopBtn.y = this.getRoot().getAdapter().rootHeight - _desktopBtn.sourceHeight * _desktopBtn.scaleX - 5;
//		_desktopBtn.addEventListener(ATouchEvent.PRESS,     onPreDesktop);
//		_desktopBtn.addEventListener(ATouchEvent.UNBINDING, onPostDesktop);
	}
	
	override public function onExit() : void {
		TweenMachine.getInstance().stopTarget(_dragFN);
	}
	
	
	private static const flag_none:int = 0;
	private static const flag_start_pre:int = 1;
	private static const flag_start_post:int = 2;
	private static const flag_dragging:int = 4;
	private static const flag_stop:int = 8;
	
	private var _flags:int;
	
	private var _dragFN:DragFusionAA;
	private var _launchBg:ImageAA;
	private var _cameraBtn:ImageAA;
	private var _desktopBtn:ImageAA;
	
	
	
	private function onPreCamera(e:ATouchEvent):void{
		var tweenA:ATween;
		
		tweenA = TweenMachine.to(_dragFN, ViewCfg.DURA_CAMERA_PRE, {y:ViewCfg.OFFSET_Y_CAMERA_PRE});
		tweenA.easing = Back.easeOut;
		tweenA.onComplete = function() : void {
			if(_flags & flag_stop){
				doCloseCamera();
			}
			else {
				_flags = flag_start_post;
			}
		}
		_flags = flag_start_pre;
		
		this.getRoot().getView("camera").activate(null, 0);
		
		_dragFN.startDrag(e.touch, new Rectangle(0, -this.getRoot().getAdapter().rootHeight, 0, this.getRoot().getAdapter().rootHeight));
	}
	
	private function onPostCamera(e:ATouchEvent):void{
		var tweenA:ATween;
		var durationA:Number
		var c_state:Camera_StateAA;
		
		this.getFusion().touchable = false;
		
		if(e.touch.velocityY < -100){
			durationA = ViewCfg.DURA_CAMERA * (AMath.calcRatio(_dragFN.y, -this.getRoot().getAdapter().rootHeight, 0)) + ViewCfg.DURA_CAMERA_MIN;
			tweenA = TweenMachine.to(_dragFN, durationA * .5, {y:-this.getRoot().getAdapter().rootHeight});
			//tweenA.easing = Quad.easeOut;
			tweenA.onComplete = function() : void {
				//getRoot().getView("camera").close();
				//getFusion().touchable = true;
				getFusion().kill();
				getRoot().getView("camera").getState().getFusion().touchable = true;
			}
			
			c_state = this.getRoot().getView("camera").getState() as Camera_StateAA;
			c_state.initCamera();
			
		}
		// 
		else {
			if((_flags & flag_start_post) || (_flags & flag_dragging)) {
				this.doCloseCamera();
				
			}
			else {
				_flags = flag_stop;
			}
		}
		
	}
	
	private function doCloseCamera() :void {
		var tweenA:ATween;
		var durationA:Number
		
		_dragFN.stopDrag();
		
		durationA = ViewCfg.DURA_CAMERA * (1 - AMath.calcRatio(_dragFN.y, -this.getRoot().getAdapter().rootHeight, 0)) + ViewCfg.DURA_CAMERA_MIN;
		//Armor.getLog().simplify(durationA);
		//durationA = 3;
		tweenA = TweenMachine.to(_dragFN, durationA, {y:0});
		tweenA.easing = Linear.easeOut;
		tweenA.onComplete = function() : void {
			getRoot().getView("camera").close();
			getFusion().touchable = true;
			_flags = flag_none;
		}
	}
	
	private function onStartDrag(e:DragEvent):void{
		var tmpDragOffsetY:Number;
		
		TweenMachine.getInstance().stopTarget(_dragFN);
		_flags |= flag_dragging;
		
		tmpDragOffsetY = ViewCfg.OFFSET_Y_CAMERA_PRE - _dragFN.y;
		_dragFN.setOffset(0, tmpDragOffsetY);
		
		
	}
	
	private function onDragging(e:DragEvent):void{
		if(_dragFN.y < -this.getRoot().getAdapter().rootHeight * .5){
			(this.getRoot().getView("camera").getState() as Camera_StateAA).initCamera();
		}
	}
	
	
	
	private function onPreDesktop(e:ATouchEvent):void{
		
	}
	
	private function onPostDesktop(e:ATouchEvent):void{
		var tweenA:ATween;
		var durationA:Number;
		
		
		if(e.touch.velocityY < -100){
			this.getFusion().touchable = false;
			
			tweenA = TweenMachine.to(_dragFN, ViewCfg.DURA_DESKTOP, {alpha:0.0});
			//tweenA.easing = Quad.easeOut;
			tweenA.onComplete = function() : void {
				
				getFusion().kill();
				
			}
//			getFusion().kill();
			
			this.getRoot().getView("desktop").activate();
		}
	}
	
}
}