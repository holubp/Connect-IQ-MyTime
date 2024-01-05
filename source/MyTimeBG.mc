using Toybox.Background as Bg;
using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Application.Storage as Ast;
using Toybox.Time;

(:background)
class MyServiceDelegate extends Sys.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    var res1 = null, Code1 = null, res2 = null, Code2 = null;
	var lat = Ast.getValue("lastLat");
	var lon = Ast.getValue("lastLong");
	var appid1 = Ast.getValue("appid1"); 
	var appid2 = Ast.getValue("appid2"); 
	var dndOffline = Ast.getValue("dndOffline"); 	
	var langi = Ast.getValue("langi"); 	
	var dndSys = Sys.getDeviceSettings().doNotDisturb;
	var tempUnits = Ast.getValue("tempUnits");
    
    function onTemporalEvent() {
    	if (dndOffline == true && dndSys == true){
    	} else {
	    	if (Sys.getDeviceSettings().phoneConnected == true) {
				var url1 = "https://api.openweathermap.org/data/2.5/weather";
				var param1 = {"lat" => lat,"lon" => lon,"appid" => appid1,"units" => tempUnits, "lang" => langi};
				var opt1 = {};
				var met1 = method(:responseCallback1);
		        Comm.makeWebRequest(url1, param1, opt1, met1);
			}
		}
	}

    function responseCallback1(responseCode, data) { 
		var url2 = "https://api.jawg.io/elevations?locations=" + lat + "," + lon + "&access-token=" + appid2;
		var param2 = {}; 
		var opt2 = {};
		var met2 = method(:responseCallback2);
	    Comm.makeWebRequest(url2, param2, opt2, met2);
    	res1 = data;
    	Code1 = responseCode;
	}

    function responseCallback2(responseCode, data) { 
    	res2 = data;
    	Code2 = responseCode;
        Bg.exit([res1,res2,Code1,Code2]);
    }
}