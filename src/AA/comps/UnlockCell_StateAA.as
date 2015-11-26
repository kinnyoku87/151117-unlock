package AA.comps {
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	
	import util.ResUtil;
	
public class UnlockCell_StateAA extends StateAA
{
	override public function onEnter() : void {
		_imgA = new ImageAA;
		_imgA.textureId = ResUtil.getCommon("password_A");
		_imgA.pivotX = _imgA.sourceWidth * .5;
		_imgA.pivotY = _imgA.sourceHeight * .5;
		_imgA.scaleX = _imgA.scaleY = 1.5;
		this.getFusion().addNode(_imgA);
		
		
		
	}
	
	private var _imgA:ImageAA;
	
}
}