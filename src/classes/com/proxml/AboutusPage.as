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
	import com.gaiaframework.api.INetStream;
	import flash.text.TextFieldAutoSize;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.*;
	import flash.media.Video;
	import flash.net.*;
	import gs.TweenMax;
	import gs.easing.*;
	import flash.geom.Rectangle;

	public class AboutusPage extends AbstractPage {

		public var middleBar:MovieClip;
		private var middleBarOpen:Boolean=false;

		private var aboutTitle1:String;
		private var aboutTitle2:String;
		private var aboutTitle3:String;
		private var aboutDesc:String;
		
		//Scroll
		private var scrollPath:MovieClip;
		private var scrollSlider:MovieClip;
		private var scrollVisible:Boolean = false;
		private var rectangleDrag:Rectangle;
		private var descTxtMask:MovieClip;

		public function AboutusPage () {
			super ();
			alpha=0;
		}
		//
		override public  function transitionIn ():void {
			super.transitionIn ();
			//
			stage.addEventListener (Event.RESIZE,resizeHandler);
			stage.dispatchEvent (new Event(Event.RESIZE));
			//
			middleBar.x=0;
			middleBar.y=60;
			middleBar.back.width=0;
			//
			middleBar.contentTxt.x=40;
			middleBar.contentTxt.alpha=0;
			//
			TweenMax.to (this,0.3,{alpha:1,onComplete:transitionInComplete});
			//
			Gaia.api.getPage("index/nav").content.addMouseMoveListener ();
			Gaia.api.getPage("index/nav").content.setMainMenuTop ();
			//
			initMiddleBar ();
		}
		//
		override public  function transitionOut ():void {
			super.transitionOut ();
			//
			stage.removeEventListener (Event.RESIZE,resizeHandler);
			//
			TweenMax.to (this,0.3,{alpha:0,onComplete:transitionOutComplete});
		}
		//
		private function initMiddleBar () {
			TweenMax.to (middleBar.back,0.5,{width:stage.stageWidth,ease:Cubic.easeOut});
			middleBarOpen=true;
			//
			loadAboutXml ();
		}
		//
		public function loadAboutXml () {
			var myAboutXML:XML=IXml(assets.aboutXml).xml;
			//
			aboutTitle1=myAboutXML.title1.text();
			aboutTitle2=myAboutXML.title2.text();
			aboutTitle3=myAboutXML.title3.text();
			aboutDesc=myAboutXML.description.text();
			//
			middleBar.contentTxt.titleTxt1.txt.htmlText=aboutTitle1;
			middleBar.contentTxt.titleTxt1.txt.autoSize=TextFieldAutoSize.LEFT;
			//
			middleBar.contentTxt.titleTxt2.txt.htmlText=aboutTitle2;
			middleBar.contentTxt.titleTxt2.txt.autoSize=TextFieldAutoSize.LEFT;
			//
			middleBar.contentTxt.titleTxt3.txt.htmlText=aboutTitle3;
			middleBar.contentTxt.titleTxt3.txt.autoSize=TextFieldAutoSize.LEFT;
			//
			middleBar.contentTxt.descTxt.txt.htmlText=aboutDesc;
			middleBar.contentTxt.descTxt.txt.width=stage.stageWidth - 80;
			middleBar.contentTxt.descTxt.txt.autoSize=TextFieldAutoSize.LEFT;
			middleBar.contentTxt.descTxt.txt.mouseWheelEnabled = false;
			
			descTxtMask = new descTxtMask_mc;
			middleBar.contentTxt.descTxt.addChild(descTxtMask);
			descTxtMask.width = middleBar.contentTxt.descTxt.width;
			descTxtMask.height = stage.stageHeight - 400;
			middleBar.contentTxt.descTxt.txt.mask = descTxtMask;
			
			if ((225 + (middleBar.contentTxt.descTxt.txt.height + 150)) > stage.stageHeight) {
				insertScroll();
			}
			//
			middleBar.contentTxt.descTxt.y=60;
			//
			if (aboutTitle2 != "") {
				middleBar.contentTxt.titleTxt2.y=40;
				middleBar.contentTxt.descTxt.y=100;
				if (aboutTitle3 != "") {
					middleBar.contentTxt.titleTxt3.y=80;
					middleBar.contentTxt.descTxt.y=140;
				}
			}
			//
			TweenMax.to (middleBar.contentTxt,0.5,{alpha:1,ease:Cubic.easeOut});
		}
		//
		public function resizeHandler (e:Event):void {
			middleBar.x=0;
			middleBar.y=60;
			//
			if (middleBarOpen == true) {
				middleBar.back.width=stage.stageWidth;
				middleBar.contentTxt.descTxt.txt.width=stage.stageWidth - 80;

				descTxtMask.width = middleBar.contentTxt.descTxt.width;
				descTxtMask.height = stage.stageHeight - 400;
			}
			else {
				middleBar.back.width=0;
			}
			
			if ((225 + (middleBar.contentTxt.descTxt.txt.height + 173)) < stage.stageHeight) {
				if (scrollVisible == true) {
					middleBar.contentTxt.descTxt.txt.y = 0;
					
					middleBar.contentTxt.descTxt.removeChild(scrollPath);
					scrollPath = null;
					middleBar.contentTxt.descTxt.removeChild(scrollSlider);
					scrollSlider = null;
					stage.removeEventListener(Event.ENTER_FRAME, enterFrameScroll);
					middleBar.contentTxt.descTxt.txt.width=stage.stageWidth - 80;
					
					scrollVisible = false;
				}
			}
			if ((225 + (middleBar.contentTxt.descTxt.txt.height + 173)) > stage.stageHeight){
				if (scrollVisible == false) {
					insertScroll();
				}
				scrollSlider.y = 0;
				scrollPath.x = middleBar.contentTxt.descTxt.txt.width + 5;
				scrollPath.height = stage.stageHeight - 425;
				scrollSlider.x = scrollPath.x;
				rectangleDrag.x = scrollPath.x;
				rectangleDrag.height = scrollPath.height - scrollSlider.height;
			}
		}
		//
		private function insertScroll() {
			scrollPath = new scrollPath_mc;
			middleBar.contentTxt.descTxt.addChild(scrollPath);
			scrollPath.x = middleBar.contentTxt.descTxt.txt.width + 5;
			scrollPath.height = stage.stageHeight - 425;
			scrollSlider = new scrollSlider_mc;
			middleBar.contentTxt.descTxt.addChild(scrollSlider);
			scrollSlider.x = scrollPath.x;
			rectangleDrag = new Rectangle(scrollPath.x, 0, 0, scrollPath.height - scrollSlider.height);
			scrollSlider.buttonMode = true;
			scrollSlider.addEventListener (MouseEvent.MOUSE_DOWN, scrollSliderDown);
			middleBar.contentTxt.descTxt.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);

			scrollVisible = true;
		}
		//
		private function scrollSliderDown(event:MouseEvent) {
			scrollSlider.startDrag(false, rectangleDrag);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameScroll);
			stage.addEventListener (MouseEvent.MOUSE_UP, scrollSliderUp);
		}
		//
		private function scrollSliderUp(event:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_UP,scrollSliderUp);
			scrollSlider.stopDrag();
		}
		//
		private function enterFrameScroll(event:Event) {
			var contentScroll:Number = middleBar.contentTxt.descTxt.txt.height - scrollPath.height;
			var dragScroll:Number = scrollPath.height - scrollSlider.height;
			var scrollTo:Number = scrollPath.y - (contentScroll * (scrollSlider.y - scrollPath.y)) / dragScroll;
			var movement:Number = (scrollTo - middleBar.contentTxt.descTxt.txt.y) / 5;
			middleBar.contentTxt.descTxt.txt.y += movement;
		}
		//Scroll Wheel
		private function mouseWheelListener(event:MouseEvent):void {
			stage.addEventListener(Event.ENTER_FRAME, enterFrameScroll);
			var d:Number = event.delta;
			if (d > 0) {
                if ((scrollSlider.y - (d * 4)) >= 0){
					scrollSlider.y -= d * 4;
				} else {
					scrollSlider.y = 0;
				}
			} else {
				if (((scrollSlider.y + scrollSlider.height) + (Math.abs(d) * 4)) <= scrollPath.height){
					scrollSlider.y += Math.abs(d) * 4;
				} else {
					scrollSlider.y = scrollPath.height - scrollSlider.height
				}
			}
        }
	}
}