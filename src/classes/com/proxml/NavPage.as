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
	//

	public class NavPage extends AbstractPage {
		//
		public var bottomBar:MovieClip;
		public var mainMenu:MovieClip;
		public var btFullScreen:MovieClip;
		//
		private var buttons:Array;
		private var bottomBarState:String = "hide";
		//
		private var mainMenuState:String = "middle";
		//
		public var myNewsTitle:String;
		public var myNewsLink:String;
		public var myNewsDescription:String;
		public var myNewsPubDate:String;
		public var myNewsGuid:String;
		//
		private var ourWorkXmlTotalItems:Number;
		public var myWorkTitle:String;
		public var myWorkDescription:String;
		public var myWorkLink:String;
		public var myWorkDate:String;
		public var myWorkThumbnail:String;
		//
		private var indexMax:int = 0;
		private var lenghtCharLine:int;
		private var indexInit:int;
		//
		private var myNewsXmlLoaded:Boolean = false;
		//
		private var isFullScreen:Boolean = false;
		//
		public function NavPage () {
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
			TweenMax.to (this, 0.3, {alpha:1, ease:Cubic.easeOut, onComplete:transitionInComplete});
			//
			mainMenu.x = 0 - mainMenu.width - 50;
			mainMenu.y = Math.floor(stage.stageHeight/2 - 100);
			//
			bottomBar.workBox.btVisitProject.visible = false;
			bottomBar.newsBox.btReadMore.visible = false;
			//
			placeBottomBar ();
			placeMainMenu ();
			placeFullScreenButton();
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
		private function placeFullScreenButton(){
			btFullScreen.buttonMode = true;
			btFullScreen.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
			btFullScreen.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
			btFullScreen.addEventListener (MouseEvent.CLICK, clickFullScreen);
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
		private function clickFullScreen (event:MouseEvent) {
			if(isFullScreen == true){
				exitFullScreen();
				isFullScreen = false;
			}
			else{
				goFullScreen();
				isFullScreen = true;
			}
		}
		//
		private function goFullScreen():void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		//
		private function exitFullScreen():void {
			stage.displayState = StageDisplayState.NORMAL;
		}
		//
		private function placeBottomBar ():void {
			bottomBar.x = 0;
			bottomBar.y = stage.stageHeight;
			bottomBar.separatorLine.y = 15;
			//
			loadWorkXml();
			//
////////////// EDITED BY FRED
			//loadNewsXml();
			//
			setBottomBarMinimized ();
			//
////////////// EDITED BY FRED
			//stage.addEventListener (MouseEvent.MOUSE_MOVE, getMousePosition);
			//
////////////// EDITED BY FRED
/*			bottomBar.btRSS.buttonMode = true;
			bottomBar.btRSS.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
			bottomBar.btRSS.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
			bottomBar.btRSS.addEventListener (MouseEvent.CLICK, clickRss);
*/			
		}
		//
		public function addMouseMoveListener(){
////////////// EDITED BY FRED
			//stage.addEventListener (MouseEvent.MOUSE_MOVE, getMousePosition);
		}
		//
		public function removeMouseMoveListener(){
////////////// EDITED BY FRED
			//stage.removeEventListener (MouseEvent.MOUSE_MOVE, getMousePosition);
		}
		//
		private function clickRss(event:MouseEvent){
			var rURL:URLRequest = new URLRequest("xml/news.xml");
			navigateToURL (rURL, '_blank');
		}
		//
		private function placeMainMenu () {
			TweenMax.to (mainMenu, 0.5, {x:Math.floor(40), y:Math.floor(stage.stageHeight/2 - 100), ease:Cubic.easeOut});
			//
			mainMenu.attachLogo.addChild (assets.myLogo.loader);
			IDisplayObject(assets.myLogo).visible = true;
			mainMenu.attachLogo.smoothing = true;
			//
			mainMenu.verticalLine.x = Math.floor(mainMenu.attachLogo.width + 20);
			mainMenu.verticalLine.y = Math.floor(mainMenu.attachLogo.height/2 - mainMenu.verticalLine.height/2);
			mainMenu.menuItems.x = Math.floor(mainMenu.verticalLine.x + 20);
			mainMenu.menuItems.y = Math.floor(mainMenu.verticalLine.height/2 - mainMenu.menuItems.height/2);
			//
			activateMainMenu ();
			//
			Gaia.api.afterGoto (onAfterGoto);
			Gaia.api.afterComplete (onAfterGoto);
		}
		//
		public function loadWorkXml(){
			//
			var myWorkXML:XML = IXml(assets.workXml).xml;
			//
			ourWorkXmlTotalItems = myWorkXML.item.length();
			//
			myWorkTitle = myWorkXML.item.title1[0].text();
			myWorkDescription = myWorkXML.item.description[0].text();
			myWorkLink = myWorkXML.item.url[0].text();
			myWorkDate = myWorkXML.item.date[0].text();
			myWorkThumbnail = myWorkXML.item.small_thumbnail[0].text();
			//
			placeWorkXmlItems();
		}
		//
		private function placeWorkXmlItems(){
			bottomBar.workBox.titleTxt.txt.htmlText = myWorkTitle;
			bottomBar.workBox.titleTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			bottomBar.workBox.dateTxt.x = Math.floor(bottomBar.workBox.titleTxt.x + bottomBar.workBox.titleTxt.width);
			bottomBar.workBox.dateTxt.txt.htmlText = " |  " + myWorkDate;
			bottomBar.workBox.dateTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			bottomBar.workBox.descTxt.txt.htmlText = myWorkDescription;
			bottomBar.workBox.descTxt.txt.width = 335;
			bottomBar.workBox.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			if (bottomBar.workBox.descTxt.txt.height > 45) {
				for (var i:int = 0; i<2; i++) {
					lenghtCharLine = bottomBar.workBox.descTxt.txt.getLineLength(i+1);
					indexMax = indexMax + lenghtCharLine;
				}
				indexInit = indexMax + 50;
				bottomBar.workBox.descTxt.txt.replaceText (indexInit, bottomBar.workBox.descTxt.txt.length, " ...");
			}
			indexMax = 0;
			//
			bottomBar.workBox.picture.preLoader.alpha = 1;
			bottomBar.workBox.picture.attacher.alpha = 0;
			//
			var tmbLoader:Loader = new Loader();
			tmbLoader.load (new URLRequest(myWorkThumbnail));
			tmbLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, tmbLoaderComplete, false, 0, true);
			//
			bottomBar.workBox.picture.attacher.addChild (tmbLoader);
			//
			bottomBar.workBox.btVisitProject.visible = true;
			bottomBar.workBox.btVisitProject.buttonMode = true;
			bottomBar.workBox.btVisitProject.addEventListener (MouseEvent.MOUSE_OVER, btBottomBarOver);
			bottomBar.workBox.btVisitProject.addEventListener (MouseEvent.MOUSE_OUT, btBottomBarOut);
			bottomBar.workBox.btVisitProject.addEventListener (MouseEvent.CLICK, btVisitProjectClick);
		}
		//
		private function tmbLoaderComplete (event:Event):void {
			var thumbNewSize = event.target.content;
			thumbNewSize.width = 50;
			thumbNewSize.height = 33;
			thumbNewSize.smoothing = true;
			//
			TweenMax.to (bottomBar.workBox.picture.preLoader, 0.3, {alpha:0, ease:Cubic.easeOut});
			TweenMax.to (bottomBar.workBox.picture.attacher, 0.3, {alpha:1, ease:Cubic.easeOut});
		}
		//
		public function loadNewsXml(){
			var myNewsXML:XML = IXml(assets.newsXml).xml;
			//
			myNewsTitle = myNewsXML.channel.item.title[0].text();
			myNewsLink = myNewsXML.channel.item.link[0].text();
			myNewsDescription = myNewsXML.channel.item.description[0].text();
			myNewsPubDate = myNewsXML.channel.item.pubDate[0].text();
			myNewsGuid = myNewsXML.channel.item.guid[0].text();
			//
			placeNewsXmlItems();
		}
		//
		private function placeNewsXmlItems(){
			bottomBar.newsBox.titleTxt.txt.htmlText = myNewsTitle;
			bottomBar.newsBox.titleTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			bottomBar.newsBox.dateTxt.x = Math.floor(bottomBar.newsBox.titleTxt.x + bottomBar.newsBox.titleTxt.width);
			bottomBar.newsBox.dateTxt.txt.htmlText = " |  " + myNewsPubDate;
			bottomBar.newsBox.dateTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			bottomBar.newsBox.descTxt.txt.htmlText = myNewsDescription;
			bottomBar.newsBox.descTxt.txt.width = stage.stageWidth - bottomBar.separatorLine.x - 15 - 20;
			bottomBar.newsBox.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			if (bottomBar.newsBox.descTxt.txt.height > 45) {
				for (var i:int = 0; i<2; i++) {
					lenghtCharLine = bottomBar.newsBox.descTxt.txt.getLineLength(i+1);
					indexMax = indexMax + lenghtCharLine;
				}
				indexInit = indexMax + 80;
				bottomBar.newsBox.descTxt.txt.replaceText (indexInit, bottomBar.newsBox.descTxt.txt.length, " ...");
			}
			indexMax = 0;
			//
			myNewsXmlLoaded = true;
			//
			bottomBar.newsBox.btReadMore.visible = true;
			bottomBar.newsBox.btReadMore.buttonMode = true;
			bottomBar.newsBox.btReadMore.addEventListener (MouseEvent.MOUSE_OVER, btBottomBarOver);
			bottomBar.newsBox.btReadMore.addEventListener (MouseEvent.MOUSE_OUT, btBottomBarOut);
			bottomBar.newsBox.btReadMore.addEventListener (MouseEvent.CLICK, btReadMoreClick);
		}
		//
		public function activateMainMenu () {
			mainMenu.menuItems.item1.branch = "index/nav/home";
			mainMenu.menuItems.item2.branch = "index/nav/aboutus";
			mainMenu.menuItems.item3.branch = "index/nav/work";
////////////// EDITED BY FRED
			//mainMenu.menuItems.item4.branch = "index/nav/news";
			mainMenu.menuItems.item5.branch = "index/nav/contacts";
////////////// EDITED BY FRED
			//buttons = [mainMenu.menuItems.item1, mainMenu.menuItems.item2, mainMenu.menuItems.item3, mainMenu.menuItems.item4, mainMenu.menuItems.item5];
			buttons = [mainMenu.menuItems.item1, mainMenu.menuItems.item2, mainMenu.menuItems.item3, mainMenu.menuItems.item5];

			var i:int = buttons.length;
			while (i--) {
				buttons[i].buttonMode = true;
				buttons[i].addEventListener (MouseEvent.CLICK, menuItemClick);
				buttons[i].addEventListener (MouseEvent.MOUSE_OVER, menuItemOver);
				buttons[i].addEventListener (MouseEvent.MOUSE_OUT, menuItemOut);
			}
		}
		//
		public function setBottomBarMinimized () {
			//
			if(mainMenuState == "middle"){
				TweenMax.to (mainMenu, 0.5, {y:Math.floor(stage.stageHeight/2 - 100), ease:Cubic.easeOut});
			}
			else{
				TweenMax.to (mainMenu, 0.5, {y:Math.floor(20), ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/home"){
				TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar, 0.5, {y:Math.floor(stage.stageHeight/2), ease:Cubic.easeOut});
				TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar.back, 0.5, {height:stage.stageHeight/2, ease:Cubic.easeOut});
				TweenMax.to (Gaia.api.getPage("index/nav/home").content.videoPlayer, 0.5, {y:stage.stageHeight/2 - 80, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/aboutus"){
				TweenMax.to (Gaia.api.getPage("index/nav/aboutus").content.middleBar, 0.5, {y:60, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/work"){
				TweenMax.to (Gaia.api.getPage("index/nav/work").content.workContent, 0.5, {y:0, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/news"){
				TweenMax.to (Gaia.api.getPage("index/nav/news").content.newsContent, 0.5, {y:0, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/contacts"){
				TweenMax.to (Gaia.api.getPage("index/nav/contacts").content.contactContent, 0.5, {y:0, ease:Cubic.easeOut});
			}
			//
			TweenMax.to (bottomBar, 0.5, {y:stage.stageHeight - 15, ease:Cubic.easeOut});
			TweenMax.to (bottomBar.separatorLine, 0.5, {y:15, ease:Cubic.easeOut});
			bottomBarState = "minimized";
		}
		//
		public function setBottomBarMaximized () {
			if(mainMenuState == "middle"){
				TweenMax.to (mainMenu, 0.5, {y:Math.floor(stage.stageHeight/2 - 100 - 135), ease:Cubic.easeOut});
			}
			else{
				TweenMax.to (mainMenu, 0.5, {y:Math.floor(20 - 135), ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/home"){
				TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar, 0.5, {y:Math.floor(stage.stageHeight/2 - 135), ease:Cubic.easeOut});
				TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar.back, 0.5, {height:stage.stageHeight/2 + 135, ease:Cubic.easeOut});
				TweenMax.to (Gaia.api.getPage("index/nav/home").content.videoPlayer, 0.5, {y:stage.stageHeight/2 - 80 - 135, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/aboutus"){
				TweenMax.to (Gaia.api.getPage("index/nav/aboutus").content.middleBar, 0.5, {y:60 - 135, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/work"){
				TweenMax.to (Gaia.api.getPage("index/nav/work").content.workContent, 0.5, {y:0 - 135, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/news"){
				TweenMax.to (Gaia.api.getPage("index/nav/news").content.newsContent, 0.5, {y:0 - 135, ease:Cubic.easeOut});
			}
			//
			if(Gaia.api.getCurrentBranch() == "index/nav/contacts"){
				TweenMax.to (Gaia.api.getPage("index/nav/contacts").content.contactContent, 0.5, {y:0 - 135, ease:Cubic.easeOut});
			}
			//
///////////// EDITED BY FRED
			//TweenMax.to (bottomBar, 0.5, {y:stage.stageHeight - 135, ease:Cubic.easeOut});
			//TweenMax.to (bottomBar.separatorLine, 0.5, {y:0, ease:Cubic.easeOut});
			//bottomBarState = "maximized";
		}
		//
		private function getMousePosition (event:MouseEvent) {
			if (mouseY > stage.stageHeight - 15) {
				setBottomBarMaximized ();
			}
			if (mouseY < stage.stageHeight - 135) {
				setBottomBarMinimized ();
			}
		}
		//
		public function setMainMenuTop(){
			TweenMax.to (mainMenu, 0.5, {y:Math.floor(20), ease:Cubic.easeOut});
			mainMenuState = "top";
		}
		//
		public function setMainMenuMiddle(){
			TweenMax.to (mainMenu, 0.5, {y:Math.floor(stage.stageHeight/2 - 100), ease:Cubic.easeOut});
			mainMenuState = "middle";
		}
		//
		private function menuItemOver (event:MouseEvent):void {
			if (event.currentTarget.branch != Gaia.api.getCurrentBranch()) {
				TweenMax.to (event.currentTarget.labelTxt, 0.5, {tint:0xFFFFFF, ease:Cubic.easeOut});
			}
		}
		//
		private function menuItemOut (event:MouseEvent):void {
			if (event.currentTarget.branch != Gaia.api.getCurrentBranch()) {
				TweenMax.to (event.currentTarget.labelTxt, 0.5, {tint:0x609EDB, ease:Cubic.easeOut});
			}
		}
		//
		private function menuItemClick (event:MouseEvent):void {
			Gaia.api.goto (event.currentTarget.branch);
			//
////////////// EDITED BY FRED
			//removeMouseMoveListener();
		}
		//
		private function onAfterGoto (event:GaiaEvent):void {
			var i:int = buttons.length;
			while (i--) {
				var btn:MovieClip = buttons[i];
				if (event.validBranch != btn.branch) {
					btn.enabled = true;
					TweenMax.to (btn.labelTxt, 0.5, {tint:0x609EDB, ease:Cubic.easeOut});
				}
				else {
					TweenMax.to (btn.labelTxt, 0.5, {tint:0xFFFFFF, ease:Cubic.easeOut});
					btn.enabled = false;
				}
			}
		}
		//
		public function btBottomBarOver(event:MouseEvent):void {
			TweenMax.to (event.currentTarget.labelTxt, 0.5, {tint:0x95BFA7, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.back, 0.5, {tint:0xFFFFFF, ease:Cubic.easeOut});
		}
		//
		public function btBottomBarOut(event:MouseEvent):void {
			TweenMax.to (event.currentTarget.labelTxt, 0.5, {tint:0x181D18, ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.back, 0.5, {tint:0x95BFA7, ease:Cubic.easeOut});
		}
		//
		public function btVisitProjectClick(event:MouseEvent):void {
			Gaia.api.goto ("index/nav/work/details/0");
		}
		//
		public function btReadMoreClick(event:MouseEvent):void {
			Gaia.api.goto ("index/nav/news");
		}
		//
		public function resizeHandler (e:Event):void {
			//
			if(mainMenuState == "middle"){
				TweenMax.to (mainMenu, 0.5, {x:Math.floor(40), y:Math.floor(stage.stageHeight/2 - 100), ease:Cubic.easeOut});
			}
			else{
				TweenMax.to (mainMenu, 0.5, {x:Math.floor(40), y:Math.floor(20), ease:Cubic.easeOut});
			}
			//
			if (bottomBarState == "hide") {
				bottomBar.y = stage.stageHeight;
				bottomBar.separatorLine.y = 15;
			}
			else if (bottomBarState == "minimized") {
				bottomBar.y = stage.stageHeight - 15;
				bottomBar.separatorLine.y = 15;
				//
				if(mainMenuState == "middle"){
					TweenMax.to (mainMenu, 0.5, {y:Math.floor(stage.stageHeight/2 - 100), ease:Cubic.easeOut});
				}
				else{
					TweenMax.to (mainMenu, 0.5, {y:Math.floor(20), ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/home"){
					TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar, 0.5, {y:Math.floor(stage.stageHeight/2), ease:Cubic.easeOut});
					TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar.back, 0.5, {height:stage.stageHeight/2, ease:Cubic.easeOut});
					//
					if(Gaia.api.getPage("index/nav/home").content.videoIsFullScreen == false){
						TweenMax.to (Gaia.api.getPage("index/nav/home").content.videoPlayer, 0.5, {y:stage.stageHeight/2 - 80, ease:Cubic.easeOut});
					}
					else{
						TweenMax.to (Gaia.api.getPage("index/nav/home").content.videoPlayer, 0.5, {y:Math.floor(stage.stageHeight/2), ease:Cubic.easeOut});
					}
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/aboutus"){
					TweenMax.to (Gaia.api.getPage("index/nav/aboutus").content.middleBar, 0.5, {y:60, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/work"){
					TweenMax.to (Gaia.api.getPage("index/nav/work").content.workContent, 0.5, {y:0, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/news"){
					TweenMax.to (Gaia.api.getPage("index/nav/news").content.newsContent, 0.5, {y:0, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/contacts"){
					TweenMax.to (Gaia.api.getPage("index/nav/contacts").content.contactContent, 0.5, {y:0, ease:Cubic.easeOut});
				}
			}
			else if (bottomBarState == "maximized") {
				bottomBar.y = stage.stageHeight - 135;
				bottomBar.separatorLine.y = 0;
				//
				if(mainMenuState == "middle"){
					TweenMax.to (mainMenu, 0.5, {y:Math.floor(stage.stageHeight/2 - 100 - 135), ease:Cubic.easeOut});
				}
				else{
					TweenMax.to (mainMenu, 0.5, {y:Math.floor(20 - 135), ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/home"){
					TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar, 0.5, {y:Math.floor(stage.stageHeight/2 - 135), ease:Cubic.easeOut});
					TweenMax.to (Gaia.api.getPage("index/nav/home").content.middleBar.back, 0.5, {height:stage.stageHeight/2 + 135, ease:Cubic.easeOut});
					TweenMax.to (Gaia.api.getPage("index/nav/home").content.videoPlayer, 0.5, {y:stage.stageHeight/2 - 80 - 135, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/aboutus"){
					TweenMax.to (Gaia.api.getPage("index/nav/aboutus").content.middleBar, 0.5, {y:60 - 135, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/work"){
					TweenMax.to (Gaia.api.getPage("index/nav/work").content.workContent, 0.5, {y:0 - 135, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/news"){
					TweenMax.to (Gaia.api.getPage("index/nav/news").content.newsContent, 0.5, {y:0 - 135, ease:Cubic.easeOut});
				}
				//
				if(Gaia.api.getCurrentBranch() == "index/nav/contacts"){
					TweenMax.to (Gaia.api.getPage("index/nav/contacts").content.contactContent, 0.5, {y:0 - 135, ease:Cubic.easeOut});
				}
			}
			bottomBar.back.width = stage.stageWidth;
			//
////////////// EDITED BY FRED
			//bottomBar.btRSS.x = bottomBar.back.width - bottomBar.btRSS.width - 5;
			//
			if (myNewsXmlLoaded == true){
				bottomBar.newsBox.descTxt.txt.htmlText = myNewsDescription;
				bottomBar.newsBox.descTxt.txt.width = stage.stageWidth - bottomBar.separatorLine.x - 15 - 20;
				bottomBar.newsBox.descTxt.txt.autoSize = TextFieldAutoSize.LEFT;
				//
				if (bottomBar.newsBox.descTxt.txt.height > 45) {
					for (var i:int = 0; i<2; i++) {
						lenghtCharLine = bottomBar.newsBox.descTxt.txt.getLineLength(i+1);
						indexMax = indexMax + lenghtCharLine;
					}
					indexInit = indexMax + 80;
					bottomBar.newsBox.descTxt.txt.replaceText (indexInit, bottomBar.newsBox.descTxt.txt.length, " ...");
				}
				indexMax = 0;
			}
			//
			btFullScreen.x = Math.floor(stage.stageWidth - btFullScreen.width - 5)
			btFullScreen.y = Math.floor(5)
		}
	}
}