//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.WatchUi;
using Toybox.System;


// Confirmation delegate used
class virtsailingConfirmationDelegate extends WatchUi.ConfirmationDelegate
{
   hidden var mController;

    // Hold onto the controller
   function initialize(controller) {
       ConfirmationDelegate.initialize();
       mController = controller;
    }

    // Handle the confirmation dialog response
   function onResponse(response) {
       if( response == WatchUi.CONFIRM_YES ) {
           mController.stop();
           mController.discard();
       }
    }
}
