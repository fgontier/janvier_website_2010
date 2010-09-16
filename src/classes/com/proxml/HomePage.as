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

	public class HomePage extends AbstractPage {

		public var middleBar:MovieClip;
		public var videoPlayer:MovieClip;

		private var middleBarOpen:Boolean=false;
		private var videoPlayerOpen:Boolean=false;

		private var homeVideo:String;

		private var conn:NetConnection;
		private var stream:NetStream;
		public var metaListener:Object=new Object  ;
		public var video:Video=new Video  ;

		private var isPlaying:Boolean;

		private var welcomeText1:String;
		private var welcomeText2:String;
		private var welcomeText3:String;
		private var messageTitle:String;
		private var messageDesc:String;
		private var messageLink:String;

		public var videoIsFullScreen:Boolean=false;

		private var myNewVideoWidth:Number;
		private var myNewVideoHeight:Number;

		private var videoTotalLength:uint;

		private var videoPlaying:Boolean=false;

		public function HomePage () {
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
			videoPlayer.x=Math.floor(stage.stageWidth / 2 + 25 + videoPlayer.back.width / 2);
			videoPlayer.y=-350;
			//
			videoPlayer.videoConsole.btPlay.visible=false;
			videoPlayer.videoConsole.btPause.visible=true;
			//
			middleBar.x=0;
			middleBar.y=Math.floor(stage.stageHeight / 2);
			middleBar.back.width=0;
			middleBar.back.height=stage.stageHeight / 2;
			//
			middleBar.messageTxt.x=40;
			middleBar.messageTxt.y=Math.floor(middleBar.back.height / 2 - middleBar.messageTxt.height / 2);
			middleBar.messageTxt.alpha=0;
			middleBar.messageTxt.btLink.visible=false;
			//
			middleBar.welcomeMsg.x=videoPlayer.x - videoPlayer.back.width / 2;
			middleBar.welcomeMsg.y=Math.floor(middleBar.back.height / 2 - middleBar.welcomeMsg.height / 2);
			middleBar.welcomeMsg.alpha=0;
			//
			TweenMax.to (this,0.3,{alpha:1,onComplete:transitionInComplete});
			//
			Gaia.api.getPage("index/nav").content.addMouseMoveListener ();
			Gaia.api.getPage("index/nav").content.setMainMenuMiddle ();
			//
			initMiddleBar ();
		}
		//
		override public  function transitionOut ():void {
			super.transitionOut ();
			//
			stage.removeEventListener (Event.ENTER_FRAME,stageEnterFrame);
			stage.removeEventListener (Event.RESIZE,resizeHandler);
			stage.removeEventListener (MouseEvent.MOUSE_UP,trackUp);
			//
			closeVideo ();
			//
			TweenMax.to (this,0.3,{alpha:0,onComplete:transitionOutComplete});
		}
		//
		private function initMiddleBar () {
			TweenMax.to (middleBar.back,0.5,{width:stage.stageWidth,ease:Cubic.easeOut});
			middleBarOpen=true;
			//
			loadHomeXml ();
		}
		//
		public function loadHomeXml () {
			var myHomeXML:XML=IXml(assets.homeXml).xml;
			//
			welcomeText1=myHomeXML.title1.text();
			welcomeText2=myHomeXML.title2.text();
			welcomeText3=myHomeXML.title3.text();
			//
			messageTitle=myHomeXML.message.title.text();
			messageDesc=myHomeXML.message.description.text();
			messageLink=myHomeXML.message.link.text();
			//
			homeVideo=myHomeXML.video.text();
			//
			middleBar.welcomeMsg.msgTxt1.txt.htmlText=welcomeText1;
			middleBar.welcomeMsg.msgTxt1.txt.autoSize=TextFieldAutoSize.LEFT;
			middleBar.welcomeMsg.msgTxt2.txt.htmlText=welcomeText2;
			middleBar.welcomeMsg.msgTxt2.txt.autoSize=TextFieldAutoSize.LEFT;
			middleBar.welcomeMsg.msgTxt3.txt.htmlText=welcomeText3;
			middleBar.welcomeMsg.msgTxt3.txt.autoSize=TextFieldAutoSize.LEFT;
			//
			middleBar.welcomeMsg.y=Math.floor(middleBar.back.height / 2 - middleBar.welcomeMsg.height / 2);
			//
			TweenMax.to (middleBar.welcomeMsg,0.5,{alpha:1,ease:Cubic.easeOut});
			//
			middleBar.messageTxt.titleTxt.txt.htmlText=messageTitle;
			middleBar.messageTxt.titleTxt.txt.autoSize=TextFieldAutoSize.LEFT;
			//
			middleBar.messageTxt.descTxt.txt.htmlText=messageDesc;
			middleBar.messageTxt.descTxt.txt.width=middleBar.messageTxt.titleTxt.width;
			middleBar.messageTxt.descTxt.txt.autoSize=TextFieldAutoSize.LEFT;
			//
			if (messageLink != "") {
				middleBar.messageTxt.btLink.visible=true;
				middleBar.messageTxt.btLink.buttonMode=true;
				middleBar.messageTxt.btLink.addEventListener (MouseEvent.MOUSE_OVER,btLinkOver);
				middleBar.messageTxt.btLink.addEventListener (MouseEvent.MOUSE_OUT,btLinkOut);
				middleBar.messageTxt.btLink.addEventListener (MouseEvent.CLICK,btLinkClick);
			}
			else {
				middleBar.messageTxt.btLink.visible=false;
			}
			//
			middleBar.messageTxt.btLink.y=Math.floor(middleBar.messageTxt.descTxt.y + middleBar.messageTxt.descTxt.height + 10);
			//
			middleBar.messageTxt.y=Math.floor(middleBar.back.height / 2 - middleBar.messageTxt.height / 2);
			//
			TweenMax.to (middleBar.messageTxt,0.5,{alpha:1,ease:Cubic.easeOut});
			//
			if (homeVideo != "") {
				initVideoPlayer ();
			} else {
				videoPlayer.visible = false;
			}
		}
		//
		function btLinkOver (event:MouseEvent) {
			TweenMax.to (event.currentTarget.labelTxt,0.5,{tint:0x72A68E,ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.back,0.5,{tint:0xB7BFAF,ease:Cubic.easeOut});
		}
		//
		function btLinkOut (event:MouseEvent) {
			TweenMax.to (event.currentTarget.labelTxt,0.5,{tint:0xB7BFAF,ease:Cubic.easeOut});
			TweenMax.to (event.currentTarget.back,0.5,{tint:0x72A68E,ease:Cubic.easeOut});
		}
		//
		function btLinkClick (event:MouseEvent) {
			var rURL:URLRequest=new URLRequest(messageLink);
			navigateToURL (rURL,'_blank');
		}
		//
		private function initVideoPlayer () {
			TweenMax.to (videoPlayer,0.5,{y:Math.floor(stage.stageHeight / 2 - 80),ease:Cubic.easeOut,onComplete:startVideo});
			videoPlayerOpen=true;
		}
		//
		private function startVideo () {
			//
			conn=new NetConnection  ;
			conn.connect (null);
			stream=new NetStream(conn);
			//
			stream.addEventListener (NetStatusEvent.NET_STATUS,onNetStreamStatus);
			//
			stream.play (homeVideo);
			//
			metaListener.onMetaData=theMeta;
			stream.client=metaListener;
			//
			video.attachNetStream (stream);
			video.width=465;
			video.height=270;
			video.x=0;
			video.y=0;
			video.smoothing=true;
			//
			videoPlayer.videoBox.attachVideo.addChild (video);
			//
			stage.addEventListener (Event.ENTER_FRAME,stageEnterFrame);
			//
			videoPlayer.videoConsole.btPlay.buttonMode=true;
			videoPlayer.videoConsole.btPlay.addEventListener (MouseEvent.MOUSE_OVER,btOver);
			videoPlayer.videoConsole.btPlay.addEventListener (MouseEvent.MOUSE_OUT,btOut);
			videoPlayer.videoConsole.btPlay.addEventListener (MouseEvent.CLICK,btPlayClick);
			//
			videoPlayer.videoConsole.btPause.buttonMode=true;
			videoPlayer.videoConsole.btPause.addEventListener (MouseEvent.MOUSE_OVER,btOver);
			videoPlayer.videoConsole.btPause.addEventListener (MouseEvent.MOUSE_OUT,btOut);
			videoPlayer.videoConsole.btPause.addEventListener (MouseEvent.CLICK,btPauseClick);
			//
			videoPlayer.videoConsole.btFullScreen.buttonMode=true;
			videoPlayer.videoConsole.btFullScreen.addEventListener (MouseEvent.MOUSE_OVER,btFullScreenOver);
			videoPlayer.videoConsole.btFullScreen.addEventListener (MouseEvent.MOUSE_OUT,btFullScreenOut);
			videoPlayer.videoConsole.btFullScreen.addEventListener (MouseEvent.CLICK,btFullScreenClick);
			//
			videoPlayer.videoConsole.videoScrubber.trackingBar.buttonMode=true;
			videoPlayer.videoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.CLICK,goToSecond);
			videoPlayer.videoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.MOUSE_DOWN,trackDown);
			stage.addEventListener (MouseEvent.MOUSE_UP,trackUp);
			videoPlayer.videoConsole.videoScrubber.trackingBar.addEventListener (MouseEvent.MOUSE_UP,trackUp);
			//
			videoPlaying=true;
		}
		//
		private function theMeta (data:Object):void {
			videoTotalLength=data.duration;
		}
		//
		private function goToSecond (event:MouseEvent):void {
			if (videoPlayer.videoConsole.videoScrubber.trackingBar.mouseX < videoPlayer.videoConsole.videoScrubber.streamingBar.width) {
				var percentAcross:Number=videoPlayer.videoConsole.videoScrubber.trackingBar.mouseX / videoPlayer.videoConsole.videoScrubber.trackingBar.width;
				stream.seek (videoTotalLength * percentAcross);
			}
		}
		//
		private function trackDown (event:MouseEvent):void {
			stage.addEventListener (MouseEvent.MOUSE_MOVE,scrubTo);
		}
		//
		private function trackUp (event:MouseEvent):void {
			stage.removeEventListener (MouseEvent.MOUSE_MOVE,scrubTo);
		}
		//
		private function scrubTo (event:MouseEvent):void {
			if (videoPlayer.videoConsole.videoScrubber.trackingBar.mouseX < videoPlayer.videoConsole.videoScrubber.streamingBar.width) {
				var percentAcross:Number=videoPlayer.videoConsole.videoScrubber.trackingBar.mouseX / videoPlayer.videoConsole.videoScrubber.trackingBar.width;
				stream.seek (videoTotalLength * percentAcross);
			}
		}
		//
		private function stageEnterFrame (event:Event):void {
			//
			var nowSecs:Number=stream.time;
			var totalSecs:Number=videoTotalLength;
			//
			if (nowSecs > 0) {
				//
				var amountPlayed:Number=nowSecs / totalSecs;
				var amountLoaded:Number=stream.bytesLoaded / stream.bytesTotal;
				//
				videoPlayer.videoConsole.videoScrubber.playingBar.width=videoPlayer.videoConsole.videoScrubber.backBar.width * amountPlayed;
				videoPlayer.videoConsole.videoScrubber.scrubber.x=videoPlayer.videoConsole.videoScrubber.playingBar.width - videoPlayer.videoConsole.videoScrubber.scrubber.width;
				videoPlayer.videoConsole.videoScrubber.streamingBar.width=videoPlayer.videoConsole.videoScrubber.backBar.width * amountLoaded;
			}
		}
		//
		private function btOver (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("over");
		}
		//
		private function btOut (event:MouseEvent) {
			event.currentTarget.gotoAndPlay ("out");
		}
		//
		private function btPlayClick (event:MouseEvent) {
			//
			videoPlayer.videoConsole.btPlay.visible=false;
			videoPlayer.videoConsole.btPause.visible=true;
			//
			if (videoPlaying == false) {
				startVideo ();
			}
			else {
				stream.resume ();
			}
		}
		//
		private function btPauseClick (event:MouseEvent) {
			//
			videoPlayer.videoConsole.btPlay.visible=true;
			videoPlayer.videoConsole.btPause.visible=false;
			//
			stream.pause ();
		}
		//
		private function onNetStreamStatus (event:NetStatusEvent):void {
			if (event.info.code == "NetStream.Play.Stop") {
				closeVideo ();
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
			if (videoIsFullScreen == false) {
				openFullScreenVideo ();
				Gaia.api.getPage("index/nav").content.removeMouseMoveListener ();
				videoIsFullScreen=true;
			}
			else {
				closeFullScreenVideo ();
				Gaia.api.getPage("index/nav").content.addMouseMoveListener ();
				videoIsFullScreen=false;
			}
		}
		//
		private function openFullScreenVideo () {
			TweenMax.to (videoPlayer,0.5,{x:Math.floor(stage.stageWidth / 2),y:Math.floor(stage.stageHeight / 2),ease:Cubic.easeOut});
			TweenMax.to (videoPlayer.backShapes,0.5,{alpha:0,ease:Cubic.easeOut});
			Gaia.api.getPage("index/nav").content.mainMenu.visible=false;
			Gaia.api.getPage("index/nav").content.bottomBar.visible=false;
			TweenMax.to (videoPlayer.backVideo,0.5,{x:0,y:0,width:stage.stageWidth,height:stage.stageHeight,ease:Cubic.easeOut});
			TweenMax.to (videoPlayer.back,0.5,{alpha:0,ease:Cubic.easeOut});
			//
			TweenMax.to (videoPlayer.videoConsole.back,0.5,{alpha:1,ease:Cubic.easeOut});
			//
			myNewVideoWidth=stage.stageWidth - 10;
			myNewVideoHeight=myNewVideoWidth * 270 / 465;
			//
			if (myNewVideoHeight > stage.stageHeight - 10) {
				myNewVideoHeight=stage.stageHeight - 10;
				myNewVideoWidth=myNewVideoHeight * 465 / 270;
			}
			//
			TweenMax.to (videoPlayer.videoConsole,0.5,{y:Math.floor(stage.stageHeight / 2 - 30),ease:Cubic.easeOut});
			//
			TweenMax.to (videoPlayer.videoBox,0.5,{x:0,y:0,width:myNewVideoWidth,height:myNewVideoHeight,ease:Cubic.easeOut});
		}
		//
		private function closeFullScreenVideo () {
			TweenMax.to (videoPlayer.videoBox,0.5,{x:0,y:-10,width:465,height:270,ease:Cubic.easeOut});
			TweenMax.to (videoPlayer.videoConsole,0.5,{y:127,ease:Cubic.easeOut});
			TweenMax.to (videoPlayer.videoConsole.back,0.5,{alpha:0,ease:Cubic.easeOut});
			TweenMax.to (videoPlayer.back,0.5,{alpha:1,ease:Cubic.easeOut});
			TweenMax.to (videoPlayer.backVideo,0.5,{x:0,y:-10,width:465,height:270,ease:Cubic.easeOut});
			Gaia.api.getPage("index/nav").content.mainMenu.visible=true;
			Gaia.api.getPage("index/nav").content.bottomBar.visible=true;
			TweenMax.to (videoPlayer.backShapes,0.5,{alpha:1,ease:Cubic.easeOut});
			TweenMax.to (videoPlayer,0.5,{x:Math.floor(stage.stageWidth / 2 + 25 + videoPlayer.back.width / 2),y:Math.floor(stage.stageHeight / 2 - 80),ease:Cubic.easeOut});
		}
		//
		public function resizeHandler (e:Event):void {
			//
			middleBar.x=0;
			TweenMax.to (middleBar,0.5,{y:Math.floor(stage.stageHeight / 2),ease:Cubic.easeOut});
			middleBar.back.height=stage.stageHeight / 2;
			TweenMax.to (middleBar.messageTxt,0.5,{y:Math.floor(middleBar.back.height / 2 - middleBar.messageTxt.height / 2),ease:Cubic.easeOut});
			//
			if (middleBarOpen == true) {
				middleBar.back.width=stage.stageWidth;
			}
			else {
				middleBar.back.width=0;
			}
			//
			if (videoIsFullScreen == false) {
				videoPlayer.x=Math.floor(stage.stageWidth / 2 + 25 + videoPlayer.back.width / 2);
				if (videoPlayerOpen == true) {
					TweenMax.to (videoPlayer,0.5,{y:Math.floor(stage.stageHeight / 2 - 80),ease:Cubic.easeOut});
				}
				else {
					videoPlayer.y=-350;
				}
			}
			else {
				videoPlayer.x=Math.floor(stage.stageWidth / 2);
				videoPlayer.y=Math.floor(stage.stageHeight / 2);
				//
				videoPlayer.backVideo.width=stage.stageWidth;
				videoPlayer.backVideo.height=stage.stageHeight;
				//
				myNewVideoWidth=stage.stageWidth - 10;
				myNewVideoHeight=myNewVideoWidth * 270 / 465;
				//
				if (myNewVideoHeight > stage.stageHeight - 10) {
					myNewVideoHeight=stage.stageHeight - 10;
					myNewVideoWidth=myNewVideoHeight * 465 / 270;
				}
				//
				videoPlayer.videoConsole.y=Math.floor(stage.stageHeight / 2 - 30);
				//
				videoPlayer.videoBox.width=myNewVideoWidth;
				videoPlayer.videoBox.height=myNewVideoHeight;
			}
			middleBar.welcomeMsg.x=videoPlayer.x - videoPlayer.back.width / 2;
			TweenMax.to (middleBar.welcomeMsg,0.5,{y:Math.floor(middleBar.back.height / 2 - middleBar.welcomeMsg.height / 2),ease:Cubic.easeOut});
		}
		//
		private function closeVideo () {
			if (videoPlaying == true) {
				//
				stream.close ();
				stream.removeEventListener (NetStatusEvent.NET_STATUS,onNetStreamStatus);
				stage.removeEventListener (Event.ENTER_FRAME,stageEnterFrame);
				//
				videoPlayer.videoConsole.btPlay.visible=true;
				videoPlayer.videoConsole.btPause.visible=false;
				//
				videoPlayer.videoConsole.videoScrubber.playingBar.width=0;
				videoPlayer.videoConsole.videoScrubber.scrubber.x=0;
				//
				videoPlaying=false;
			}
		}
	}
}