using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System;
using Toybox.Math;

function draw_bmi(dc, kg, cm, xBMI, yBMI) {
	//Hamburgersymbol
	dc.drawLine(xBMI, yBMI - 1, xBMI + 15, yBMI - 1);
	dc.drawArc(xBMI + 7, yBMI + 3, 9, 0, 35, 145);
	dc.drawRoundedRectangle(xBMI - 2, yBMI, 19, 5, 2);
	dc.drawRoundedRectangle(xBMI, yBMI + 5, 15, 4, 2);
	dc.drawPoint(xBMI + 5, yBMI - 3);
	dc.drawPoint(xBMI + 8, yBMI - 4);
	if (kg != null && cm != null) { //Nur wenn die nötigen Angaben vorhanden sind
		cm = cm / 100; //cm in Meter
		var bmi = kg / cm / cm;
		if (bmi < 16) {dc.setColor(Gc.COLOR_PURPLE, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 16 && bmi <= 16.9) {dc.setColor(Gc.COLOR_DK_BLUE, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 17 && bmi <= 18.4) {dc.setColor(Gc.COLOR_BLUE, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 18.5 && bmi <= 24.9) {dc.setColor(Gc.COLOR_GREEN, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 25 && bmi <= 29.9) {dc.setColor(Gc.COLOR_YELLOW, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 30 && bmi <= 34.9) {dc.setColor(Gc.COLOR_ORANGE, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 35 && bmi <= 39.9) {dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);}
		else if(bmi >= 40) {dc.setColor(Gc.COLOR_DK_RED, Gc.COLOR_TRANSPARENT);}
		dc.fillCircle(xBMI + 62, yBMI, 2);
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		dc.drawText(xBMI + 24, yBMI, Gc.FONT_SYSTEM_XTINY, bmi.format("%.1f"), Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
	}
}

function draw_wind(dc, xWind, yWind) {
	//Richtungs-Symbol
	if (Ast.getValue("WebWindDeg")) {
		var WebWindDeg = Ast.getValue("WebWindDeg").toNumber() - 50 - 180;
		if (WebWindDeg < 0) {WebWindDeg = WebWindDeg + 360;} //Die Richtung um 180 Grad drehen
//		if (WebWindDeg == 0) { //Bei Windstille wird ein Punkt gezeichnet
//			dc.fillCircle(xWind, yWind, 3);
//		} else {
			var arrWindDis = [7, 8, 1, 8]; //4 Distanzen, um den Pfeil zu zeichnen
			var arrWindWinkelDef = [0, 135, 180, 225]; //Vier Winkel für den Pfeil
			var arrWindWinkel = new [4];
			for (var w = 0; w < 4; w = w + 1) {
				arrWindWinkel[w] = WebWindDeg + arrWindWinkelDef[w]; //Winkel zur Windrichtung dazuzählen
				if (arrWindWinkel[w] > 360) {
					arrWindWinkel[w] = arrWindWinkel[w] - 360;
				}
			}
			//Mehrdim Array muss vordefiniert werden
			var arrWindPts = [[1,1], [1,1], [1,1], [1,1]];
			for ( var w = 0; w < 4; w = w + 1) {
				dis = arrWindDis[w];
				Winkel = arrWindWinkel[w];
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
				arrWindPts[w][0] = X - r + xWind;
				arrWindPts[w][1] = Y - r + yWind;
			}
			dc.fillPolygon(arrWindPts);
		//}
	}
	//Text
	if (Ast.getValue("WebWindSpeed")) {
		var WebWindSpeed = (Ast.getValue("WebWindSpeed") - 50); //-50 ist ein Wert den ich beim Speichern dazuzähle aus irgendwelchen Gründen
		if (Ast.getValue("tempUnits").equals("metric")){WebWindSpeed = WebWindSpeed * 3.6;}//Aus owm kommt meterprosekunde oder milesperhour
		WebWindSpeed = WebWindSpeed.toNumber();
		if (Ast.getValue("tempUnits").equals("metric")){
			dc.drawText(xWind + 16, yWind, Gc.FONT_SYSTEM_XTINY, WebWindSpeed.toString() + " km/h", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
		} else {
			dc.drawText(xWind + 16, yWind, Gc.FONT_SYSTEM_XTINY, WebWindSpeed.toString() + " mph", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
		}
	} else {
		dc.drawText(xWind, yWind, Gc.FONT_SYSTEM_XTINY, "No Wind", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
	}
}

function draw_sun(dc, xSun, ySun) {
	if (Ast.getValue("WebSunrise") && Ast.getValue("WebSunset")) {
		//Symbol
		dc.fillCircle(xSun, ySun, 5);
		dc.drawLine(xSun + 7, ySun, xSun + 9, ySun);
		dc.drawLine(xSun + 5, ySun + 5, xSun + 7, ySun + 7);
		dc.drawLine(xSun, ySun + 7, xSun, ySun + 9);
		dc.drawLine(xSun - 5, ySun + 5, xSun - 7, ySun + 7);
		dc.drawLine(xSun - 7, ySun, xSun - 9, ySun);
		dc.drawLine(xSun - 5, ySun - 5, xSun - 7, ySun - 7);
		dc.drawLine(xSun, ySun - 7, xSun, ySun - 9);
		dc.drawLine(xSun + 5, ySun - 5, xSun + 7, ySun - 7);
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		if (DF6_Stat <= 4) {
			//Sonnenaufgang
	        var sunriseMoment = new Time.Moment(Ast.getValue("WebSunrise"));
	        var sunriseDate =  Gregorian.info(sunriseMoment, Time.FORMAT_MEDIUM);
			var sunrise = Lang.format("$1$:$2$", [sunriseDate.hour.format("%02d"),sunriseDate.min.format("%02d")]);
			dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
			dc.drawLine(xSun, ySun - 3, xSun, ySun + 4);
			dc.drawLine(xSun, ySun - 3, xSun + 3, ySun);
			dc.drawLine(xSun, ySun - 3, xSun - 3, ySun);
			dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
        	dc.drawText(xSun + 16, ySun, Gc.FONT_SYSTEM_XTINY, sunrise, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
		} else {
			//Sonnenuntergang
	        var sunsetMoment = new Time.Moment(Ast.getValue("WebSunset"));
	        var sunsetDate =  Gregorian.info(sunsetMoment, Time.FORMAT_MEDIUM);
			var sunset = Lang.format("$1$:$2$", [sunsetDate.hour.format("%02d"),sunsetDate.min.format("%02d")]); 
			dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
			dc.drawLine(xSun, ySun - 3, xSun, ySun + 3);
			dc.drawLine(xSun, ySun + 3, xSun + 3, ySun);
			dc.drawLine(xSun, ySun + 3, xSun - 3, ySun);
			dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	        dc.drawText(xSun + 16, ySun, Gc.FONT_SYSTEM_XTINY, sunset, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
		}
    } else {
		dc.drawText(xSun, ySun, Gc.FONT_SYSTEM_XTINY, "No Sun", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
    }
}

function draw_press(dc, xPress, yPress) {
	if (Ast.getValue("WebPressure") ) { //&& Ast.getValue("WebHumidity")
		var WebPress = Ast.getValue("WebPressure");
		var WebHumi = Ast.getValue("WebHumidity");
		if (DF6_Stat <= 10) {
			//Druck
			dc.drawCircle(xPress, yPress, 7);
			dc.drawArc(xPress, yPress, 5, 1, 225, 315);
			dc.fillCircle(xPress, yPress, 1);
			dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
			dc.setPenWidth(2);
			dc.drawLine(xPress, yPress, xPress + 5, yPress - 5);
        	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
			dc.setPenWidth(1);
        	dc.drawText(xPress + 16, yPress, Gc.FONT_SYSTEM_XTINY, WebPress, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
		} else {
			//Feuchtigkeit
			dc.drawArc(xPress, yPress + 2, 5, 1, 45, 135);
			dc.drawLine(xPress, yPress - 6, xPress - 4, yPress - 1);
			dc.drawLine(xPress, yPress - 6, xPress + 4, yPress - 1);
	        dc.drawText(xPress + 16, yPress, Gc.FONT_SYSTEM_XTINY, WebHumi + " %", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
		}
    } else {
		dc.drawText(xPress, yPress, Gc.FONT_SYSTEM_XTINY, "No Press.", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
    }
}
