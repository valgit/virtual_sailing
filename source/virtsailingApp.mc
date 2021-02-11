using Toybox.Application;
using Toybox.WatchUi;

class virtsailingApp extends Application.AppBase {
    var model;
    var controller;    
	var supportsRecording;
	
    function initialize() {
        AppBase.initialize();       

        model = new $.virtsailingModel();
        controller = new $.virtsailingController();
		//System.println("app init");
		supportsRecording = Toybox has :ActivityRecording;        
    }

    // onStart() is called on application start up
    function onStart(state) {
    	//var pref = Application.Properties.getValue("usegps");
    	//System.println("app on Start :" + pref);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
		//System.println("app view");
        //return [ new sailingView(), new sailingDelegate() ];       
        
        var delegate = new virtsailingDelegate();
        return [ new virtsailingView(), delegate ];                      
    }

}


