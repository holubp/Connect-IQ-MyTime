using Toybox.Graphics as Gc;
using Toybox.System;

function draw_batt(dc, xBatt, yBatt, battStat, FT_ForeTemp) {
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.drawRoundedRectangle(xBatt, yBatt, 41, 16, 3);
	dc.fillRoundedRectangle(xBatt + 40, yBatt + 4, 5, 8, 1);
	//Kritische Zustände anders einfärben
	if ( battStat > 20) {
		dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
	} else if (battStat > 10) {
		dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
	} else {
		dc.setColor(Gc.COLOR_DK_RED, Gc.COLOR_TRANSPARENT);
	}
	dc.fillRoundedRectangle(xBatt + 1, yBatt + 1, 0.4 * battStat.toFloat() - 1, 14, 2);
	if (battStat == 100) {battStat = 99;} 
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	if (battView == 0){
		//Batteriestriche
		for (var i = 1; i < (battStat / 10).toNumber() + 1; i = i + 1){
			dc.drawLine(xBatt + (i * 4), yBatt + 3, xBatt + (i * 4), yBatt + 13);
		}
		//Unter 21% die Zahl zusätzlich hinschreiben
		if (battStat <= 20) {dc.drawText(xBatt + 24, yBatt + 7,  FT_ForeTemp, battStat + "%", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);} 
	} else {
		dc.drawText(xBatt + 22, yBatt + 7,  FT_ForeTemp, (battStat+1) + "%", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
	}
}

function draw_bt(dc, btX, btY, telConn) {
	//Ausgefüllt oder leer
	dc.setPenWidth(1);
	if (telConn == true) {
		dc.setColor(mainCol, mainCol);
		dc.fillCircle(btX, btY + 5, 7);
		dc.fillCircle(btX, btY - 5, 7);
		dc.fillRectangle(btX - 7, btY - 7, 15, 11);
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		dc.drawArc(btX, btY + 5, 7, 1, 0, 180);
		dc.drawArc(btX, btY - 5, 7, 0, 0, 180);
		dc.drawLine(btX - 7, btY - 5, btX - 7, btY + 5);
		dc.drawLine(btX + 7, btY + 5, btX + 7, btY - 5);
	} else {
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		dc.drawArc(btX, btY + 5, 7, 1, 0, 180);
		dc.drawArc(btX, btY - 5, 7, 0, 0, 180);
		dc.drawLine(btX - 7, btY - 5, btX - 7, btY + 5);
		dc.drawLine(btX + 7, btY + 5, btX + 7, btY - 5);
	}
	//Bluetooth Symbol
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.drawLine(btX - 1, btY, btX - 1 + 4, btY + 4);
	dc.drawLine(btX - 1 + 4, btY + 4, btX - 1, btY + 8);
	dc.drawLine(btX - 1, btY, btX - 1, btY + 8);
	dc.drawLine(btX - 1, btY, btX - 1 - 4, btY - 4);
	dc.drawLine(btX - 1, btY, btX - 1 + 4, btY - 4);
	dc.drawLine(btX - 1 + 4, btY - 4, btX - 1, btY - 8);
	dc.drawLine(btX - 1, btY, btX - 1, btY - 8);
	dc.drawLine(btX - 1, btY, btX - 1 - 4, btY + 4);
}

function draw_mess(dc, mX, mY, AnzNach) {
	if (AnzNach > 0) {
		dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
	    dc.fillRoundedRectangle( mX - 17, mY - 9, 35, 19, 3);
	}
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
    dc.drawRoundedRectangle( mX - 17, mY - 9, 35, 19, 3);
    dc.drawLine(mX - 15, mY - 7, mX, mY + 3);
    dc.drawLine(mX, mY + 3, mX + 15, mY - 7);
    dc.drawLine(mX - 15, mY + 7, mX - 4, mY);
    dc.drawLine(mX + 4, mY, mX + 15, mY + 7);
	if (AnzNach > 0) {
		dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
		var arrNach = [ //Nachrichten Punkte definieren
			[mX - 13, mY + 18 ],
			[mX - 5, mY + 18 ],
			[mX + 3, mY + 18 ],
			[mX + 11, mY + 18 ],
			[mX - 13, mY + 25 ],
			[mX - 5, mY + 25 ],
			[mX + 3, mY + 25 ],
			[mX - 13, mY + 32 ],
			[mX - 5, mY + 32 ],
			[mX - 13, mY + 39 ]];
		if (AnzNach > 10) {
	    	for (var u = 0; u < 9; u = u + 1) {
				dc.fillCircle(arrNach[u][0],arrNach[u][1], 2);
			}
			dc.drawLine(arrNach[9][0] - 3, arrNach[9][1], arrNach[9][0] + 4, arrNach[9][1]);
			dc.drawLine(arrNach[9][0], arrNach[9][1] - 3, arrNach[9][0], arrNach[9][1] + 4);
		} else {
	    	for (var u = 0; u < AnzNach; u = u + 1) {
				dc.fillCircle(arrNach[u][0],arrNach[u][1], 2);
			}
		}
		dc.setColor(MyTimeFg, MyTimeBg);
    }
}

function draw_ala(dc, alX, alY, AnzAlarm) {
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	//Anz Alarme Text
	if (AnzAlarm > 0) { 
		dc.drawText(alX - 22, alY - 2,  Gc.FONT_XTINY, AnzAlarm, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
	} else {
		dc.drawText(alX - 15, alY - 1,  Gc.FONT_XTINY, AnzAlarm, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
	}
	//Wenn ein Alarm gesetzt ist, dann das Symbol verschieben
	if (AnzAlarm > 0) {
		dc.drawArc(alX + 7, alY, 6, 0, 320, 40);
		dc.drawArc(alX - 7, alY, 6, 0, 140, 220);
	}
	//Wecker zeichnen
	if (AnzAlarm > 0) { 
		dc.setColor(mainCol, mainCol);
		dc.fillCircle(alX - 5, alY - 5, 2);
		dc.fillCircle(alX + 5, alY - 5, 2);
		dc.fillCircle(alX, alY, 6);
		dc.fillCircle(alX - 5, alY + 5, 1);
		dc.fillCircle(alX + 5, alY + 5, 1);
	}
	dc.setColor(MyTimeFg, MyTimeBg);
	dc.drawLine(alX, alY, alX - 3, alY -3);
	dc.drawLine(alX, alY, alX + 4, alY);
	dc.drawCircle(alX - 5, alY - 5, 2);
	dc.drawCircle(alX + 5, alY - 5, 2);
	dc.drawCircle(alX, alY, 6);
	dc.drawCircle(alX - 5, alY + 5, 1);
	dc.drawCircle(alX + 5, alY + 5, 1);
}

function draw_bpm(dc, heaX, heaY, hr, birth, Datum, schnarch, oxyMess) {
	dc.drawText(heaX, heaY + 32, Gc.FONT_SMALL, hr, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
	//Herz zeichnen, bzw schlagen lassen
	if (hr.equals("")) { //Wenn kein Herzschlag gemessen wird, dann einen Grabstein zeichnen
		//Grabstein
		var graveX = heaX;
		var graveY = heaY + 14;
		dc.setPenWidth(2);
		dc.drawEllipse(graveX, graveY - 20, 24, 12); //oben
		dc.drawEllipse(graveX, graveY + 33, 36, 10); //unten
		dc.setColor(MyTimeBg, MyTimeBg);
		dc.fillEllipse(graveX, graveY - 20, 22, 10); //oben
		dc.fillEllipse(graveX, graveY + 33, 36, 8); //unten
		dc.fillRectangle(graveX - 25, graveY - 20, 50, 13); //oben
		dc.fillRectangle(graveX - 37, graveY + 33, 76, 12); //unten
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		//Linke Kante
		dc.drawLine(graveX - 24,graveY - 20,graveX - 24,graveY - 15);
		dc.drawLine(graveX - 24,graveY - 15,graveX - 20,graveY - 13);
		dc.drawLine(graveX - 20,graveY - 13,graveX - 24,graveY - 11);
		dc.drawLine(graveX - 24,graveY - 11,graveX - 24,graveY + 25);
		//Rechte Kante
		dc.drawLine(graveX + 24,graveY - 20,graveX + 24,graveY + 8);
		dc.drawLine(graveX + 24,graveY + 8,graveX + 20,graveY + 10);
		dc.drawLine(graveX + 20,graveY + 10,graveX + 24,graveY + 14);
		dc.drawLine(graveX + 24,graveY + 14,graveX + 24,graveY + 25);
		//Inschriften
		dc.drawText(graveX,graveY - 16, FT_RIP, "R.I.P", Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
		dc.drawText(graveX - 4,graveY - 1, FT_ForeTemp, birth, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
		dc.drawText(graveX + 1,graveY + 12, FT_ForeTemp,"- " +  Datum.year, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
		//Dreckpunkte
		dc.drawPoint(graveX - 27, graveY + 30);
		dc.drawPoint(graveX - 24, graveY + 33);
		dc.drawPoint(graveX - 20, graveY + 34);
		dc.drawPoint(graveX - 18, graveY + 31);
		dc.drawPoint(graveX - 14, graveY + 33);
		dc.drawPoint(graveX - 8, graveY + 29);
		dc.drawPoint(graveX - 2, graveY + 33);
		dc.drawPoint(graveX + 1, graveY + 28);
		dc.drawPoint(graveX + 5, graveY + 33);
		dc.drawPoint(graveX + 12, graveY + 31);
		dc.drawPoint(graveX + 16, graveY + 34);
		dc.drawPoint(graveX + 19, graveY + 31);
		dc.drawPoint(graveX + 26, graveY + 33);
		dc.drawPoint(graveX + 13, graveY - 11);
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
	} else { //Bei Herzschlag animieren
		dc.setColor(Gc.COLOR_RED, Gc.COLOR_TRANSPARENT);
		dc.fillCircle(heaX + 6, heaY - 8, 8); //Kleineres Herz
		dc.fillCircle(heaX - 6, heaY - 8, 8); 
		var poly = [[heaX, heaY + 14], [heaX - 14, heaY - 4],[heaX, heaY - 8], [heaX + 14, heaY - 4]];
		dc.fillPolygon(poly);
		dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
		if(oxyMess!=null && oxy==true){dc.drawText(heaX, heaY-5, FT_ForeTemp, oxyMess, Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);}
	}
}