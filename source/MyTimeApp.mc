using Toybox.Application as App;
using Toybox.Application.Storage as Ast;
using Toybox.Background as Bg;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Communications as Comm;
using Toybox.Lang;
using Toybox.Weather as W;

	var title;
	//Hauptfarbe
	var mainCol;
	//Keys
	var appid1, appid2;
	//Low-Power
	var lowPowView, anaZeig, anaOut, anaDig, anaCen, calView, battView, dateView;
	var anaZeigSet, anaOutSet, anaDigSet, anaCenSet;
	//Stunden, Minuten usw...
	var h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12;
	var vor, ab, vorh, abh;
	var m5_25_35_55, m10_50, m15_45, m20_40, m30,m0;
	//Koordinaten
	var longi, lati, alti;
	//Fore and Background Things,DoNotDisturb
	var MyTimeBg, MyTimeFg;
	var dnd, dndOffline, sw, moveBar, oxy;
	
(:background)	
class MyTimeApp extends App.AppBase {

	const X_MINUTES = new Time.Duration(10 * 60);
		
    function initialize() {
        AppBase.initialize(); 
    }

	function onSettingsChanged() { // Bei Änderungen der Settings in der GC App
	    
		title = getProperty("title");
	
		var arrmainCol = [Graphics.COLOR_WHITE,Graphics.COLOR_BLUE,Graphics.COLOR_DK_BLUE,Graphics.COLOR_RED,Graphics.COLOR_DK_RED,Graphics.COLOR_GREEN,Graphics.COLOR_DK_GREEN,Graphics.COLOR_ORANGE,Graphics.COLOR_YELLOW,Graphics.COLOR_PINK,Graphics.COLOR_PURPLE,Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLACK,0,102,204,13056,13158,13260,26112,26214,26316,39168,39270,39372,52224,52326,52428,65280,65382,65484,3342336,3342438,3342540,3355392,3355494,3355596,3368448,3368550,3368652,3381504,3381606,3381708,3394560,3394662,3394764,3407616,3407718,3407820,6684672,6684774,6684876,6697728,6697830,6697932,6710784,6710886,6710988,6723840,6723942,6724044,6736896,6736998,6737100,6749952,6750054,6750156,10027008,10027110,10027212,10040064,10040166,10040268,10053120,10053222,10053324,10066176,10066278,10066380,10079232,10079334,10079436,10092288,10092390,10092492,13369344,13369446,13369548,13382400,13382502,13382604,13395456,13395558,13395660,13408512,13408614,13408716,13421568,13421670,13421772,13434624,13434726,13434828,16711680,16711782,16711884,16724736,16724838,16724940,16737792,16737894,16737996,16750848,16750950,16751052,16763904,16764006,16764108,16776960,16777062,16777164];

		mainCol = arrmainCol[getProperty("mainCol")];
		
		appid1 = getProperty("appid1");
		Ast.setValue("appid1", appid1);

		appid2 = getProperty("appid2");
		Ast.setValue("appid2", appid2);

		calView = getProperty("calView");

		battView = getProperty("battView");

		dateView = getProperty("dateView");

		lowPowView = getProperty("lowPowView"); 
		
		moveBar = getProperty("moveBar");
		
		dndOffline = getProperty("dndOffline");
		Ast.setValue("dndOffline", dndOffline);

		oxy = getProperty("oxy");
		
		sw = getProperty("sw");
		
		anaZeig = getProperty("anaZeig");
		anaZeigSet = getProperty("anaZeigSet");
		
		anaOut = getProperty("anaOut");
		anaOutSet = getProperty("anaOutSet");
		
		anaDig = getProperty("anaDig");
		anaDigSet = getProperty("anaDigSet");
		
		anaCen = getProperty("anaCen");
		anaCenSet = getProperty("anaCenSet");

		var arrlowCol = [Graphics.COLOR_WHITE, Graphics.COLOR_BLUE, Graphics.COLOR_DK_BLUE, Graphics.COLOR_RED, Graphics.COLOR_DK_RED, Graphics.COLOR_GREEN, Graphics.COLOR_DK_GREEN, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_PINK, Graphics.COLOR_PURPLE, Graphics.COLOR_LT_GRAY, Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK];
		
		MyTimeFg = arrlowCol[getProperty("MyTimeFg")];
		Ast.setValue("FgCol", MyTimeFg);
		MyTimeBg = arrlowCol[getProperty("MyTimeBg")];
		Ast.setValue("BgCol", MyTimeBg);
		
		var tempUnits = System.getDeviceSettings().temperatureUnits;
		if (tempUnits == 0){//allf. Imperial Einstellungen in owm übersetzen
			tempUnits = "metric";
		} else {
			tempUnits = "imperial";
		}
		Ast.setValue("tempUnits",tempUnits);
		
		h1 = getProperty("h1");
		h2 = getProperty("h2");
		h3 = getProperty("h3");
		h4 = getProperty("h4");
		h5 = getProperty("h5");
		h6 = getProperty("h6");
		h7 = getProperty("h7");
		h8 = getProperty("h8");
		h9 = getProperty("h9");
		h10 = getProperty("h10");
		h11 = getProperty("h11");
		h12 = getProperty("h12");
		
		vor = getProperty("vor");
		ab = getProperty("ab");
		vorh = getProperty("vorh");
		abh = getProperty("abh");
		
		m5_25_35_55 = getProperty("m5_25_35_55");
		m10_50 = getProperty("m10_50");
		m15_45 = getProperty("m15_45");
		m20_40 = getProperty("m20_40");
		m30 = getProperty("m30");
		m0 = getProperty("m0");

		dnd = getProperty("dnd");

		registerEvents();	    
	    WatchUi.requestUpdate();   //Screenupdate
	}
	
    // onStart() is called on application start up
    function onStart(state) {
    	registerEvents();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
	}

    // Return the initial view of your application here
    function getInitialView() {
		onSettingsChanged();
        return [new MyTimeView()];
    }
        
	function onBackgroundData(data) {
		//System.println("data: "+ data);
		if (data[2] != null) {
			if (data[2].toNumber() == 200) { //data 3 = responseCode des Wetters
				Ast.setValue("WebWeatherCode", data[2]);
				Ast.setValue("WebWeatherTR", data[0]["dt"]); //Zeit der letzten erfolgreichen Antwort
				Ast.setValue("WebTemp", data[0]["main"]["temp"]);
				Ast.setValue("WebOrt", data[0]["name"]);
				Ast.setValue("WebIcon", data[0]["weather"][0]["icon"]);
				Ast.setValue("WebWindDeg", data[0]["wind"]["deg"] + 50);
				Ast.setValue("WebWindSpeed", data[0]["wind"]["speed"] + 50);
				Ast.setValue("WebSunrise", data[0]["sys"]["sunrise"]);
				Ast.setValue("WebSunset", data[0]["sys"]["sunset"]);
				Ast.setValue("WebPressure", data[0]["main"]["pressure"]);
				Ast.setValue("WebHumidity", data[0]["main"]["humidity"]);
				Ast.setValue("WebCountry", data[0]["sys"]["country"]);
			}
		}
		if (data[3] != null) {
			if (data[3].toNumber() == 200) { //data 4 = responseCode der Geo Höhe
				Ast.setValue("WebHCode", data[3]);
				Ast.setValue("WebH", data[1][0]["elevation"]); 
			} else {
				Ast.setValue("WebHCode", data[3]);
			} 
		}
		
		var df = W.getDailyForecast();
		if(df != null) {
			var garCond = "";
			for (var tempDF = 1; tempDF <= 3; tempDF = tempDF + 1){
				Ast.setValue("WebForeTR", Time.now().value());
				Ast.setValue("WebForeD" + tempDF + "T", df[tempDF].lowTemperature);  
				Ast.setValue("WebForeD" + tempDF + "T1", df[tempDF].highTemperature);
				var del =  df[tempDF].condition; //Die 50 Wetterlagen von Garmin in OWM umsetzen
				if (del == 0) {garCond = "01";}
				else if (del == 23 || del == 52) {garCond = "02";}
				else if (del == 1 || del == 22) {garCond = "03";}								
				else if (del == 2) {garCond = "04";}
				else if (del == 10 || del == 15 || del == 19 || del == 26) {garCond = "09";}
				else if (del == 3 || del == 11 || del == 14 || del == 18 || del == 24 || del == 25 || del == 27 || del == 31 || del == 44 || del == 45 || del == 47 || del == 49 || del == 50) {garCond = "10";}
				else if (del == 6 || del == 12 || del == 28) {garCond = "11";}
				else if (del == 4 || del == 7 || del == 16 || del == 17 || del == 21 || del == 34 || del == 43 || del == 46 || del == 48 || del == 51) {garCond = "13";}
				else if (del == 5 || del == 8 || del == 9 || del == 20 || del == 29 || del == 30 || del == 32 || del == 33 || del == 35 || del == 36 || del == 37 || del == 38 || del == 39 || del == 40 || del == 41 || del == 42) {garCond = "50";}
				Ast.setValue("WebForeD" + tempDF + "I", garCond);  
			}
		}
		
		WatchUi.requestUpdate();   //Screenupdate
		
        registerEvents();
    }

 	function registerEvents(){
		var lastTime = Bg.getLastTemporalEventTime();
		if (lastTime != null) {
		    // Events scheduled for a time in the past trigger immediately
		    var nextTime = lastTime.add(X_MINUTES);
		    Bg.registerForTemporalEvent(nextTime);
		} else {
		    Bg.registerForTemporalEvent(Time.now());
		}
	}
	
	function getServiceDelegate(){
        return [new MyServiceDelegate()];
    }
}