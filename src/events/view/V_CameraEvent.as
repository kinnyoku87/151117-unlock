package events.view
{
	import d2armor.events.AEvent;

	public class V_CameraEvent extends AEvent
	{
		public function V_CameraEvent( type:String )
		{
			super(type);
		}
		
		public static const LAUNCH_CAMERA:String = "launchCamera";
	}
}