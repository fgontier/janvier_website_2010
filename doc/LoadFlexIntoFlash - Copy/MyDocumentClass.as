﻿// Document class for loading Flex into Flash example
//
// Jim Armstrong, algorithmist.wordpress.com
//
// This is a hack, but have fun with it :)

package
{
  import flash.display.*;
  import flash.events.*;
  import flash.net.URLRequest;

  import flash.system.ApplicationDomain;
  import flash.system.LoaderContext;

  public class MyDocumentClass extends MovieClip
  {
    private var __loadedClip:MovieClip;     // loaded content cast as MovieClip
	private var __loader:Loader;            // reference to external asset loader
    private var __application:*;            // reference to loaded application (<mx:Application>)

    public function MyDocumentClass()
    {
      __loadedClip = null;
	  
	  __loader            = new Loader();
      var info:LoaderInfo = __loader.contentLoaderInfo;

      // info.addEventListener(ProgressEvent.PROGRESS, __onProgress); - uncomment if you want to add load progress handling
      info.addEventListener(Event.COMPLETE        , __onComplete);
      //info.addEventListener(Event.INIT            , __onInit    ); - uncomment if you want init event handling
      info.addEventListener(IOErrorEvent.IO_ERROR , __onIOError );

      load("myFlexApp.swf");
	}

    public function load(_file:String):void
	{
      var urlRequest:URLRequest = new URLRequest(_file);
			
      var loaderContext:LoaderContext = new LoaderContext();
      loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			
      __loader.load(urlRequest, loaderContext);
    }

	private function __onComplete(_evt:Event):void
    { 
      addChild(__loader);

      __loadedClip = __loader.content as MovieClip;
      __loadedClip.addEventListener(Event.ENTER_FRAME, __onFlexAppLoaded);
    }

    // poll loaded Flex clip until application property is set (Flex completes its own internal initialization)
    private function __onFlexAppLoaded(_evt:Event):void
    {
      if( __loadedClip.application != null )
      {
        __loadedClip.removeEventListener(Event.ENTER_FRAME, __onFlexAppLoaded);
 
        __application = __loadedClip.application;

	    // handler for Flex button click event
        __application.addEventListener("FlexButtonClick", __onClick);
	  }
	}


    private function __cleanup():void
    {
      var info:LoaderInfo = __loader.contentLoaderInfo;

	  // info.removeEventListener(ProgressEvent.PROGRESS, __onProgress);
	  // info.removeEventListener(Event.INIT    , __onInit    );
      info.removeEventListener(Event.COMPLETE, __onComplete);
      info.removeEventListener(IOErrorEvent.IO_ERROR , __onIOError );
    }

    private function __onIOError(_evt:IOErrorEvent):void
    {
      trace( "io error - check file names and location" );
	}

    private function __onInitialize(_e:Event):void
    {
      __cleanup();
    }

    private function __onClick(_evt:Event):void
    {
      // disable Flex button and call the myFunction() method - notice that you have to know something about what's being loaded
      __application.__myButton__.enabled = false;
      __application.myFunction();
 	}
  }
}