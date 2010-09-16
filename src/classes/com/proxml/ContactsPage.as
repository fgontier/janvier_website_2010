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

	public class ContactsPage extends AbstractPage {
		//
		public var contactContent:MovieClip;
		private var middleBarOpen:Boolean = false;
		private var blackBarOpen:Boolean = false;
		private var contactFormOpen:Boolean = false;

		private var newsTitle1:String;
		private var newsTitle2:String;
		private var newsTitle3:String;
		private var messageTitle:String;
		private var messageDescription:String;

		public var loader:URLLoader = new URLLoader();
		public var req:URLRequest = new URLRequest("contactform.php");
		public var variables:URLVariables = new URLVariables();
		//
		public function ContactsPage () {
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
			contactContent.x = 0;
			contactContent.y = 0;
			//
			contactContent.middleBar.x = 0;
			contactContent.middleBar.y = stage.stageHeight - 50;
			contactContent.middleBar.width = 0;
			contactContent.middleBar.height = 50;
			//
			contactContent.blackBar.x = stage.stageWidth;
			contactContent.blackBar.y = Math.floor(stage.stageHeight/2 - 110);
			contactContent.blackBar.width = 0;
			contactContent.blackBar.height = stage.stageHeight/2 + 110;
			//
			contactContent.contactForm.x = -830;
			contactContent.contactForm.y = Math.floor(contactContent.blackBar.y + contactContent.blackBar.height/2 - contactContent.contactForm.height/2 - 25);
			//
			contactContent.topTitleTxt.x = -830;
			contactContent.topTitleTxt.y = Math.floor(contactContent.blackBar.y - contactContent.topTitleTxt.height - 10);
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
			stage.removeEventListener (Event.RESIZE, resizeHandler);
			//
			TweenMax.to (this, 0.3, {alpha:0, onComplete:transitionOutComplete});
		}
		//
		private function initMiddleBar () {
			middleBarOpen = true;
			TweenMax.to (contactContent.middleBar, 0.5, {width:stage.stageWidth, ease:Cubic.easeOut, onComplete:initBlackBar});
		}
		//
		private function initBlackBar () {
			blackBarOpen = true;
			TweenMax.to (contactContent.blackBar, 0.5, {width:stage.stageWidth, ease:Cubic.easeOut, onComplete:initContactForm});
		}
		//
		private function initContactForm () {
			//
			var myContactXML:XML = IXml(assets.contactXml).xml;
			//
			newsTitle1 = myContactXML.title1.text();
			newsTitle2 = myContactXML.title2.text();
			newsTitle3 = myContactXML.title3.text();
			//
			messageTitle = myContactXML.message.title.text();
			messageDescription = myContactXML.message.description.text();
			//
			contactContent.topTitleTxt.titleTxt1.txt.htmlText = newsTitle1;
			contactContent.topTitleTxt.titleTxt1.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			contactContent.topTitleTxt.titleTxt2.txt.htmlText = newsTitle2;
			contactContent.topTitleTxt.titleTxt2.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			contactContent.topTitleTxt.titleTxt3.txt.htmlText = newsTitle3;
			contactContent.topTitleTxt.titleTxt3.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			if (newsTitle2 != "") {
				contactContent.topTitleTxt.titleTxt2.y = 40;
				//
				if (newsTitle3 != "") {
					contactContent.topTitleTxt.titleTxt3.y = 80;
				}
			}
			//
			contactContent.topTitleTxt.y = Math.floor(contactContent.blackBar.y - contactContent.topTitleTxt.height - 10);
			//
			contactContent.contactForm.messageTitleTxt.txt.htmlText = messageTitle;
			contactContent.contactForm.messageTitleTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			contactContent.contactForm.messageDescTxt.txt.htmlText = messageDescription;
			contactContent.contactForm.messageDescTxt.txt.width = 460;
			contactContent.contactForm.messageDescTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			//
			contactFormOpen = true;
			TweenMax.to (contactContent.topTitleTxt, 0.5, {x:40, ease:Cubic.easeOut});
			TweenMax.to (contactContent.contactForm, 0.5, {x:40, ease:Cubic.easeOut});
			//
			initForm ();
		}
		//
		private function initForm () {
			//
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			req.method = URLRequestMethod.POST;
			//
			contactContent.contactForm.form.inName.tabIndex = 0;
			contactContent.contactForm.form.inEmail.tabIndex = 1;
			contactContent.contactForm.form.inMessage.tabIndex = 2;
			//
			contactContent.contactForm.form.inName.addEventListener (Event.CHANGE, inErrorCheck);
			contactContent.contactForm.form.inEmail.addEventListener (Event.CHANGE, inErrorCheck);
			contactContent.contactForm.form.inMessage.addEventListener (Event.CHANGE, inErrorCheck);
			//
			contactContent.contactForm.form.btSend.buttonMode = true;
			contactContent.contactForm.form.btSend.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
			contactContent.contactForm.form.btSend.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
			contactContent.contactForm.form.btSend.addEventListener (MouseEvent.CLICK, sendForm);
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
		private function inErrorCheck (event:Event):void {
			if (contactContent.contactForm.form.inError.text.length>0) {
				contactContent.contactForm.form.inError.text = "";
			}
		}
		//
		function sendForm (evt:MouseEvent):void {
			//
			if (contactContent.contactForm.form.inName.text.length<=0) {
				contactContent.contactForm.form.inError.text = "Username Required";
			}
			else if (!contactContent.contactForm.form.inEmail.text.length || contactContent.contactForm.form.inEmail.text.indexOf("@") == -1 || contactContent.contactForm.form.inEmail.text.indexOf(".") == -1) {
				contactContent.contactForm.form.inError.text = "missing field/Invalid email";
			}
			else if (contactContent.contactForm.form.inMessage.text==""||contactContent.contactForm.form.inMessage.text.length<=1) {
				contactContent.contactForm.form.inError.text = "Message Required";
			}
			else {
				contactContent.contactForm.form.inError.text = "Sending Message - Please wait";
				variables.senderName = contactContent.contactForm.form.inName.text;
				variables.senderEmail = contactContent.contactForm.form.inEmail.text;
				variables.senderMsg = contactContent.contactForm.form.inMessage.text;
				req.data = variables;
				loader.load (req);
				loader.addEventListener (Event.COMPLETE, receiveLoad);
			}
		}
		//
		function receiveLoad (evt:Event):void {
			if (evt.target.data.retval == 1) {
				contactContent.contactForm.form.inError.text = "Message Submited";
				clearForm ();
			}
			else {
				contactContent.contactForm.form.inError.text = "Error Sending Message";
				clearForm ();
			}
		}
		//
		private function clearForm () {
			contactContent.contactForm.form.inName.text = "";
			contactContent.contactForm.form.inEmail.text = "";
			contactContent.contactForm.form.inMessage.text = "";
			//
			contactContent.contactForm.form.btSend.buttonMode = true;
			contactContent.contactForm.form.btSend.addEventListener (MouseEvent.MOUSE_OVER, btTimelineOver);
			contactContent.contactForm.form.btSend.addEventListener (MouseEvent.MOUSE_OUT, btTimelineOut);
			contactContent.contactForm.form.btSend.addEventListener (MouseEvent.CLICK, sendForm);
		}
		//
		public function resizeHandler (e:Event):void {
			//
			contactContent.x = 0;
			contactContent.y = 0;
			//
			contactContent.middleBar.x = 0;
			contactContent.middleBar.y = stage.stageHeight - 50;
			contactContent.middleBar.height = 50;
			//
			if (middleBarOpen == true) {
				contactContent.middleBar.width = stage.stageWidth;
			}
			else {
				contactContent.middleBar.width = 0;
			}
			//
			contactContent.blackBar.x = stage.stageWidth;
			contactContent.blackBar.y = Math.floor(stage.stageHeight/2 - 110);
			contactContent.blackBar.height = stage.stageHeight/2 + 110;
			//
			if (blackBarOpen == true) {
				contactContent.blackBar.width = stage.stageWidth;
			}
			else {
				contactContent.blackBar.width = 0;
			}
			//
			if (contactFormOpen == true) {
				contactContent.contactForm.x = 40;
				contactContent.topTitleTxt.x = 40;
			}
			else {
				contactContent.contactForm.x = -830;
				contactContent.topTitleTxt.x = -830;
			}
			contactContent.contactForm.y = Math.floor(contactContent.blackBar.y + contactContent.blackBar.height/2 - contactContent.contactForm.height/2 - 25);
			contactContent.topTitleTxt.y = Math.floor(contactContent.blackBar.y - contactContent.topTitleTxt.height - 10);
		}
	}
}