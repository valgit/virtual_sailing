//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;


class PickerWind extends WatchUi.Picker {	
	
    function initialize() {   	    	
		System.println("PickerWind - init ");		

        var title = new WatchUi.Text({:text=>"Wind" /*Rez.Strings.PickerBoatTitle*/,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
            :color=>Graphics.COLOR_WHITE});
        // wind speed in knots ?
        var factory = new NumberFactory(0, 30, 1, {:font=>Graphics.FONT_NUMBER_MEDIUM});
        Picker.initialize({:title=>title, :pattern=>[factory]});
    }

    function onUpdate(dc) {    	
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
 
        // TODO : draw background
    }

}

class PickerWindDelegate extends WatchUi.PickerDelegate {	
	
    function initialize() { 	    	
        PickerDelegate.initialize();
    }

    function onCancel() {    	
        System.println("PickerWindDelegate - onCancel ");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {    	    	
    	System.println("PickerWindDelegate - onAccept " + values[0]);
        Application.getApp().setProperty("wind", values[0]);    	
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }


}
