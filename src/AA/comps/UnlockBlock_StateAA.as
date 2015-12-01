package AA.comps
{
	import configs.ViewCfg;
	
	import d2armor.animate.DelayMachine;
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	import d2armor.events.ATouchEvent;
	import d2armor.utils.AMath;
	
	import util.ImageUtil;
	
	public class UnlockBlock_StateAA extends StateAA {
		
		public function reset() : void {
			var i:int;
			var l:int;
			var cellStateA:UnlockCell_StateAA;
			
			while(i < _numCell){
				cellStateA = _cellAY[i++];
				cellStateA.reset();
			}
			_token = "";
			_mistakeDelayID = -1;
		}
		
		public function mistake() : void {
			var i:int;
			var l:int;
			var cellStateA:UnlockCell_StateAA;
			
			while(i < _numCell){
				cellStateA = _cellAY[i++];
				cellStateA.mistake();
			}
			
			_mistakeDelayID = DelayMachine.getInstance().delayedCall(2, function():void{
				reset();
			});
		}
		
		override public function onEnter():void {
			var stateFusion_A:StateFusionAA;
			var i:int;
			var l:int;
			var gap:Number;
			var imgA:ImageAA;
			var tweenA:ATween;
			
			
			_onSuccess = this.getArg(0);
			
			
			gap = this.getRoot().getAdapter().rootWidth / 4;
			
			imgA = ImageUtil.createImg("sketch/hotspot.png", true);
			imgA.scaleX = imgA.scaleY = 20.0
			this.getFusion().addNode(imgA);
			imgA.x = gap * 2;
			imgA.y = gap + 700;
			imgA.alpha = 0.0;
			
			while(i < _numCell){
				stateFusion_A = new StateFusionAA;
				stateFusion_A.setState(UnlockCell_StateAA);
				_cellAY[i] = stateFusion_A.getState();
				this.getFusion().addNode(stateFusion_A);
				stateFusion_A.x = (i % 3) * gap + gap;
				stateFusion_A.y = int(i / 3) * gap + 700;
				stateFusion_A.userData = ++i;
				TweenMachine.from(stateFusion_A, ViewCfg.DURA_UNLOCK * 0.95, {alpha:0.5});
				tweenA = TweenMachine.from(stateFusion_A, ViewCfg.DURA_UNLOCK * AMath.random(0.8, 0.95), {y:stateFusion_A.y + 300});
				tweenA.easing = Back.easeOut;
				
				stateFusion_A.addEventListener(ATouchEvent.PRESS, onPressCell);
				stateFusion_A.addEventListener(ATouchEvent.HOVER, onHoverCell);
			}
			
			this.getFusion().addEventListener(ATouchEvent.PRESS, onPressSelf);
			this.getFusion().addEventListener(ATouchEvent.UNBINDING, onUnbindingSelf);
		}
		
		override public function onExit():void{
			if(_mistakeDelayID>=0){
				DelayMachine.getInstance().killDelayedCall(_mistakeDelayID);
			}
		}
		
		
		private const TOKEN:String = "12356";
		
		private var _cellAY:Array = [];
		private var _numCell:int = 9;
		private var _token:String = "";
		private var _pressed:Boolean;
		
		private var _onSuccess:Function;
		private var _mistakeDelayID:int = -1;
		
		
		private function onPressSelf(e:ATouchEvent):void{
			_pressed = true;
		}
		
		private function onUnbindingSelf(e:ATouchEvent):void{
			if(!_pressed){
				return;
			}
			_pressed = false;
			this.doValidateToken();
		}
		
		private function onPressCell(e:ATouchEvent):void{
			var state_A:UnlockCell_StateAA;
			
			state_A = (e.target as StateFusionAA).getState() as UnlockCell_StateAA;
			this.doCheckCell(state_A);
		}
		
		private function onHoverCell(e:ATouchEvent):void{
			var state_A:UnlockCell_StateAA;
			
			if(!_pressed){
				return;
			}
			state_A = (e.target as StateFusionAA).getState() as UnlockCell_StateAA;
			this.doCheckCell(state_A);
		}
		
		private function doCheckCell( state:UnlockCell_StateAA ) : void {
			if(_mistakeDelayID>=0){
				DelayMachine.getInstance().killDelayedCall(_mistakeDelayID);
				this.reset();
			}
			if(state.selected){
				return;
			}
			state.show();
			_token += String(state.getFusion().userData);
		}
		
		private function doValidateToken() : void {
			if(_token == TOKEN){
				
				if(_onSuccess != null) {
					_onSuccess();
				}
			}
			else {
				this.mistake();
				
			}
		}
	}
}