/*
 *
 * derived from WordFactory sample
 */
using Toybox.Graphics;
using Toybox.WatchUi;

class BoatFactory extends WatchUi.PickerFactory {
    hidden var mBoats;     
    hidden var mFont;

    function initialize(options) {    	
        PickerFactory.initialize();
        
        // TODO update boat list
        mBoats = ["Formule 18", "Laser", "Star", "49er", "Nacra 17", "J/70", "F50", "Offshore Racer"];

        if(options != null) {
            mFont = options.get(:font);
        }

        if(mFont == null) {
            mFont = Graphics.FONT_LARGE;
        }          
    }

    function getIndex(value) {
        if(value instanceof String) {
            System.println("getIndex : string");
            for(var i = 0; i < mBoats.size(); ++i) {
                if(value.equals(WatchUi.loadResource(mBoats[i]))) {
                    return i;
                }
            }
        }
        else {
            System.println("getIndex : other");
            for(var i = 0; i < mBoats.size(); ++i) {
                if(mBoats[i].equals(value)) {
                    return i;
                }
            }
        }

        return 0;
    }

   
    function getDrawable(index, selected) {    	    
        return new WatchUi.Text({:text=>mBoats[index],
            :color=>Graphics.COLOR_WHITE, :font=>mFont,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    function getValue(index) {
        return mBoats[index];
    }

    function getSize() {
        return mBoats.size();
    }

}
