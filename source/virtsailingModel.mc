//
// Copyright 2019.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.Activity;
using Toybox.Sensor;
using Toybox.System;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.FitContributor;
using Toybox.ActivityRecording;

using Toybox.WatchUi as Ui;

class virtsailingModel
{
    // Timer for handling the accelerometer    
    
    // Primary stats
    hidden var mHeartRate; 
  
    // FIT recording session
    hidden var mSession;

    // FIT Contributions variables
    hidden const TOTAL_LEGS_FIELD_ID = 1;   // total de manche
    hidden const AVG_TIME_PER_LEG_FIELD_ID = 2;   //
    hidden const LAP_LEG_TIME_FIELD_ID = 3;

    hidden var mSessTotalLegsField = null; // nombre de manche
    hidden var mSessAvgTimePerLegField = null; // temps moy / manche
    hidden var mLapLegTimeField = null;

    // Summarized and exposed statistics
    var elapsedTime;
    var calories;
    var averageHR;
    var peakHR;
    
    var _maxTime;
	var _avgTime;
	
	hidden var _legStart;
	hidden var _legEnd;
    var avgLegTime;

    hidden var _totalLeg;
    hidden var _currentLeg;

    var timer = null;
    var secTot;
	var secLeft;
    //var raceStartTime;
	
    /*
     * fit contributor for Record session 
     */
	function initializeFITRecord() {
	    // Create the new FIT fields to record to.
		        // current values

      
    	// MESG_TYPE_SESSION : once per session
    	// MESG_TYPE_LAP : once per lap
    	// MESG_TYPE_RECORD : max one per sec (real time)
    	
    	// init data
    	//mCurrentarrowField.setData(0);
    	//mCurrentEndsField.setData(0);
    	//mTimePerArrowField.setData(0.0);
    			    
    	//mPerArrowEndsField.setData(0);
	}

    /*
     * fit contributor for Lap
     */
    function initializeFITLap() {
        // Create the new FIT fields to record to.
        mLapLegTimeField = mSession.createField(Ui.loadResource(Rez.Strings.virtsailing_legtime), 
            LAP_LEG_TIME_FIELD_ID, 
            FitContributor.DATA_TYPE_FLOAT, 
            {:mesgType => FitContributor.MESG_TYPE_LAP, :units=>Ui.loadResource(Rez.Strings.virtsailing_time)}
        );
    }
	
    /*
     * FIT contributor for the whole session
     */
    function initializeFITsession() {
    	//System.println("initializeFITsession");
        
		mSessTotalLegsField = mSession.createField(Ui.loadResource(Rez.Strings.virtsailing_totallegs),
            TOTAL_LEGS_FIELD_ID, 
            FitContributor.DATA_TYPE_UINT32, 
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units=>Ui.loadResource(Rez.Strings.virtsailing_unitleg)}
            );

        mSessAvgTimePerLegField = mSession.createField(Ui.loadResource(Rez.Strings.virtsailing_avglegtime),
            AVG_TIME_PER_LEG_FIELD_ID, 
            FitContributor.DATA_TYPE_FLOAT, 
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units=>Ui.loadResource(Rez.Strings.virtsailing_time)}
            );
            
        //System.println("initializeFITsession - out");
    }

    

    // Initialize sensor readings
    function initialize() {    
    	//System.println("model init"); 

        // Current 
        
        // total
 		_maxTime = 0;
 		_avgTime = 0;
        _legStart = 0;
        _legEnd = 0;
 		_totalLeg = 0;
        _currentLeg = 0;
        avgLegTime = 0;

      	// Sensor Heart Rate
		//TODO: mHeartRate = 0;

		// check for support !
		if( Toybox has :ActivityRecording ) {				
		        // Create a new FIT recording session
		        if ((mSession == null) || (mSession.isRecording() == false)) {
		        	mSession = ActivityRecording.createSession(
		        	 	{
		        	 		// :name=>"diving_"+Time.now().value(), // set session name
		  				   :name=>"virtual regatta", // +Time.now().value(),      // set session name
		   				   :sport=>ActivityRecording.SPORT_SAILING,        // set sport type
		  				   :subSport=>ActivityRecording.SUB_SPORT_GENERIC//,  // set sub sport type
		  				   //:sensorLogger => mLogger // add accel logger
		    			}
		    
		        	);
		        }		        	
		    	initializeFITRecord();
		    	
		    	initializeFITsession();
		    
                initializeFITLap();
                //mSession.addLap();


		   }
    	//System.println("model init - out");
    }

    // Begin sensor processing
    function start() {
    	//System.println("model - start");
  
        // Start recording
        mSession.start();
  
        var now = System.getTimer();
        _legStart = now;  
        _legEnd = _legStart;     
        //System.println("model - start out");
        startTimer();
    }

    // Stop sensor processing
    function stop() {
        
        // Stop the FIT recording
        if ((mSession != null) && mSession.isRecording()) {  
        	mSession.stop();
        }
    }

    // Save the current session
    function save() {
    	if (mSession != null) {
    	    // https://forums.garmin.com/forum/developers/connect-iq/connect-iq-bug-reports/1452620-monkey-graph-doesn-t-display-session-data
            // Update the total virtsailing  Shot field
            

            //System.println("avg end : "+ (avgEnds/60)%60+avgEnds%60/100.0);
            // this one should convert to long before ?
            /*
            System.println("end- time " + avgEnds + " - " + 
                ((avgEnds/60)%60+avgEnds%60/100.0)  + " mm:ss" 
                );
            */
            
            mSessTotalLegsField.setData(_totalLeg.toLong());
            mSessAvgTimePerLegField.setData(avgLegTime); // temps moy par manche
                           
	        mSession.save();
	       
	        mSession = null;
        }      
    }

    // Discard the current session
    function discard() {
    	if (mSession != null) {
	        mSession.discard();
	        mSession = null;
        }
    }

	// gather final session stats for review/save
	function setStats() {
		//System.println( "set stats");
		var activity = Activity.getActivityInfo();
        if (activity != null){

            if ( activity.elapsedTime != null ) {
                elapsedTime = activity.elapsedTime;
            } else {
                elapsedTime = 0;
            }

            if ( activity.calories != null ) {
                calories = activity.calories;
            } else {
                calories = 0;
            }

            if ( activity.averageHeartRate != null ) {
                averageHR = activity.averageHeartRate;                
            } else {
                averageHR = 0;
                
            }

            if ( activity.maxHeartRate != null ) {
                peakHR = activity.maxHeartRate;                
            } else {
                peakHR = 0;                
            }
            /*
            if ( activity.elapsedDistance != null ) {
                System.println("dist : " + activity.elapsedDistance);                
            }
            var _info = ActivityMonitor.getInfo();
			if (_info != null) {
				steps = _info.steps;
				if (steps == null) {steps = 0;}
				System.println("steps : " + steps);
			}
			*/
            //total_strides
            // add stats specific for  activity ?
            //totalArrow = mCurrentArrow;
            //totalEnds = mCurrentEnds;
		}
	}
	
	 // Return the current calories burned
    function getCalories() {
        var activity = Activity.getActivityInfo();
        if (activity.calories != null){
            return activity.calories;
        } else {
            return 0;
        }
	}

  	// Return the current heart rate in bpm
    function getHRbpm() {
        return mHeartRate;
	}

	// Handle controller sensor events
    function setSensor(sensor_info) {
        if( sensor_info has :heartRate &&  sensor_info.heartRate != null ) {
                mHeartRate = sensor_info.heartRate.toString();     
        } else {
                mHeartRate = "---"; // 0;
        }
                
	    //System.println("x: " + sensor_info.temperature + ", y: " + sensor_info.pressure);
	    //var steps = info.steps;
    }

    // Return the total elapsed recording time
    function getTimeElapsed() {
        //return mSeconds;
        
        var _elapsed = 0;
        var activity = Activity.getActivityInfo();
        if (activity != null) {         
            _elapsed = activity.timerTime; //elapsedTime;
            if (_elapsed == null) { _elapsed = 0; }         
        } else {
            	_elapsed = 0;
        } 
        //System.println("elaps : "+ _elapsed);
        _elapsed = _elapsed / 1000; // in ms
        return _elapsed;
        
    }
   
    // Return the current elapsed rest time 
    function getRestElapsed() {
        var now = System.getTimer();
				
        var endtime = (now - _legEnd);
        
        //System.println("rest elaps : "+ endtime);
        if (endtime < 0) {
            return 0;
        }
        return (endtime / 1000); // in ms
    }    
  
    function endLap() {
    	//System.println("lastArrow");
    	var now = System.getTimer();
    	
    	_legEnd = now;

        var legtime = (_legEnd - _legStart);            
        avgLegTime += legtime;
        _totalLeg ++;

        mLapLegTimeField.setData( legtime / 1000.0);
        // addLapd should be call after all (forum info)
        mSession.addLap(); 
    }
  
    // signal start of new lap
    function newLap() {
		//System.println("newEnd");
		if ((mSession != null) && mSession.isRecording()) {
			var now = System.getTimer();
			_legStart = now;
            _currentLeg++;
            startTimer();
		}
    }

    function getCurrentLeg() {
            return _currentLeg;
    }

    function getTotalLegs() {
            return _totalLeg;
    }

	// Return the total elapsed recording time
	function getTotalTime() {
		return elapsedTime;
	}	
	
    function getRaceTime() {        
        var now = Time.now();
        var raceTime = now.subtract(_legStart);
        var raceTimeStr = secToStr(raceTime.value());
        //System.println(raceTimeStr);
        return raceTimeStr;
    }

	function toFixed(value, scale) {
        return ((value * scale) + 0.5).toNumber();
    }

    
/*
 * chrono time functions
*/
    function fixTimeUp() {
    	secLeft = ((secLeft / 60) + 1) * 60;
    	//Sys.println("fixTimeUp" + secLeft / 60 + 1);
    }
    
    function isTimerRunning() {
    	return (secLeft != null and secLeft < 300);
    }
    
    function fixTimeDown() {
    	secLeft = (secLeft / 60) * 60;
    	//Sys.println("fixTimeUpDown" + secLeft / 60);
    }
 
    function startTimer() {
    	secTot = 30; // App.getApp().getDefaultTimerCount();
        secLeft = secTot;
        
    	updateTimer();
        
        timer = new Timer.Timer();
        timer.start( method(:callback), 1000, true );
        
        //timerRunning = true;
	}

    function getTimer() {
        var color = Graphics.COLOR_BLACK;
        if (secLeft<=5) {
            color = Graphics.COLOR_RED;
        }
        return [secLeft,color];
    }

    function updateTimer() {
    	secLeft -= 1;
    }
    
    function callback() {
    	if(secLeft > 1) {
    		
    		if(secLeft == 5) {
    		    //ring();
                //System.println("ring 5");
                // query attention
                if (Attention has :vibrate) {
                    var vibe = [new Attention.VibeProfile(  50, 100 )];
                    Attention.vibrate(vibe);
                }
    	    }
    	    /*
    	    if((secLeft-1) % 30 == 0){
    		    ring();
    		    if((secLeft-1) % 60 == 0){
    		    	ring();
    	    	}
    	    }
            */
    		updateTimer();            
    	}else {
    		endTimer();
		}
        
        //Ui.requestUpdate();
    }

    function endTimer() {
        System.println("endTimer");
        if (Attention has :vibrate) {
            var vibe = [new Attention.VibeProfile(  50, 100 )];
            Attention.vibrate(vibe);
        }
    	_legStart = Time.now();    	
		timer.stop();
        timer = null;
        secLeft = null;
    }
}
