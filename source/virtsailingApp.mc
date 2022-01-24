using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Timer;

class virtsailingApp extends Application.AppBase {
    var model;
    var controller;    
	var supportsRecording;
	var mTimer;

    function initialize() {
        AppBase.initialize();       

        model = new $.virtsailingModel();
        controller = new $.virtsailingController();
		//System.println("app init");
		supportsRecording = Toybox has :ActivityRecording;   

        // global App timer
        mTimer = new Timer.Timer(); 
        
    }

    // onStart() is called on application start up
    function onStart(state) {
    	//var pref = Application.Properties.getValue("usegps");
    	//System.println("app on Start :" + pref);
        // Allocate a 1Hz timer        
        mTimer.start(method(:onTimer), 1000, true);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        mTimer.stop();
    }

    // Return the initial view of your application here
    function getInitialView() {
		//System.println("app view");
        //return [ new sailingView(), new sailingDelegate() ];
        
        var delegate = new virtsailingDelegate();
        return [ new virtsailingView(), delegate ];                      
    }

    // global time callback
    function onTimer() {    	
    	//mModel.updateTimer();
        WatchUi.requestUpdate();
    }
}


