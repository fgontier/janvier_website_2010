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
	import com.gaiaframework.templates.AbstractPreloader;
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.events.*;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import gs.TweenMax;
	import gs.easing.*;

	public class PreloaderScaffold extends Sprite {
		public var percentTxt:MovieClip;
		public var barBack:MovieClip;
		public var verticalLine:MovieClip;
		
		public var TXT_Overall:TextField;
		public var TXT_Asset:TextField;
		public var TXT_Bytes:TextField;
		public var MC_Bar:Sprite;

		public function PreloaderScaffold () {
			super ();
			alpha = 0;
			visible = false;
			mouseEnabled = mouseChildren = false;
			addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage (event:Event):void {
			removeEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener (Event.RESIZE, onResize);
			onResize ();
		}
		public function transitionIn ():void {
			TweenMax.to (this, .1, {autoAlpha:1});
		}
		public function transitionOut ():void {
			TweenMax.to (this, .1, {autoAlpha:0});
		}
		public function onProgress (event:AssetEvent):void {
			// if bytes, don't show if loaded = 0, if not bytes, don't show if perc = 0
			// the reason is because all the files might already be loaded so no need to show preloader
			visible = event.bytes ? (event.loaded > 0) : (event.perc > 0);

			// multiply perc (0-1) by 100 and round for overall 
			percentTxt.TXT_Overall.text = Math.round(event.perc * 100) + "%";

			// individual asset percentage (0-1) multiplied by 100 and round for display
			var assetPerc:int = Math.round(event.asset.percentLoaded * 100) || 0;
			TXT_Asset.text = (event.asset.title || event.asset.id) + " " + assetPerc + "%";
			TXT_Asset.autoSize = TextFieldAutoSize.LEFT;
			
			TweenMax.to (MC_Bar, .5, {width:(event.perc * stage.stageWidth) / 1, ease:Cubic.easeOut});
			TweenMax.to (verticalLine, .5, {x:(event.perc * stage.stageWidth) / 1, ease:Cubic.easeOut});
			TweenMax.to (percentTxt, .5, {x:Math.floor(((event.perc * stage.stageWidth) / 1) - 92), ease:Cubic.easeOut});

			// if bytes is true, show the actual bytes loaded and total
			TXT_Bytes.text = (event.bytes) ? event.loaded + " / " + event.total : "";
			TXT_Bytes.autoSize = TextFieldAutoSize.LEFT;
		}
		private function onResize (event:Event = null):void {
			x = 0;
			y = 0;
			//
			MC_Bar.x = 0;
			MC_Bar.y = stage.stageHeight/2;
			//
			percentTxt.y = Math.floor(stage.stageHeight/2 - 23);
			//
			verticalLine.y = stage.stageHeight/2 - 15;
			//
			barBack.x = 0;
			barBack.y = stage.stageHeight/2;
			barBack.width = stage.stageWidth;
		}
	}
}