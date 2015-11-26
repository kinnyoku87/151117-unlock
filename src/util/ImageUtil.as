package util {
	import d2armor.display.ImageAA;
	
public class ImageUtil {
	
//	public static var allUseSketch:Boolean;
	public static var allUseSketch:Boolean = true;
	
	public static function createImg( textureId:String, pivot:Boolean = false ) : ImageAA {
		var imgA:ImageAA;
		
		imgA = new ImageAA;
		imgA.textureId = textureId;
		if(pivot){
			imgA.pivotX = imgA.sourceWidth * .5;
			imgA.pivotY = imgA.sourceHeight * .5;
		}
		return imgA;
	}
	
	public static function createSketchImg( textureId:String, pivot:Boolean = false, sketchScale:Number = 1.0 ) : ImageAA {
		var imgA:ImageAA;
		
		imgA = new ImageAA;
		imgA.textureId = allUseSketch ? "sketch/hotspot.png" : textureId;
		if(pivot){
			imgA.pivotX = imgA.sourceWidth * .5;
			imgA.pivotY = imgA.sourceHeight * .5;
		}
		if(allUseSketch){
			imgA.scaleX = sketchScale;
			imgA.scaleY = sketchScale;
		}
		return imgA;
	}
	
	
}
}