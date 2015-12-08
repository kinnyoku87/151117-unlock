package AA.unlock.a
{
	import configs.ViewCfg;
	
	import d2armor.Armor;
	import d2armor.animate.DelayMachine;
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.display.FusionAA;
	import d2armor.display.ImageAA;
	import d2armor.display.Scale3ImageAA;
	import d2armor.display.Scale9ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	import d2armor.display.core.AbstractStretchedImage;
	import d2armor.display.core.NodeAA;
	import d2armor.events.AEvent;
	import d2armor.events.ATouchEvent;
	import d2armor.input.Touch;
	import d2armor.utils.AMath;
	
	import util.ImageUtil;
	import util.ResUtil;
	import AA.unlock.b.UnlockCell_StateAA;
	
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
			
			var paddingX:Number;
			var imgA:ImageAA;
			var tweenA:ATween;
			
			
			_onSuccess = this.getArg(0);
			
			_lineFN = new FusionAA;
			this.getFusion().addNode(_lineFN);
			
			
			
//			_currLine = this.doCreateLine();
//			_currLine.width = 300;
//			_currLine.x = _currLine.y = 500;
//			_currLine.rotation = 90;
			
			
			
			_gap = this.getRoot().getAdapter().rootWidth / 4 + 35;
			paddingX = (this.getRoot().getAdapter().rootWidth - _gap * 2) / 2;
			
			imgA = ImageUtil.createImg("sketch/hotspot.png", true);
			imgA.scaleX = imgA.scaleY = 20.0
			this.getFusion().addNode(imgA);
			imgA.x = _gap * 2;
			imgA.y = _gap + 700;
			imgA.alpha = 0.0;
			
			while(i < _numCell){
				stateFusion_A = new StateFusionAA;
				stateFusion_A.setState(UnlockCell_StateAA);
				_cellAY[i] = stateFusion_A.getState();
				this.getFusion().addNode(stateFusion_A);
				stateFusion_A.x = (i % 3) * _gap + paddingX;
				stateFusion_A.y = int(i / 3) * _gap + 670;
				stateFusion_A.userData = ++i;
				TweenMachine.from(stateFusion_A, ViewCfg.DURA_UNLOCK * 0.95, {alpha:0.5});
				tweenA = TweenMachine.from(stateFusion_A, ViewCfg.DURA_UNLOCK * AMath.random(0.8, 0.95), {y:stateFusion_A.y + 300}, ViewCfg.DELAY_UNLOCK);
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
		
		
//		private const TOKEN:String = "12356";
		private const TOKEN:String = "1235";
		
		private var _lineFN:FusionAA;
		
		private var _gap:Number;
		
		private var _cellAY:Array = [];
		private var _numCell:int = 9;
		private var _token:String = "";
		private var _pressed:Boolean;
		
		private var _onSuccess:Function;
		private var _mistakeDelayID:int = -1;
		
		private var _currCirc:NodeAA;
		private var _currLine:AbstractStretchedImage;
		
		
		
		private function doCreateLine():AbstractStretchedImage{
			
			var s3ImgA:AbstractStretchedImage;
			
			s3ImgA = new Scale9ImageAA;
			s3ImgA.textureId = ResUtil.getTemp("line_A");
			s3ImgA.pivotY = s3ImgA.height / 2;
			s3ImgA.alpha = 0.5;
			//s3ImgA.scaleY = 0.1;
			//s3ImgA.width = length;
			//s3ImgA.y = 300;
			//s3ImgA.height = 300;
			_lineFN.addNode(s3ImgA);
			return s3ImgA;
		}
		
		
		private function onPressSelf(e:ATouchEvent):void{
			_pressed = true;
		}
		
		private function onUnbindingSelf(e:ATouchEvent):void{
			if(!_pressed){
				return;
			}
			_pressed = false;
			
			_lineFN.killAllNodes();
			_currLine = null;
			_currCirc = null;
			
			this.____doValidateToken();
		}
		
		private function onPressCell(e:ATouchEvent):void{
			var state_A:UnlockCell_StateAA;
			
			state_A = (e.target as StateFusionAA).getState() as UnlockCell_StateAA;
			this.____doCheckCell(state_A, e.touch);
		}
		
		private function onHoverCell(e:ATouchEvent):void{
			var state_A:UnlockCell_StateAA;
			
			if(!_pressed){
				return;
			}
			state_A = (e.target as StateFusionAA).getState() as UnlockCell_StateAA;
			this.____doCheckCell(state_A, e.touch);
		}
		
		private function ____doCheckCell( state:UnlockCell_StateAA, touch:Touch ) : void {
			var s3ImgA:AbstractStretchedImage;
			var circA:NodeAA;
			var rotationA:Number;
			
			if(_mistakeDelayID>=0){
				DelayMachine.getInstance().killDelayedCall(_mistakeDelayID);
				this.reset();
			}
			if(state.selected){
				return;
			}
			state.show();
			
			if(_currCirc) {
				circA = state.getFusion();
				
				s3ImgA = this.doCreateLine();
				s3ImgA.width = AMath.distance(_currCirc.x, _currCirc.y, circA.x, circA.y);
				s3ImgA.x = _currCirc.x;
				s3ImgA.y = _currCirc.y;
				
				rotationA = 180 / Math.PI * (Math.atan2(circA.y - _currCirc.y, circA.x - _currCirc.x));
				s3ImgA.rotation = rotationA;
				
				//trace(rotationA);
			}
			else {
				touch.addEventListener(AEvent.CHANGE, onMoving);
			}
			
			_currCirc = state.getFusion();
			
			if(!_currLine) {
				_currLine = this.doCreateLine();
			}
			_currLine.x = _currCirc.x;
			_currLine.y = _currCirc.y;
			this.____doUpdateLineAngle(touch);
			
			_token += String(state.getFusion().userData);
			Armor.getLog().simplify("new token: {0} ({1})", _currCirc.userData, _token);
			
			s3ImgA = this.doCreateLine();
			
		}
		
		private function onMoving(e:AEvent):void{
			var rotationA:Number;
			var touchA:Touch;
			
			touchA = e.target as Touch;
			this.____doUpdateLineAngle(touchA);
		}
		
		
		private function ____doUpdateLineAngle( touch:Touch ) : void {
			var rotationA:Number;
			
			rotationA = 180 / Math.PI * (Math.atan2(touch.rootY - _currCirc.y, touch.rootX - _currCirc.x));
			_currLine.width = AMath.distance(_currCirc.x, _currCirc.y, touch.rootX, touch.rootY);
			_currLine.rotation = rotationA;
		}
		
		private function ____doValidateToken() : void {
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