package AA {
	import flash.geom.Rectangle;
	
	import configs.ViewCfg;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.animate.easing.Linear;
	import d2armor.animate.easing.Quad;
	import d2armor.display.DragFusionAA;
	import d2armor.display.FusionAA;
	import d2armor.display.ImageAA;
	import d2armor.display.RadioAA;
	import d2armor.display.StateAA;
	import d2armor.display.core.NodeAA;
	import d2armor.events.AEvent;
	import d2armor.events.ATouchEvent;
	import d2armor.events.DragEvent;
	import d2armor.ui.RadioGroup;
	import d2armor.utils.AMath;
	
	import events.view.V_CameraEvent;
	
	import util.EventUtil;
	import util.ImageUtil;
	import util.ResUtil;
	
public class Launch_StateAA extends StateAA {
	
	override public function onEnter() : void {
		var radio:RadioAA;
		var i:int;
		var l:int;
		var imgA:ImageAA;
		
		_dragFN = new DragFusionAA;
		this.getFusion().addNode(_dragFN);
		_dragFN.addEventListener(DragEvent.START_DRAG, onStartDrag);
		_dragFN.addEventListener(DragEvent.DRAGGING,   onDragging);
		
		_launchBg = new ImageAA;
		_launchBg.textureId = ResUtil.getTemp("launch_bg");
		_dragFN.addNode(_launchBg);
		_launchBg.addEventListener(ATouchEvent.PRESS,     onPreDesktop);
		_launchBg.addEventListener(ATouchEvent.UNBINDING, onPostDesktop);
		
		_launchBgBlur = new ImageAA;
		_launchBgBlur.textureId = ResUtil.getTemp("launch_bg_blur");
		_launchBgBlur.visible = false;
		this.getFusion().addNode(_launchBgBlur);
		
		_funsionA = new FusionAA;
		_dragFN.addNode(_funsionA);
		
		_statusBar = new ImageAA;
		_statusBar.textureId = ResUtil.getTemp("statusBar");
		_funsionA.addNode(_statusBar);
		
		_widget = new ImageAA;
		_widget.textureId = ResUtil.getTemp("widget");
		_funsionA.addNode(_widget);
		
		_statusBar.touchable = _widget.touchable = false;
		
		_radioGroup = new RadioGroup();
		this.insertEventListener(_radioGroup, AEvent.CHANGE, onRadioGroupChanged);
		l = 2;
		while(i < l) {
			radio = new RadioAA;
			radio.group = _radioGroup;
			//radio.skinId = "radio";
			imgA = ImageUtil.createImg("sketch/hotspot.png");
			imgA.scaleX = ViewCfg.HOTSPOT_SCALE;
			imgA.scaleY = ViewCfg.HOTSPOT_SCALE;
			radio.addNode(imgA);
			radio.y = i * 150 + 1200;
			radio.alpha = 0.3;
			radio.addEventListener(AEvent.CHANGE, onRadioChanged);
			_dragFN.addNode(radio);
			i++;
		}
		_radioGroup.selectedIndex = 0;
		
		_cameraBtn = ImageUtil.createSketchImg("temp/cameraBtn.png", false, ViewCfg.HOTSPOT_SCALE);
		_cameraBtn.pivotX = _cameraBtn.sourceWidth / 2;
		_cameraBtn.pivotY = _cameraBtn.sourceHeight / 2;
		_cameraBtn.setCollisionMethod(function(localX:Number, localY:Number, node:NodeAA ) : Boolean {
			if(AMath.distance(localX, localY, 0, 0) < 100){
				return true;
			}
			return false;
		});
		_dragFN.addNode(_cameraBtn);
		_cameraBtn.x = this.getRoot().getAdapter().rootWidth - 110;
		_cameraBtn.y = this.getRoot().getAdapter().rootHeight - 80;
		
		_cameraBtn.addEventListener(ATouchEvent.PRESS,     onPreCamera);
		_cameraBtn.addEventListener(ATouchEvent.UNBINDING, onPostCamera);
		
		
//		_desktopBtn = ImageUtil.createSketchImg("temp/desktopBtn.png", false, ViewCfg.HOTSPOT_SCALE);
//		_desktopBtn.touchable = false;
//		_dragFN.addNode(_desktopBtn);
//		_desktopBtn.x = (this.getRoot().getAdapter().rootWidth - _desktopBtn.sourceWidth * _desktopBtn.scaleX) / 2;
//		_desktopBtn.y = this.getRoot().getAdapter().rootHeight - _desktopBtn.sourceHeight * _desktopBtn.scaleX - 5;
		
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
	private var _launchBgBlur:ImageAA;
	
	private var _funsionA:FusionAA;
	private var _widget:ImageAA;
	private var _statusBar:ImageAA;
	
	private var _cameraBtn:ImageAA;
	private var _desktopBtn:ImageAA;
	
	private var _radioGroup:RadioGroup;
	private var _intoUnlock:Boolean; // 是否进入解锁状态
	
	
	private function onRadioChanged(e:AEvent):void{
		var radioA:RadioAA;
		
		radioA = e.target as RadioAA;
		//trace(radioA.selected);
		radioA.alpha = radioA.selected ? 1.0 : 0.3;
	}
	
	private function onRadioGroupChanged(e:AEvent):void{
		_intoUnlock = (_radioGroup.selectedIndex == 0)
	}
	
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
			
//			c_state = this.getRoot().getView("camera").getState() as Camera_StateAA;
//			c_state.initCamera();
			EventUtil.edView.dispatchEvent(new V_CameraEvent(V_CameraEvent.LAUNCH_CAMERA));
			
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
			//(this.getRoot().getView("camera").getState() as Camera_StateAA).initCamera();
			
			EventUtil.edView.dispatchEvent(new V_CameraEvent(V_CameraEvent.LAUNCH_CAMERA));
		}
	}
	
	
	
	private function onPreDesktop(e:ATouchEvent):void{
		
	}
	
	private function onPostDesktop(e:ATouchEvent):void{
		var tweenA:ATween;
		var durationA:Number;
		
		if(e.touch.velocityY < -100){
			_cameraBtn.kill();
			
			this.getFusion().touchable = false;
			
			_launchBgBlur.visible = true;
			TweenMachine.to(_funsionA, ViewCfg.DURA_DESKTOP, {y:_launchBgBlur.y - 220 }).easing = Quad.easeOut;
			TweenMachine.from(_launchBgBlur, ViewCfg.DURA_DESKTOP, { alpha:0.5});
			tweenA = TweenMachine.to(_launchBg, ViewCfg.DURA_DESKTOP, {alpha:0.0});
			
			//tweenA.easing = Quad.easeOut;
			tweenA.onComplete = function() : void {
				_dragFN.kill();
			}
			
			if(_intoUnlock){
				this.getRoot().getView("unlock").activate();
			}
			else {
				this.getRoot().getView("desktop").activate();
			}
			
		}
	}
	
}
}