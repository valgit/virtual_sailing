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
            //mController.start();
            System.println("set boat");
            return true;
        } else if (item == :wind) {
            //mController.save();
            System.println("set wind");
            return true;
        } else {
            System.println("default ?");
            return true;
        }
        return false;
    }


}