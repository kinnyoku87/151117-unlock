package AA {
	import flash.media.Camera;
	
	import d2armor.display.StateAA;
	import d2armor.events.AEvent;
	import d2armor.resource.FilesBundle;
	import d2armor.resource.ResMachine;
	import d2armor.resource.handlers.TextureAA_BundleHandler;
	import d2armor.ui.skins.SkinManager;
	import d2armor.ui.skins.ToggleSkin;
	
public class Res_StateAA extends StateAA {
	
	override public function onEnter() : void {
		var AY:Vector.<String>;
		
		this.resA = new ResMachine("common/");
		
		AY = new <String>
			[
				"sketch/hotspot.png",
				
				"temp/cameraBg.png",
				"temp/cameraBgPre.png",
				"temp/cameraBtn.png",
				
				"temp/desk.png",
				"temp/desk_bg.png",
				
				"atlas/common/password_A.png",
				"atlas/common/password_B.png",
				"temp/launch_bg.png"
			]
		if(!Camera.getCamera()){
			AY.push("temp/virtualCamera.png");
		}
		this.resA.addBundle(new FilesBundle(AY), new TextureAA_BundleHandler(1.0, false, false));
		
//		AY = new <String>
//		[
//			"sketch/hotspot.png"
//		];
//		SkinManager.registerSkin("radio", new ToggleSkin(AY, 0, 0, 0 , 0, 0, 0, 0, 0));
		
		this.resA.addEventListener(AEvent.COMPLETE, onComplete);
	}
	
	public var resA:ResMachine;
	
	private function onComplete(e:AEvent):void {
		var AY:Array;
		var i:int;
		var l:int;
		
		this.resA.removeAllListeners();
		this.getFusion().kill();
		
		AY = this.getArg(0);
		l = AY.length;
		while (i < l) {
			this.getRoot().getView(AY[i++]).activate();
		}
	}
}
}