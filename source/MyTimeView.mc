using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gc;
using Toybox.System as Sys;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor as AM;
using Toybox.Math;
using Toybox.Timer;
using Toybox.UserProfile as UP;
using Toybox.Activity as Ac;
using Toybox.Application.Storage as Ast;
using Toybox.Position as Pos;
using Toybox.Weather as W;
  
var X, Y; //Für die Winkelberechnungen
var r;

//Font
var FT_ForeTemp;
var FT_RIP;

//Einzelne Variablen, konnte ich nicht weitergeben...
var dist;
var kalo;
var schritte;
var schritteGoal;
var etaPlus;
var etaPlusGoal;
//Datenfeld 6 Status
var DF6_Stat = 1;
//Koordiatenberechnungen
var dis;
var Winkel;
var radWinkel;

class MyTimeView extends Ui.WatchFace {
 
	var schnarch = false; // Sleep Modus
	var ortCount = 0; //Counter für die WebOrt-Laufschrift
	var zufall;
	//ampm Zustand
	var ampmIst;
	//Monate
	var m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12;
	//Tage 
	var d1,d2,d3,d4,d5,d6,d7;
	//Sprache aus String
	var langi;
	//240 = 0 oder 260 = 1 oder 280 = 2
	var ModelTyp;
	//Analog ScreenSaverDigitDatumSchiber
	var anaMove, widthDig;
	
	function getScreen() {
		r = Sys.getDeviceSettings().screenWidth / 2; 
		if (r == 120) { 
			ModelTyp = 0; //240er : 2
		} else if (r == 130) {
			ModelTyp = 1; // 260er : 2
		} else if (r == 140) {
			ModelTyp = 2; // 280er : 2
		}
	}	
	
	var arrPos = [ //Array aller Startpositionen
		[[138,120],[150,130],[162,140]], //DND-Mond Gelber Kreis 0
		[[185,120],[200,130],[215,140]], //DND-Mond Schwarzer Kreis 1
		[[115,190],[122,210],[129,227]], //Datum 2
		[[115,158],[122,172],[129,188]], //Zeit 3	
		[[112,167],[120,182],[125,198]], //Sek 4	
		[[62,167],[67,183],[74,199]], //AMPM 5	
		[[17,142],[19,156],[23,170]], //Batterie 6	
		[[40,176],[44,192],[48,208]], //Bluetooth 7	
		[[197,169],[208,182],[222,200]], //Nachrichten 8	
		[[120,62],[130,65],[140,70]], //BPM 9	
		[[100,218],[110,240],[118,259]], //Alarme 10	
		[[77,51],[79,55],[85,59]], //GehDistanz 11	
		[[67,71],[68,77],[74,83]], //Kalorien 12	
		[[67,91],[68,99],[74,107]], //Schritte 13	
		[[156,58],[175,61],[185,66]], //Etagen 14	
		[[149,76],[168,82],[178,89]], //Höhe 15	
		[[149,91],[168,99],[178,107]], //BMI DF6 16	
		[[157,91],[176,99],[186,107]], //Wind DF6 17	
		[[157,91],[176,99],[186,107]], //Sonne DF6 18	
		[[157,91],[176,99],[186,107]], //Druck DF6 19
		[[171,115],[185,124],[195,134]], //Vorhersage Min 20
		[[194,115],[208,124],[220,134]], //Vorhersage Min 21
		[[218,115],[231,124],[245,134]], //Vorhersage Min 22
		[[171,147],[185,159],[195,169]], //Vorhersage Max 23
		[[194,147],[208,159],[220,169]], //Vorhersage Max 24
		[[218,147],[231,159],[245,169]], //Vorhersage Max 25
		[[170,130],[184,141],[194,151]], //Vorhersage Icon 26
		[[193,130],[207,141],[219,151]], //Vorhersage Icon 27
		[[217,130],[230,141],[244,151]], //Vorhersage Icon 28
		[[233,115],[250,142],[265,151]], //Ampel ModelIs true 29
		[[120,120],[130,130],[140,140]], //Ampel ModelIs false 30
		[[138,218],[151,239],[164,258]], //Mond 31 
		[[180,60],[190,70],[200,80]], //Stunden- und Minutentext(beides Y) 32 
		[[1,1],[1,1],[1,1]], //Stunden- und Minutenzeigerlänge 33 RESET
		[[120,160],[130,180],[140,200]], //Allf. Nachrichten 34 
		[[200,98],[220,108],[240,118]], //Allf. Nachrichten als Text 35 
		[[160,160],[180,180],[200,200]], //Batterie Analog 36 
		[[40,98],[40,110],[40,118]], //Batterie als Text 37 
		[[80,158],[80,178],[80,198]], //Bluetooth Analog 38 
		[[40,138],[40,150],[40,162]], //Bluetooth als Text 39 
		[[215,120],[235,130],[255,140]], //Datum Analog 40  
		[[200,138],[220,148],[240,158]], //Datum als Text 41 
		[[120,65],[130,80],[140,80]], //Datum Digi 42 
		[[120,175],[130,190],[140,205]], //Nachrichten Digi 43 
		[[70,174],[80,189],[90,204]], //Batterie Digi 44 
		[[170,173],[180,188],[190,203]] //BT Digi 45 
	];
	
	function getLastPos() {	
		//Falls eine Höhe aus GPS der Uhr, dann diese hier auslesen. Ansonsten kann es leere Höhen geben
		alti = Ac.getActivityInfo().altitude.toNumber();
		if (alti != null) {
			Ast.setValue("alti", alti);
		}
		var hf = W.getCurrentConditions();
    	if(hf != null) {
			var GarminWeathLati = hf.observationLocationPosition.toDegrees()[0];
			var GarminWeathLongi = hf.observationLocationPosition.toDegrees()[1];
			Ast.setValue("lastLong", GarminWeathLongi);
			Ast.setValue("lastLat", GarminWeathLati);
		}	
	}
	
	function timerCallback() {
		Ui.requestUpdate();
	}
	
	//Herzschlag
	function getHeartRate(dc) {
		var hr = "";
		var hrGet = Activity.getActivityInfo().currentHeartRate;
		if (hrGet != null && hrGet < 250 && hrGet > 40) {hr = hrGet.toString();}
		else {hr = "";}
		return hr;
	}
	
	//Koordinatenberechnung
	function Koord() { 
		Winkel = Winkel - 90; //Null bei Garmin ist bei 3 Uhr
		if (Winkel < 0) {Winkel = Winkel + 360;} //Unter 0 abfangen
		Winkel = Winkel * (-1) + 360; //Umkehren
		radWinkel = Math.toRadians(Winkel); //an Rad
		X = Math.cos(radWinkel) * dis;
		Y = Math.sin(radWinkel) * dis;
		//Schauen, an welchen Quadrant die Koo liegt
		if (Winkel > 0 && Winkel <= 90) {X = r + X; Y = r - Y;}
		else if (Winkel > 90 && Winkel <= 180) {X = r + X; Y = r - Y;}
		else if (Winkel > 180 && Winkel <= 270) {X = r + X; Y = r - Y;}
		else if (Winkel > 270 && Winkel <= 360) {X = r + X; Y = r - Y;}
	}

    function initialize() {
        WatchFace.initialize();
    }
    
    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
		FT_ForeTemp = Ui.loadResource(Rez.Fonts.ForeTemp); //Font für die Vorhersage/Forecast
		FT_RIP = Ui.loadResource(Rez.Fonts.RIP); //Font für die Vorhersage/Forecast
		m1 = Ui.loadResource(Rez.Strings.m1);
		m2 = Ui.loadResource(Rez.Strings.m2);
		m3 = Ui.loadResource(Rez.Strings.m3);
		m4 = Ui.loadResource(Rez.Strings.m4);
		m5 = Ui.loadResource(Rez.Strings.m5);
		m6 = Ui.loadResource(Rez.Strings.m6);
		m7 = Ui.loadResource(Rez.Strings.m7);
		m8 = Ui.loadResource(Rez.Strings.m8);
		m9 = Ui.loadResource(Rez.Strings.m9);
		m10 = Ui.loadResource(Rez.Strings.m10);
		m11 = Ui.loadResource(Rez.Strings.m11);
		m12 = Ui.loadResource(Rez.Strings.m12);
		langi = Ui.loadResource(Rez.Strings.langi);		
		Ast.setValue("langi", langi);
		d1 = Ui.loadResource(Rez.Strings.d1);
		d2 = Ui.loadResource(Rez.Strings.d2);
		d3 = Ui.loadResource(Rez.Strings.d3);
		d4 = Ui.loadResource(Rez.Strings.d4);
		d5 = Ui.loadResource(Rez.Strings.d5);
		d6 = Ui.loadResource(Rez.Strings.d6);
		d7 = Ui.loadResource(Rez.Strings.d7);
        getLastPos();
        getScreen();
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    
//Application.Storage.clearValues();
		
		//Geräteeinstellungen und Aktivität ansprechen
        var DevStat = Sys.getDeviceSettings();
        var AktiMonInfo = AM.getInfo();
        var SysStat = Sys.getSystemStats();
        var ProfInfo = UP.getProfile();
        //Einzelne Infos        
        var AnzAlarm = DevStat.alarmCount;
        var battStat = SysStat.battery.toNumber();
        var telConn = DevStat.phoneConnected;
        var AnzNach = DevStat.notificationCount;
        schritte = AktiMonInfo.steps;
        schritteGoal = AktiMonInfo.stepGoal;
		kalo = AktiMonInfo.calories;
		dist = AktiMonInfo.distance / 10000;
		var cm = ProfInfo.height.toFloat();
		var kg = ProfInfo.weight.toFloat() / 1000;
		var birth = ProfInfo.birthYear;
		var gender = ProfInfo.gender;
		var ampm = DevStat.is24Hour;
		var dndSys = DevStat.doNotDisturb;
		var arrWTag = [d1,d2,d3,d4,d5,d6,d7];
		var arrMonat = [m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12];
		var yMoveBar = 99;
		var wMoveBar = 99;
		var oxyMess = Ac.getActivityInfo().currentOxygenSaturation;
		
		if (dndSys == true && dnd == true) {
			//Bei DnD wird nur ein Mond gezeichnet
        	dc.setColor(Gc.COLOR_BLACK, Gc.COLOR_BLACK);
			dc.fillCircle(r, r, r + 1);
       		dc.setColor(16776960, Gc.COLOR_BLACK); //Gelber Kreis
			dc.fillCircle(arrPos[0][ModelTyp][0],arrPos[0][ModelTyp][1], 45);
        	dc.setColor(Gc.COLOR_BLACK, Gc.COLOR_BLACK);
			dc.fillCircle(arrPos[1][ModelTyp][0],arrPos[1][ModelTyp][1], 75);
        	return;
		} else {		
			//FG- und BG-Farbe nach Sonnenuntergang tauschen 
			if (sw == true) {
				if (Ast.getValue("WebSunrise") && Ast.getValue("WebSunset")) {
					var swSunriseMom = new Time.Moment(Ast.getValue("WebSunrise"));
					var swSunsetMom = new Time.Moment(Ast.getValue("WebSunset"));  
					var swNow = new Time.Moment(Time.now().value());
					if (swNow.greaterThan(swSunsetMom) || swNow.lessThan(swSunriseMom)) { //Also Nacht
						MyTimeFg = Ast.getValue("BgCol");
						MyTimeBg = Ast.getValue("FgCol"); 
					} else {
 						MyTimeFg = Ast.getValue("FgCol"); 
						MyTimeBg = Ast.getValue("BgCol"); 
					}
				}
			}

			//Display leeren
	        dc.setColor(MyTimeBg, MyTimeBg);
			dc.clear();
			
	        // Wochentag und Zeit 
	        var Zeit = Time.now();
	        var Datum =  Gregorian.info(Zeit, Time.FORMAT_SHORT);
	        
	        var Stunde = Lang.format("$1$", [Datum.hour.format("%02d")]);
			var Minute = Lang.format("$1$", [Datum.min.format("%02d")]);
			var Sekunde = Lang.format("$1$", [Datum.sec.format("%02d")]);
	
	        var WTagTemp = Lang.format("$1$", [Datum.day_of_week]).toNumber();
			var Tag  = Lang.format("$1$", [Datum.day.format("%02d")]);
			var Monat = Lang.format("$1$", [Datum.month]);
			
			WTagTemp = WTagTemp - 2;
			if (WTagTemp < 0) {WTagTemp = WTagTemp + 7;}
			var WTag = arrWTag[WTagTemp]; //Array = 0 bis 6, Tage 1 - 7
			Monat = arrMonat[Monat.toNumber()-1]; //Array = 0 bis 11, Monate 1 - 12
			
			//AM / PM Angabe
			if (ampm == false) {
				var numStunde = Stunde.toNumber(); //Stunde als Number
				if (numStunde >= 12){
					ampmIst = "p";
					if (numStunde > 12){
						numStunde = numStunde - 12;
					}
				} else {
					ampmIst = "a";
					if (numStunde == 0) {numStunde = 12;}
				}
				Stunde = numStunde.toString();
			}
			
			//Nur zeichnen wenn schlaf und lowPow = 2 oder wach 
			if (schnarch == true && lowPowView == 2 || schnarch == false ) {
				dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
				//Datum zeichnen
				if(dateView == 0){//Normale Datumsansicht
					var Heute = WTag + " " + Tag+ ". " + Monat;
					dc.drawText(arrPos[2][ModelTyp][0],arrPos[2][ModelTyp][1],  Gc.FONT_SMALL, Heute, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
				} else {
					var Heute = Monat + " " + Tag+ ". " + WTag;
					dc.drawText(arrPos[2][ModelTyp][0],arrPos[2][ModelTyp][1],  Gc.FONT_SMALL, Heute, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
				}
				var Jahr = Lang.format("$1$", [Datum.year]);
				//Zeit
				var Jetzt = Stunde + ":" + Minute; 
				dc.drawText(arrPos[3][ModelTyp][0],arrPos[3][ModelTyp][1],  Gc.FONT_SYSTEM_NUMBER_MILD, Jetzt, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
				//Sekunden
				var stdWidth = dc.getTextWidthInPixels(Jetzt, Gc.FONT_SYSTEM_NUMBER_MILD); //Sek immer im selben Abstand zur Uhrzeit
				if (schnarch == false) {
					dc.drawText(arrPos[4][ModelTyp][0] + stdWidth / 2 + 6, arrPos[4][ModelTyp][1],  FT_ForeTemp, Sekunde, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
				}
				//AmPm schreiben
				if (ampm == false) {
					dc.drawText(arrPos[5][ModelTyp][0],arrPos[5][ModelTyp][1], Gc.FONT_XTINY, ampmIst, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
				} 
				//Batterie
				var xBatt = arrPos[6][ModelTyp][0];
				var yBatt = arrPos[6][ModelTyp][1];
				draw_batt(dc, xBatt, yBatt, battStat, FT_ForeTemp);
		        //Bluetooth-Verbindung
		        var btX = arrPos[7][ModelTyp][0];
		        var btY = arrPos[7][ModelTyp][1];
				draw_bt(dc, btX, btY, telConn);
		        //Nachrichten
		        var mX = arrPos[8][ModelTyp][0];
		        var mY = arrPos[8][ModelTyp][1];
				if (ampm == false) {
			        mX = mX + 5;
				}
				draw_mess(dc, mX, mY, AnzNach);
		        //Herzschlag auslesen
				var hr = getHeartRate(dc);
				var heaX = arrPos[9][ModelTyp][0];
				var heaY = arrPos[9][ModelTyp][1];
				draw_bpm(dc, heaX, heaY, hr, birth, Datum, schnarch, oxyMess);
		        //Alarme
		        var alX = arrPos[10][ModelTyp][0]; 
		        var alY = arrPos[10][ModelTyp][1]; 
				draw_ala(dc, alX, alY, AnzAlarm);
						
				//Obere Hälfte, mit gelaufenen KM, Schritte, Kalorien, Geschlecht usw
				dist = dist.toFloat() / 10;
				dist = dist.format("%.1f");
				var xDist = arrPos[11][ModelTyp][0];
				var yDist = arrPos[11][ModelTyp][1];
				var xCal = arrPos[12][ModelTyp][0];
				var yCal = arrPos[12][ModelTyp][1];
				var stepX = arrPos[13][ModelTyp][0]; 
				var stepY = arrPos[13][ModelTyp][1];
				var xTr = arrPos[14][ModelTyp][0];
				var yTr = arrPos[14][ModelTyp][1];
				var xHoe = arrPos[15][ModelTyp][0];
				var yHoe = arrPos[15][ModelTyp][1];
				
				draw_top_dist(dc, xDist, yDist); 
				
   				var restCalories = 0;
				if (gender == 0) { //Frau   
					restCalories = (-197.6) - 6.116 * (Jahr.toNumber() - birth.toNumber()) + 7.628 * cm + 12.2 * kg;
				} else { //Mann
					restCalories = 5.2 - 6.116 * (Jahr.toNumber() - birth.toNumber()) + 7.628 * cm + 12.2 * kg;
				}
				restCalories = Math.round((Stunde.toNumber() * 60 + Minute.toNumber()) * restCalories / 1440 ).toNumber();
				var actCal = kalo - restCalories;
				draw_top_Cal(dc, xCal, yCal, actCal); 
				 
				draw_top_step(dc, stepX, stepY); 
				if (AktiMonInfo.getInfo() has :floorsClimbed) { 
					etaPlus = AktiMonInfo.floorsClimbed;
					etaPlusGoal = AktiMonInfo.floorsClimbedGoal;
					draw_top_Tr(dc, xTr, yTr);
				} 
				draw_top_Hoe(dc, xHoe, yHoe); 
				
				//Datenfeld 6 = DF6		
 
				var xBMI = arrPos[16][ModelTyp][0];
				var yBMI = arrPos[16][ModelTyp][1];
				var xWind = arrPos[17][ModelTyp][0];
				var yWind = arrPos[17][ModelTyp][1];
				var xSun = arrPos[18][ModelTyp][0];
				var ySun = arrPos[18][ModelTyp][1];
				var xPress = arrPos[19][ModelTyp][0];
				var yPress = arrPos[19][ModelTyp][1];

				if (DF6_Stat > 12) { DF6_Stat = 1;}
				//BMI zeichnen 
				if (DF6_Stat <= 2) {draw_bmi(dc, kg, cm, xBMI, yBMI);}
				//Sonnensachen zeichnen
				else if (DF6_Stat <= 6) {draw_sun(dc, xSun, ySun);}
				//Windsachen zeichnen
				else if (DF6_Stat <= 8) {draw_wind(dc, xWind, yWind);}
				//Drucksachen zeichnen
				else if (DF6_Stat <= 12) {draw_press(dc, xPress, yPress);}
				
				DF6_Stat = DF6_Stat + 1;
		
				//Wetter 
				if (appid1.equals("")) { //Hier gehts nur rein, wenn ein openweathermap vorhanden ist
					dc.drawText(r, r, Gc.FONT_XTINY, "No Openweathermap-Key!", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
				} else {
					if (Ast.getValue("WebWeatherCode")) { //Sobald der WebRequest dieses Feld erzeugt hat
						if (Ast.getValue("WebWeatherCode") != null) {
							if (Ast.getValue("WebWeatherCode") == 200) { //Falls erfolgreich
								//Aktuelles Wetter Temp und Ort
								var WebTemp = Ast.getValue("WebTemp");
								var WebOrt = Ast.getValue("WebOrt");
								var	ortLen = dc.getTextWidthInPixels(WebOrt,Gc.FONT_XTINY); //Anz Pixel des Titels auslesen
								var OrtLenMax = 100; //100 Pixel ist die lesbare Weite beim WebOrt für 240er
								if (ModelTyp == 1) {
									OrtLenMax = 110;
								} else if (ModelTyp == 2) {
									OrtLenMax = 120;
								} else if (ModelTyp == 3) {
									OrtLenMax = 86;
								}
								if (ortLen > OrtLenMax && schnarch == false) { 
									if (ortCount > 8) { // 1.5 Sek.(8 * 0.2) warten, dann die Laufschrift starten
										dc.drawText(4 - ortCount + 8, r, Gc.FONT_XTINY, WebOrt, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
									} else {
										dc.drawText(4, r, Gc.FONT_XTINY, WebOrt, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
									}
									if (ortLen - OrtLenMax <= ortCount - 8) {
									//Hier noch 2 Sek. Pause einfügen, aber wie???	
										ortCount = 0;
									} else {
										ortCount = ortCount + 2; //4 Pixel nach links, damit der Text schneller läuft
									}
								} else {
									dc.drawText(OrtLenMax + 4, r, Gc.FONT_XTINY, WebOrt, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
									//Differenz mit Animation füllen
									for (var i = 0; i <= (OrtLenMax - ortLen - 8) / 2; i = i + 1) {
										zufall = Math.rand() % 7 + 1;
										dc.drawLine(4 + i * 2, r, 4 + i * 2, r - zufall);
										dc.drawLine(4 + i * 2, r, 4 + i * 2, r + zufall);
									}
								}
								dc.setColor(MyTimeBg, MyTimeBg); //Farbiges Rechteck um den Text zu überblenden
								dc.fillRectangle(OrtLenMax + 6, r - 10, 62, 20); //116, r - 10, 62, 20); 
								dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT); 
								dc.drawText(OrtLenMax + 48, r, Gc.FONT_XTINY, WebTemp.toNumber() + "°", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
								//Icon des aktuellen Wetters
								var WebIcon = Ast.getValue("WebIcon");
								var xI = r; 
								var yI = r; 
								WebIcon = WebIcon.substring(0,2);
								//System.println(WebIcon);
								if (WebIcon.equals("01")) { 
									draw_icon_01(dc,xI,yI);
								} else if (WebIcon.equals("02")) { 
									draw_icon_02(dc,xI,yI);
								} else if (WebIcon.equals("03")) {
									draw_icon_03(dc,xI,yI);
								} else if (WebIcon.equals("04")) {
									draw_icon_04(dc,xI,yI);
								} else if (WebIcon.equals("09")) {
									draw_icon_09(dc,xI,yI);
								} else if (WebIcon.equals("10")) {
									draw_icon_10(dc,xI,yI);
								} else if (WebIcon.equals("11")) {
									draw_icon_11(dc,xI,yI);
								} else if (WebIcon.equals("13")) {
									draw_icon_13(dc,xI,yI);
								} else if (WebIcon.equals("50")) {
									draw_icon_50(dc,xI,yI);
								}
								dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT); 
							}
						}
					}
					
					var df = W.getDailyForecast();
					if(df != null) {
						if (Ast.getValue("WebForeD1T")) {
							//Tag 1
							var WebForeD1T = Ast.getValue("WebForeD1T");
							if (System.getDeviceSettings().temperatureUnits == 1){WebForeD1T = (WebForeD1T * 9/5) + 32;}
							dc.drawText(arrPos[20][ModelTyp][0], arrPos[20][ModelTyp][1], FT_ForeTemp, WebForeD1T, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
							//Tag 2
							var WebForeD2T = Ast.getValue("WebForeD2T");
							if (System.getDeviceSettings().temperatureUnits == 1){WebForeD2T = (WebForeD2T * 9/5) + 32;}
							dc.drawText(arrPos[21][ModelTyp][0], arrPos[21][ModelTyp][1], FT_ForeTemp, WebForeD2T, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
							//Tag 3
							var WebForeD3T = Ast.getValue("WebForeD3T");
							if (System.getDeviceSettings().temperatureUnits == 1){WebForeD3T = (WebForeD3T * 9/5) + 32;}
							dc.drawText(arrPos[22][ModelTyp][0], arrPos[22][ModelTyp][1], FT_ForeTemp, WebForeD3T, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						}
						if (Ast.getValue("WebForeD1T1")) {
							//Tag 1
							var WebForeD1T1 = Ast.getValue("WebForeD1T1");
							if (System.getDeviceSettings().temperatureUnits == 1){WebForeD1T1 = (WebForeD1T1 * 9/5) + 32;}
							dc.drawText(arrPos[23][ModelTyp][0], arrPos[23][ModelTyp][1], FT_ForeTemp, WebForeD1T1, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
							//Tag 2
							var WebForeD2T1 = Ast.getValue("WebForeD2T1");
							if (System.getDeviceSettings().temperatureUnits == 1){WebForeD2T1 = (WebForeD2T1 * 9/5) + 32;}
							dc.drawText(arrPos[24][ModelTyp][0], arrPos[24][ModelTyp][1], FT_ForeTemp, WebForeD2T1, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
							//Tag 3
							var WebForeD3T1 = Ast.getValue("WebForeD3T1");
							if (System.getDeviceSettings().temperatureUnits == 1){WebForeD3T1 = (WebForeD3T1 * 9/5) + 32;}
							dc.drawText(arrPos[25][ModelTyp][0], arrPos[25][ModelTyp][1], FT_ForeTemp, WebForeD3T1, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						}
						
						//Icons der 3 Tage, egal von wo
						if (Ast.getValue("WebForeD1I")) {
							var WebForeD1I = Ast.getValue("WebForeD1I");
							var WebForeD2I = Ast.getValue("WebForeD2I");
							var WebForeD3I = Ast.getValue("WebForeD3I");
							var arrIcon = [
								[WebForeD1I, arrPos[26][ModelTyp][0], arrPos[26][ModelTyp][1]],
								[WebForeD2I, arrPos[27][ModelTyp][0], arrPos[27][ModelTyp][1]],
								[WebForeD3I, arrPos[28][ModelTyp][0], arrPos[28][ModelTyp][1]] 
							];
							for (var i = 0; i < 3; i = i + 1) { 
								if (arrIcon[i][0].equals("01")) { 
									arrIcon[i][1] = arrIcon[i][1] + 1;
									arrIcon[i][2] = arrIcon[i][2];
									draw_icon_01(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("02")) {
									draw_icon_02(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("03")) {
									draw_icon_03(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("04")) {
									draw_icon_04(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("09")) {
									draw_icon_09(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("10")) {
									draw_icon_10(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("11")) {
									draw_icon_11(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("13")) {
									draw_icon_13(dc,arrIcon[i][1],arrIcon[i][2]);
								} else if (arrIcon[i][0].equals("50")) {
									draw_icon_50(dc,arrIcon[i][1],arrIcon[i][2]);
								}
								dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT); 
							}	
						}
					} else {
						dc.drawText(arrPos[21][ModelTyp][0], arrPos[21][ModelTyp][1], Gc.FONT_SYSTEM_XTINY, "no data", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						dc.drawText(arrPos[27][ModelTyp][0], arrPos[27][ModelTyp][1], Gc.FONT_SYSTEM_XTINY, "from", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						dc.drawText(arrPos[24][ModelTyp][0], arrPos[24][ModelTyp][1], Gc.FONT_SYSTEM_XTINY, "Garmin", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					}
					
					//Aktualität der positiven Webabfragen, Ampel
					var xAmp = arrPos[29][ModelTyp][0];
					var yAmp = arrPos[29][ModelTyp][1];
					if (Ast.getValue("WebWeatherCode") ){ 
						if (Ast.getValue("WebWeatherCode") != null ){ 
							if (Ast.getValue("WebWeatherCode") == 200 ){ 
								//Zeitdifferenz zu den geglückten Abfragen für die Ampel
								var WebWeatherTR = Ast.getValue("WebWeatherTR"); //Letzte erfolgreiche Antwort
								var diffWeather = Time.now().value() - WebWeatherTR;
								if (diffWeather <= 3600 ){//Grösser 1 Std. Orange
									dc.setColor(Gc.COLOR_GREEN, Gc.COLOR_TRANSPARENT);
									dc.fillCircle(xAmp, yAmp, 2);
								} else if (diffWeather > 7200 ){//Grösser 2 Std Rot
									dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
									dc.fillCircle(xAmp, yAmp, 4);
								} else if (diffWeather > 3600 ){//Sonst Grün
									dc.setColor(Gc.COLOR_ORANGE, Gc.COLOR_TRANSPARENT);
									dc.fillCircle(xAmp, yAmp, 3);
								}
							}
						}
					} dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
				}
		
		 		//Mond
		 		var xMond = arrPos[31][ModelTyp][0];
		 		var yMond = arrPos[31][ModelTyp][1];
		 		draw_moon(dc, xMond, yMond); 
		 		
		 		//Deko und Überschrift
				dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
		 		if (ModelTyp == 0) { //= 240er
					dc.drawLine(50, 38, 90, 38);
					dc.drawLine(150, 38, 190, 38);
			        dc.fillRectangle(60, 0, 140, 3);
			        dc.fillRectangle(60, 237, 140, 3); 
					dc.drawLine(150, 106, 226, 106); 
					if (moveBar){
						yMoveBar = 106;
						wMoveBar = 7;
					} else {
						dc.drawLine(14, 106, 90, 106);
					}
					dc.drawLine(14, 134, 90, 134);
					dc.drawLine(117, 209, 117, 228);
					dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
					if(dndSys){
						dc.drawText(r, 22, Gc.FONT_SMALL, "PSSSTTT...", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					} else {
						dc.drawText(r, 22, Gc.FONT_SMALL, title, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					}
				} else if (ModelTyp == 1) { //= 260er
					dc.drawLine(55, 40, 99, 40);
					dc.drawLine(161, 40, 204, 40);
			        dc.fillRectangle(60, 0, 140, 3);
			        dc.fillRectangle(60, 257, 140, 3); 
					dc.drawLine(162, 114, 244, 114);
					if (moveBar){
						yMoveBar = 115;
						wMoveBar = 8;
					} else {
						dc.drawLine(14, 114, 98, 114);
					}
					dc.drawLine(14, 146, 98, 146);
					dc.drawLine(129, 231, 129, 250);
					dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
					if(dndSys){
						dc.drawText(r, 23, Gc.FONT_SMALL, "PSSSTTT...", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					} else {
						dc.drawText(r, 23, Gc.FONT_SMALL, title, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					}
				} else if (ModelTyp == 2) { //= 280er
					dc.drawLine(50, 44, 108, 44);
					dc.drawLine(172, 44, 230, 44);
			        dc.fillRectangle(60, 0, 140, 3);
			        dc.fillRectangle(60, 277, 140, 3); 
					dc.drawLine(172, 124, 266, 124);
					if (moveBar){
						yMoveBar = 125;
						wMoveBar = 9;
					} else {
						dc.drawLine(14, 124, 108, 124);
					}
					dc.drawLine(14, 157, 108, 157);
					dc.drawLine(139, 250, 139, 268);
					dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
					if(dndSys){
						dc.drawText(r, 23, Gc.FONT_SMALL, "PSSSTTT...", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					} else {
						dc.drawText(r, 23, Gc.FONT_SMALL, title, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					}
				}
			}
			
			if (moveBar && schnarch == false){
				dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
				var moveBarL = AktiMonInfo.moveBarLevel;
				dc.drawRoundedRectangle(14, yMoveBar - 4, wMoveBar*5-2, wMoveBar, 2);
				dc.drawRoundedRectangle(14 + wMoveBar*5+2, yMoveBar - 4, 7, wMoveBar, 2);
				dc.drawRoundedRectangle(14 + wMoveBar*6+4, yMoveBar - 4, 7, wMoveBar, 2);
				dc.drawRoundedRectangle(14 + wMoveBar*7+6, yMoveBar - 4, 7, wMoveBar, 2);
				dc.drawRoundedRectangle(14 + wMoveBar*8+8, yMoveBar - 4, 7, wMoveBar, 2);
				if (moveBarL == 1){
					dc.fillRoundedRectangle(14, yMoveBar - 4, wMoveBar*5-2, wMoveBar, 2);
				} else if (moveBarL == 2){
					dc.fillRoundedRectangle(14, yMoveBar - 4, wMoveBar*5-2, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*5+2, yMoveBar - 4, 7, wMoveBar, 2);
				} else if (moveBarL == 3){
					dc.fillRoundedRectangle(14, yMoveBar - 4, wMoveBar*5-2, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*5+2, yMoveBar - 4, 7, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*6+4, yMoveBar - 4, 7, wMoveBar, 2);
				} else if (moveBarL == 4){
					dc.fillRoundedRectangle(14, yMoveBar - 4, wMoveBar*5-2, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*5+2, yMoveBar - 4, 7, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*6+4, yMoveBar - 4, 7, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*7+6, yMoveBar - 4, 7, wMoveBar, 2);
				} else if (moveBarL == 5){
					dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
					dc.fillRoundedRectangle(14, yMoveBar - 4, wMoveBar*5-2, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*5+2, yMoveBar - 4, 7, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*6+4, yMoveBar - 4, 7, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*7+6, yMoveBar - 4, 7, wMoveBar, 2);
					dc.fillRoundedRectangle(14 + wMoveBar*8+8, yMoveBar - 4, 7, wMoveBar, 2);
				}
				dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
			}
			//Screensaver ein
			
		    if(dc has :setAntiAlias) {
		        dc.setAntiAlias(true);
		    }
				
			if (schnarch == true && lowPowView != 2) {
			
				var Hour = Stunde.toNumber();
				if (Hour >= 12) {Hour = Hour - 12;}
				var M = Minute.toNumber();
				
				anaMove = 0;
				widthDig = 0;

				dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);

				if (lowPowView == 1) { //Zeit als Text
				
					//Minuten-Koordinaten darstellen.
					dis = r - 8;
					Winkel = M * 6;
					Koord();
					dc.fillCircle(X, Y, 5);
			
					//Low Power Modus
					var minText = "";
					var stdText = "";
					var vorText = "";
					
					if (Hour == 0 && M < 25) { stdText = h12;}
					else if (Hour == 0 && M >= 25) { stdText = h1;}
					else if (Hour == 1 && M < 25) { stdText = h1;}
					else if (Hour == 1 && M >= 25) { stdText = h2;}
					else if (Hour == 2 && M < 25){ stdText = h2;}
					else if (Hour == 2 && M >= 25){ stdText = h3;}
					else if (Hour == 3 && M < 25) { stdText = h3;}
					else if (Hour == 3 && M >= 25) { stdText = h4;}
					else if (Hour == 4 && M < 25) { stdText = h4;}
					else if (Hour == 4 && M >= 25) { stdText = h5;}
					else if (Hour == 5 && M < 25) { stdText = h5;}
					else if (Hour == 5 && M >= 25) { stdText = h6;}
					else if (Hour == 6 && M < 25) { stdText = h6;}
					else if (Hour == 6 && M >= 25) { stdText = h7;}
					else if (Hour == 7 && M < 25) { stdText = h7;}
					else if (Hour == 7 && M >= 25) { stdText = h8;}
					else if (Hour == 8 && M < 25) { stdText = h8;}
					else if (Hour == 8 && M >= 25) { stdText = h9;}
					else if (Hour == 9 && M < 25) { stdText = h9;}
					else if (Hour == 9 && M >= 25) { stdText = h10;}
					else if (Hour == 10 && M < 25) { stdText = h10;}
					else if (Hour == 10 && M >= 25) { stdText = h11;}
					else if (Hour == 11 && M < 25) { stdText = h11;}
					else if (Hour == 11 && M >= 25) { stdText = h12;}
					
					if (M >= 55) { minText = m5_25_35_55; vorText = vor;}
					else if (M >= 50) { minText = m10_50; vorText = vor;}
					else if (M >= 45) { minText = m15_45; vorText = vor;}
					else if (M >= 40) { minText = m20_40; vorText = vor;}
					else if (M >= 35) { minText = m5_25_35_55; vorText = abh;}
					else if (M >= 30) { minText = m30; vorText = "";}
					else if (M >= 25) { minText = m5_25_35_55; vorText = vorh;}
					else if (M >= 20) { minText = m20_40; vorText = ab;}
					else if (M >= 15) { minText = m15_45; vorText = ab;}
					else if (M >= 10) { minText = m10_50; vorText = ab;}
					else if (M >= 5) { minText = m5_25_35_55; vorText = ab;}
					else if (M >= 0) { minText = m0; vorText = "";}
					//Text setzen
					var stdTextH = arrPos[32][ModelTyp][0]; 
					var minTextH = arrPos[32][ModelTyp][1];
					if (minText.equals("Haubi") || minText.equals("Es isch")) {
						stdTextH = stdTextH - 20;
						minTextH = minTextH + 20;
						dc.drawText(r, minTextH,  Gc.FONT_LARGE, minText , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						dc.drawText(r, stdTextH,  Gc.FONT_LARGE, stdText , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					} else {
						dc.drawText(r, r,  Gc.FONT_LARGE, vorText , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						dc.drawText(r, minTextH,  Gc.FONT_LARGE, minText , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						dc.drawText(r, stdTextH,  Gc.FONT_LARGE, stdText , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					}
					
				} else if (lowPowView == 3) { //Digitale Anzeige
					//Zeit gross
					dc.drawText(r, r,  Gc.FONT_NUMBER_THAI_HOT, Stunde + ":" + Minute , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);

				} else if (lowPowView == 0) { //Analoge Anzeige, bzw Stundenzeiger
					if (anaDigSet.length() != 2) {anaDigSet = "33";}
					if (anaCenSet.length() != 2) {anaCenSet = "48";}
					if (anaZeigSet.length() != 6) {anaZeigSet = "865433";}
					if (anaOutSet.length() != 6) {anaOutSet = "326424";}
					//Zeiger
					if (anaZeig == 0) { //Simple Line
						dc.setPenWidth(anaZeigSet.substring(1, 2).toNumber()); 
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber(); //Minutenzeiger
						Winkel = M * 6;
						Koord();
						dc.drawLine(r, r, X, Y);
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber() / 2; //Stundenzeiger
						Winkel = (Hour * 30) + (M / 10 * 5);
						Koord();
						dc.drawLine(r, r, X, Y);
						dc.setPenWidth(1);
					} else if (anaZeig == 1) { //Dreieckzeiger
						var xP1, yP1, xP2, yP2;//Minute
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber() / 10 * anaZeigSet.substring(2, 3).toNumber(); //Punkt links
						Winkel = M * 6 - anaZeigSet.substring(3, 4).toNumber();
						if (Winkel <= 0) {Winkel = Winkel + 360;}
						Koord();
						xP1 = X;
						yP1 = Y;
						Winkel = M * 6 + anaZeigSet.substring(3, 4).toNumber(); //Punkt rechts
						if (Winkel >= 360) {Winkel = Winkel - 360;}
						Koord();
						xP2 = X;
						yP2 = Y;
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber();
						Winkel = M * 6;
						Koord();
						var arrP = [[r,r],[xP1,yP1],[X,Y],[xP2,yP2]];
						dc.fillPolygon(arrP);
						//Stunde
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber() / 10 * anaZeigSet.substring(2, 3).toNumber() / 2; //Punkt links
						Winkel = (Hour * 30) + (M / 10 * 5) - 2 * anaZeigSet.substring(3, 4).toNumber();
						if (Winkel <= 0) {Winkel = Winkel + 360;}
						Koord();
						xP1 = X;
						yP1 = Y;
						Winkel = (Hour * 30) + (M / 10 * 5) + 2 * anaZeigSet.substring(3, 4).toNumber(); //Punkt rechts
						if (Winkel >= 360) {Winkel = Winkel - 360;} 
						Koord();
						xP2 = X;
						yP2 = Y; 
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber() / 2;
						Winkel = (Hour * 30) + (M / 10 * 5);
						Koord();
						arrP = [[r,r],[xP1,yP1],[X,Y],[xP2,yP2]]; 
						dc.fillPolygon(arrP);
					} else if (anaZeig == 2) { //Punkte
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber();
						Winkel = M * 6;
						Koord();
						dc.fillCircle(X, Y, anaZeigSet.substring(4, 5).toNumber() * 2);
						dis = r / 10 * anaZeigSet.substring(0, 1).toNumber() / 2; //Stunde
						Winkel = (Hour * 30) + (M / 10 * 5);
						Koord();
						dc.fillCircle(X, Y, anaZeigSet.substring(5, 6).toNumber() * 2);
					}
					//Ziffernblatt
					//Uhrdesign 1 Min Striche
					if (anaOut == 1) {
						dc.setPenWidth(anaOutSet.substring(0, 1).toNumber());
						var anaX, anaY;
						for (var w = 1; w <= 60; w = w + 1) {
							dis = r;
							Winkel = w * 6;
							Koord();
							anaX = X;
							anaY = Y;
							dis = r - 2 * anaOutSet.substring(1, 2).toNumber();
							Winkel = w * 6;
							Koord();
							dc.drawLine(anaX, anaY, X, Y);
						}
						dc.setPenWidth(1);
						anaMove = anaMove + 2 * anaOutSet.substring(1, 2).toNumber(); //Der Abstand entspricht der Strichlänge
					} else if (anaOut == 2) {//Uhrdesign 5 Min Striche
						var anaX, anaY;
						dc.setPenWidth(anaOutSet.substring(2, 3).toNumber());
						for (var w = 1; w <= 12; w = w + 1) {
							dis = r;
							Winkel = w * 30;
							Koord();
							anaX = X;
							anaY = Y;
							dis = r - 2 * anaOutSet.substring(3, 4).toNumber();
							Winkel = w * 30;
							Koord();
							dc.drawLine(anaX, anaY, X, Y);
						}
						dc.setPenWidth(1);
						anaMove = anaMove + 2 * anaOutSet.substring(3, 4).toNumber(); //Der Abstand entspricht der Strichlänge
					} else if (anaOut == 3) {//Uhrdesign 1 / 5 Min Striche
						var anaX, anaY;
						dc.setPenWidth(anaOutSet.substring(0, 1).toNumber());
						for (var w = 1; w <= 60; w = w + 1) {
							dis = r;
							Winkel = w * 6;
							Koord();
							anaX = X;
							anaY = Y;
							dis = r - 2 * anaOutSet.substring(1, 2).toNumber();
							Winkel = w * 6;
							Koord();
							dc.drawLine(anaX, anaY, X, Y);
						}
						dc.setPenWidth(anaOutSet.substring(2, 3).toNumber());
						for (var w = 1; w <= 12; w = w + 1) {
							dis = r;
							Winkel = w * 30;
							Koord();
							anaX = X;
							anaY = Y;
							dis = r - 2 * anaOutSet.substring(3, 4).toNumber();
							Winkel = w * 30;
							Koord();
							dc.drawLine(anaX, anaY, X, Y);
						}
						dc.setPenWidth(1);
						anaMove = anaMove + 2 * anaOutSet.substring(3, 4).toNumber(); //Der Abstand entspricht der Strichlänge
					} else if (anaOut == 4) {//Uhrdesign 1 Minuten Punkte
						for (var w = 1; w <= 60; w = w + 1) {
							dis = r - 2 - anaOutSet.substring(5, 6).toNumber();
							Winkel = w * 6;
							Koord();
							dc.fillCircle(X, Y, anaOutSet.substring(4, 5).toNumber());
						}
						anaMove = anaMove + 2 + 2 * anaOutSet.substring(5, 6).toNumber(); //*2 weil ja der Radius gegeben ist
					} else if (anaOut == 5) {//Uhrdesign 5 Minuten Punkte
						for (var w = 1; w <= 12; w = w + 1) {
							dis = r - 2 - anaOutSet.substring(5, 6).toNumber();
							Winkel = w * 30;
							Koord();
							dc.fillCircle(X, Y, anaOutSet.substring(5, 6).toNumber());
						}
						anaMove = anaMove + 2 + 2 * anaOutSet.substring(5, 6).toNumber(); //*2 weil ja der Radius gegeben ist
					} else if (anaOut == 6) {//Uhrdesign 1 und 5 Minuten Punkte
						for (var w = 1; w <= 12; w = w + 1) {
							dis = r - 2 - anaOutSet.substring(5, 6).toNumber();
							Winkel = w * 30;
							Koord();
							dc.fillCircle(X, Y, anaOutSet.substring(5, 6).toNumber());
						}
						for (var w = 1; w <= 60; w = w + 1) {
							dis = r - 2 - anaOutSet.substring(5, 6).toNumber();
							Winkel = w * 6;
							Koord();
							dc.fillCircle(X, Y, anaOutSet.substring(4, 5).toNumber());
						}
						anaMove = anaMove + 2 + 2 * anaOutSet.substring(5, 6).toNumber(); //*2 weil ja der Radius gegeben ist
					}
					//Uhr Ziffern
					if (anaDig == 1) {//Uhrdesign Ziffern 3/6/9/12
						var arrZiff = [180, 270, 0]; //Ohne 3 Uhr
						widthDig = dc.getTextWidthInPixels("12", (anaDigSet.substring(0, 1).toNumber()) + 1) / 2;//Die Breite der Zahl 12, ist die breiteste, mit dem gewählten Font
						for (var w = 1; w <= 3; w = w + 1) {
							dis = r - anaMove - widthDig - 2;
							Winkel = arrZiff[w - 1];
							Koord();
							dc.drawText(X, Y, anaDigSet.substring(0, 1).toNumber() + 1, w * 3 + 3 , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						}
					} else if (anaDig == 2) {//Uhrdesign Ziffern 1 - 12
						var arrZiff = [30,60,90,120,150,180,210,240,270,300,330,360];
						widthDig = dc.getTextWidthInPixels("12", (anaDigSet.substring(1, 2).toNumber()) + 1) / 2;
						for (var w = 1; w <= 12; w = w + 1) {
							dis = r - anaMove - widthDig - 2;
							Winkel = arrZiff[w - 1];
							Koord();
							if (w != 3) { //Dort steht das Datum
								dc.drawText(X, Y, anaDigSet.substring(1, 2).toNumber() + 1, w , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
							}
						}
					}
					//Zentrumspunkt
					if (anaCen == 1) {
						dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
						dc.fillCircle(r, r, anaCenSet.substring(0, 1).toNumber());//Zentrumspunkt innen
					} else if (anaCen == 2 ) {
						dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
						dc.fillCircle(r, r, anaCenSet.substring(1, 2).toNumber());//Zentrumspunkt aussen
						dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
						dc.fillCircle(r, r, anaCenSet.substring(0, 1).toNumber());//Zentrumspunkt innen
					}
					dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
				} 
				//Batterie / Datum usw.
				if (lowPowView != 2) {	
				//Wenn nicht das Red. Updateintervall gewählt wurde, dann div. Infos anzeigen
					//Allf. Nachrichten simpel darstellen
					dc.setPenWidth(2);
					if (AnzNach > 0) {
						var xN = arrPos[34][ModelTyp][0]; 
						var yN = arrPos[34][ModelTyp][1];
						if (lowPowView == 1) { //1 = Zeit als Text
							xN = arrPos[35][ModelTyp][0]; 
							yN = arrPos[35][ModelTyp][1];
						} else if (lowPowView == 3) { //3 = Digital
							xN = arrPos[43][ModelTyp][0]; 
							yN = arrPos[43][ModelTyp][1];
						} 
						dc.drawRectangle(xN - 10, yN - 6, 20, 12);
						dc.drawLine(xN - 10, yN - 6, xN - 1, yN);
						dc.drawLine(xN + 8, yN - 6, xN - 1, yN);
					}
					//Falls die Batterie unter 20% fällt
					if (battStat < 20) { 
						var xB = arrPos[36][ModelTyp][0]; 
						var yB = arrPos[36][ModelTyp][1];
						if (lowPowView == 1) { //1 = Zeit als Text
							xB = arrPos[37][ModelTyp][0]; 
							yB = arrPos[37][ModelTyp][1];
							if (telConn == true) {yB = r;}
						} else if (lowPowView == 3) { //3 = Digital
							xB = arrPos[44][ModelTyp][0];
							yB = arrPos[44][ModelTyp][1];
						}
						dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
						dc.fillRectangle(xB - 9, yB - 5, 4, 9);
						dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
						dc.drawRectangle(xB - 10, yB - 6, 20, 12);
						dc.fillRectangle(xB + 10, yB - 4, 3, 7);
					}
					//BT-Verbindung
					dc.setPenWidth(1);	
					if (telConn == false) {
						var xC = arrPos[38][ModelTyp][0]; 
						var yC = arrPos[38][ModelTyp][1]; 
						if (lowPowView == 1) { //1 = Zeit als Text
							xC = arrPos[39][ModelTyp][0];
							yC = arrPos[39][ModelTyp][1]; 
							if (battStat >= 20) {yC = r;}
						} else if (lowPowView == 3) { //3 = Digital 
							xC = arrPos[45][ModelTyp][0];
							yC = arrPos[45][ModelTyp][1]; 
						}
						dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
						dc.drawText(xC, yC,  Gc.FONT_XTINY, "BT" , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
						dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
					}
					//Datum
					var xD = arrPos[40][ModelTyp][0] - anaMove; 
					var yD = arrPos[40][ModelTyp][1];
					var lowPowDate = Lang.format("$1$", [Datum.day.format("%02d")]);
					if (lowPowView == 1) { //1 = Zeit als Text
						xD = arrPos[41][ModelTyp][0]; 
						yD = arrPos[41][ModelTyp][1];
						if (AnzNach == 0) {yD = r;}
					} else if (lowPowView == 3) { //3 = Digital
						xD = arrPos[42][ModelTyp][0];
						yD = arrPos[42][ModelTyp][1]; 
					}
					if (lowPowView == 3) {
						//Digitale Anzeige => Datum mit Text
						var Heute = WTag + " " + Tag + ". " + Monat;
						dc.drawText(xD, yD,  Gc.FONT_TINY, Heute , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					} else {
						var arrTxtDim = dc.getTextDimensions(lowPowDate, Gc.FONT_TINY); //Rechteck ums Datum
						dc.drawRoundedRectangle(xD - arrTxtDim[0]  / 2 - 2, yD - arrTxtDim[0] / 2, arrTxtDim[0] + 4, arrTxtDim[0] + 1, 3);
						dc.drawText(xD, yD, Gc.FONT_TINY, lowPowDate , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
					}
					dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
				}
				if(dc has :setAntiAlias) {
		        	dc.setAntiAlias(false);
		   		}
			}		//} //Schnarch Ende
		}	// DND Ende
    } //Function OnUpdate Ende

    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
		schnarch =false;
		ortCount = 0;
		getLastPos(); //Letzte Position aus der Aktivität lesen
    }

    // Terminate any active timers and prepare for slow updates
    function onEnterSleep() {
		schnarch = true;
		Ui.requestUpdate();
    }
}
