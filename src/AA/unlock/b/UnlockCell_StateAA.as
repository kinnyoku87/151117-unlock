package AA.unlock.b {
	import d2armor.Armor;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.utils.AColor;
	
	import util.ResUtil;
	
public class UnlockCell_StateAA extends StateAA {
	
	public var selected:Boolean;
	
	public function show() : void {
		_bgA.alpha = 1.0;
		this.selected = true;
	}
	
	public function mistake() : void {
		
		if(this.selected){
			_bgA.color = new AColor(0xdd0000);
		}
	}
	
	public function reset() : void {
		_bgA.alpha = 0.0;
		_bgA.color = null;
		this.selected = false;
	}
	
	override public function onEnter() : void {
		_bgA = new ImageAA;
//		_bgA.textureId = ResUtil.getCommon("password_A");
		_bgA.textureId = ResUtil.getTemp("circ_B");
		_bgA.pivotX = _bgA.sourceWidth * .5;
		_bgA.pivotY = _bgA.sourceHeight * .5;
		_bgA.scaleX = _bgA.scaleY = 1.35;
		this.getFusion().addNode(_bgA);
		_bgA.alpha = 0.0;
		//_bgA.color = new AColor(0xFF0000);
		
		_dot = new ImageAA;
//		_dot.textureId = ResUtil.getCommon("password_B");
		_dot.textureId = ResUtil.getTemp("circ_A");
		_dot.pivotX = _dot.sourceWidth * .5;
		_dot.pivotY = _dot.sourceHeight * .5;
//		_dot.scaleX = _dot.scaleY = 1.3;
		this.getFusion().addNode(_dot);
		
	}
	
	private var _bgA:ImageAA;
	private var _dot:ImageAA;
	
	
}
}