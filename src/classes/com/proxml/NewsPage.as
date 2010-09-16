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
	import flash.text.TextFieldAutoSize;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import gs.TweenMax;
	import gs.easing.*;

	public class NewsPage extends AbstractPage {
		//
		public var newsContent:MovieClip;
		
		private var middleBarOpen:Boolean = false;
		private var newsDetailsOpen:Boolean = false;
		
		private var newsTitle:String;
		private var newsDescription:String;
		private var newsXmlTotalItems:Number;
		private var a:Number = 0;
		private var newsItemArray:Array = new Array;
		public var newsItem:MovieClip;
		private var itemTitle:String;
		private var itemLink:String;
		private var itemDescription:String;
		private var itemDate:String;
		private var itemGuid:String;
		private var itemImage:String;
		private var myCurrentNewsID:Number = 0;
		private var thumbLoader:Array = new Array;
		//
		public function NewsPage () {
			super ();
			alpha = 0;
		}
		//
		override public function transitionIn ():void {
			super.transitionIn ();
			//
			stage.addEventListener (Event.RESIZE, resizeHandler);
			stage.dispatchEvent (new Event(Event.RESIZE));
			//
			newsContent.x = 0;
			newsContent.y = 0;
			//
			newsContent.middleBar.x = 0;
			newsContent.middleBar.y = stage.stageHeight - 50;
			newsContent.middleBar.width = 0;
			newsContent.middleBar.height = 50;
			//
			newsContent.newsDetails.x = stage.stageWidth;
			newsContent.newsDetails.y = Math.floor(stage.stageHeight/2 - 35 - 40);
			newsContent.newsDetails.masker.width = stage.stageWidth;
			//
			Gaia.api.getPage("index/nav").content.addMouseMoveListener ();
			Gaia.api.getPage("index/nav").content.setMainMenuTop ();
			//
			initMiddleBar();
			//
			TweenMax.to (this, 0.3, {alpha:1, onComplete:transitionInComplete});
		}
		//
		override public function transitionOut ():void {
			super.transitionOut ();
			//
			stage.removeEventListener (Event.RESIZE, resizeHandler);
			//
			TweenMax.to (this, 0.3, {alpha:0, onComplete:transitionOutComplete});
		}
		//
		private function initMiddleBar(){
			middleBarOpen = true;
			TweenMax.to (newsContent.middleBar, 0.5, {width:stage.stageWidth, ease:Cubic.easeOut, onComplete:loadNewsXml});
		}
		//
		private function initNewsContent(){
			newsDetailsOpen = true;
			TweenMax.to (newsContent.newsDetails, 0.5, {x:40, ease:Cubic.easeOut});
		}
		//
		private function loadNewsXml () {
			var myNewsXML:XML = IXml(assets.newsXml).xml;
			//
			newsTitle = myNewsXML.channel.title.text();
			newsDescription = myNewsXML.channel.description.text();
			//
			newsXmlTotalItems = myNewsXML.channel.item.length();
			//
			newsItemArray = [];
			//
			for (a = 0; a < newsXmlTotalItems; a++) {
				newsItem = new newsDetailsItem;
				//
				itemTitle = myNewsXML.channel.item.title[a].text();
				itemLink = myNewsXML.channel.item.link[a].text();
				itemDescription = myNewsXML.channel.item.description[a].text();
				itemDate = myNewsXML.channel.item.pubDate[a].text();
				itemGuid = myNewsXML.channel.item.guid[a].text();
				itemImage = myNewsXML.channel.item.image[a].text();
				//
				newsItemArray.push (newsItem);
				//
				newsItemArray[a].alpha = 0;
				newsItemArray[a].x = stage.stageWidth;
				//
				newsItemArray[a].topTitleTxt.titleTxt1.txt.text = newsTitle;
				newsItemArray[a].topTitleTxt.titleTxt1.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				newsItemArray[a].topTitleTxt.titleTxt2.txt.text = newsDescription;
				newsItemArray[a].topTitleTxt.titleTxt2.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				newsItemArray[a].topTitleTxt.titleTxt3.txt.text = itemTitle;
				newsItemArray[a].topTitleTxt.titleTxt3.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				newsItemArray[a].topTitleTxt.y = -75;
				//
				if (newsDescription != "") {
					newsItemArray[a].topTitleTxt.titleTxt2.y = 40;
					newsItemArray[a].topTitleTxt.y = -115;
					//
					if (itemTitle != "") {
						newsItemArray[a].topTitleTxt.titleTxt3.y = 80;
						newsItemArray[a].topTitleTxt.y = -155;
					}
				}
				//
				if(itemImage == ""){
					newsItemArray[a].contentTxt.x = Math.floor(0);
					//
					newsItemArray[a].picture.visible = false;
					newsItemArray[a].backPicture.visible = false;
					newsItemArray[a].back.visible = false;
				}
				else{
					newsItemArray[a].contentTxt.x = Math.floor(370);
					//
					thumbLoader[a] = new Loader();
					thumbLoader[a].load (new URLRequest(itemImage));
					thumbLoader[a].contentLoaderInfo.addEventListener (Event.COMPLETE, itemImageLoadComplete, false, 0, true);
					thumbLoader[a].contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, itemImageLoadProgress);
					//
					TweenMax.to (newsItemArray[a].preLoader, 0.5, {alpha:1, ease:Expo.easeOut});
					//
					newsItemArray[a].picture.attachPicture.alpha = 0;
					newsItemArray[a].picture.attachPicture.addChild (thumbLoader[a]);
				}
				//
				newsItemArray[a].contentTxt.dateTxt.txt.htmlText = itemDate;
				newsItemArray[a].contentTxt.dateTxt.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				newsItemArray[a].contentTxt.descTxt.txt.htmlText = itemDescription;
				newsItemArray[a].contentTxt.descTxt.txt.width = 590;
				newsItemArray[a].contentTxt.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				if (itemLink == "") {
					newsItemArray[a].btOpenURL.visible = false;
				}
				else {
					newsItemArray[a].btOpenURL.instanceUrl = itemLink;
					newsItemArray[a].btOpenURL.buttonMode = true;
					newsItemArray[a].btOpenURL.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
					newsItemArray[a].btOpenURL.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
					newsItemArray[a].btOpenURL.addEventListener (MouseEvent.CLICK, btOpenUrlClick);
					newsItemArray[a].btOpenURL.visible = true;
				}
				//
				newsItemArray[a].btOpenURL.x = Math.floor(newsItemArray[a].contentTxt.x);
				newsItemArray[a].btOpenURL.y = Math.floor(newsItemArray[a].contentTxt.y + newsItemArray[a].contentTxt.height + 10)
				//
				newsContent.newsDetails.attachItems.addChild (newsItem);
				newsItemArray[a].x = a * stage.stageWidth;
				//
				TweenMax.to (newsItemArray[a], 0.5, {alpha:1, ease:Expo.easeOut, delay:a * 0.2});
				//
				setNewsItemPositions ();
				//
				if (myCurrentNewsID == 0) {
					newsContent.newsDetails.navBts.btBack.visible = false;
					newsContent.newsDetails.navBts.btNext.visible = true;
				}
				else {
					if (myCurrentNewsID == newsXmlTotalItems - 1) {
						newsContent.newsDetails.navBts.btBack.visible = true;
						newsContent.newsDetails.navBts.btNext.visible = false;
					}
					else {
						newsContent.newsDetails.navBts.btBack.visible = true;
						newsContent.newsDetails.navBts.btNext.visible = true;
					}
				}
				//
				newsContent.newsDetails.navBts.btNext.buttonMode = true;
				newsContent.newsDetails.navBts.btNext.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
				newsContent.newsDetails.navBts.btNext.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
				newsContent.newsDetails.navBts.btNext.addEventListener (MouseEvent.CLICK, newsBtNextClick);
				//
				newsContent.newsDetails.navBts.btBack.buttonMode = true;
				newsContent.newsDetails.navBts.btBack.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
				newsContent.newsDetails.navBts.btBack.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
				newsContent.newsDetails.navBts.btBack.addEventListener (MouseEvent.CLICK, newsBtBackClick);
			}
			initNewsContent();
		}
		//
		private function itemImageLoadProgress (event:ProgressEvent):void {
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
					newsItemArray[a].preLoader.percentTxt.txt.text = "LOADING " + Math.floor(100 * percent) + "%";
					newsItemArray[a].preLoader.percentTxt.txt.autoSize = TextFieldAutoSize.LEFT;
					if (loaded == total) {
						TweenMax.to (newsItemArray[a].preLoader, 0.5, {alpha:0, ease:Expo.easeOut});
						TweenMax.to (newsItemArray[a].picture.attachPicture, 1, {alpha:1, ease:Expo.easeOut});
					}
				}
			}
		}
		//
		private function itemImageLoadComplete (event:Event):void {
			var pictureNewSize = event.target.content;
			//
			pictureNewSize.width = 345;
			pictureNewSize.height = 210;
			pictureNewSize.smoothing = true;
		}
		//
		private function btOpenUrlClick(event:MouseEvent) {
			var rURL:URLRequest = new URLRequest(event.currentTarget.instanceUrl);
			navigateToURL (rURL, '_blank');
		}
		//
		private function btTimelineOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function btTimelineOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function newsBtNextClick (event:MouseEvent) {
			//
			newsContent.newsDetails.navBts.btBack.visible = true;
			//
			TweenMax.to (newsItemArray[myCurrentNewsID], 0.5, {x:0 - stage.stageWidth, ease:Cubic.easeOut});
			//
			myCurrentNewsID = myCurrentNewsID + 1;
			//
			if (myCurrentNewsID == newsXmlTotalItems - 1) {
				newsContent.newsDetails.navBts.btNext.visible = false;
			}
			//
			TweenMax.to (newsItemArray[myCurrentNewsID], 0.5, {x:0, ease:Cubic.easeOut, onComplete:setNewsItemPositions});
		}
		//
		private function newsBtBackClick (event:MouseEvent) {
			//
			newsContent.newsDetails.navBts.btNext.visible = true;
			//
			TweenMax.to (newsItemArray[myCurrentNewsID], 0.5, {x:stage.stageWidth, ease:Cubic.easeOut});
			//
			myCurrentNewsID = myCurrentNewsID - 1;
			//
			if (myCurrentNewsID == 0) {
				newsContent.newsDetails.navBts.btBack.visible = false;
			}
			//
			TweenMax.to (newsItemArray[myCurrentNewsID], 0.5, {x:0, ease:Cubic.easeOut, onComplete:setNewsItemPositions});
		}
		//
		private function setNewsItemPositions () {
			//
			var ItemNr:String;
			var ItemNrTotal:String;
			//
			if (myCurrentNewsID + 1 <= newsXmlTotalItems) {
				ItemNr = "" + int(myCurrentNewsID+1);
			}
			else {
				ItemNr = "" + newsXmlTotalItems;
			}
			//
			if (myCurrentNewsID + 1 < 100) {
				if (myCurrentNewsID + 1 < 10) {
					ItemNr = "00" + ItemNr;
				}
				else {
					ItemNr = "0" + ItemNr;
				}
			}
			//
			if (newsXmlTotalItems < 100) {
				if (newsXmlTotalItems < 10) {
					ItemNrTotal = "00" + newsXmlTotalItems;
				}
				else {
					ItemNrTotal = "0" + newsXmlTotalItems;
				}
				newsContent.newsDetails.navBts.txt.text = ItemNr + " of " + ItemNrTotal;
				newsContent.newsDetails.navBts.txt.autoSize = TextFieldAutoSize.LEFT;
				newsContent.newsDetails.navBts.btNext.x = Math.floor(newsContent.newsDetails.navBts.txt.x + newsContent.newsDetails.navBts.txt.width + 5);
			}
			else {
				newsContent.newsDetails.navBts.txt.text = ItemNr + " of " + newsXmlTotalItems;
				newsContent.newsDetails.navBts.txt.autoSize = TextFieldAutoSize.LEFT;
				newsContent.newsDetails.navBts.btNext.x = Math.floor(newsContent.newsDetails.navBts.txt.x + newsContent.newsDetails.navBts.txt.width + 5);
			}
		}
		//
		public function resizeHandler (e:Event):void {
			//
			newsContent.x = 0;
			newsContent.y = 0;
			//
			newsContent.middleBar.x = 0;
			newsContent.middleBar.y = stage.stageHeight - 50;
			newsContent.middleBar.height = 50;
			//
			if (middleBarOpen == true) {
				newsContent.middleBar.width = stage.stageWidth;
			}
			else {
				newsContent.middleBar.width = 0;
			}
			//
			if(newsDetailsOpen == true){
				newsContent.newsDetails.x = 40;
				//
				for (var i:Number = 0; i < newsXmlTotalItems; i++) {
					if (i < myCurrentNewsID) {
						newsItemArray[i].x = 0 - stage.stageWidth;
					}
					else if (i == myCurrentNewsID) {
						newsItemArray[i].x = 0;
					}
					else if (i > myCurrentNewsID) {
						newsItemArray[i].x = stage.stageWidth;
					}
				}
			}
			else{
				newsContent.newsDetails.x = stage.stageWidth;
			}
			newsContent.newsDetails.y = Math.floor(stage.stageHeight/2 - 35 - 40);
			newsContent.newsDetails.masker.width = stage.stageWidth;
		}
	}
}