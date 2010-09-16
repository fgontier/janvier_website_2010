/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2008
* Written by: Steven Sacks
* email: stevensacks@gmail.com
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is (c) 2007-2008 Steven Sacks and is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.proxml{
	import com.gaiaframework.templates.AbstractPage;
	import com.gaiaframework.events.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.api.*;
	import flash.display.*;
	import flash.events.*;
	import gs.TweenMax;
	import gs.easing.*;

	public class IndexPage extends AbstractPage {
		
		public var mainBackground:MovieClip;
		
		public function IndexPage () {
			super ();
			alpha = 0;
		}
		//
		override public function transitionIn ():void {
			super.transitionIn ();
			//
			mainBackground.x = 0;
			mainBackground.y = 0;
			mainBackground.alpha = 0;
			//
			stage.addEventListener (Event.RESIZE, resizeHandler);
			stage.dispatchEvent (new Event(Event.RESIZE));
			//
			TweenMax.to (this, 0.3, { alpha:1, ease:Cubic.easeOut, onComplete:transitionInComplete } );
			//
			placeBackground ();
		}
		//
		override public function transitionOut ():void {
			super.transitionOut ();
			TweenMax.to (this, 0.3, {alpha:0, onComplete:transitionOutComplete});
		}
		//
		private function placeBackground (){
			mainBackground.addChild(assets.myBackground.loader);
			IDisplayObject(assets.myBackground).visible = true;
			TweenMax.to (mainBackground, 0.5, {alpha:1, ease:Cubic.easeOut});
			mainBackground.width = stage.stageWidth;
			mainBackground.height = stage.stageHeight;
			mainBackground.smoothing = true;
		}
		//
		public function resizeHandler (e:Event):void {
			mainBackground.x = 0;
			mainBackground.y = 0;
			mainBackground.width = stage.stageWidth;
			mainBackground.height = stage.stageHeight;
			mainBackground.smoothing = true;
		}
	}
}