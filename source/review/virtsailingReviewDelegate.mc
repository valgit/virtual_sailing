// Delegates inputs to the controller

using Toybox.WatchUi as Ui;

class virtsailingReviewDelegate extends Ui.BehaviorDelegate {

    hidden var mController;
    
    function initialize() {
        // Initialize the superclass
        BehaviorDelegate.initialize();
        // Get the controller from the application class
        mController = Application.getApp().controller;
    }

    function onBack() {
        //Exit the app
        mController.onExit();
        return true;
    }

    // Button Pressed
    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            //Exit the app
            mController.onExit();
        }
      
        return true;
    }

 /*
    // Screen Tap
    function onTap(type) {
        if (type.getType() == Ui.CLICK_TYPE_TAP) {
            mController.turnOnBacklight();
        }
    }
*/
}