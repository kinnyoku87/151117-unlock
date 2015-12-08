package launchers
{
	import flash.display.Stage;
	
	import AA.Camera_StateAA;
	import AA.Desktop_StateAA;
	import AA.LaunchBlur_StateAA;
	import AA.Launch_StateAA;
	import AA.Res_StateAA;
	import AA.Unlock_StateAA;
	
	import d2armor.Armor;
	import d2armor.core.Adapter;
	import d2armor.core.ILauncher;
	import d2armor.display.AAFacade;
	import d2armor.display.RootAA;
	import d2armor.events.AEvent;
	import d2armor.input.TouchType;
	import d2armor.resource.ResMachine;
	import d2armor.resource.converters.AtlasAssetConvert;
	import d2armor.resource.converters.SwfClassAssetConverter;
	
	import util.CameraUtil;
	
	public class Launcher_151117_A implements ILauncher {
		
		private var _adapter:Adapter;
		private var _rootAA:RootAA;
		
		public function onLaunch( stage:Stage ) : void {
			//stage.quality = StageQuality.LOW;
			//stage.quality = StageQuality.MEDIUM
			//stage.quality = StageQuality.HIGH;
			
			this._adapter = Armor.createAdapter(stage, false);
			this._adapter.getTouch().velocityEnabled = true;
			this._adapter.getTouch().touchType = TouchType.SINGLE;
			
			ResMachine.activate(SwfClassAssetConverter);
			ResMachine.activate(AtlasAssetConvert);
			
			AAFacade.registerView("res",    Res_StateAA);
			AAFacade.registerView("launch", Launch_StateAA);
			
			AAFacade.registerView("camera", Camera_StateAA);
			
			AAFacade.registerView("desktop", Desktop_StateAA);
			
			AAFacade.registerView("unlock", Unlock_StateAA);
			
			_rootAA = AAFacade.createRoot(this._adapter, 0x0, true);
			_rootAA.addEventListener(AEvent.START, onStart);
		}
		
		private function onStart(e:AEvent):void {	
			_rootAA.removeEventListener(AEvent.START, onStart);
			
			// 第一次开启delete状态AA，存在缓动bug..!!第二次开启bug自动消失..
			
			CameraUtil.initCameraTexture(_adapter, function():void{
				_rootAA.getView("res").activate([["launch"]]);
				//_rootAA.getView("res").activate([["launch", "desktop"]]);
			});
			
		}
	}
}