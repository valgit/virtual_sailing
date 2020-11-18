module HrvAlgorithms {
	class ShortDetailedHrvActivity extends HrActivity {
		function initialize(fitSession, heartbeatIntervalsSensor) {
			me.mHeartbeatIntervalsSensor = heartbeatIntervalsSensor;
			HrActivity.initialize(fitSession);
		}
		
		protected var mHeartbeatIntervalsSensor;		
		private var mHrvMonitor;
		
		
		function onBeforeStart(fitSession) {		
			me.mHeartbeatIntervalsSensor.setOneSecBeatToBeatIntervalsSensorListener(method(:onOneSecBeatToBeatIntervals));
			me.mHrvMonitor = new HrvMonitorDetailed(fitSession, false);
		}
		
		function onOneSecBeatToBeatIntervals(heartBeatIntervals) {
			me.mHrvMonitor.addOneSecBeatToBeatIntervals(heartBeatIntervals);
		}
		
		 function onBeforeStop() {
	    	me.mHeartbeatIntervalsSensor.setOneSecBeatToBeatIntervalsSensorListener(null);
		}
		
		private var mHrvSuccessive;
		
		 function onRefreshHrActivityStats(activityInfo, minHr) {	
    		me.mHrvSuccessive = me.mHrvMonitor.calculateHrvSuccessive();		
    		me.onRefreshHrvActivityStats(activityInfo, minHr, me.mHrvSuccessive);
		}
		
		function onRefreshHrvActivityStats(activityInfo, minHr, hrvSuccessive) {
		}
		
		function calculateSummaryFields() {	
			var hrSummary = HrActivity.calculateSummaryFields();	
			var activitySummary = new ActivitySummary();
			activitySummary.hrSummary = hrSummary;
			activitySummary.hrvSummary = me.mHrvMonitor.calculateHrvSummary();
			return activitySummary;
		}
	}	
}