//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.WatchUi;
using Toybox.System;

class virtsailingPlaceDelegate extends WatchUi.MenuInputDelegate {

    hidden var mController;   

    // Constructor
    function initialize() {
        MenuInputDelegate.initialize();
        mController = Application.getApp().controller;

    }

    // Handle the menu input
    function onMenuItem(item) {
        if (item == :boat) {            
            //System.println("set boat");
            WatchUi.pushView(new PickerBoat(),
                new PickerBoatDelegate(),
                WatchUi.SLIDE_IMMEDIATE);
            return true;
        } else if (item == :wind) {
            //mController.save();
            System.println("set wind");
            return true;
        }
        return false;
    }


}