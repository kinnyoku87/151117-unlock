package AA 
{
	import flash.media.Camera;
	
	import configs.ViewCfg;
	
	import d2armor.Armor;
	import d2armor.animate.TweenMachine;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.VideoAA;
	import d2armor.display.textures.VideoTextureAA;
	import d2armor.events.ATouchEvent;
	
	import events.view.V_CameraEvent;
	
	import util.CameraUtil;
	import util.EventUtil;
	import util.ImageUtil;

public class Camera_StateAA extends StateAA
{
	
	override public function onEnter() : void
	{
		this.getFusion().touchable = false;
		
		//this.doInitCamera();
		_cameraBg = new ImageAA
		_cameraBg.textureId = "temp/cameraBgPre.png";
		this.getFusion().addNode(_cameraBg);
		
		_closeBtn = ImageUtil.createImg("sketch/hotspot.png");
		_closeBtn.scaleX = ViewCfg.HOTSPOT_SCALE;
		_closeBtn.scaleY = ViewCfg.HOTSPOT_SCALE;
		this.getFusion().addNode(_closeBtn);
		_closeBtn.addEventListener(ATouchEvent.CLICK, onCloseCamera);
		
		this.insertEventListener(EventUtil.edView, V_CameraEvent.LAUNCH_CAMERA, onLaunchCamera);
	}
	
	
	
	public var camera_A:Camera;
	public var videoTEX:VideoTextureAA;
	
	private var _cameraBg:ImageAA;
	
	private var _closeBtn:ImageAA;
	private var _isInitCamera:Boolean;
	
	
	private function onLaunchCamera( e:V_CameraEvent ):void{
		var ratioX:Number;
		var ratioY:Number;
		var ratioA:Number;
		var img_A:ImageAA;
		
		if(_isInitCamera){
			return;
		}
		_isInitCamera = true;
		_cameraBg.textureId = "temp/cameraBg.png";
		if(Camera.getCamera()){
			img_A = new VideoAA;
			img_A.textureId = CameraUtil.CAMERA_TEXTURE_ID;
			img_A.pivotX = img_A.sourceWidth / 2;
			img_A.pivotY = img_A.sourceHeight / 2;
			
			Armor.getLog().simplify("{0} | {1}", img_A.sourceWidth, img_A.sourceHeight / 2 );
			
			img_A.rotation = 90;
			img_A.x = this.getRoot().getAdapter().rootWidth / 2;
			img_A.y = this.getRoot().getAdapter().rootHeight / 2;
			ratioX = img_A.sourceHeight / this.getRoot().getAdapter().rootWidth;
			ratioY = img_A.sourceWidth / this.getRoot().getAdapter().rootHeight;
			ratioA = Math.min(ratioX, ratioY);
			img_A.scaleX = img_A.scaleY = 1 / ratioA + 0.05;
			
			//		img_A.filters = [new ColorMatrixFilterAA()];
			
			Armor.getLog().simplify("{0} | {1}: {2}", img_A.sourceHeight, img_A.sourceWidth, img_A.scaleY);
		}
		else {
			img_A = new ImageAA;
			img_A.textureId = "temp/virtualCamera.png";
			
			
		}
		this.getFusion().addNodeAt(img_A, 0);
	}
	
	
	private function onCloseCamera(e:ATouchEvent):void{
		this.getRoot().closeAllViews();
		
		this.getRoot().getView("launch").activate();
	}
	
}
}