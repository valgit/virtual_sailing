
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.Timer;

class virtsailingReviewView extends Ui.View {

    hidden var mModel;
    hidden var mController;    

    hidden var elapsedTime = 0;
    hidden var calories = 0;
    hidden var averageHR = 0;
    
    hidden var peakHR = 0;
    hidden var totalLeg = 0;
        
    hidden var uiTime = null;
    hidden var uiCalories = null;
    
    hidden var uiAvgHR = null;
    hidden var uiMaxHR = null;    
     
    function initialize() {
        View.initialize();
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;
        
        // let's make this a little time...
        var _pTimer = new Timer.Timer();
        _pTimer.start(method(:onExit), 30000, false);        
    }

    //Load your resources here
    function onLayout(dc) {
        // Load the layout from the resource file
           
        elapsedTime = mModel.getTotalTime() /1000; // in millisec
        calories = mModel.calories;
        averageHR = mModel.averageHR;
    
        peakHR = mModel.peakHR; 
                
        // TODO: add end, get uiview        
        totalLeg = mModel.getTotalLegs();
    }

    //Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	//System.println( "review onShow");
        Ui.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        // drawing info
        var _canvas_w;
        var _canvas_h;
    
        // new version ... draw directly !       
        _canvas_w = dc.getWidth();
        _canvas_h = dc.getHeight();
        
        //System.println( "review onUpdate");
           // clear the screen
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_YELLOW);
        dc.setPenWidth(2);
        dc.drawCircle(_canvas_w / 2, _canvas_h / 2, _canvas_h / 2 - 10);
        // top					
		dc.fillRectangle(0,0,_canvas_w,_canvas_h / 3 + 12 );
		dc.drawLine(50,_canvas_h - _canvas_h/4,_canvas_w - 50,_canvas_h - _canvas_h/4); 

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.setPenWidth(10);
        dc.drawCircle(_canvas_w / 2, _canvas_h / 2, _canvas_h / 2 - 3);
        dc.setPenWidth(2);

		// sports infos
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);         

        // legs done
        dc.drawText(
            (0.25 * _canvas_w ), 
            _canvas_h/3 - Graphics.getFontHeight(Graphics.FONT_XTINY) + 10, 
            Graphics.FONT_XTINY , 
            "LEGS", 
            Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(
            (0.25 * _canvas_w ), 
            _canvas_h/3 - 2 * Graphics.getFontHeight(Graphics.FONT_MEDIUM) + 10, 
            Graphics.FONT_NUMBER_MEDIUM , 
            totalLeg.format("%d"), 
            Graphics.TEXT_JUSTIFY_CENTER);

        // time 
        var _btIcon = Ui.loadResource(Rez.Drawables.archerIcon);
        dc.drawBitmap( (0.5 * _canvas_w ) + 15 , _canvas_h/2 - 30 ,_btIcon);
        _btIcon = null;

        // TODO : better
        var timeString = secToTimeStr(elapsedTime);
        dc.drawText(
            (0.5 * _canvas_w ), 
            _canvas_h/2 + 10, 
            Graphics.FONT_NUMBER_MILD , 
            timeString, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var rate = WatchUi.loadResource(Rez.Strings.Summary_avgHR) +
             " " + averageHR;
        dc.drawText(
            (0.5 * _canvas_w ), 
            _canvas_h/2 + Graphics.getFontHeight(Graphics.FONT_XTINY) + 10, 
            Graphics.FONT_XTINY , 
            rate, 
            Graphics.TEXT_JUSTIFY_CENTER);

		/*
        // DEBUG
        // check zone
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);        
        dc.drawLine(_canvas_w/2, 50,_canvas_w/2 ,_canvas_h - 50);
        dc.drawLine(50,_canvas_h/2,_canvas_w - 50, _canvas_h/2); 
        */
    }
   
 	// Handle timing out after exit
    function onExit() {
        System.exit();
    }
}