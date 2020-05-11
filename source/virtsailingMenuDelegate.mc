//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.WatchUi;
using Toybox.System;

class virtsailingMenuDelegate extends WatchUi.MenuInputDelegate {

    hidden var mController;   

    // Constructor
    function initialize() {
        MenuInputDelegate.initialize();
        mController = Application.getApp().controller;

    }

    // Handle the menu input
    function onMenuItem(item) {
        if (item == :resume) {
            mController.start();
            return true;
        } else if (item == :save) {
            mController.save();
            //System.println("item 2");
            return true;
        } else {
            mController.discard();
            return true;
        }
        return false;
    }


}