/*
 * some common and usefull functions
 */
using Toybox.Application as App;

function secToStr(raceTime){
        var raceSec = (raceTime % 60).format("%02d");
        var raceMin = ((raceTime / 60) % 60).format("%02d");
        //var raceHours = ((raceTime / 3600) % 60).format("%02d");
        
        return ""+raceMin+":"+raceSec;
    }

// ms to [[hh:]m]m:ss
function secToTimeStr(secs) {
    var hr = secs/3600;
    var min = (secs-(hr*3600))/60;
    var sec = secs%60;
    var str;
    if (hr > 0) {
        str = hr.format("%02d") + ":" + min.format("%02d") + ":" + sec.format("%02d");
    } else {
        str = min.format("%02d") + ":" + sec.format("%02d");
    }
    return str;
}
        
function toHMS(secs) {
    var hr = secs/3600;
    var min = (secs-(hr*3600))/60;
    var sec = secs%60;
    return [hr, min,sec];
}

// Return min of two values
function min(a, b) {
        if(a < b) {
            return a;
        }
        else {
            return b;
        }
}

// Return max of two values
function max(a, b) {
        if(a > b) {
            return a;
        }
        else {
            return b;
        }
}

// Return the boolean value for the preference
// @param name the name of the preference
// @param def the default value if preference value cannot be found
function getBoolean(name, def) {
    var app = App.getApp();
    var pref = def;

    if (app != null) {
        pref = app.getProperty(name);
        //pref = Application.Properties.getValue(name);

        if (pref != null) {
            if (pref instanceof Toybox.Lang.Boolean) {
                return pref;
            }

            if (pref == 1) {
                return true;
            }
        } else {
        	return def; 
        }
    }
}

//! Return the number value for a preference, or the given default value if pref
//! does not exist, is invalid, is less than the min or is greater than the max.
//! @param name the name of the preference
//! @param def the default value if preference value cannot be found
//! @param min the minimum authorized value for the preference
//! @param max the maximum authorized value for the preference
function getNumber(name, def, min, max) {
    var app = App.getApp();
    var pref = def;

    if (app != null) {
        pref = app.getProperty(name);

        if (pref != null) {
            // GCM used to return value as string
            if (pref instanceof Toybox.Lang.String) {
                try {
                    pref = pref.toNumber();
                } catch(ex) {
                    pref = null;
                }
            }
        }
    }

    // Run checks
    if (pref == null || pref < min || pref > max) {
        pref = def;
        app.setProperty(name, pref);
    }

    return pref;
}

