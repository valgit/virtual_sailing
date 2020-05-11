//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

/*
 * base class for all view during activity recording
 */

using Toybox.WatchUi as Ui;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.System;

class commonView extends Ui.View {

    hidden var mModel;
    hidden var mController;
        
    //hidden var mIndicator;
    
    hidden var mPrompt;    
    
    hidden var mRestPrompt;
    
	hidden var _heartIcon;	

    var _canvas_w;
    var _canvas_h;

    // Initialize the View
    function initialize() {
		//System.println("commonView initialize");
        // Call the superclass initialize
        View.initialize();
        
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;
                      
		 // Load UI resources		
		mPrompt = Ui.loadResource(Rez.Strings.prompt);
		
        mRestPrompt = Ui.loadResource(Rez.Strings.restprompt);
        
        //System.println("view initialize - out ");
    }

    // Load your resources here
    function onLayout(dc) {
		
       _heartIcon = Ui.loadResource(Rez.Drawables.HeartIcon); 
    
        // new version ... draw directly !       
        _canvas_w = dc.getWidth();
        _canvas_h = dc.getHeight();      
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
		// 1 Hz timer
        //mTimer.start(method(:onTimer), 1000, true);
        mController.onShow();
    }

    // Update the view
    function onUpdate(dc) {
		//System.println("commonView onUpdate");
		// drawing info
       
        // clear the screen
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

		if( Toybox has :ActivityRecording ) {
		        
                if(mController.isRunning() ) {
                    updateCommon(dc,_canvas_w,_canvas_h);	
                }
                
		} else {			
			//TODO: handle strings
			dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
	        dc.drawText((_canvas_w / 2), (_canvas_h / 2) - 20, Graphics.FONT_MEDIUM, "This product doesn't", Graphics.TEXT_JUSTIFY_LEFT);
			dc.drawText((_canvas_w / 2), (_canvas_h / 2), Graphics.FONT_MEDIUM, "have FIT Support", Graphics.TEXT_JUSTIFY_LEFT);
		}
      
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        mController.onHide();
    }

    /*
     * update all info common to view
     */
    function updateCommon(dc,_canvas_w,_canvas_h) {
        // draw a red line
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.setPenWidth(1);
        dc.drawLine(50,_canvas_h/2,_canvas_w - 50,_canvas_h/2);

        // draw color
        var fntasc = Graphics.getFontHeight(Graphics.FONT_LARGE);                   
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        // top                  
        dc.fillRectangle(0,0,_canvas_w,fntasc);                                     
        // bottom
        dc.fillRectangle(0,_canvas_h - fntasc,_canvas_w,_canvas_h);
        
        dc.setPenWidth(2);
        dc.drawCircle(_canvas_w / 2, _canvas_h / 2, _canvas_h / 2 - 10);
        
        // display timer
        //TODO: draw black back ? maybe bufferd ?
        // Format time
        var time = mController.getTime();
        //var timeString = Lang.format("$1$:$2$", [time / 60, (time % 60).format("%02d")]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);                                      
        dc.drawText( _canvas_w/2, 0, 
            Graphics.FONT_NUMBER_MILD,
            secToTimeStr(time),
            Graphics.TEXT_JUSTIFY_CENTER
            );                                     
        
         //TODO: draw black back ? maybe bufferd ?      
        // display HR
        var HR = mModel.getHRbpm();   
        var textDimensions = dc.getTextDimensions(HR.toString(), Graphics.FONT_NUMBER_MILD);
        var iconOffsetX = 5+32; // textDimensions[0] / 2 ;
        var iconOffsetY = textDimensions[1]/ 2 -10;
    /*
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(_canvas_w/4,_canvas_h - 50,_canvas_w - 50,_canvas_h - 50);
        */
        var y =  _canvas_h - Graphics.getFontHeight(Graphics.FONT_NUMBER_MILD);
        //dc.drawBitmap( _canvas_w/2 -iconOffsetX , y + iconOffsetY ,_heartIcon);
        //dc.drawLine(0,y + iconOffsetY ,_canvas_w,y + iconOffsetY);
        dc.drawBitmap( _canvas_w * 0.3 , y  + iconOffsetY ,_heartIcon);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);                                  
        dc.drawText( _canvas_w/2, y, // 50, 
            Graphics.FONT_NUMBER_MILD,
            HR.toString(),
            Graphics.TEXT_JUSTIFY_CENTER
            );
        /*
        // Draw page indicator
        var _idx = mController.getCurrentPage();    
        mIndicator.draw(dc, _idx);        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        */
    }

}
