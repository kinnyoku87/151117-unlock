package AA {
	import AA.comps.UnlockCell_StateAA;
	
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	
public class Unlock_StateAA extends StateAA {
	
	override public function onEnter() : void {
		var stateFusion_A:StateFusionAA;
		var i:int;
		var l:int;
		var gap:Number;
		
		gap = this.getRoot().getAdapter().rootWidth / 4;
		l = 9;
		while(i < l){
			stateFusion_A = new StateFusionAA;
			stateFusion_A.setState(UnlockCell_StateAA);
			this.getFusion().addNode(stateFusion_A);
			stateFusion_A.x = (i % 3) * gap + gap;
			stateFusion_A.y = int(i / 3) * gap + 800;
			i++;
				
		}
		
	}
	
	
	
}
}