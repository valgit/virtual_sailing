using Toybox.Graphics;
using Toybox.WatchUi;

class PickerBoat extends WatchUi.Picker {

    function initialize() {
        var title = new WatchUi.Text({:text=>"Boat" /*Rez.Strings.PickerBoatTitle*/,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
            :color=>Graphics.COLOR_WHITE});
        var factory = new BoatFactory({:font=>Graphics.FONT_MEDIUM});
        Picker.initialize({:title=>title, :pattern=>[factory]});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class PickerBoatDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        System.println("onAccept : "+ values[0]);
        Application.getApp().setProperty("boat", values[0]);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
