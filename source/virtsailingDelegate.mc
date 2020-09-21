//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.WatchUi;
using Toybox.Attention;

class virtsailingDelegate extends WatchUi.BehaviorDelegate {
  
   // Controller class
    var mController;	

    // for double touch ? (in ms)
    hidden const DOUBLETOUCH_MS = 250;
    hidden var mStartedAt;

    // Constructor
    function initialize() {
		//System.println("dlg init");
        // Initialize the superclass
        BehaviorDelegate.initialize();
        // Get the controller from the application class
        mController = Application.getApp().controller;
    	mStartedAt = 0;    
        //System.println("dlg init - out");
    }


    // Input handling of start/stop is mapped to onSelect
    // or click_tap touch
    // The onSelect() method should get called when you tap the screen of the vivoactive_hr. 
    // If onSelect returns false, then onTap should get called
    //function onSelect() {
        //System.println("onSelect");  
        //return false; // allow InputDelegate function to be called
        //return true;
    //}

    /* remove to give access to menu, even when no GPS
	// A long press of the right button can be seen as onMenu
    // Block access to the menu button
    function onMenu() {
		//System.println("onMenu");
    	//TODO: WatchUi.pushView(new Rez.Menus.MainMenu(), new virtsailingMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    */
    
   function onMenu() {
        System.println("dlg:onMenu");
        
        //WatchUi.pushView(new Rez.Menus.SettingsMenu(), new virtsailingSettingsDelegate(), WatchUi.SLIDE_UP);
        return false;  // allow InputDelegate function to be called
    }

    // Handle the back action
    function onBack() {
        //System.println("dlg: onBack");		
		
        if (mController.isRunning() ) { 
            // simple press : mark/add lap	        
	    	mController.onDoubleTouch();     
            return true;
        }         
        //System.println("onBack");
		// return false so that the InputDelegate method gets called. this will
        // allow us to know what kind of input cause the back behavior
        return false;  // allow InputDelegate function to be called
    }


	// Key pressed
    function onKey(key) {
    	//System.println("onKey");
    /* maybe better ?
       if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) {
            return onSelect();
        }
        */
        if (key.getKey() == WatchUi.KEY_ENTER) {            
            //System.println("Key pressed: ENTER");            
            // Pass the input to the controller
        	mController.onStartStop();
            return true;
        }
        // KEY_LAP KEY_START
        //System.println("Key pressed: " + key.getKey() );
        // next = 8
        // prev = 13
        return false; // allow InputDelegate function to be called
    }
        
        
	function onSwipe(evt) {
        var swipe = evt.getDirection();
    	//System.println("dlg: onSwipe : " + swipe);
    	/*
    	 var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
            setActionString("SWIPE_UP");
        } else if (swipe == SWIPE_RIGHT) {
            setActionString("SWIPE_RIGHT");
        } else if (swipe == SWIPE_DOWN) {
            setActionString("SWIPE_DOWN");
        } else if (swipe == SWIPE_LEFT) {
            setActionString("SWIPE_LEFT");
        }
        */
        return false;  // allow InputDelegate function to be called
    }
    

  /*
  	Actually, on the va3 with 2.60FW you can mark manual laps.
	It's a setting for the activity, and is a double tap 
	of the screen. So with that, you get onTimerLap().
	
	On a va3, that's triggered by a right swipe.
	 In watch apps for the va3, I use the right swipe
	  to mark laps and catch it in onBack(). 
	
	In the sim, you can trigger a lap by using Datafields>Timer>Lap Activity.
	
    */     
     // Screen Tap
    function onTap(evt) {
    	//System.println("dlg: onTap : " + evt.getType() );

        var now = System.getTimer();    
           
        if ((mStartedAt != 0) && ((now - mStartedAt) <= DOUBLETOUCH_MS)) {
            /* detect double touch ? */
            //System.println("onTap - double touch");
            //mStartedAt = 0;
          
            // call controller
            mController.onDoubleTouch();
            mStartedAt = now;
            return true;
        } else {
            mController.onSelect();
            mStartedAt = now;
            return true;
        }
        mStartedAt = now;

        return false;  // allow InputDelegate function to be called
    }
    
    function onNextPage() {
        //System.println("dlg: onNextPage");
        // handle it like simple touch
        mController.onSelect();
        return true; // we handle it !
    }

    function onPreviousPage() {
        //System.println("dlg: onPreviousPage");
        return false;
    }

    // hold to reset timer
    /*
    function onHold(evt) {
		System.println("onHold");
		if (Attention has :vibrate) {
        	var vibe = [new Attention.VibeProfile(  50, 100 )];
       	 	Attention.vibrate(vibe);
       	}
        //TODO: resetTimer();
        return true;
    }
    */
}
