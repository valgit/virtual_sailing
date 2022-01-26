//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.System;

class virtsailingView extends commonView {
    hidden var mEnds;
    hidden var timedisplay;

    // Initialize the View
    function initialize() {
		//System.println("virtsailingView:: view initialize");
        // Call the superclass initialize
        commonView.initialize();
        
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;
              
		 // Load UI resources		
	    mEnds = Ui.loadResource(Rez.Strings.sailing_leg);

        timedisplay = 20;
        //System.println("view initialize - out ");
    }

    // Load your resources here
    function onLayout(dc) {
		//System.println("onLayout"); 
		commonView.onLayout(dc);   
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	commonView.onShow();
		// 1 Hz timer
        //mTimer.start(method(:onTimer), 1000, true);
        //mController.onShow();
    }

    // Update the view
    function onUpdate(dc) {
		//System.println("onUpdate");
        commonView.onUpdate(dc);

		// drawing info                
		if( Toybox has :ActivityRecording ) {
		        
                if(mController.isRunning() ) {
                    updateCommon(dc,_canvas_w,_canvas_h);
    		
    				// TODO : better display !
    				if (mController.isInRest() == false) {
    					updateRestsInfo(dc,_canvas_w,_canvas_h);
    				} else {    				
	    				updateSportsInfo(dc,_canvas_w,_canvas_h);
	    	        }
    				
                } else {
                    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
                                                      
                    dc.drawText( _canvas_w/2, _canvas_h/2, 
                        Graphics.FONT_MEDIUM,
                        mPrompt,
                        Graphics.TEXT_JUSTIFY_CENTER
                        );
                        
                    // draw logo
                    var _btIcon = Ui.loadResource(Rez.Drawables.esfIcon);
                    dc.drawBitmap( (0.5 * _canvas_w ) - 32 , _canvas_h/2 - 100 ,_btIcon); // 25+64+space
                    _btIcon = null;
                    /* display some status before starting */                    
                    drawBattery(dc, 
                            0.5*_canvas_w, 0.5*_canvas_h - 20,
                            Graphics.COLOR_BLACK, Graphics.COLOR_DK_RED, Graphics.COLOR_DK_GREEN);
                    updatePhone(dc,_canvas_w/2 -20, _canvas_h/2 - 25);
                    updateHeart(dc,_canvas_w/2 -50, _canvas_h/2 - 25);
                } /* not running */		      
		} else {
			// tell the user this sample doesn't work
			//TODO: handle strings
			dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
	        dc.drawText((_canvas_w / 2), (_canvas_h / 2) - 20, Graphics.FONT_MEDIUM, "This product doesn't", Graphics.TEXT_JUSTIFY_LEFT);
			dc.drawText((_canvas_w / 2), (_canvas_h / 2), Graphics.FONT_MEDIUM, "have FIT Support", Graphics.TEXT_JUSTIFY_LEFT);
		}
		

        //System.println("onUpdate - out");
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        //System.println("virtsailingView:: onHide");
        mController.onHide();
    }
  
 
	/*
	 * draw battery level
	 */
    function drawBattery(dc, batt_x, batt_y, primaryColor, lowBatteryColor, fullBatteryColor) {
        var batt_width_rect = 20;
        var batt_height_rect = 10;
        var batt_width_rect_small = 2;
        var batt_height_rect_small = 5;
        var batt_x_small, batt_y_small;
        var background_color = Graphics.COLOR_WHITE;

        batt_x_small = batt_x + batt_width_rect;
        batt_y_small = batt_y + ((batt_height_rect - batt_height_rect_small) / 2);

        var battery = System.getSystemStats().battery;
        
        if(battery < 15.0) {
            primaryColor = lowBatteryColor;
        }
        //else if(battery == 100.0)
        //{
        //    primaryColor = fullBatteryColor;
        //}

		//primaryColor
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(batt_x, batt_y, (batt_width_rect * battery / 100), batt_height_rect);
        if(battery == 100.0) {
            dc.fillRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        }
        
        dc.setColor(primaryColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x, batt_y, batt_width_rect, batt_height_rect);
        dc.setColor(background_color, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small-1, batt_y_small+1, batt_x_small-1, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        dc.setColor(background_color, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small, batt_y_small+1, batt_x_small, batt_y_small + batt_height_rect_small-1);
		
    }
    
    // display phone status
    function updatePhone(dc,x,y) {        
        var btAvailable = System.getDeviceSettings().phoneConnected;
                
        if (btAvailable) {
        	//System.println("updatePhone - connected");
            var _btIcon = Ui.loadResource(Rez.Drawables.bticon);
            dc.drawBitmap( x , y,_btIcon);
            _btIcon = null;
        }
    }

    // display Heart Monitor status
    function updateHeart(dc,x,y) {    
    	var sensorInfo = Sensor.getInfo();
    	if (sensorInfo has :heartRate) {
    		//System.println("HR available");
    		dc.drawBitmap(x , y ,_heartIcon);
    	}   	
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
    }

    /*
     * update all the SPorts info to display
     */
    function updateSportsInfo(dc,_canvas_w,_canvas_h) {
        //System.println("virtsailingView:: updateSportsInfo");
        // add sports info from model
		
        // calculate starting y position
        var y = _canvas_h/2 - Graphics.getFontAscent(Graphics.FONT_MEDIUM) - 
        			Graphics.getFontAscent(Graphics.FONT_NUMBER_MEDIUM) - 5; // add some space

        var _leg = mModel.getCurrentLeg();
        dc.drawText(
            (_canvas_w / 2), 
            y, 
            Graphics.FONT_MEDIUM , 
            mEnds, 
            Graphics.TEXT_JUSTIFY_CENTER);

        y += Graphics.getFontAscent(Graphics.FONT_MEDIUM);
        dc.drawText(
            (_canvas_w / 2), 
            y , 
            Graphics.FONT_NUMBER_MEDIUM , 
            _leg.format("%d"), 
            Graphics.TEXT_JUSTIFY_CENTER);

        y += Graphics.getFontAscent(Graphics.FONT_NUMBER_MEDIUM);

        if (!mModel.isTimerRunning()) {
            var raceTimeStr = mModel.getRaceTime();
            // display race time
          
            //System.println("virtsailingView:: updateSportsInfo : "+raceTimeStr);
            dc.drawText(
                (_canvas_w / 2), 
                y, // _canvas_h/2 + Graphics.getFontAscent(Graphics.FONT_MEDIUM), 
                Graphics.FONT_NUMBER_MEDIUM , 
                raceTimeStr, 
                Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            //print running timer
            var sttime = mModel.getTimer();
            var timerStr = secToStr(sttime[0]);
            dc.setColor(sttime[1], Graphics.COLOR_TRANSPARENT);
            //System.println("virtsailingView:: updateSportsInfo : " + timerStr);
            dc.drawText(
                (_canvas_w / 2), 
                y, // _canvas_h/2 + Graphics.getFontAscent(Graphics.FONT_MEDIUM), 
                Graphics.FONT_NUMBER_MEDIUM , 
                timerStr, 
                Graphics.TEXT_JUSTIFY_CENTER);
        }
        y += Graphics.getFontAscent(Graphics.FONT_MEDIUM);
/*        
        var _arrow = mModel.getCurrentArrow();
        dc.drawText(
            (_canvas_w / 2), 
            y, //_canvas_h/2, 
            Graphics.FONT_MEDIUM , 
            mArrows, 
            Graphics.TEXT_JUSTIFY_CENTER);
            
        y += Graphics.getFontAscent(Graphics.FONT_MEDIUM);
        dc.drawText(
            (_canvas_w / 2), 
            y, // _canvas_h/2 + Graphics.getFontAscent(Graphics.FONT_MEDIUM), 
            Graphics.FONT_NUMBER_MEDIUM , 
            _arrow.format("%d"), 
            Graphics.TEXT_JUSTIFY_CENTER);
            */
    }

    function getCurrentTime() {
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;
        return hours.format("%02d") + ":" + minutes.format("%02d");
    }

    /*
     * update all the rest info to display
     */
    function updateRestsInfo(dc,_canvas_w,_canvas_h) {
        //System.println("virtsailingView:: updateRestsInfo : In End Pause");
              // calculate starting y position
        var y = _canvas_h/2 - Graphics.getFontAscent(Graphics.FONT_MEDIUM) - 
        		Graphics.getFontAscent(Graphics.FONT_NUMBER_MEDIUM) - 5; // add some space

        var _resttime = mModel.getRestElapsed();
        //System.println("virtsailingView: updateRestsInfo : In End Pause since : " + secToTimeStr(_resttime));                 
        timedisplay = timedisplay-1;
        if (timedisplay<0) {
            timedisplay = 20;
        }

        dc.drawText(
            (_canvas_w / 2), 
            y, 
            Graphics.FONT_MEDIUM , 
            mRestPrompt, 
            Graphics.TEXT_JUSTIFY_CENTER);

        y += Graphics.getFontAscent(Graphics.FONT_MEDIUM);
        
        if (timedisplay<=10) {            
            var timestr = getCurrentTime();
            dc.drawText(
                (_canvas_w / 2), 
                y , 
                Graphics.FONT_NUMBER_MEDIUM , 
                timestr, 
                Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(
                (_canvas_w / 2), 
                y , 
                Graphics.FONT_NUMBER_MEDIUM , 
                secToTimeStr(_resttime), 
                Graphics.TEXT_JUSTIFY_CENTER);
        }       

        y += Graphics.getFontAscent(Graphics.FONT_NUMBER_MEDIUM);
        
        //var y = _canvas_h/2 + Graphics.getFontAscent(Graphics.FONT_MEDIUM)
        //         - 2 * Graphics.getFontHeight(Graphics.FONT_MEDIUM); 

        // display current end ?
        
        var _leg = mModel.getCurrentLeg();
        dc.drawText(
            (_canvas_w / 2), 
            y, 
            Graphics.FONT_NUMBER_MEDIUM , 
            _leg.format("%d"), 
            Graphics.TEXT_JUSTIFY_CENTER);
            
    }


}
