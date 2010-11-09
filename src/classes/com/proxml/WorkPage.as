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
	import flash.geom.Rectangle;
	import gs.TweenMax;
	import gs.easing.*;

	public class WorkPage extends AbstractPage {

		public var workContent:MovieClip;
		private var middleBarOpen:Boolean = false;
		public var ourWorkOpen:String = "right";
		public var workDetailsOpen:String = "right";

		private var workTitle1:String;
		private var workTitle2:String;
		private var workTitle3:String;

		private var ourWorkXmlTotalItems:Number;
		private var projectListArray:Array = new Array;
		private var i:Number = 0;

		public var workItem:MovieClip;
		private var workProjectTitle1:String;
		private var workProjectTitle2:String;
		private var workProjectTitle3:String;
		private var workProjectDescription:String;
		private var workProjectSmallTmb:String;
		private var workProjectLargeTmb:String;
		private var workProjectURL:String;
		private var workProjectDate:String;
		private var thumbLoader:Array = new Array;

		private var indexMaxWorkDesc:int = 0;
		private var lenghtCharLineWorkDesc:int;
		private var indexInitWorkDesc:int;

		private var myTotalItemsNr:String;
		private var numX:Number;
		private var numItems:Number;
		private var myCurrentItemNr:String;
		private var rectangleDragWork:Rectangle;
		private var myWorkItemUrl:String;

		private var myOurWorkPos:Number;
		private var myWorkDetailsPos:Number;

		public var myWorkDetailsItem:MovieClip;
		private var workDetailsPicSize:Number;
		private var workDetailsArray:Array = new Array;
		private var projectDetailsLargeTmb:Array = new Array;
		private var largeTmbLoader:Loader;
		private var largeTmbUrl:URLRequest;

		private var myProjectDetailsID:Number = undefined;
		private var largeTmbCounterArray:Array = new Array;
		private var largeTmbLoadedFirstTime:Boolean = false;
		private var validateLargeTmbArray:Boolean = false;
		private var myLargeTmbComplete:*;

		private var projectGalleryID:Number;
		private var projectGalleryTitle1:String;
		private var projectGalleryTitle2:String;
		private var projectGalleryTitle3:String;
		private var projectGalleryTotalItems:Number;
		private var a:Number = 0;
		public var projectGalleryItem:MovieClip;
		private var projectGalleryItemTitle:String;
		private var projectGalleryItemDescription:String;
		private var projectGalleryItemThumbnail:String;
		private var projectGalleryItemType:String;
		private var projectGalleryItemFile:String;
		private var projectGalleryItemLink:String;
		private var projectGalleryArray:Array = new Array;
		private var projectGalleryNumX:Number;
		private var rectangleDragProjectGallery:Rectangle;
		private var numItemsProjectGallery:Number;
		private var projectGalleryThumbLoader:Array = new Array;
		private var rectangleWorkAvailable:Boolean = false;
		private var rectangleProjectGalleryAvailable:Boolean = false;
		private var myProjectGalleryPos:Number;
		private var projectGalleryOpen:String = "right";
		private var myProjectGalleryItemID:Number;
		private var myProjectGalleryItemType:String;
		private var myProjectGalleryItemFile:String;
		private var myProjectGalleryItemLink:String;
		private var myProjectGalleryItemTitle:String;
		private var myProjectGalleryItemDescription:String;
		private var myProjectGalleryVideoItemFile:String;

		private var conn:NetConnection;
		private var conn2:NetConnection;
		private var stream:NetStream;
		private var stream2:NetStream;
		public var metaListener:Object = new Object();
		public var metaListener2:Object = new Object();
		public var video:Video = new Video();
		public var video2:Video = new Video();
		private var projectGalleryVideoTotalLength:uint;
		private var projectGalleryVideoOriginalWidth:Number;
		private var projectGalleryVideoOriginalHeight:Number;
		private var projectGalleryPlayVideoFirstTime:Boolean = false;
		private var projectGalleryVideoPlaying:Boolean = false;
		private var myTempVideoID:Number;
		private var videoIsFullScreen:Boolean = false;
		private var projectGalleryPicSize:Number;
		private var myFullScreenPlayerPos:Number;
		private var fullScreenPlayerOpen:String = "right";
		private var fullScreenImageLoader:Loader;
		private var fullScreenFlashLoader:Loader;
		private var fullScreenImageRequest:URLRequest;

		private var fullScreenVideoTotalLength:uint;
		private var fullScreenVideoOriginalWidth:Number;
		private var fullScreenVideoOriginalHeight:Number;

		private var projectGalleryIsOnProgress:Boolean = false;
		
		private var deepLinkString:String;
		private var deepLinkID:Number;
		private var deepLinkZone:String = "work";
		
		private var tempProjID:Number = -1;

		public function WorkPage () {
			super ();
			alpha = 0;
			//
			myDeeplinkHandler(Gaia.api.getDeeplink());
		}
		//
		override public function onDeeplink (event:GaiaSWFAddressEvent):void {
			myDeeplinkHandler (event.deeplink);
		}
		//
		private function myDeeplinkHandler (deeplink:String):void {
			//
			deepLinkString = deeplink.slice(0,-1);
			deepLinkID = int(deeplink.slice(-1,deeplink.length));
			//
			if(deepLinkString == "/details/"){
				deepLinkZone = "details"
			}
			else if (deepLinkString == "/details/gallery/"){
				deepLinkZone = "gallery"
			}
		}
		//
		override public function transitionIn ():void {
			super.transitionIn ();
			//
			stage.addEventListener (Event.RESIZE, resizeHandler);
			stage.dispatchEvent (new Event(Event.RESIZE));
			//
			workContent.x = 0;
			workContent.y = 0;
			//
			workContent.btBack.visible = false;
			workContent.btBack2.visible = false;
			workContent.btBack3.visible = false;
			//
			workContent.middleBar.x = 0;
			workContent.middleBar.y = stage.stageHeight/2 - 35;
			workContent.middleBar.width = 0;
			workContent.middleBar.height = stage.stageHeight/2 + 35;
			//
			workContent.ourWork.x = stage.stageWidth;
			workContent.ourWork.y = Math.floor(workContent.middleBar.y - 40);
			workContent.ourWork.previewMode.navScroller.x = 0;
			//
			if (stage.stageWidth >= 1300) {
				workContent.ourWork.previewMode.navScroller.scrollBar.back.width = 1260;
				workContent.ourWork.previewMode.navScroller.scrollSlider.width = 60;
				//
				//workDetailsPicSize = 875;
				workDetailsPicSize = 575;
			}
			else {
				workContent.ourWork.previewMode.navScroller.scrollBar.back.width = 940;
				workContent.ourWork.previewMode.navScroller.scrollSlider.width = 40;
				//
				workDetailsPicSize = 575;
			}
			//
			if (stage.stageWidth >= 1195) {
				workContent.projectGallery.navScroller.scrollBar.back.width = 1155;
				workContent.projectGallery.navScroller.scrollSlider.width = 60;
				//
				//projectGalleryPicSize = 1155;
				projectGalleryPicSize = 765;	
			}
			else {
				workContent.projectGallery.navScroller.scrollBar.back.width = 765;
				workContent.projectGallery.navScroller.scrollSlider.width = 40;
				//
				projectGalleryPicSize = 765;
			}
			//
			workContent.ourWork.previewMode.navBts.x = 0;
			//
			Gaia.api.getPage("index/nav").content.addMouseMoveListener ();
			Gaia.api.getPage("index/nav").content.setMainMenuTop ();
			//
			TweenMax.to (this, 0.3, {alpha:1, onComplete:transitionInComplete});
			//
			initMiddleBar ();
		}
		//
		override public function transitionOut ():void {
			super.transitionOut ();
			//
			closeProjectGalleryVideo ();
			//
			stage.removeEventListener (Event.RESIZE, resizeHandler);
			stage.removeEventListener (MouseEvent.MOUSE_UP, FSvideoTrackUp);
			//
			//if (myProjectGalleryItemType == "image" ) {
////////// ADDED BY FRED //			
			if (myProjectGalleryItemType == "image" ) {
				workContent.fullScreenPlayer.player.picture.attach.removeChild (fullScreenImageLoader);
			}
			else if (myProjectGalleryItemType == "flash") {
				workContent.fullScreenPlayer.player.flashAsset.attach.removeChild (fullScreenFlashLoader);
			}			
			
			else if (myProjectGalleryItemType == "video") {
				closeFullScreenVideo ();
			}
			//
			TweenMax.to (this, 0.3, {alpha:0, onComplete:transitionOutComplete});
		}
		//
		private function initMiddleBar () {
			TweenMax.to (workContent.middleBar, 0.5, {width:stage.stageWidth, ease:Cubic.easeOut, onComplete:loadWorkXml});
			middleBarOpen = true;
		}
		//
		private function loadWorkXml () {
			var myWorkXML:XML = IXml(assets.workXml).xml;
			//
			workTitle1 = myWorkXML.title1.text();
			workTitle2 = myWorkXML.title2.text();
			workTitle3 = myWorkXML.title3.text();
			//
			workContent.ourWork.previewMode.topTitleTxt.titleTxt1.txt.text = workTitle1;
			workContent.ourWork.previewMode.topTitleTxt.titleTxt1.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.ourWork.previewMode.topTitleTxt.titleTxt2.txt.text = workTitle2;
			workContent.ourWork.previewMode.topTitleTxt.titleTxt2.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.ourWork.previewMode.topTitleTxt.titleTxt3.txt.text = workTitle3;
			workContent.ourWork.previewMode.topTitleTxt.titleTxt3.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.ourWork.previewMode.topTitleTxt.y = -90;
			//
			if (workTitle2 != "") {
				workContent.ourWork.previewMode.topTitleTxt.titleTxt2.y = 40;
				workContent.ourWork.previewMode.topTitleTxt.y = -130;
				if (workTitle3 != "") {
					workContent.ourWork.previewMode.topTitleTxt.titleTxt3.y = 80;
					workContent.ourWork.previewMode.topTitleTxt.y = -170;
				}
			}
			//
			ourWorkXmlTotalItems = myWorkXML.item.length();
			//
			projectListArray = [];
			//
			for (i = 0; i < ourWorkXmlTotalItems; i++) {
				workItem = new ourWorkItem;
				//
				workProjectTitle1 = myWorkXML.item.title1[i].text();
				workProjectTitle2 = myWorkXML.item.title2[i].text();
				workProjectTitle3 = myWorkXML.item.title3[i].text();
				workProjectDescription = myWorkXML.item.description[i].text();
				workProjectSmallTmb = myWorkXML.item.small_thumbnail[i].text();
				workProjectLargeTmb = myWorkXML.item.large_thumbnail[i].text();
				workProjectURL = myWorkXML.item.url[i].text();
				workProjectDate = myWorkXML.item.date[i].text();
				//
				projectListArray.push (workItem);
				projectDetailsLargeTmb.push (workProjectLargeTmb);
				//
				projectListArray[i].titleTxt.txt.htmlText = workProjectTitle1;
				projectListArray[i].commentTxt.txt.htmlText = workProjectTitle2;
				projectListArray[i].descTxt.txt.htmlText = workProjectDescription;
				projectListArray[i].descTxt.txt.width = 290;
				projectListArray[i].descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				if (projectListArray[i].descTxt.txt.height > 48) {
					for (var a:int = 0; a<3; a++) {
						lenghtCharLineWorkDesc = projectListArray[i].descTxt.txt.getLineLength(a+1);
						indexMaxWorkDesc = indexMaxWorkDesc + lenghtCharLineWorkDesc;
					}
					indexInitWorkDesc = indexMaxWorkDesc + 40;
					projectListArray[i].descTxt.txt.replaceText (indexInitWorkDesc, projectListArray[i].descTxt.txt.length, " ...");
				}
				indexMaxWorkDesc = 0;
				//
				workContent.ourWork.previewMode.attachItems.addChild (workItem);
				//
				projectListArray[i].alpha = 0;
				projectListArray[i].x = 320 * i;
				TweenMax.to (projectListArray[i], 0.5, {alpha:1, ease:Expo.easeOut, delay:i * 0.2});
				//
				projectListArray[i].btOpenUrl.instanceUrl = workProjectURL;
				//
				if (workProjectURL == "") {
					projectListArray[i].btOpenUrl.visible = false;
				}
				else {
					projectListArray[i].btOpenUrl.buttonMode = true;
					projectListArray[i].btOpenUrl.gotoAndStop (1);
					projectListArray[i].btOpenUrl.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
					projectListArray[i].btOpenUrl.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
					projectListArray[i].btOpenUrl.addEventListener (MouseEvent.CLICK, btOpenUrlClick);
					projectListArray[i].btOpenUrl.visible = true;
				}
				//
				thumbLoader[i] = new Loader();
				thumbLoader[i].load (new URLRequest(workProjectSmallTmb));
				thumbLoader[i].contentLoaderInfo.addEventListener (Event.COMPLETE, workThumbLoadComplete, false, 0, true);
				thumbLoader[i].contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, workThumbLoadProgress);
				//
				TweenMax.to (projectListArray[i].preLoader, 0.5, {alpha:1, ease:Expo.easeOut});
				//
				workItem.picture.attach.alpha = 0;
				workItem.picture.attach.addChild (thumbLoader[i]);
				//
				myWorkDetailsItem = new workDetailsItem;
				workDetailsArray.push (myWorkDetailsItem);
				//
				workContent.workDetails.attachItems.addChild (myWorkDetailsItem);
				//
				workDetailsArray[i].alpha = 0;
				workDetailsArray[i].x = stage.stageWidth;
				//
				workDetailsArray[i].topTitleTxt.titleTxt1.txt.text = workProjectTitle1;
				workDetailsArray[i].topTitleTxt.titleTxt1.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				workDetailsArray[i].topTitleTxt.titleTxt2.txt.text = workProjectTitle2;
				workDetailsArray[i].topTitleTxt.titleTxt2.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				workDetailsArray[i].topTitleTxt.titleTxt3.txt.text = workProjectTitle3;
				workDetailsArray[i].topTitleTxt.titleTxt3.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				workDetailsArray[i].topTitleTxt.y = -75;
				//
				if (workProjectTitle2 != "") {
					workDetailsArray[i].topTitleTxt.titleTxt2.y = 40;
					workDetailsArray[i].topTitleTxt.y = -115;
					if (workProjectTitle3 != "") {
						workDetailsArray[i].topTitleTxt.titleTxt3.y = 80;
						workDetailsArray[i].topTitleTxt.y = -155;
					}
				}
				//
				workDetailsArray[i].btVisitProject.instanceUrl = workProjectURL;
				//
				if (workProjectURL == "") {
					workDetailsArray[i].btVisitProject.visible = false;
				}
				else {
					workDetailsArray[i].btVisitProject.buttonMode = true;
					workDetailsArray[i].btVisitProject.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
					workDetailsArray[i].btVisitProject.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
					workDetailsArray[i].btVisitProject.addEventListener (MouseEvent.CLICK, btOpenUrlClick);
					workDetailsArray[i].btVisitProject.visible = true;
				}
				//
				workDetailsArray[i].back.width = workDetailsPicSize;
				workDetailsArray[i].backPicture.width = workDetailsPicSize - 10;
				workDetailsArray[i].masker.maskIn.width = workDetailsPicSize - 10;
				workDetailsArray[i].contentTxt.x = workDetailsArray[i].back.x + workDetailsArray[i].back.width + 10;
								
				workDetailsArray[i].btVisitProject.x = Math.floor(workDetailsPicSize - workDetailsArray[i].btVisitProject.width);

//// ADDED BY FRED ////
				// if we don't have a gallery, don't show the button:
				if(myWorkXML.item[i].gallery == undefined)
				{						
					workDetailsArray[i].btProjectGallery.visible = false;
				}
//// END OF ADDED BY FRED ////

				workDetailsArray[i].btProjectGallery.x = Math.floor(workDetailsArray[i].btVisitProject.x - 5 - workDetailsArray[i].btProjectGallery.width );
				//
				workDetailsArray[i].contentTxt.titleTxt.txt.htmlText = workProjectTitle1;
				workDetailsArray[i].contentTxt.titleTxt.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				workDetailsArray[i].contentTxt.descTxt.txt.htmlText = workProjectDescription;
				workDetailsArray[i].contentTxt.descTxt.txt.width = 335;
				workDetailsArray[i].contentTxt.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				TweenMax.to (workDetailsArray[i], 0.5, {alpha:1, ease:Expo.easeOut, delay:i * 0.2});
				//				
				workDetailsArray[i].btProjectGallery.instanceID = i;
				workDetailsArray[i].btProjectGallery.instanceWorkProjectTitle1 = workProjectTitle1;
				workDetailsArray[i].btProjectGallery.instanceWorkProjectTitle2 = workProjectTitle2;
				workDetailsArray[i].btProjectGallery.instanceWorkProjectTitle3 = workProjectTitle3;
				//	
				workDetailsArray[i].btProjectGallery.buttonMode = true;
				workDetailsArray[i].btProjectGallery.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
				workDetailsArray[i].btProjectGallery.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
				workDetailsArray[i].btProjectGallery.addEventListener (MouseEvent.CLICK, btOpenProjectGallery);
				//
				workContent.btBack.buttonMode = true;
				workContent.btBack.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
				workContent.btBack.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
				workContent.btBack.addEventListener (MouseEvent.CLICK, btBackToWorkContentClick);
				//
				projectListArray[i].bt.instanceID = i;
				//
				projectListArray[i].bt.buttonMode = true;
				projectListArray[i].bt.addEventListener (MouseEvent.MOUSE_OVER, btWorkItemOver);
				projectListArray[i].bt.addEventListener (MouseEvent.MOUSE_OUT, btWorkItemOut);
				projectListArray[i].bt.addEventListener (MouseEvent.CLICK, btWorkItemClick);
				//
				projectListArray[i].btMoreInfo.instanceID = i;
				projectListArray[i].btMoreInfo.buttonMode = true;
				projectListArray[i].btMoreInfo.gotoAndStop (1);
				projectListArray[i].btMoreInfo.addEventListener (MouseEvent.MOUSE_OVER, btMoreInfoOver);
				projectListArray[i].btMoreInfo.addEventListener (MouseEvent.MOUSE_OUT, btMoreInfoOut);
				projectListArray[i].btMoreInfo.addEventListener (MouseEvent.CLICK, btMoreInfoClick);
			}
			
			if (ourWorkXmlTotalItems > 3) {
				if (ourWorkXmlTotalItems < 100) {
					if (ourWorkXmlTotalItems < 10) {
						myTotalItemsNr = "00" + ourWorkXmlTotalItems;
					}
					else {
						myTotalItemsNr = "0" + ourWorkXmlTotalItems;
					}
					workContent.ourWork.previewMode.navBts.pictureNumberTxt.txt.text = "001 of " + myTotalItemsNr;
				}
				else {
					workContent.ourWork.previewMode.navBts.pictureNumberTxt.txt.text = "001 of " + ourWorkXmlTotalItems;
				}
				//
				workContent.ourWork.previewMode.navScroller.visible = true;
				workContent.ourWork.previewMode.navBts.visible = true;
				//
				workContent.ourWork.previewMode.navScroller.scrollSlider.buttonMode = true;
				workContent.ourWork.previewMode.navScroller.scrollBar.buttonMode = true;
				workContent.ourWork.previewMode.navScroller.scrollBar.addEventListener (MouseEvent.CLICK, scrollBarClick);
				//
				workContent.ourWork.previewMode.navBts.btBack.buttonMode = true;
				workContent.ourWork.previewMode.navBts.btBack.addEventListener (MouseEvent.MOUSE_OVER, workBtBackOver);
				workContent.ourWork.previewMode.navBts.btBack.addEventListener (MouseEvent.MOUSE_OUT, workBtBackOut);
				workContent.ourWork.previewMode.navBts.btBack.addEventListener (MouseEvent.CLICK, workBtBackClick);
				//
				workContent.ourWork.previewMode.navBts.btNext.buttonMode = true;
				workContent.ourWork.previewMode.navBts.btNext.addEventListener (MouseEvent.MOUSE_OVER, workBtNextOver);
				workContent.ourWork.previewMode.navBts.btNext.addEventListener (MouseEvent.MOUSE_OUT, workBtNextOut);
				workContent.ourWork.previewMode.navBts.btNext.addEventListener (MouseEvent.CLICK, workBtNextClick);
				//
				activateWorkScroll ();
			}
			else {
				workContent.ourWork.previewMode.navScroller.visible = false;
				workContent.ourWork.previewMode.navBts.visible = false;
			}
			//
			if(deepLinkZone == "work"){
				setOurWork ("middle");
				setWorkDetails ("right");
				setProjectGallery ("right");
				setFullScreenPlayer ("right");
			}
			//
			if(deepLinkZone == "details"){
				myProjectDetailsID = deepLinkID;
				openProjectDetails ();
			}
			//
			if(deepLinkZone == "gallery"){
				myProjectDetailsID = deepLinkID;
				//
				projectGalleryID = deepLinkID;
				projectGalleryTitle1 = myWorkXML.item.title1[deepLinkID].text();
				projectGalleryTitle2 = myWorkXML.item.title2[deepLinkID].text();
				projectGalleryTitle3 = myWorkXML.item.title3[deepLinkID].text();
				//
				openProjectGallery ();
			}
		}
		//
		private function workThumbLoadProgress (event:ProgressEvent):void {
			//
			var bytesLoadedNum:Number = event.bytesLoaded;
			var bytesTotalNum:Number = event.bytesTotal;
			//
			for (var a in thumbLoader) {
				//
				var percent:Number = 0;
				var loaded:Number = 0;
				var total:Number = 0;
				//
				loaded += thumbLoader[a].contentLoaderInfo.bytesLoaded;
				total += thumbLoader[a].contentLoaderInfo.bytesTotal;
				//
				percent = loaded / total;
				//
				if (loaded > 0) {
					projectListArray[a].preLoader.percentTxt.txt.text = "LOADING " + Math.floor(100 * percent) + "%";
					projectListArray[a].preLoader.percentTxt.txt.autoSize = TextFieldAutoSize.LEFT;
					if (loaded == total) {
						TweenMax.to (projectListArray[a].preLoader, 0.5, {alpha:0, ease:Expo.easeOut});
						TweenMax.to (projectListArray[a].picture.attach, 1, {alpha:1, ease:Expo.easeOut});
					}
				}
			}
		}
		//
		private function workThumbLoadComplete (event:Event):void {
			var workThumbNewSize = event.target.content;
			//
			workThumbNewSize.width = 290;
			workThumbNewSize.height = 190;
			workThumbNewSize.smoothing = true;
		}
		//
		private function scrollBarClick (event:MouseEvent) {
			if (event.currentTarget.mouseX > workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width) {
				workContent.ourWork.previewMode.navScroller.scrollSlider.x = workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width;
			}
			else {
				workContent.ourWork.previewMode.navScroller.scrollSlider.x = event.currentTarget.mouseX;
			}
		}
		//
		private function projectGalleryScrollBarClick (event:MouseEvent) {
			if (event.currentTarget.mouseX > workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width) {
				workContent.projectGallery.navScroller.scrollSlider.x = workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width;
			}
			else {
				workContent.projectGallery.navScroller.scrollSlider.x = event.currentTarget.mouseX;
			}
		}
		//
		private function enterFrameWorkScroll (event:Event) {
			numX = (workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width) / (ourWorkXmlTotalItems - 1);
			numItems = Math.floor((workContent.ourWork.previewMode.navScroller.scrollSlider.x * ourWorkXmlTotalItems) / (workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width));
			TweenMax.to (workContent.ourWork.previewMode.attachItems, 0.5, {x:0 - (320 * numItems), ease:Expo.easeOut});
			//
			if (workContent.ourWork.previewMode.navScroller.scrollSlider.x > 0) {
				workContent.ourWork.previewMode.navBts.btBack.buttonMode = true;
				workContent.ourWork.previewMode.navBts.btBack.addEventListener (MouseEvent.MOUSE_OVER, workBtBackOver);
				workContent.ourWork.previewMode.navBts.btBack.addEventListener (MouseEvent.MOUSE_OUT, workBtBackOut);
				workContent.ourWork.previewMode.navBts.btBack.addEventListener (MouseEvent.CLICK, workBtBackClick);
				workContent.ourWork.previewMode.navBts.btBack.alpha = 1;
			}
			else {
				workContent.ourWork.previewMode.navBts.btBack.buttonMode = false;
				workContent.ourWork.previewMode.navBts.btBack.removeEventListener (MouseEvent.MOUSE_OVER, workBtBackOver);
				workContent.ourWork.previewMode.navBts.btBack.removeEventListener (MouseEvent.MOUSE_OUT, workBtBackOut);
				workContent.ourWork.previewMode.navBts.btBack.removeEventListener (MouseEvent.CLICK, workBtBackClick);
				workContent.ourWork.previewMode.navBts.btBack.alpha = 0.2;
				workContent.ourWork.previewMode.navBts.btBack.gotoAndStop (1);
				workContent.ourWork.previewMode.navScroller.scrollSlider.x = 0;
				TweenMax.to (workContent.ourWork.previewMode.attachItems, 0.5, {x:0, ease:Expo.easeOut});
			}
			//
			if (workContent.ourWork.previewMode.navScroller.scrollSlider.x >= (workContent.ourWork.previewMode.navScroller.scrollBar.back.width - (workContent.ourWork.previewMode.navScroller.scrollSlider.width + 2))) {
				workContent.ourWork.previewMode.navScroller.scrollSlider.x = (workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width);
				//
				workContent.ourWork.previewMode.navBts.btNext.buttonMode = false;
				workContent.ourWork.previewMode.navBts.btNext.removeEventListener (MouseEvent.MOUSE_OVER, workBtNextOver);
				workContent.ourWork.previewMode.navBts.btNext.removeEventListener (MouseEvent.MOUSE_OUT, workBtNextOut);
				workContent.ourWork.previewMode.navBts.btNext.removeEventListener (MouseEvent.CLICK, workBtNextClick);
				workContent.ourWork.previewMode.navBts.btNext.alpha = 0.2;
				workContent.ourWork.previewMode.navBts.btNext.gotoAndStop (1);
			}
			else {
				workContent.ourWork.previewMode.navBts.btNext.buttonMode = true;
				workContent.ourWork.previewMode.navBts.btNext.addEventListener (MouseEvent.MOUSE_OVER, workBtNextOver);
				workContent.ourWork.previewMode.navBts.btNext.addEventListener (MouseEvent.MOUSE_OUT, workBtNextOut);
				workContent.ourWork.previewMode.navBts.btNext.addEventListener (MouseEvent.CLICK, workBtNextClick);
				workContent.ourWork.previewMode.navBts.btNext.alpha = 1;
			}
			//
			if (numItems == ourWorkXmlTotalItems) {
				TweenMax.to (workContent.ourWork.previewMode.attachItems, 0.5, {x:0 - (workContent.ourWork.previewMode.attachItems.width - 300), ease:Expo.easeOut});
			}
			//
			if (numItems + 1 <= ourWorkXmlTotalItems) {
				myCurrentItemNr = "" + int(numItems+1);
			}
			else {
				myCurrentItemNr = "" + ourWorkXmlTotalItems;
			}
			if (numItems + 1 < 100) {
				if (numItems + 1 < 10) {
					myCurrentItemNr = "00" + myCurrentItemNr;
				}
				else {
					myCurrentItemNr = "0" + myCurrentItemNr;
				}
			}
			//
			if (ourWorkXmlTotalItems < 100) {
				if (ourWorkXmlTotalItems < 10) {
					myTotalItemsNr = "00" + ourWorkXmlTotalItems;
				}
				else {
					myTotalItemsNr = "0" + ourWorkXmlTotalItems;
				}
				workContent.ourWork.previewMode.navBts.pictureNumberTxt.txt.text = myCurrentItemNr + " of " + myTotalItemsNr;
			}
			else {
				workContent.ourWork.previewMode.navBts.pictureNumberTxt.txt.text = myCurrentItemNr + " of " + ourWorkXmlTotalItems;
			}
		}
		//
		private function enterFrameProjectGalleryScroll (event:Event) {
			//
			projectGalleryNumX = (workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width) / (projectGalleryTotalItems - 1);
			numItemsProjectGallery = Math.floor((workContent.projectGallery.navScroller.scrollSlider.x * projectGalleryTotalItems) / (workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width));
			TweenMax.to (workContent.projectGallery.attachItems, 0.5, {x:0 - (390 * numItemsProjectGallery), ease:Expo.easeOut});
			//
			if (workContent.projectGallery.navScroller.scrollSlider.x > 0) {
				workContent.projectGallery.navBts.btBack.buttonMode = true;
				workContent.projectGallery.navBts.btBack.addEventListener (MouseEvent.MOUSE_OVER, workBtBackOver);
				workContent.projectGallery.navBts.btBack.addEventListener (MouseEvent.MOUSE_OUT, workBtBackOut);
				workContent.projectGallery.navBts.btBack.addEventListener (MouseEvent.CLICK, projectGalleryBtBackClick);
				workContent.projectGallery.navBts.btBack.alpha = 1;
			}
			else {
				workContent.projectGallery.navBts.btBack.buttonMode = false;
				workContent.projectGallery.navBts.btBack.removeEventListener (MouseEvent.MOUSE_OVER, workBtBackOver);
				workContent.projectGallery.navBts.btBack.removeEventListener (MouseEvent.MOUSE_OUT, workBtBackOut);
				workContent.projectGallery.navBts.btBack.removeEventListener (MouseEvent.CLICK, projectGalleryBtBackClick);
				workContent.projectGallery.navBts.btBack.alpha = 0.2;
				workContent.projectGallery.navBts.btBack.gotoAndStop (1);
				workContent.projectGallery.navScroller.scrollSlider.x = 0;
				TweenMax.to (workContent.projectGallery.attachItems, 0.5, {x:0, ease:Expo.easeOut});
			}
			//
			if (workContent.projectGallery.navScroller.scrollSlider.x >= (workContent.projectGallery.navScroller.scrollBar.back.width - (workContent.projectGallery.navScroller.scrollSlider.width + 2))) {
				workContent.projectGallery.navScroller.scrollSlider.x = (workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width);
				//
				workContent.projectGallery.navBts.btNext.buttonMode = false;
				workContent.projectGallery.navBts.btNext.removeEventListener (MouseEvent.MOUSE_OVER, workBtNextOver);
				workContent.projectGallery.navBts.btNext.removeEventListener (MouseEvent.MOUSE_OUT, workBtNextOut);
				workContent.projectGallery.navBts.btNext.removeEventListener (MouseEvent.CLICK, projectGalleryBtNextClick);
				workContent.projectGallery.navBts.btNext.alpha = 0.2;
				workContent.projectGallery.navBts.btNext.gotoAndStop (1);
			}
			else {
				workContent.projectGallery.navBts.btNext.buttonMode = true;
				workContent.projectGallery.navBts.btNext.addEventListener (MouseEvent.MOUSE_OVER, workBtNextOver);
				workContent.projectGallery.navBts.btNext.addEventListener (MouseEvent.MOUSE_OUT, workBtNextOut);
				workContent.projectGallery.navBts.btNext.addEventListener (MouseEvent.CLICK, projectGalleryBtNextClick);
				workContent.projectGallery.navBts.btNext.alpha = 1;
			}
			//
			if (numItemsProjectGallery == projectGalleryTotalItems) {
				TweenMax.to (workContent.projectGallery.attachItems, 0.5, {x:0 - (workContent.projectGallery.attachItems.width - 375), ease:Expo.easeOut});
			}
			//
			if (numItemsProjectGallery + 1 <= projectGalleryTotalItems) {
				myCurrentItemNr = "" + int(numItemsProjectGallery+1);
			}
			else {
				myCurrentItemNr = "" + projectGalleryTotalItems;
			}
			if (numItemsProjectGallery + 1 < 100) {
				if (numItemsProjectGallery + 1 < 10) {
					myCurrentItemNr = "00" + myCurrentItemNr;
				}
				else {
					myCurrentItemNr = "0" + myCurrentItemNr;
				}
			}
			//
			if (projectGalleryTotalItems < 100) {
				if (projectGalleryTotalItems < 10) {
					myTotalItemsNr = "00" + projectGalleryTotalItems;
				}
				else {
					myTotalItemsNr = "0" + projectGalleryTotalItems;
				}
				workContent.projectGallery.navBts.pictureNumberTxt.txt.text = myCurrentItemNr + " of " + myTotalItemsNr;
			}
			else {
				workContent.projectGallery.navBts.pictureNumberTxt.txt.text = myCurrentItemNr + " of " + projectGalleryTotalItems;
			}
		}
		//
		private function activateProjectGalleryScroll () {
			rectangleProjectGalleryAvailable = true;
			rectangleDragProjectGallery = new Rectangle(0,0,workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width,0);
			workContent.projectGallery.navScroller.scrollSlider.addEventListener (MouseEvent.MOUSE_DOWN, scrollSliderProjectGalleryDown);
			stage.addEventListener (Event.ENTER_FRAME, enterFrameProjectGalleryScroll);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener2);
		}
		//
		private function desactivateProjectGalleryScroll () {
			rectangleProjectGalleryAvailable = false;
			workContent.projectGallery.navScroller.scrollSlider.removeEventListener (MouseEvent.MOUSE_DOWN, scrollSliderProjectGalleryDown);
			stage.removeEventListener (Event.ENTER_FRAME, enterFrameProjectGalleryScroll);
			//workContent.projectGallery.navScroller.scrollSlider.x = 0;
			//workContent.projectGallery.attachItems.x = 0;
		}
		//
		private function activateWorkScroll () {
			rectangleWorkAvailable = true;
			rectangleDragWork = new Rectangle(0,0,workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width,0);
			workContent.ourWork.previewMode.navScroller.scrollSlider.addEventListener (MouseEvent.MOUSE_DOWN, scrollSliderWorkDown);
			stage.addEventListener (Event.ENTER_FRAME, enterFrameWorkScroll);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
		}
		//
		private function desactivateWorkScroll () {
			workContent.ourWork.previewMode.navScroller.scrollSlider.removeEventListener (MouseEvent.MOUSE_DOWN, scrollSliderWorkDown);
			stage.removeEventListener (Event.ENTER_FRAME, enterFrameWorkScroll);
			workContent.ourWork.previewMode.navScroller.scrollSlider.x = 0;
			workContent.ourWork.previewMode.attachItems.x = 0;
		}
		//
		private function scrollSliderWorkDown (event:MouseEvent) {
			stage.addEventListener (MouseEvent.MOUSE_UP,scrollSliderWorkUp);
			workContent.ourWork.previewMode.navScroller.scrollSlider.startDrag (false,rectangleDragWork);
		}
		//
		private function scrollSliderProjectGalleryDown (event:MouseEvent) {
			stage.addEventListener (MouseEvent.MOUSE_UP,scrollSliderProjectGalleryUp);
			workContent.projectGallery.navScroller.scrollSlider.startDrag (false,rectangleDragProjectGallery);
		}
		//
		private function scrollSliderWorkUp (event:MouseEvent) {
			stage.removeEventListener (MouseEvent.MOUSE_UP,scrollSliderWorkUp);
			workContent.ourWork.previewMode.navScroller.scrollSlider.stopDrag ();
			workContent.ourWork.previewMode.navScroller.scrollSlider.x = (numItems * (workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width)) / (ourWorkXmlTotalItems - 1);
		}
		//
		private function scrollSliderProjectGalleryUp (event:MouseEvent) {
			stage.removeEventListener (MouseEvent.MOUSE_UP,scrollSliderProjectGalleryUp);
			workContent.projectGallery.navScroller.scrollSlider.stopDrag ();
			workContent.projectGallery.navScroller.scrollSlider.x = (numItemsProjectGallery * (workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width)) / (projectGalleryTotalItems - 1);
		}
		//Scroll Wheel
		private function mouseWheelListener(event:MouseEvent):void {
			//numX = (workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width) / (ourWorkXmlTotalItems - 1);
			//stage.addEventListener(Event.ENTER_FRAME, enterFrameScroll);
			var d:Number = event.delta;
			if (d > 0) {
                if (workContent.ourWork.previewMode.navScroller.scrollSlider.x > 0){
					workContent.ourWork.previewMode.navScroller.scrollSlider.x = (workContent.ourWork.previewMode.navScroller.scrollSlider.x - numX);
				} else {
					workContent.ourWork.previewMode.navScroller.scrollSlider.x = 0;
				}
			} else {
				if (((workContent.ourWork.previewMode.navScroller.scrollSlider.x + workContent.ourWork.previewMode.navScroller.scrollSlider.width)) < workContent.ourWork.previewMode.navScroller.scrollBar.back.width){
					workContent.ourWork.previewMode.navScroller.scrollSlider.x = (workContent.ourWork.previewMode.navScroller.scrollSlider.x + numX);
				} else {
					workContent.ourWork.previewMode.navScroller.scrollSlider.x = workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width
				}
			}
        }
		//
		private function mouseWheelListener2(event:MouseEvent):void {
			var d:Number = event.delta;
			if (d > 0) {
        		if (workContent.projectGallery.navScroller.scrollSlider.x > 0){
					workContent.projectGallery.navScroller.scrollSlider.x = workContent.projectGallery.navScroller.scrollSlider.x - projectGalleryNumX;
				} else {
					workContent.projectGallery.navScroller.scrollSlider.x = 0;
				}
			} else {
				if ((workContent.projectGallery.navScroller.scrollSlider.x + workContent.projectGallery.navScroller.scrollSlider.width) < workContent.projectGallery.navScroller.scrollBar.back.width){
					workContent.projectGallery.navScroller.scrollSlider.x = workContent.projectGallery.navScroller.scrollSlider.x + projectGalleryNumX;
				} else {
					workContent.projectGallery.navScroller.scrollSlider.x = workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width
				}
			}
        }
		//
		private function workBtBackOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function workBtBackOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function workBtBackClick (event:MouseEvent) {
			workContent.ourWork.previewMode.navScroller.scrollSlider.x = workContent.ourWork.previewMode.navScroller.scrollSlider.x - numX;
		}
		//
		private function projectGalleryBtBackClick (event:MouseEvent) {
			workContent.projectGallery.navScroller.scrollSlider.x = workContent.projectGallery.navScroller.scrollSlider.x - projectGalleryNumX;
		}
		//
		private function workBtNextOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function workBtNextOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function workBtNextClick (event:MouseEvent) {
			workContent.ourWork.previewMode.navScroller.scrollSlider.x = workContent.ourWork.previewMode.navScroller.scrollSlider.x + numX;
		}
		//
		private function projectGalleryBtNextClick (event:MouseEvent) {
			workContent.projectGallery.navScroller.scrollSlider.x = workContent.projectGallery.navScroller.scrollSlider.x + projectGalleryNumX;
		}
		//
		private function btWorkItemOver (event:MouseEvent) {
			TweenMax.to (event.currentTarget.parent.backWhite, 0.2, {alpha:1, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.parent.back, 0.2, {alpha:0, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.parent.titleTxt, 0.2, {tint:0x262D26, ease:Cubic.easeOut});
		}
		//
		private function btWorkItemOut (event:MouseEvent) {
			TweenMax.to (event.currentTarget.parent.backWhite, 0.2, {alpha:0, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.parent.back, 0.2, {alpha:1, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.parent.titleTxt, 0.2, {tint:0xFFFFFF, ease:Cubic.easeOut});
		}
		//
		private function btWorkItemClick (event:MouseEvent) {
			myProjectDetailsID = event.currentTarget.instanceID;
			openProjectDetails ();
			//
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
		}
		//
		private function btOpenUrlOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function btOpenUrlOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function btOpenUrlClick (event:MouseEvent) {
			var rURL:URLRequest = new URLRequest(event.currentTarget.instanceUrl);
			navigateToURL (rURL, '_blank');
		}
		//
		private function btMoreInfoOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function btMoreInfoOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function btMoreInfoClick (event:MouseEvent) {
			myProjectDetailsID = event.currentTarget.instanceID;
			openProjectDetails ();
			//
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
		}
		//
		private function btOpenProjectGallery (event:MouseEvent) {
			projectGalleryID = event.currentTarget.instanceID;
			projectGalleryTitle1 = event.currentTarget.instanceWorkProjectTitle1;
			projectGalleryTitle2 = event.currentTarget.instanceWorkProjectTitle2;
			projectGalleryTitle3 = event.currentTarget.instanceWorkProjectTitle3;
			//
			openProjectGallery ();
		}
		//
		public function openProjectDetails () {
			//
			Gaia.api.goto ("index/nav/work/details/"+myProjectDetailsID);
			var currentDeeplink:String = Gaia.api.getDeeplink();
			onDeeplink (new GaiaSWFAddressEvent(GaiaSWFAddressEvent.DEEPLINK, false, false, currentDeeplink));
			//
			setProjectDetailsItemPositions ();
			//
			if (myProjectDetailsID == 0) {
				workContent.workDetails.navBts.btBack.visible = false;
				workContent.workDetails.navBts.btNext.visible = true;
			}
			else {
				if (myProjectDetailsID == ourWorkXmlTotalItems - 1) {
					workContent.workDetails.navBts.btBack.visible = true;
					workContent.workDetails.navBts.btNext.visible = false;
				}
				else {
					workContent.workDetails.navBts.btBack.visible = true;
					workContent.workDetails.navBts.btNext.visible = true;
				}
			}
			//
			workContent.workDetails.navBts.btNext.buttonMode = true;
			workContent.workDetails.navBts.btNext.addEventListener (MouseEvent.MOUSE_OVER, workDetailsBtNavOver);
			workContent.workDetails.navBts.btNext.addEventListener (MouseEvent.MOUSE_OUT, workDetailsBtNavOut);
			workContent.workDetails.navBts.btNext.addEventListener (MouseEvent.CLICK, workDetailsBtNextClick);
			//
			workContent.workDetails.navBts.btBack.buttonMode = true;
			workContent.workDetails.navBts.btBack.addEventListener (MouseEvent.MOUSE_OVER, workDetailsBtNavOver);
			workContent.workDetails.navBts.btBack.addEventListener (MouseEvent.MOUSE_OUT, workDetailsBtNavOut);
			workContent.workDetails.navBts.btBack.addEventListener (MouseEvent.CLICK, workDetailsBtBackClick);
			//
			setOurWork ("left");
			setWorkDetails ("middle");
			setProjectGallery ("right");
			setFullScreenPlayer ("right");
		}
		//
		private function openProjectGallery () {
			//
			Gaia.api.goto ("index/nav/work/details/gallery/"+projectGalleryID);
			var currentDeeplink:String = Gaia.api.getDeeplink();
			onDeeplink (new GaiaSWFAddressEvent(GaiaSWFAddressEvent.DEEPLINK, false, false, currentDeeplink));
			//
			projectGalleryIsOnProgress = false;
			//
			workContent.projectGallery.topTitleTxt.titleTxt1.txt.text = projectGalleryTitle1;
			workContent.projectGallery.topTitleTxt.titleTxt1.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.projectGallery.topTitleTxt.titleTxt2.txt.text = projectGalleryTitle2;
			workContent.projectGallery.topTitleTxt.titleTxt2.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.projectGallery.topTitleTxt.titleTxt3.txt.text = projectGalleryTitle3;
			workContent.projectGallery.topTitleTxt.titleTxt3.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.projectGallery.topTitleTxt.y = -90;
			//
			if (projectGalleryTitle2 != "") {
				//
				workContent.projectGallery.topTitleTxt.titleTxt2.y = 40;
				workContent.projectGallery.topTitleTxt.y = -130;
				//
				if (projectGalleryTitle3 != "") {
					workContent.projectGallery.topTitleTxt.titleTxt3.y = 80;
					workContent.projectGallery.topTitleTxt.y = -170;
				}
			}
			//
			var myWorkXML:XML = IXml(assets.workXml).xml;
			//
			projectGalleryTotalItems = myWorkXML.item[projectGalleryID].gallery.item.length();
			//
			projectGalleryArray = [];
			//
			//trace("projectGalleryID "+projectGalleryID)
			//trace("tempProjID "+tempProjID)
			//
			if(projectGalleryID != tempProjID){
				workContent.projectGallery.navScroller.scrollSlider.x = 0
				workContent.projectGallery.attachItems.x = 0;
			}
			//
			tempProjID = projectGalleryID;
			//
			for (a = 0; a < projectGalleryTotalItems; a++) {
				projectGalleryItem = new projectGalleryItemAttach;
				//
				projectGalleryItemTitle = myWorkXML.item[projectGalleryID].gallery.item.title[a].text();
				projectGalleryItemDescription = myWorkXML.item[projectGalleryID].gallery.item.description[a].text();
				projectGalleryItemThumbnail = myWorkXML.item[projectGalleryID].gallery.item.thumbnail[a].text();
				projectGalleryItemType = myWorkXML.item[projectGalleryID].gallery.item.largeView[a].attribute("type");
				projectGalleryItemFile = myWorkXML.item[projectGalleryID].gallery.item.largeView[a].attribute("file");
				
/////////////// ADDED BY FRED				
				projectGalleryItemLink = myWorkXML.item[projectGalleryID].gallery.item.largeView[a].attribute("link");
/////////////// END ADDED BU FRED				
				
				//
				projectGalleryArray.push (projectGalleryItem);
				//
				projectGalleryArray[a].videoBox.visible = false;
				projectGalleryArray[a].videoConsole.visible = false;
				//
				projectGalleryArray[a].titleTxt.txt.htmlText = projectGalleryItemTitle;
				projectGalleryArray[a].descTxt.txt.htmlText = projectGalleryItemDescription;
				//
				workContent.projectGallery.attachItems.addChild (projectGalleryItem);
				//
				projectGalleryArray[a].alpha = 0;
				projectGalleryArray[a].x = 390 * a;
				TweenMax.to (projectGalleryArray[a], 0.5, {alpha:1, ease:Expo.easeOut, delay:a * 0.2});
				//
				projectGalleryArray[a].btOpenFullScreen.alpha = 0;
				//
				projectGalleryIsOnProgress = true;
				//
				projectGalleryThumbLoader[a] = new Loader();
				projectGalleryThumbLoader[a].load (new URLRequest(projectGalleryItemThumbnail));
				projectGalleryThumbLoader[a].contentLoaderInfo.addEventListener (Event.COMPLETE, projectGalleryThumbLoadComplete, false, 0, true);
				projectGalleryThumbLoader[a].contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, projectGalleryLoadProgress);
				//
				TweenMax.to (projectGalleryArray[a].preLoader, 0.5, {alpha:1, ease:Expo.easeOut});
				//
				projectGalleryArray[a].picture.attach.alpha = 0;
				projectGalleryArray[a].picture.attach.addChild (projectGalleryThumbLoader[a]);
				//
				if (projectGalleryItemType == "video") {
					//
					projectGalleryArray[a].instanceProjectGalleryItemID = a;
					projectGalleryArray[a].instanceProjectGalleryItemType = projectGalleryItemType;
					projectGalleryArray[a].instanceProjectGalleryItemFile = projectGalleryItemFile;
					projectGalleryArray[a].instanceProjectGalleryItemTitle = projectGalleryItemTitle;
					projectGalleryArray[a].instanceProjectGalleryItemDescription = projectGalleryItemDescription;
					//
					projectGalleryArray[a].instanceVideoFile = projectGalleryItemFile;
					//
					projectGalleryArray[a].addEventListener (MouseEvent.MOUSE_OVER, projectGalleryItemOver);
					projectGalleryArray[a].addEventListener (MouseEvent.MOUSE_OUT, projectGalleryItemOut);
					//
					projectGalleryArray[a].btOpenFullScreen.visible = false;
					//
					projectGalleryArray[a].videoBox.alpha = 0;
					projectGalleryArray[a].videoBox.visible = true;
					projectGalleryArray[a].videoConsole.visible = true;
					//
					projectGalleryArray[a].videoConsole.btPlay.instanceProjectGalleryItemID = a;
					projectGalleryArray[a].videoConsole.btPlay.instanceVideoFile = projectGalleryItemFile;
					projectGalleryArray[a].videoConsole.btPlay.instanceProjectGalleryItemTitle = projectGalleryItemTitle;
					projectGalleryArray[a].videoConsole.btPlay.instanceProjectGalleryItemDescription = projectGalleryItemDescription;
					//
					projectGalleryArray[a].videoConsole.btPlay.visible = true;
					projectGalleryArray[a].videoConsole.btPause.visible = false;
					//
					projectGalleryArray[a].videoConsole.btPlay.buttonMode = true;
					projectGalleryArray[a].videoConsole.btPlay.addEventListener (MouseEvent.MOUSE_OVER, projectGalleryVideoPlayOver);
					projectGalleryArray[a].videoConsole.btPlay.addEventListener (MouseEvent.MOUSE_OUT, projectGalleryVideoPlayOut);
					projectGalleryArray[a].videoConsole.btPlay.addEventListener (MouseEvent.CLICK, projectGalleryVideoPlayClick);
					//
					projectGalleryArray[a].videoConsole.btPause.buttonMode = true;
					projectGalleryArray[a].videoConsole.btPause.addEventListener (MouseEvent.MOUSE_OVER, projectGalleryVideoPauseOver);
					projectGalleryArray[a].videoConsole.btPause.addEventListener (MouseEvent.MOUSE_OUT, projectGalleryVideoPauseOut);
					projectGalleryArray[a].videoConsole.btPause.addEventListener (MouseEvent.CLICK, projectGalleryVideoPauseClick);
					//
					projectGalleryArray[a].videoConsole.btFullScreen.instanceProjectGalleryItemID = a;
					projectGalleryArray[a].videoConsole.btFullScreen.instanceProjectGalleryItemType = projectGalleryItemType;
					projectGalleryArray[a].videoConsole.btFullScreen.instanceProjectGalleryItemFile = projectGalleryItemFile;
					projectGalleryArray[a].videoConsole.btFullScreen.instanceProjectGalleryItemTitle = projectGalleryItemTitle;
					projectGalleryArray[a].videoConsole.btFullScreen.instanceProjectGalleryItemDescription = projectGalleryItemDescription;
					//
					projectGalleryArray[a].videoConsole.btFullScreen.buttonMode = true;
					projectGalleryArray[a].videoConsole.btFullScreen.gotoAndStop (1);
					projectGalleryArray[a].videoConsole.btFullScreen.addEventListener (MouseEvent.MOUSE_OVER, btFullScreenOver);
					projectGalleryArray[a].videoConsole.btFullScreen.addEventListener (MouseEvent.MOUSE_OUT, btFullScreenOut);
					projectGalleryArray[a].videoConsole.btFullScreen.addEventListener (MouseEvent.CLICK, btFullScreenClick);
				}
				else {
					projectGalleryArray[a].instanceProjectGalleryItemID = a;
					projectGalleryArray[a].instanceProjectGalleryItemType = projectGalleryItemType;
					projectGalleryArray[a].instanceProjectGalleryItemFile = projectGalleryItemFile;
/////////////////// ADDED BY FRED					
					projectGalleryArray[a].instanceProjectGalleryItemLink = projectGalleryItemLink;
////////////////// END ADDED BY FRED					
					projectGalleryArray[a].instanceProjectGalleryItemTitle = projectGalleryItemTitle;
					projectGalleryArray[a].instanceProjectGalleryItemDescription = projectGalleryItemDescription;
					//
					projectGalleryArray[a].buttonMode = true;
					projectGalleryArray[a].addEventListener (MouseEvent.MOUSE_OVER, projectGalleryItemOver);
					projectGalleryArray[a].addEventListener (MouseEvent.MOUSE_OUT, projectGalleryItemOut);
					projectGalleryArray[a].addEventListener (MouseEvent.CLICK, btFullScreenClick);
				}
			}
			
			//
			if (projectGalleryTotalItems > 2) {
				if (projectGalleryTotalItems < 100) {
					if (projectGalleryTotalItems < 10) {
						myTotalItemsNr = "00" + projectGalleryTotalItems;
					}
					else {
						myTotalItemsNr = "0" + projectGalleryTotalItems;
					}
					workContent.projectGallery.navBts.pictureNumberTxt.txt.text = "001 of " + myTotalItemsNr;
				}
				else {
					workContent.projectGallery.navBts.pictureNumberTxt.txt.text = "001 of " + ourWorkXmlTotalItems;
				}
				//
				workContent.projectGallery.navScroller.visible = true;
				workContent.projectGallery.navBts.visible = true;
				//
				workContent.projectGallery.navScroller.scrollSlider.buttonMode = true;
				workContent.projectGallery.navScroller.scrollBar.buttonMode = true;
				workContent.projectGallery.navScroller.scrollBar.addEventListener (MouseEvent.CLICK, projectGalleryScrollBarClick);
				//
				workContent.projectGallery.navBts.btBack.buttonMode = true;
				workContent.projectGallery.navBts.btBack.addEventListener (MouseEvent.MOUSE_OVER, workBtBackOver);
				workContent.projectGallery.navBts.btBack.addEventListener (MouseEvent.MOUSE_OUT, workBtBackOut);
				workContent.projectGallery.navBts.btBack.addEventListener (MouseEvent.CLICK, projectGalleryBtBackClick);
				//
				workContent.projectGallery.navBts.btNext.buttonMode = true;
				workContent.projectGallery.navBts.btNext.addEventListener (MouseEvent.MOUSE_OVER, workBtNextOver);
				workContent.projectGallery.navBts.btNext.addEventListener (MouseEvent.MOUSE_OUT, workBtNextOut);
				workContent.projectGallery.navBts.btNext.addEventListener (MouseEvent.CLICK, projectGalleryBtNextClick);
				//
				activateProjectGalleryScroll ();
			}
			else {
				workContent.projectGallery.navScroller.visible = false;
				workContent.projectGallery.navBts.visible = false;
			}
			//
			workContent.btBack2.buttonMode = true;
			workContent.btBack2.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
			workContent.btBack2.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
			workContent.btBack2.addEventListener (MouseEvent.CLICK, btBack2Click);
			//
			setOurWork ("left");
			setWorkDetails ("left");
			setProjectGallery ("middle");
			setFullScreenPlayer ("right");
		}
		//
		private function projectGalleryVideoPlayOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function projectGalleryVideoPlayOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function projectGalleryVideoPlayClick (event:MouseEvent) { 
			//
			projectGalleryArray[event.currentTarget.instanceProjectGalleryItemID].videoConsole.btPlay.visible = false;
			projectGalleryArray[event.currentTarget.instanceProjectGalleryItemID].videoConsole.btPause.visible = true;
			//
			if (projectGalleryPlayVideoFirstTime == false) {
				//
				myTempVideoID = event.currentTarget.instanceProjectGalleryItemID;
				//
				myProjectGalleryItemID = event.currentTarget.instanceProjectGalleryItemID;
				myProjectGalleryVideoItemFile = event.currentTarget.instanceVideoFile;
				//
				projectGalleryArray[myProjectGalleryItemID].videoBox.alpha = 0;
				//
				addProjectGalleryVideoPlayer ();
			}
			else {
				if (event.currentTarget.instanceProjectGalleryItemID == myTempVideoID) {
					stream.resume ();
				}
				else {
					closeProjectGalleryVideo ();
					//
					myProjectGalleryItemID = event.currentTarget.instanceProjectGalleryItemID;
					myProjectGalleryVideoItemFile = event.currentTarget.instanceVideoFile;
					//
					TweenMax.to (projectGalleryArray[myTempVideoID].videoBox, 0.5, {alpha:0, ease:Expo.easeOut, onComplete:addProjectGalleryVideoPlayer});
				}
			}
		}
		//
		private function projectGalleryVideoPauseOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function projectGalleryVideoPauseOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function projectGalleryVideoPauseClick (event:MouseEvent) {
			//
			projectGalleryArray[myProjectGalleryItemID].videoConsole.btPlay.visible = true;
			projectGalleryArray[myProjectGalleryItemID].videoConsole.btPause.visible = false;
			//
			stream.pause ();
		}
		//
		private function closeProjectGalleryVideo () {
			//
			if (projectGalleryVideoPlaying == true) {
				//
				stream.close ();
				stream.removeEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
				stage.removeEventListener (Event.ENTER_FRAME, projectGalleryVideoEnterFrame);
				//
				projectGalleryArray[myTempVideoID].videoConsole.btPlay.visible = true;
				projectGalleryArray[myTempVideoID].videoConsole.btPause.visible = false;
				//
				projectGalleryArray[myTempVideoID].videoConsole.videoScrubber.scrubber.x = 0;
				//
				TweenMax.to (projectGalleryArray[myTempVideoID].videoBox, 0.5, {alpha:0, ease:Expo.easeOut});
				//
				projectGalleryVideoPlaying = false;
				//
				projectGalleryPlayVideoFirstTime = false;
			}
		}
		//
		private function addProjectGalleryVideoPlayer () {
			myTempVideoID = myProjectGalleryItemID;
			//
			projectGalleryPlayVideoFirstTime = true;
			//
			conn = new NetConnection();
			conn.connect (null);
			stream = new NetStream(conn);
			//
			stream.addEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
			//
			stream.play (myProjectGalleryVideoItemFile);
			metaListener.onMetaData = theMeta;
			stream.client = metaListener;
			video.attachNetStream (stream);
			video.width = 365;
			video.height = 230;
			video.x = 0;
			video.y = 0;
			video.smoothing = true;
			//
			projectGalleryArray[myProjectGalleryItemID].videoBox.attachVideo.addChild (video);
			//
			projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.buttonMode = true;
			projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.CLICK, videoToSecond);
			projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.MOUSE_DOWN, videoTrackDown);
			projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.MOUSE_UP, videoTrackUp);
			//
			projectGalleryVideoPlaying = true;
			stage.addEventListener (Event.ENTER_FRAME, projectGalleryVideoEnterFrame);
		}
		//
		private function theMeta (data:Object):void {
			projectGalleryVideoTotalLength = data.duration;
			projectGalleryVideoOriginalWidth = data.width;
			projectGalleryVideoOriginalHeight = data.height;
		}
		//
		private function videoTrackDown (event:MouseEvent):void {
			stage.addEventListener (MouseEvent.MOUSE_MOVE, videoScrubTo);
		}
		//
		private function videoTrackUp (event:MouseEvent):void {
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, videoScrubTo);
		}
		//
		private function videoScrubTo (event:MouseEvent):void {
			if (projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.mouseX < projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.streamingBar.width) {
				var percentAcross:Number = (projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.mouseX) / projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.width;
				stream.seek (projectGalleryVideoTotalLength * percentAcross);
			}
		}
		//
		private function videoToSecond (event:MouseEvent):void {
			if (projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.mouseX < projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.streamingBar.width) {
				var percentAcross:Number = (projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.mouseX) / projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.trackingBar.width;
				stream.seek (projectGalleryVideoTotalLength * percentAcross);
			}
		}
		//
		function projectGalleryVideoEnterFrame (event:Event):void {
			//
			var nowSecs:Number = stream.time;
			var totalSecs:Number = projectGalleryVideoTotalLength;
			//
			if (nowSecs > 0) {
				var amountPlayed:Number = nowSecs / totalSecs;
				var amountLoaded:Number = stream.bytesLoaded / stream.bytesTotal;
				//
				projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.playingBar.width = projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.backBar.width * amountPlayed;
				if (Math.floor(projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.playingBar.width - projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.scrubber.width) < 0) {
					projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.scrubber.x = 0;
				}
				else {
					projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.scrubber.x = Math.floor(projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.playingBar.width - projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.scrubber.width);
				}
				projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.streamingBar.width = projectGalleryArray[myProjectGalleryItemID].videoConsole.videoScrubber.backBar.width * amountLoaded;
			}
		}
		//
		private function netStatusHandler (event:NetStatusEvent):void {
			//
			switch (event.info.code) {
				case "NetStream.Buffer.Empty" :
					trace ("NetStream.Buffer.Empty");
					break;
				case "NetStream.Buffer.Full" :
					trace ("NetStream.Buffer.Full");
					break;
				case "NetStream.Play.Start" :
					trace ("NetStream.Play.Start");
					TweenMax.to (projectGalleryArray[myProjectGalleryItemID].videoBox, 0.5, {alpha:1, ease:Expo.easeOut});
					break;
				case "NetStream.Play.Stop" :
					trace ("NetStream.Play.Stop");
					closeProjectGalleryVideo ();
					break;
			}
		}
		//
		private function btFullScreenOver (event:Event):void {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function btFullScreenOut (event:Event):void {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function btFullScreenClick (event:Event):void {
			//
			myProjectGalleryItemID = event.currentTarget.instanceProjectGalleryItemID;
			myProjectGalleryItemType = event.currentTarget.instanceProjectGalleryItemType;	
			myProjectGalleryItemFile = event.currentTarget.instanceProjectGalleryItemFile;
			
/////////// ADDED BY FRED			
			myProjectGalleryItemLink = event.currentTarget.instanceProjectGalleryItemLink;
/////////// END OF ADDED BY FRED		

			myProjectGalleryItemTitle = event.currentTarget.instanceProjectGalleryItemTitle;
			myProjectGalleryItemDescription = event.currentTarget.instanceProjectGalleryItemDescription;
			//
			if (videoIsFullScreen == false) {
				openFullScreenContent ();
				//videoIsFullScreen = true;
			}
			else {
				closeFullScreenContent ();
				videoIsFullScreen = false;
			}
		}
		//
		private function openFullScreenContent () {
/*			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener2);
			//
			workContent.fullScreenPlayer.player.txtInfo.alpha = 0;
			//
			workContent.fullScreenPlayer.player.txtInfo.titleTxt.txt.htmlText = myProjectGalleryItemTitle;
			workContent.fullScreenPlayer.player.txtInfo.titleTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.fullScreenPlayer.player.txtInfo.descTxt.txt.htmlText = myProjectGalleryItemDescription;
			workContent.fullScreenPlayer.player.txtInfo.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.fullScreenPlayer.player.back.width = 0;
			workContent.fullScreenPlayer.player.back.height = 0;
			//
			workContent.fullScreenPlayer.player.picture.alpha = 0;
			workContent.fullScreenPlayer.player.myVideo.alpha = 0;
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.visible = false;*/
			//
			if (myProjectGalleryItemType == "image") {
				//
				fullScreenImageLoader = new Loader();				
				//
				fullScreenImageRequest = new URLRequest(myProjectGalleryItemFile);
				//
				fullScreenImageLoader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, fullScreenImageProgress);
				fullScreenImageLoader.contentLoaderInfo.addEventListener (Event.COMPLETE,fullScreenImageComplete);
				fullScreenImageLoader.load (fullScreenImageRequest);			
				//
				if (projectGalleryPlayVideoFirstTime == true) {
					closeProjectGalleryVideo ();
				}
				 showFullScreen()
			}
			
///////////// ADDED BY FRED //			
			// loading flash movie with no resize:			
			else if (myProjectGalleryItemType == "flash") 
			{
				trace ("myProjectGalleryItemType == flash")
				//
				fullScreenFlashLoader = new Loader();
				//
				fullScreenImageRequest = new URLRequest(myProjectGalleryItemFile);
				//
				fullScreenFlashLoader.contentLoaderInfo.addEventListener (Event.COMPLETE,fullScreenFlashComplete);
				fullScreenFlashLoader.load (fullScreenImageRequest);			
				//
				if (projectGalleryPlayVideoFirstTime == true) {
					closeProjectGalleryVideo ();
				}
				 showFullScreen()
			}
			
			else if (myProjectGalleryItemType == "url") 
			{
				trace ("myProjectGalleryItemType == url")
				trace ("myProjectGalleryItemLink " + myProjectGalleryItemLink)
				//
				var externalURL:URLRequest = new URLRequest(myProjectGalleryItemLink);
				navigateToURL (externalURL, '_blank');	
				//
				if (projectGalleryPlayVideoFirstTime == true) {
					closeProjectGalleryVideo ();
				}
				
			}	
			
////// END OF ADDED BY FRED //

			else if (myProjectGalleryItemType == "video")  
			{
				trace ("myProjectGalleryItemType == " + myProjectGalleryItemType)
				closeProjectGalleryVideo ();
				loadFullScreenVideo ();
				showFullScreen();
			}
			//
/*			workContent.btBack3.buttonMode = true;
			workContent.btBack3.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
			workContent.btBack3.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
			workContent.btBack3.addEventListener (MouseEvent.CLICK, btBack3Click);
			//
			setOurWork ("left");
			setWorkDetails ("left");
			setProjectGallery ("left");
			setFullScreenPlayer ("middle");*/
		}
		
		function showFullScreen():void
		{
			videoIsFullScreen = true;
			
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener2);
			//
			workContent.fullScreenPlayer.player.txtInfo.alpha = 0;
			//
			workContent.fullScreenPlayer.player.txtInfo.titleTxt.txt.htmlText = myProjectGalleryItemTitle;
			workContent.fullScreenPlayer.player.txtInfo.titleTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.fullScreenPlayer.player.txtInfo.descTxt.txt.htmlText = myProjectGalleryItemDescription;
			workContent.fullScreenPlayer.player.txtInfo.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			workContent.fullScreenPlayer.player.back.width = 0;
			workContent.fullScreenPlayer.player.back.height = 0;
			//
			workContent.fullScreenPlayer.player.picture.alpha = 0;
			workContent.fullScreenPlayer.player.myVideo.alpha = 0;
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.visible = false;
			
			workContent.btBack3.buttonMode = true;
			workContent.btBack3.addEventListener (MouseEvent.MOUSE_OVER, btOpenUrlOver);
			workContent.btBack3.addEventListener (MouseEvent.MOUSE_OUT, btOpenUrlOut);
			workContent.btBack3.addEventListener (MouseEvent.CLICK, btBack3Click);
			//
			setOurWork ("left");
			setWorkDetails ("left");
			setProjectGallery ("left");
			setFullScreenPlayer ("middle");			
			
		}
		
		//
		function fullScreenFlashComplete (event:Event):void {	trace ("fullScreenFlashComplete")
			//
			var myFullScreenPicture = event.target.content;
			//
			workContent.fullScreenPlayer.player.flashAsset.attach.addChild (fullScreenFlashLoader);
			//			
			workContent.fullScreenPlayer.player.flashAsset.attach.x = - Math.floor(event.target.width / 2);			
			workContent.fullScreenPlayer.player.flashAsset.attach.y = - Math.floor(event.target.height/2 +25);
			//
			workContent.fullScreenPlayer.player.back.x = workContent.fullScreenPlayer.player.flashAsset.x;
			workContent.fullScreenPlayer.player.back.y = workContent.fullScreenPlayer.player.flashAsset.y - 25;
			//
			workContent.fullScreenPlayer.player.txtInfo.x = workContent.fullScreenPlayer.player.flashAsset.attach.x - 5;
			workContent.fullScreenPlayer.player.txtInfo.y = workContent.fullScreenPlayer.player.flashAsset.attach.y + event.target.height + 10;
			//
			workContent.btBack3.x = Math.floor((stage.stageWidth/2) + (event.target.width/2) + 5 - workContent.btBack3.width);
			workContent.btBack3.y = Math.floor((stage.stageHeight / 2) - (event.target.height/ 2) - 40 - workContent.btBack3.height);
			//
			TweenMax.to (workContent.fullScreenPlayer.player.back, 0.5, { width:Math.floor(event.target.width + 10), height:Math.floor(event.target.height + 10), ease:Expo.easeOut, delay:0 } );
			TweenMax.to (workContent.fullScreenPlayer.player.txtInfo, 0.5, {alpha:1, ease:Expo.easeOut, delay:0.3});
			TweenMax.to (workContent.fullScreenPlayer.player.flashAsset, 0.5, {alpha:1, ease:Expo.easeOut, delay:0.3});		
		}
		//
		function fullScreenImageProgress (event:ProgressEvent):void {
			//
			var bytesLoadedNum:Number = event.bytesLoaded;
			var bytesTotalNum:Number = event.bytesTotal;
			//
			trace (int(bytesLoadedNum*100/bytesTotalNum) + "%");
		}
		//
		function fullScreenImageComplete (event:Event):void {
			//
			var myFullScreenPicture = event.target.content;
			//
			myFullScreenPicture.smoothing = true;
			//
			workContent.fullScreenPlayer.player.picture.attach.addChild (fullScreenImageLoader);
			//
			workContent.fullScreenPlayer.player.picture.attach.width = Math.floor(stage.stageWidth - 90);
			workContent.fullScreenPlayer.player.picture.attach.scaleY = workContent.fullScreenPlayer.player.picture.attach.scaleX;
			//
			if (workContent.fullScreenPlayer.player.picture.attach.height > stage.stageHeight - 190) {
				workContent.fullScreenPlayer.player.picture.attach.height = Math.floor(stage.stageHeight - 190);
				workContent.fullScreenPlayer.player.picture.attach.scaleX = workContent.fullScreenPlayer.player.picture.attach.scaleY;
			}
			//
			workContent.fullScreenPlayer.player.picture.attach.x = - Math.floor(workContent.fullScreenPlayer.player.picture.attach.width/2);
			workContent.fullScreenPlayer.player.picture.attach.y = - Math.floor(workContent.fullScreenPlayer.player.picture.attach.height/2 + 25);
			//
			workContent.fullScreenPlayer.player.back.x = workContent.fullScreenPlayer.player.picture.x;
			workContent.fullScreenPlayer.player.back.y = workContent.fullScreenPlayer.player.picture.y - 25;
			//
			workContent.fullScreenPlayer.player.txtInfo.x = workContent.fullScreenPlayer.player.picture.attach.x - 5;
			workContent.fullScreenPlayer.player.txtInfo.y = workContent.fullScreenPlayer.player.picture.attach.y + workContent.fullScreenPlayer.player.picture.attach.height + 10;
			//
			workContent.btBack3.x = Math.floor((stage.stageWidth/2) + (workContent.fullScreenPlayer.player.picture.attach.width/2) + 5 - workContent.btBack3.width);
			workContent.btBack3.y = Math.floor((stage.stageHeight/2) - (workContent.fullScreenPlayer.player.picture.attach.height/2) - 40 - workContent.btBack3.height);
			//
			TweenMax.to (workContent.fullScreenPlayer.player.back, 0.5, {width:Math.floor(workContent.fullScreenPlayer.player.picture.attach.width + 10), height:Math.floor(workContent.fullScreenPlayer.player.picture.attach.height + 10), ease:Expo.easeOut, delay:0});
			TweenMax.to (workContent.fullScreenPlayer.player.txtInfo, 0.5, {alpha:1, ease:Expo.easeOut, delay:0.3});
			TweenMax.to (workContent.fullScreenPlayer.player.picture, 0.5, {alpha:1, ease:Expo.easeOut, delay:0.3});
		}
		//
		private function loadFullScreenVideo () {
			//
			conn2 = new NetConnection();
			conn2.connect (null);
			stream2 = new NetStream(conn2);
			//
			stream2.addEventListener (NetStatusEvent.NET_STATUS, fullScreenNetStatusHandler);
			//
			stream2.play (myProjectGalleryItemFile);
			metaListener2.onMetaData = fullScreenMeta;
			stream2.client = metaListener2;
			video2.attachNetStream (stream2);
			video2.smoothing = true;
			//
			workContent.fullScreenPlayer.player.myVideo.attach.addChild (video2);
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.buttonMode = true;
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.addEventListener (MouseEvent.MOUSE_OVER, projectGalleryVideoPlayOver);
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.addEventListener (MouseEvent.MOUSE_OUT, projectGalleryVideoPlayOut);
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.addEventListener (MouseEvent.CLICK, FullScreenVideoPlayClick);
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.buttonMode = true;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.addEventListener (MouseEvent.MOUSE_OVER, projectGalleryVideoPauseOver);
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.addEventListener (MouseEvent.MOUSE_OUT, projectGalleryVideoPauseOut);
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.addEventListener (MouseEvent.CLICK, fullScreenVideoPauseClick);
			//
			stage.addEventListener (Event.ENTER_FRAME, fullScreenVideoEnterFrame);
		}
		//
		private function FullScreenVideoPlayClick (event:MouseEvent) {
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.visible = true;
			//
			stream2.resume ();
		}
		//
		private function fullScreenVideoPauseClick (event:MouseEvent) {
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.visible = true;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.visible = false;
			//
			stream2.pause ();
		}
		//
		private function fullScreenMeta (data:Object):void {
			//
			workContent.fullScreenPlayer.player.myVideo.attach.width = 0;
			workContent.fullScreenPlayer.player.myVideo.attach.height = 0;
			//
			fullScreenVideoTotalLength = data.duration;
			fullScreenVideoOriginalWidth = data.width;
			fullScreenVideoOriginalHeight = data.height;
			//
			workContent.fullScreenPlayer.player.myVideo.attach.width = Math.floor(stage.stageWidth - 90);
			workContent.fullScreenPlayer.player.myVideo.attach.height = Math.floor(((stage.stageWidth - 90)*fullScreenVideoOriginalHeight) / fullScreenVideoOriginalWidth);
			//
			if (workContent.fullScreenPlayer.player.myVideo.attach.height > stage.stageHeight - 220) {
				workContent.fullScreenPlayer.player.myVideo.attach.height = Math.floor(stage.stageHeight - 220);
				workContent.fullScreenPlayer.player.myVideo.attach.width = Math.floor((fullScreenVideoOriginalWidth * (stage.stageHeight - 220)) / fullScreenVideoOriginalHeight);
			}
			workContent.fullScreenPlayer.player.myVideo.attach.x = - Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.width/2);
			workContent.fullScreenPlayer.player.myVideo.attach.y = - Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.height/2 + 45);
			//
			workContent.fullScreenPlayer.player.back.x = workContent.fullScreenPlayer.player.myVideo.x;
			workContent.fullScreenPlayer.player.back.y = workContent.fullScreenPlayer.player.myVideo.y - 45;
			//
			workContent.fullScreenPlayer.player.myVideoConsole.x = Math.floor(- (workContent.fullScreenPlayer.player.myVideo.attach.width/2 + 5));
			workContent.fullScreenPlayer.player.myVideoConsole.y = workContent.fullScreenPlayer.player.myVideo.attach.y + workContent.fullScreenPlayer.player.myVideo.attach.height + 15;
			//
			workContent.fullScreenPlayer.player.txtInfo.x = workContent.fullScreenPlayer.player.myVideo.attach.x - 5;
			workContent.fullScreenPlayer.player.txtInfo.y = Math.floor(workContent.fullScreenPlayer.player.myVideoConsole.y + workContent.fullScreenPlayer.player.myVideoConsole.height + 10);
			//
			workContent.btBack3.x = Math.floor((stage.stageWidth/2) + (workContent.fullScreenPlayer.player.myVideo.attach.width/2) + 5 - workContent.btBack3.width);
			workContent.btBack3.y = Math.floor((stage.stageHeight/2) - (workContent.fullScreenPlayer.player.myVideo.attach.height/2) - 60 - workContent.btBack3.height);
			//
			workContent.fullScreenPlayer.player.myVideoConsole.back.width = workContent.fullScreenPlayer.player.myVideo.attach.width + 10;
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.backBar.width = workContent.fullScreenPlayer.player.myVideoConsole.back.width - 30;
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.track.width = workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.backBar.width;
			//
			TweenMax.to (workContent.fullScreenPlayer.player.back, 0.5, {width:Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.width + 10), height:Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.height + 10), ease:Expo.easeOut, delay:0});
			TweenMax.to (workContent.fullScreenPlayer.player.txtInfo, 0.5, {alpha:1, ease:Expo.easeOut, delay:0.3});
			TweenMax.to (workContent.fullScreenPlayer.player.myVideo, 0.5, {alpha:1, ease:Expo.easeOut, delay:0.3});
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.visible = true;
			workContent.fullScreenPlayer.player.myVideoConsole.visible = true;
			//
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.buttonMode = true;
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.CLICK, FSvideoToSecond);
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.MOUSE_DOWN, FSvideoTrackDown);
			stage.addEventListener (MouseEvent.MOUSE_UP, FSvideoTrackUp);
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.MOUSE_UP, FSvideoTrackUp);
		}
		//
		private function FSvideoToSecond (event:MouseEvent):void {
			if (workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.mouseX < workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.streamingBar.width) {
				var percentAcross:Number = (workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.mouseX) / workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.track.width;
				stream2.seek (fullScreenVideoTotalLength * percentAcross);
			}
		}
		//
		private function FSvideoTrackDown (event:MouseEvent):void {
			stage.addEventListener (MouseEvent.MOUSE_MOVE, FSvideoScrubTo);
		}
		//
		private function FSvideoTrackUp (event:MouseEvent):void {
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, FSvideoScrubTo);
		}
		//
		private function FSvideoScrubTo (event:MouseEvent):void {
			if (workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.mouseX < workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.streamingBar.width) {
				var percentAcross:Number = workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.mouseX / workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.track.width;
				stream2.seek (fullScreenVideoTotalLength * percentAcross);
			}
		}
		//
		function fullScreenVideoEnterFrame (event:Event):void {
			//
			var nowSecs:Number = stream2.time;
			var totalSecs:Number = fullScreenVideoTotalLength;
			//
			if (nowSecs > 0) {
				var amountPlayed:Number = nowSecs / totalSecs;
				var amountLoaded:Number = stream2.bytesLoaded / stream2.bytesTotal;
				//
				workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.playingBar.width = workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.backBar.width * amountPlayed;
				if (Math.floor(workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.playingBar.width - workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.scrubber.width) < 0) {
					workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.scrubber.x = 0;
				}
				else {
					workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.scrubber.x = Math.floor(workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.playingBar.width - workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.scrubber.width);
				}
				workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.streamingBar.width = workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.backBar.width * amountLoaded;
			}
		}
		//
		private function fullScreenNetStatusHandler (event:NetStatusEvent):void {
			//
			switch (event.info.code) {
				case "NetStream.Buffer.Empty" :
					trace ("NetStream.Buffer.Empty");
					break;
				case "NetStream.Buffer.Full" :
					trace ("NetStream.Buffer.Full");
					break;
				case "NetStream.Play.Start" :
					trace ("NetStream.Play.Start");
					TweenMax.to (workContent.fullScreenPlayer.player.myVideo, 0.5, {alpha:1, ease:Expo.easeOut});
					break;
				case "NetStream.Play.Stop" :
					trace ("NetStream.Play.Stop");
					stream2.seek (0);
					//
					break;
			}
		}
		//
		private function closeFullScreenVideo () {
			//
			stream2.close ();
			stream2.removeEventListener (NetStatusEvent.NET_STATUS, fullScreenNetStatusHandler);
			stage.removeEventListener (Event.ENTER_FRAME, fullScreenVideoEnterFrame);
			//
			workContent.fullScreenPlayer.player.myVideoConsole.btPlay.visible = false;
			workContent.fullScreenPlayer.player.myVideoConsole.btPause.visible = false;
			//
			workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.scrubber.x = 0;
			//
			closeFullScreenContent ();
			//
			workContent.fullScreenPlayer.player.myVideo.attach.removeChild (video2);
			//
			videoIsFullScreen = false;
		}
		//
		private function closeFullScreenContent () {
			setOurWork ("left");
			setWorkDetails ("left");
			setProjectGallery ("middle");
			setFullScreenPlayer ("right");
			//
			videoIsFullScreen = false;
		}
		//
		private function projectGalleryLoadProgress (event:ProgressEvent):void {
			//
			var bytesLoadedNum:Number = event.bytesLoaded;
			var bytesTotalNum:Number = event.bytesTotal;
			//
			for (var a:Number = 0; a < projectGalleryTotalItems; a++) {
				//
				var percent:Number = 0;
				var loaded:Number = 0;
				var total:Number = 0;
				//
				loaded += projectGalleryThumbLoader[a].contentLoaderInfo.bytesLoaded;
				total += projectGalleryThumbLoader[a].contentLoaderInfo.bytesTotal;
				//
				percent = loaded / total;
				//
				if (loaded > 0) {
					projectGalleryArray[a].preLoader.percentTxt.txt.text = "LOADING " + Math.floor(100 * percent) + "%";
					projectGalleryArray[a].preLoader.percentTxt.txt.autoSize = TextFieldAutoSize.LEFT;
					//
					if (loaded == total) {
						TweenMax.to (projectGalleryArray[a].preLoader, 0.5, {alpha:0, ease:Expo.easeOut});
						TweenMax.to (projectGalleryArray[a].picture.attach, 1, {alpha:1, ease:Expo.easeOut});
					}
				}
			}
		}
		//
		private function projectGalleryThumbLoadComplete (event:Event):void {
			var projectGalleryThumbNewSize = event.target.content;
			//
			projectGalleryThumbNewSize.width = 365;
			projectGalleryThumbNewSize.height = 230;
			projectGalleryThumbNewSize.smoothing = true;
		}
		//
		private function projectGalleryItemOver (event:MouseEvent) {
			TweenMax.to (event.currentTarget.back, 0.5, {alpha:0, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.backWhite, 0.5, {alpha:1, ease:Cubic.easeOut});
			//
			TweenMax.to (projectGalleryArray[event.currentTarget.instanceProjectGalleryItemID].btOpenFullScreen, 0.5, {alpha:1, ease:Cubic.easeOut});
		}
		//
		private function projectGalleryItemOut (event:MouseEvent) {
			TweenMax.to (event.currentTarget.back, 0.5, {alpha:1, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.backWhite, 0.5, {alpha:0, ease:Cubic.easeOut});
			//
			TweenMax.to (projectGalleryArray[event.currentTarget.instanceProjectGalleryItemID].btOpenFullScreen, 0.5, {alpha:0, ease:Cubic.easeOut});
		}
		//
		private function workDetailsBtNavOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function workDetailsBtNavOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function workDetailsBtNextClick (event:MouseEvent) {
			//
			workContent.workDetails.navBts.btBack.visible = true;
			//
			TweenMax.to (workDetailsArray[myProjectDetailsID], 0.5, {x:0 - stage.stageWidth, ease:Cubic.easeOut});
			//
			myProjectDetailsID = myProjectDetailsID + 1;
			//
			if (myProjectDetailsID == ourWorkXmlTotalItems - 1) {
				workContent.workDetails.navBts.btNext.visible = false;
			}
			//
			TweenMax.to (workDetailsArray[myProjectDetailsID], 0.5, {x:0, ease:Cubic.easeOut, onComplete:setProjectDetailsItemPositions});
		}
		//
		private function workDetailsBtBackClick (event:MouseEvent) {
			//
			workContent.workDetails.navBts.btNext.visible = true;
			//
			TweenMax.to (workDetailsArray[myProjectDetailsID], 0.5, {x:stage.stageWidth, ease:Cubic.easeOut});
			//
			myProjectDetailsID = myProjectDetailsID - 1;
			//
			if (myProjectDetailsID == 0) {
				workContent.workDetails.navBts.btBack.visible = false;
			}
			//
			TweenMax.to (workDetailsArray[myProjectDetailsID], 0.5, {x:0, ease:Cubic.easeOut, onComplete:setProjectDetailsItemPositions});
		}
		//
		private function setProjectDetailsItemPositions () {
			//
			var ItemNr:String;
			var ItemNrTotal:String;
			//
			if (myProjectDetailsID + 1 <= ourWorkXmlTotalItems) {
				ItemNr = "" + int(myProjectDetailsID+1);
			}
			else {
				ItemNr = "" + ourWorkXmlTotalItems;
			}
			//
			if (myProjectDetailsID + 1 < 100) {
				if (myProjectDetailsID + 1 < 10) {
					ItemNr = "00" + ItemNr;
				}
				else {
					ItemNr = "0" + ItemNr;
				}
			}
			//
			if (ourWorkXmlTotalItems < 100) {
				if (ourWorkXmlTotalItems < 10) {
					ItemNrTotal = "00" + ourWorkXmlTotalItems;
				}
				else {
					ItemNrTotal = "0" + ourWorkXmlTotalItems;
				}
				workContent.workDetails.navBts.txt.text = ItemNr + " of " + ItemNrTotal;
				workContent.workDetails.navBts.txt.autoSize = TextFieldAutoSize.LEFT;
				workContent.workDetails.navBts.btNext.x = Math.floor(workContent.workDetails.navBts.txt.x + workContent.workDetails.navBts.txt.width + 5);
			}
			else {
				workContent.workDetails.navBts.txt.text = ItemNr + " of " + ourWorkXmlTotalItems;
				workContent.workDetails.navBts.txt.autoSize = TextFieldAutoSize.LEFT;
				workContent.workDetails.navBts.btNext.x = Math.floor(workContent.workDetails.navBts.txt.x + workContent.workDetails.navBts.txt.width + 5);
			}
			//
			validateLargeTmbArray = false;
			//
			if (largeTmbLoadedFirstTime != true) {
				largeTmbCounterArray.push (myProjectDetailsID);
				//
				largeTmbLoader = new Loader();
				largeTmbUrl = new URLRequest(projectDetailsLargeTmb[myProjectDetailsID]);
				largeTmbLoader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, largeTmbLoadProgress);
				largeTmbLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, largeTmbLoadComplete);
				largeTmbLoader.load (largeTmbUrl);
				//
				TweenMax.to (workDetailsArray[myProjectDetailsID].preLoader, 0.5, {alpha:1, ease:Expo.easeOut});
				//
				workDetailsArray[myProjectDetailsID].picture.attachPicture.alpha = 0;
				workDetailsArray[myProjectDetailsID].picture.attachPicture.addChild (largeTmbLoader);
			}
			else {
				for (var a:Number = 0; a < largeTmbCounterArray.length; a++) {
					if (myProjectDetailsID == largeTmbCounterArray[a]) {
						//
						validateLargeTmbArray = true;
					}
					if (a == largeTmbCounterArray.length - 1) {
						if (validateLargeTmbArray != true) {
							largeTmbCounterArray.push (myProjectDetailsID);
							//
							largeTmbLoader = new Loader();
							largeTmbUrl = new URLRequest(projectDetailsLargeTmb[myProjectDetailsID]);
							largeTmbLoader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, largeTmbLoadProgress);
							largeTmbLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, largeTmbLoadComplete);
							largeTmbLoader.load (largeTmbUrl);
							//
							TweenMax.to (workDetailsArray[myProjectDetailsID].preLoader, 0.5, {alpha:1, ease:Expo.easeOut});
							//
							workDetailsArray[myProjectDetailsID].picture.attachPicture.alpha = 0;
							workDetailsArray[myProjectDetailsID].picture.attachPicture.addChild (largeTmbLoader);
						}
					}
				}
			}
			for (var i:Number = 0; i < ourWorkXmlTotalItems; i++) {
				if (i < myProjectDetailsID) {
					workDetailsArray[i].x = 0 - stage.stageWidth;
				}
				else if (i == myProjectDetailsID) {
					TweenMax.to (workDetailsArray[i], 0.5, {x:0, ease:Cubic.easeOut});
				}
				else if (i > myProjectDetailsID) {
					workDetailsArray[i].x = stage.stageWidth;
				}
			}
		}
		//
		private function largeTmbLoadProgress (event:ProgressEvent):void {
			//
			var bytesLoadedNum:Number = event.bytesLoaded;
			var bytesTotalNum:Number = event.bytesTotal;
			//
			workDetailsArray[myProjectDetailsID].preLoader.percentTxt.txt.text = "LOADING " + int(bytesLoadedNum*100/bytesTotalNum) + "%";
			workDetailsArray[myProjectDetailsID].preLoader.percentTxt.txt.autoSize = TextFieldAutoSize.LEFT;
		}
		//
		private function largeTmbLoadComplete (event:Event):void {
			largeTmbLoadedFirstTime = true;
			//
			largeTmbLoader.contentLoaderInfo.removeEventListener (ProgressEvent.PROGRESS, largeTmbLoadProgress);
			//
			myLargeTmbComplete = event.target.content;			
			
			trace("event.target.content " + event.target.content)
			myLargeTmbComplete.smoothing = true;
			
////////////// ADDED BY FRED //
			//
			//if (myLargeTmbComplete.width > workDetailsArray[myProjectDetailsID].masker.width) {
			//	stage.addEventListener (MouseEvent.MOUSE_MOVE, validateLargeTmbSlider);
			//}
			//
			
			TweenMax.to (workDetailsArray[myProjectDetailsID].picture.attachPicture, 1, {alpha:1, ease:Cubic.easeOut});
			//
			TweenMax.to (workDetailsArray[myProjectDetailsID].preLoader, 0.5, {alpha:0, ease:Expo.easeOut});
		}
		//
		private function validateLargeTmbSlider (event:Event) {
			if (workDetailsArray[myProjectDetailsID].masker.mouseX > 0) {
				if (workDetailsArray[myProjectDetailsID].masker.mouseX < workDetailsArray[myProjectDetailsID].masker.width) {
					if (workDetailsArray[myProjectDetailsID].masker.mouseY > 0) {
						if (workDetailsArray[myProjectDetailsID].masker.mouseY < workDetailsArray[myProjectDetailsID].masker.height) {
							largeTmbVertical ();
							largeTmbHorizontal ();
						}
					}
				}
			}
		}
		//
		private function largeTmbHorizontal () {
			var d:Number = 1;
			var mov:Number = workDetailsArray[myProjectDetailsID].masker.mouseX;
			var coef:Number = ((workDetailsPicSize - 10) - workDetailsArray[myProjectDetailsID].picture.width)/(workDetailsPicSize - 10);
			TweenMax.to (workDetailsArray[myProjectDetailsID].picture, 1, {x:workDetailsArray[myProjectDetailsID].picture.x - (((workDetailsArray[myProjectDetailsID].picture.x -+ workDetailsArray[myProjectDetailsID].masker.x)-coef*mov)/d), ease:Cubic.easeOut});
		}
		//
		private function largeTmbVertical () {
			var d:Number = 1;
			var mov:Number = workDetailsArray[myProjectDetailsID].masker.mouseY;
			var coef:Number = (workDetailsArray[myProjectDetailsID].masker.height - workDetailsArray[myProjectDetailsID].picture.height)/workDetailsArray[myProjectDetailsID].masker.height;
			TweenMax.to (workDetailsArray[myProjectDetailsID].picture, 1, {y:workDetailsArray[myProjectDetailsID].picture.y - (((workDetailsArray[myProjectDetailsID].picture.y -+ workDetailsArray[myProjectDetailsID].masker.y)-coef*mov)/d), ease:Cubic.easeOut});
		}
		//
		public function openAllProjects () {
			//
			Gaia.api.goto ("index/nav/work/");
			var currentDeeplink:String = Gaia.api.getDeeplink();
			onDeeplink (new GaiaSWFAddressEvent(GaiaSWFAddressEvent.DEEPLINK, false, false, currentDeeplink));
			//
			setOurWork ("middle");
			setWorkDetails ("right");
			setProjectGallery ("right");
			setFullScreenPlayer ("right");
		}
		//
		function btBackToWorkContentClick (event:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
			openAllProjects ();
		}
		//
		function btBack2Click (event:MouseEvent) {
			//
			//workContent.projectGallery.attachItems.x = 0;
			//
			if(deepLinkZone == "gallery"){
				Gaia.api.goto ("index/nav/work/details/"+myProjectDetailsID);
				var currentDeeplink:String = Gaia.api.getDeeplink();
				onDeeplink (new GaiaSWFAddressEvent(GaiaSWFAddressEvent.DEEPLINK, false, false, currentDeeplink));
				//
				if (rectangleProjectGalleryAvailable == true) {
					desactivateProjectGalleryScroll ();
				}
				if (projectGalleryVideoPlaying == true) {
					closeProjectGalleryVideo ();
				}
				for (a = 0; a < projectGalleryTotalItems; a++) {
					//
					if (projectGalleryIsOnProgress == true) {
						projectGalleryThumbLoader[a].contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, projectGalleryLoadProgress);
					}
					workContent.projectGallery.attachItems.removeChildAt (1);
				}
				//
				openProjectDetails ();
			}
			else{
				Gaia.api.goto ("index/nav/work/details/"+myProjectDetailsID);
				var currentDeeplink2:String = Gaia.api.getDeeplink();
				onDeeplink (new GaiaSWFAddressEvent(GaiaSWFAddressEvent.DEEPLINK, false, false, currentDeeplink2));
				//
				setOurWork ("left");
				setWorkDetails ("middle");
				setProjectGallery ("right");
				setFullScreenPlayer ("right");
				//
				if (rectangleProjectGalleryAvailable == true) {
					desactivateProjectGalleryScroll ();
				}
				if (projectGalleryVideoPlaying == true) {
					closeProjectGalleryVideo ();
				}
				for (a = 0; a < projectGalleryTotalItems; a++) {
					//
					if (projectGalleryIsOnProgress == true) {
						projectGalleryThumbLoader[a].contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, projectGalleryLoadProgress);
					}
					workContent.projectGallery.attachItems.removeChildAt (1);
				}
			}
			//
			//workContent.projectGallery.attachItems.x = 0;
		}
		//
		function btBack3Click (event:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener2);
			setOurWork ("left");
			setWorkDetails ("left");
			setProjectGallery ("middle");
			setFullScreenPlayer ("right");
			//
			//if (myProjectGalleryItemType == "image" ) {
////////// ADDED BY FRED //			
			if (myProjectGalleryItemType == "image" ) {
				workContent.fullScreenPlayer.player.picture.attach.removeChild (fullScreenImageLoader);
			}
			
			else if (myProjectGalleryItemType == "flash") {
				workContent.fullScreenPlayer.player.flashAsset.attach.removeChild (fullScreenFlashLoader);
				fullScreenFlashLoader.unload();
			}
			
			else {
				closeFullScreenVideo ();
			}
			videoIsFullScreen = false;
		}
		//
		public function setOurWork (place:String) {
			if (place == "right") {
				myOurWorkPos = stage.stageWidth + 40;
				ourWorkOpen = "right";
				TweenMax.to (workContent.middleBar, 0.5, {y:stage.stageHeight - 50, ease:Cubic.easeOut});
			}
			if (place == "middle") {
				myOurWorkPos = 40;
				ourWorkOpen = "middle";
				TweenMax.to (workContent.middleBar, 0.5, {y:stage.stageHeight/2 - 35, ease:Cubic.easeOut});
			}
			if (place == "left") {
				myOurWorkPos = - stage.stageWidth;
				ourWorkOpen = "left";
				TweenMax.to (workContent.middleBar, 0.5, {y:stage.stageHeight - 50, ease:Cubic.easeOut});
			}
			TweenMax.to (workContent.ourWork, 0.5, {x:myOurWorkPos, ease:Cubic.easeOut});
		}
		//
		public function setWorkDetails (place:String) {
			if (place == "right") {
				myWorkDetailsPos = stage.stageWidth + 40;
				workDetailsOpen = "right";
				workContent.btBack.visible = false;
			}
			if (place == "middle") {
				myWorkDetailsPos = 40;
				workDetailsOpen = "middle";
				workContent.btBack.visible = true;
				workContent.btBack.x = Math.floor(workDetailsPicSize + 45 - workContent.btBack.width);
				workContent.btBack.y = Math.floor(workContent.workDetails.y - 100);
			}
			if (place == "left") {
				myWorkDetailsPos = - stage.stageWidth;
				workDetailsOpen = "left";
				workContent.btBack.visible = false;
			}
			TweenMax.to (workContent.workDetails, 0.5, {x:myWorkDetailsPos, ease:Cubic.easeOut});
		}
		//
		public function setProjectGallery (place:String) {
			if (place == "right") {
				myProjectGalleryPos = stage.stageWidth + 40;
				projectGalleryOpen = "right";
				workContent.btBack2.visible = false;
			}
			if (place == "middle") {
				myProjectGalleryPos = 40;
				projectGalleryOpen = "middle";
				workContent.btBack2.visible = true;
				workContent.btBack2.x = Math.floor(projectGalleryPicSize + 40 - workContent.btBack2.width);
				workContent.btBack2.y = Math.floor(workContent.projectGallery.y - 100);
			}
			if (place == "left") {
				myProjectGalleryPos = - stage.stageWidth;
				projectGalleryOpen = "left";
				workContent.btBack2.visible = false;
			}
			TweenMax.to (workContent.projectGallery, 0.5, {x:myProjectGalleryPos, ease:Cubic.easeOut});
		}
		//
		public function setFullScreenPlayer (place:String) {
			if (place == "right") {
				myFullScreenPlayerPos = stage.stageWidth + 40;
				fullScreenPlayerOpen = "right";
				workContent.btBack3.visible = false;
			}
			if (place == "middle") {
				myFullScreenPlayerPos = 0;
				fullScreenPlayerOpen = "middle";
				workContent.btBack3.visible = true;
			}
			if (place == "left") {
				myFullScreenPlayerPos = - stage.stageWidth;
				fullScreenPlayerOpen = "left";
				workContent.btBack3.visible = false;
			}
			TweenMax.to (workContent.fullScreenPlayer, 0.5, {x:myFullScreenPlayerPos, ease:Cubic.easeOut});
		}
		//
		public function resizeHandler (e:Event):void {
			//
			workContent.x = 0;
			workContent.y = 0;
			//
			workContent.middleBar.x = 0;
			workContent.middleBar.height = stage.stageHeight/2 + 35;
			//
			if (middleBarOpen == true) {
				workContent.middleBar.width = stage.stageWidth;
			}
			else {
				workContent.middleBar.width = 0;
			}
			if (ourWorkOpen == "right") {
				workContent.ourWork.x = stage.stageWidth + 40;
				workContent.middleBar.y = stage.stageHeight - 50;
			}
			if (ourWorkOpen == "middle") {
				workContent.ourWork.x = 40;
				workContent.middleBar.y = stage.stageHeight/2 - 35;
			}
			if (ourWorkOpen == "left") {
				workContent.ourWork.x = - stage.stageWidth;
				workContent.middleBar.y = stage.stageHeight - 50;
			}
			workContent.ourWork.y = Math.floor(stage.stageHeight/2 - 35 - 40);
			workContent.ourWork.previewMode.masker.width = stage.stageWidth;
			//
			workContent.workDetails.y = Math.floor(stage.stageHeight/2 - 35 - 40);
			workContent.workDetails.masker.width = stage.stageWidth;
			//
			if (stage.stageWidth >= 1300) {
				workContent.ourWork.previewMode.navScroller.scrollBar.back.width = 1260;
				workContent.ourWork.previewMode.navScroller.scrollSlider.width = 60;
				//
				workDetailsPicSize = 875;
			}
			else {
				workContent.ourWork.previewMode.navScroller.scrollBar.back.width = 940;
				workContent.ourWork.previewMode.navScroller.scrollSlider.width = 40;
				//
				workDetailsPicSize = 575;
			}
			//
			if (workDetailsOpen == "right") {
				workContent.workDetails.x = stage.stageWidth + 40;
			}
			if (workDetailsOpen == "middle") {
				workContent.workDetails.x = 40;
				TweenMax.to (workContent.btBack, 0.5, {x:Math.floor(workDetailsPicSize + 45 - workContent.btBack.width), y:Math.floor(workContent.workDetails.y - 100), ease:Cubic.easeOut});
			}
			if (workDetailsOpen == "left") {
				workContent.workDetails.x = - stage.stageWidth;
			}
			if (rectangleWorkAvailable == true) {
				rectangleDragWork = new Rectangle(0,0,workContent.ourWork.previewMode.navScroller.scrollBar.back.width - workContent.ourWork.previewMode.navScroller.scrollSlider.width,0);
			}
			if (stage.stageWidth >= 1195) {
				workContent.projectGallery.navScroller.scrollBar.back.width = 1155;
				workContent.projectGallery.navScroller.scrollSlider.width = 60;
				//
				projectGalleryPicSize = 1155;
			}
			else {
				workContent.projectGallery.navScroller.scrollBar.back.width = 765;
				workContent.projectGallery.navScroller.scrollSlider.width = 40;
				//
				projectGalleryPicSize = 765;
			}
			if (rectangleProjectGalleryAvailable == true) {
				rectangleDragProjectGallery = new Rectangle(0,0,workContent.projectGallery.navScroller.scrollBar.back.width - workContent.projectGallery.navScroller.scrollSlider.width,0);
			}
			if (projectGalleryOpen == "right") {
				workContent.projectGallery.x = stage.stageWidth + 40;
			}
			if (projectGalleryOpen == "middle") {
				workContent.projectGallery.x = 40;
				TweenMax.to (workContent.btBack2, 0.5, {x:Math.floor(projectGalleryPicSize + 40 - workContent.btBack2.width), y:Math.floor(workContent.projectGallery.y - 100), ease:Cubic.easeOut});
			}
			if (projectGalleryOpen == "left") {
				workContent.projectGallery.x = - stage.stageWidth;
			}
			workContent.projectGallery.y = Math.floor(stage.stageHeight/2 - 35 - 40);
			workContent.projectGallery.masker.width = stage.stageWidth;
			//
			workContent.projectGallery.masker.height = stage.stageHeight;
			workContent.projectGallery.masker.y = - workContent.projectGallery.y;
			//
			for (var i:Number = 0; i < ourWorkXmlTotalItems; i++) {
				if (i < myProjectDetailsID) {
					workDetailsArray[i].x = 0 - stage.stageWidth;
				}
				else if (i == myProjectDetailsID) {
					workDetailsArray[i].x = 0;
				}
				else if (i > myProjectDetailsID) {
					workDetailsArray[i].x = stage.stageWidth;
				}
////////////////// ADDED BY FRED
				// This move and expend stuff when resized, we don't want that
/*				TweenMax.to (workDetailsArray[i].back, 0.5, {width:workDetailsPicSize, ease:Cubic.easeOut});
				TweenMax.to (workDetailsArray[i].backPicture, 0.5, {width:workDetailsPicSize - 10, ease:Cubic.easeOut});
				TweenMax.to (workDetailsArray[i].masker.maskIn, 0.5, {width:workDetailsPicSize - 10, ease:Cubic.easeOut});
				TweenMax.to (workDetailsArray[i].contentTxt, 0.5, {x:0 + workDetailsPicSize + 10, ease:Cubic.easeOut});
				TweenMax.to (workDetailsArray[i].btVisitProject, 0.5, {x:Math.floor(workDetailsPicSize - workDetailsArray[i].btVisitProject.width), ease:Cubic.easeOut});
				TweenMax.to (workDetailsArray[i].btProjectGallery, 0.5, {x:Math.floor(workDetailsPicSize - workDetailsArray[i].btVisitProject.width - 5 - workDetailsArray[i].btProjectGallery.width), ease:Cubic.easeOut});*/
				//
				if (myProjectDetailsID >= 0) {
					TweenMax.to (workDetailsArray[myProjectDetailsID].picture, 1, {x:0, ease:Cubic.easeOut});
				}
			}
			if (fullScreenPlayerOpen == "right") {
				workContent.fullScreenPlayer.x = stage.stageWidth + 40;
			}
			if (fullScreenPlayerOpen == "middle") {
				workContent.fullScreenPlayer.x = 0;
			}
			if (fullScreenPlayerOpen == "left") {
				workContent.fullScreenPlayer.x = - stage.stageWidth;
			}
			workContent.fullScreenPlayer.player.x = Math.floor(stage.stageWidth/2);
			workContent.fullScreenPlayer.y = Math.floor(stage.stageHeight/2);
			//
			if (myProjectGalleryItemType == "image") {
				workContent.fullScreenPlayer.player.picture.attach.width = Math.floor(stage.stageWidth - 90);
				workContent.fullScreenPlayer.player.picture.attach.scaleY = workContent.fullScreenPlayer.player.picture.attach.scaleX;
				//
				if (workContent.fullScreenPlayer.player.picture.attach.height > stage.stageHeight - 190) {
					workContent.fullScreenPlayer.player.picture.attach.height = Math.floor(stage.stageHeight - 190);
					workContent.fullScreenPlayer.player.picture.attach.scaleX = workContent.fullScreenPlayer.player.picture.attach.scaleY;
				}
				//
				workContent.fullScreenPlayer.player.picture.attach.x = - Math.floor(workContent.fullScreenPlayer.player.picture.attach.width/2);
				workContent.fullScreenPlayer.player.picture.attach.y = - Math.floor(workContent.fullScreenPlayer.player.picture.attach.height/2 + 25);
				//
				workContent.fullScreenPlayer.player.back.x = workContent.fullScreenPlayer.player.picture.x;
				workContent.fullScreenPlayer.player.back.y = workContent.fullScreenPlayer.player.picture.y - 25;
				//
				workContent.fullScreenPlayer.player.txtInfo.x = workContent.fullScreenPlayer.player.picture.attach.x - 5;
				workContent.fullScreenPlayer.player.txtInfo.y = workContent.fullScreenPlayer.player.picture.attach.y + workContent.fullScreenPlayer.player.picture.attach.height + 10;
				//
				workContent.fullScreenPlayer.player.back.width = Math.floor(workContent.fullScreenPlayer.player.picture.attach.width + 10);
				workContent.fullScreenPlayer.player.back.height = Math.floor(workContent.fullScreenPlayer.player.picture.attach.height + 10);
				//
				if (fullScreenPlayerOpen == "middle") {
					workContent.btBack3.x = Math.floor((stage.stageWidth/2) + (workContent.fullScreenPlayer.player.picture.attach.width/2) + 5 - workContent.btBack3.width);
					workContent.btBack3.y = Math.floor((stage.stageHeight/2) - (workContent.fullScreenPlayer.player.picture.attach.height/2) - 40 - workContent.btBack3.height);
				}
			}
			else if (myProjectGalleryItemType == "video") {
				//
				workContent.fullScreenPlayer.player.myVideo.attach.width = Math.floor(stage.stageWidth - 90);
				workContent.fullScreenPlayer.player.myVideo.attach.height = Math.floor(((stage.stageWidth - 90)*fullScreenVideoOriginalHeight) / fullScreenVideoOriginalWidth);
				//
				if (workContent.fullScreenPlayer.player.myVideo.attach.height > stage.stageHeight - 220) {
					workContent.fullScreenPlayer.player.myVideo.attach.height = Math.floor(stage.stageHeight - 220);
					workContent.fullScreenPlayer.player.myVideo.attach.width = Math.floor((fullScreenVideoOriginalWidth * (stage.stageHeight - 220)) / fullScreenVideoOriginalHeight);
				}
				workContent.fullScreenPlayer.player.myVideo.attach.x = - Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.width/2);
				workContent.fullScreenPlayer.player.myVideo.attach.y = - Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.height/2 + 45);
				//
				workContent.fullScreenPlayer.player.back.x = workContent.fullScreenPlayer.player.myVideo.x;
				workContent.fullScreenPlayer.player.back.y = workContent.fullScreenPlayer.player.myVideo.y - 45;
				//
				workContent.fullScreenPlayer.player.myVideoConsole.x = Math.floor(- (workContent.fullScreenPlayer.player.myVideo.attach.width/2 + 5));
				workContent.fullScreenPlayer.player.myVideoConsole.y = workContent.fullScreenPlayer.player.myVideo.attach.y + workContent.fullScreenPlayer.player.myVideo.attach.height + 15;
				//
				workContent.fullScreenPlayer.player.txtInfo.x = workContent.fullScreenPlayer.player.myVideo.attach.x - 5;
				workContent.fullScreenPlayer.player.txtInfo.y = Math.floor(workContent.fullScreenPlayer.player.myVideoConsole.y + workContent.fullScreenPlayer.player.myVideoConsole.height + 10);
				//
				workContent.fullScreenPlayer.player.myVideoConsole.back.width = workContent.fullScreenPlayer.player.myVideo.attach.width + 10;
				workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.backBar.width = workContent.fullScreenPlayer.player.myVideoConsole.back.width - 30;
				workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.trackingBar.track.width = workContent.fullScreenPlayer.player.myVideoConsole.videoScrubber.backBar.width;
				//
				workContent.fullScreenPlayer.player.back.width = Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.width + 10);
				workContent.fullScreenPlayer.player.back.height = Math.floor(workContent.fullScreenPlayer.player.myVideo.attach.height + 10);
				//
				if (fullScreenPlayerOpen == "middle") {
					workContent.btBack3.x = Math.floor((stage.stageWidth/2) + (workContent.fullScreenPlayer.player.myVideo.attach.width/2) + 5 - workContent.btBack3.width);
					workContent.btBack3.y = Math.floor((stage.stageHeight/2) - (workContent.fullScreenPlayer.player.myVideo.attach.height/2) - 60 - workContent.btBack3.height);
				}
			}
		}
	}
}