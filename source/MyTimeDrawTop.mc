using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Math;

function draw_top_dist(dc, xDist, yDist) {
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	//Distanz
	dc.drawText(xDist - 11, yDist, Gc.FONT_XTINY, dist, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
	dc.drawArc(xDist, yDist, 3, 0, 315, 235);
	dc.drawPoint(xDist, yDist);
	dc.drawLine(xDist-2, yDist+2, xDist-1, yDist+7);
	dc.drawLine(xDist+2, yDist+2, xDist-1, yDist+7);
	dc.drawArc(xDist+11, yDist-3, 3, 0, 315, 235);
	dc.drawPoint(xDist+11, yDist-3);
	dc.drawLine(xDist+9, yDist-1, xDist+10, yDist+4);
	dc.drawLine(xDist+13, yDist-1, xDist+10, yDist+4);
	dc.setPenWidth(2);
	dc.drawPoint(xDist+4, yDist+8);
	dc.drawPoint(xDist+8, yDist+9);
	dc.drawPoint(xDist+11, yDist+7);
	dc.setPenWidth(1);
}

function draw_top_Cal(dc, xCal, yCal, actCal) {
	//Kalorien
	if (calView == 0){
		dc.drawText(xCal, yCal, Gc.FONT_XTINY, kalo, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
	} else {
		dc.drawText(xCal, yCal, Gc.FONT_XTINY, actCal, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
	}
	dc.drawText(xCal + 7, yCal, Gc.FONT_XTINY, "cal", Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
}

function draw_top_step(dc, stepX, stepY) {
	//Schritte
	dc.drawText(stepX, stepY, Gc.FONT_XTINY, schritte, Gc.TEXT_JUSTIFY_RIGHT | Gc.TEXT_JUSTIFY_VCENTER);
	dc.setPenWidth(4);
	var proSchritte = schritte.toFloat() / schritteGoal.toFloat() * 100;
	dc.drawArc(r, r, r - 3, 1, 168, 163);
	dc.drawArc(r, r, r - 3, 1, 162, 157);
	dc.drawArc(r, r, r - 3, 1, 156, 151);
	dc.drawArc(r, r, r - 3, 1, 150, 145);
	dc.drawArc(r, r, r - 3, 1, 144, 139);
	dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
	if (proSchritte > 20) {dc.drawArc(r, r, r - 3, 1, 168, 163);}
	if (proSchritte > 40) {dc.drawArc(r, r, r - 3, 1, 162, 157);}
	if (proSchritte > 60) {dc.drawArc(r, r, r - 3, 1, 156, 151);}
	if (proSchritte > 80) {dc.drawArc(r, r, r - 3, 1, 150, 145);}
	if (proSchritte > 100) {dc.drawArc(r, r, r - 3, 1, 144, 139);}
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.setPenWidth(1);
	//Schuhsymbole
	//oben
	stepX = stepX + 10; 
	stepY = stepY - 4;
	dc.fillCircle(stepX, stepY, 2); 
	dc.fillRectangle(stepX, stepY - 2, 3, 5);
	var poly3 = [[stepX + 4, stepY - 2], [stepX + 8, stepY - 2],[stepX + 8, stepY + 2],[stepX + 4, stepY + 2]];
	dc.fillPolygon(poly3);
	dc.fillCircle(stepX + 8, stepY, 3);
	//unten
	stepX = stepX + 5;
	stepY = stepY + 8;
	dc.fillCircle(stepX, stepY, 2);
	dc.fillRectangle(stepX, stepY - 2, 3, 5);
	var poly4 = [[stepX + 4, stepY - 2], [stepX + 8, stepY - 2],[stepX + 8, stepY + 2],[stepX + 4, stepY + 2]];
	dc.fillPolygon(poly4);
	dc.fillCircle(stepX + 8, stepY, 3);
}

function draw_top_Tr(dc, xTr, yTr) {
	//Etagen plus
	dc.drawText(xTr + 17, yTr - 6, Gc.FONT_XTINY, etaPlus, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
	dc.drawLine(xTr - 3, yTr, xTr, yTr);
	dc.drawLine(xTr, yTr, xTr, yTr - 3);
	dc.drawLine(xTr, yTr - 3, xTr + 3, yTr - 3);
	dc.drawLine(xTr + 3, yTr - 3, xTr + 3, yTr - 6);
	dc.drawLine(xTr + 3, yTr - 6, xTr + 6, yTr - 6);
	dc.drawLine(xTr + 6, yTr - 6, xTr + 6, yTr - 9);
	dc.drawLine(xTr + 6, yTr - 9, xTr + 9, yTr - 9);
	//Pfeil
	dc.drawLine(xTr - 6, yTr - 3, xTr + 3, yTr - 12);
	dc.drawLine(xTr + 3, yTr - 12, xTr - 1, yTr - 12);
	dc.drawLine(xTr + 3, yTr - 12, xTr + 3, yTr - 8);
	//Treppenfortschritt
	dc.setPenWidth(4);
	var proTreppen = Math.round(etaPlus.toFloat() / etaPlusGoal.toFloat() * 100).toNumber();
	dc.drawArc(r, r, r - 3, 0, 12, 17);
	dc.drawArc(r, r, r - 3, 0, 18, 23);
	dc.drawArc(r, r, r - 3, 0, 24, 29);
	dc.drawArc(r, r, r - 3, 0, 30, 35);
	dc.drawArc(r, r, r - 3, 0, 36, 41);
	dc.setColor(mainCol, Gc.COLOR_TRANSPARENT);
	if (proTreppen >= 20) {dc.drawArc(r, r, r - 3, 0, 12, 17);}
	if (proTreppen >= 40) {dc.drawArc(r, r, r - 3, 0, 18, 23);}
	if (proTreppen >= 60) {dc.drawArc(r, r, r - 3, 0, 24, 29);}
	if (proTreppen >= 80) {dc.drawArc(r, r, r - 3, 0, 30, 35);}
	if (proTreppen >= 100) {dc.drawArc(r, r, r - 3, 0, 36, 41);}
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.setPenWidth(1);
}
	
function draw_top_Hoe(dc, xHoe, yHoe) {
	//Höhe aus GPS-Lage oder API
	//Symbol
	dc.setAntiAlias(true);
	var poly5 = [[xHoe, yHoe + 1],[xHoe + 3, yHoe - 6],[xHoe + 7, yHoe - 3],[xHoe + 13, yHoe - 12],[xHoe + 18, yHoe + 1]];
	dc.fillPolygon(poly5);
	dc.setColor(MyTimeBg, MyTimeBg);
	var poly6 = [[xHoe + 10, yHoe - 4],[xHoe + 13, yHoe - 9],[xHoe + 14, yHoe - 5]];
	dc.fillPolygon(poly6);
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.setAntiAlias(false);
	var H; //Variable fürs Display
	if (Ast.getValue("alti")) {
		if (Ast.getValue("WebHCode")) {
			if (Ast.getValue("WebHCode") == 200) {
				H = Ast.getValue("WebH").toNumber();
				//if (Ast.getValue("tempUnits").equals("imperial")){H=(H*3.281).toNumber();}
				dc.drawText(xHoe + 24, yHoe - 5, Gc.FONT_XTINY, H, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
			} else {
				H = Ast.getValue("alti").toNumber(); //Wenn es keinen Höhenkorrektur Key hat, dann die GPS Höhe
				//if (Ast.getValue("tempUnits").equals("imperial")){H=(H*3.281).toNumber();}
				H = H.toString() + "*";
				dc.drawText(xHoe + 24, yHoe - 5, Gc.FONT_XTINY, H, Gc.TEXT_JUSTIFY_LEFT | Gc.TEXT_JUSTIFY_VCENTER);
			}
		}
	}			
}