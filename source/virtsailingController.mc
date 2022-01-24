//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.Timer;
using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Attention;

using Toybox.System;

// Controller class for the Archery app. Controls
// the UI flow of the app and controlls FIT
// recording
class virtsailingController
{
    //var mTimer;
    var mModel;
    var mRunning;
    var _virtsailingEndView;
    var _state; // 0 : in End, 1 : waiting ...

    // Initialize the controller
    function initialize() {
		//System.println("ctrl init");
        // Allocate a 1Hz timer               
        //mTimer = new Timer.Timer();        
        
        // Get the model from the application
        mModel = Application.getApp().model;
        // We are not running (yet)
        mRunning = false;
        
        try {
	  		// code that might throw an exception
	       
	         // Enable the WHR or ANT HR sensor
	        // FYI: if a Tempe is available it's data will be included in the .fit and seen on Garmin Connect
	        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE,Sensor.SENSOR_FOOTPOD,Sensor.SENSOR_TEMPERATURE]);
	        // add a listener (http://developer.garmin.com/connect-iq/programmers-guide/positioning-sensors/)
	        Sensor.enableSensorEvents( method( :onSensor ) );
	        //System.println("Sensor rate : " + Sensor.getMaxSampleRate());
        }
		catch (ex) {
			    Toybox.System.println(ex.getErrorMessage());
			    ex.printStackTrace();
			
			    // rethrow if you want to let it crash
			    throw ex;
		}
		
        //System.println("ctrl init - out");
    }

    // Start the recording process
    function start() {
        // Start the model's processing
        mModel.start();
        // Flag that we are running
        mRunning = true;
        _state = 1; //debut with first End
    }

    // Stop the recording process
    function stop() {
        // Stop the model's processing
        mModel.stop();
        // Flag that we are not running
        mRunning = false;
        _state = 0;
    }

    // Save the recording
    function save() {
    	// Set final statistic variables for review
        mModel.setStats();
        // Save the recording
        mModel.save();
        // Give the system some time to finish the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.virtsailing_save), null), 
        	new virtsailingProgressDelegate(), 
        	WatchUi.SLIDE_DOWN);
        var _pTimer = new Timer.Timer();
        _pTimer.start(method(:onFinish), 3000, false);
    }

    function discard() {
        // Discard the recording
        mModel.discard();
        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.virtsailing_discard), null), 
        	new virtsailingProgressDelegate(),
        	 WatchUi.SLIDE_DOWN);
        var _pTimer = new Timer.Timer();
        _pTimer.start(method(:onExit), 3000, false);
                
    }

    // Are we running currently?
    function isRunning() {
        return mRunning;
    }

	// Get the recording time elapsed
    function getTime() {
        return mModel.getTimeElapsed();
    }

    // Handle the start/stip button
    function onStartStop() {
        if(mRunning) {
            stop();
            //System.println("onStartStop - stopping");
            WatchUi.pushView(new Rez.Menus.MainMenu(), new virtsailingMenuDelegate(), WatchUi.SLIDE_UP);
        } else {
            start();
        }
    }

    // Handle timing out after exit
    function onExit() {
        System.exit();
    }

    //Review the stats of the activity when finished
    function onFinish() {    	        
        WatchUi.switchToView(new virtsailingReviewView(), new virtsailingReviewDelegate(), WatchUi.SLIDE_UP);                
    }
    
    function onBack() {
        //System.println("Ctrl: onBack");
        if(mRunning) {
            // call for touchscreen !
        	onDoubleTouch();
            return true;
        } else {
           // Pass the message through to the system
           return false;
        }
    }
    
    // Handle Sensor Events
    function onSensor(sensor_info) {
        mModel.setSensor(sensor_info);
	}

	// handle UI interraction ?
	 function onShow() {		
		// Allocate a 1Hz timer               
        //mTimer = new Timer.Timer();     
        //mTimer.start(method(:onTimer), 1000, true);
    }
    
    function onHide() {
        //System.println("onHide");
        //mTimer.stop();
        //mTimer = null;		    
    }
    
    // Handler for the timer callback
    /*
    function onTimer() {
    	// for testing
    	//mModel.generateTest();
    	
    	//mModel.updateTimer();
        WatchUi.requestUpdate();
    }
    */
  	
    function onSelect() {
    
    }

  	// Handler for double touch action
  	function onDoubleTouch() {
        if(mRunning) {
                if (_state == 0) {
                    // signal start of new End
                    _state = 1;
              	  	// query attention
                    if (Attention has :vibrate) {
                        var vibe = [new Attention.VibeProfile(  50, 100 )];
                        Attention.vibrate(vibe);
                    }
                    mModel.newLap();
                    //System.println("onDoubleTouch - new End");
                } else {
                    if (_state == 1) {
                        // signal finish End
                        //System.println("onDoubleTouch - end End");
                        mModel.endLap();
                        // display stats
                        /*
                        _virtsailingEndView = new arrowPicker(mModel); // new virtsailingEndView(mModel);
                        WatchUi.pushView(_virtsailingEndView, 
                            new arrowPickerDelegate(mModel),  // virtsailingEndDelegate
                            WatchUi.SLIDE_DOWN);
                            
                            
                        var _pTimer = new Timer.Timer();
                        _pTimer.start(method(:onEnds), 5000, false);
                        */
                        // we are waiting for another one
                        _state = 0;
                    }
                } // other ?
        }          
    }

    function isInRest() {
        return (_state == 1);
    }
}

