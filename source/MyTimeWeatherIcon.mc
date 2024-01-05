using Toybox.Graphics as Gc;

function draw_icon_01(dc,xI,yI) {
	dc.setColor(0xffff00, Gc.COLOR_TRANSPARENT);
	dc.fillCircle(xI, yI + 1, 7);
}

function draw_icon_02(dc,xI,yI) {
	dc.setColor(0xffff00, Gc.COLOR_TRANSPARENT);
	dc.fillCircle(xI + 4, yI - 1, 5);
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 3, 10, 5);
	dc.fillCircle(xI - 4, yI + 4, 3);
	dc.fillCircle(xI + 6, yI + 4, 2);
	dc.fillCircle(xI - 2, yI + 1, 3);
	dc.fillCircle(xI + 3, yI + 2, 3);
}

function draw_icon_03(dc,xI,yI) {
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 2);
	dc.fillCircle(xI + 6, yI + 3, 3);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
}

function draw_icon_04(dc,xI,yI) {
	xI = xI + 2;
	yI = yI - 2;
	dc.setColor(Gc.COLOR_LT_GRAY, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
	xI = xI - 3;
	yI = yI + 3;
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
}

function draw_icon_09(dc,xI,yI) {
	xI = xI + 2;
	yI = yI - 3;
	dc.setColor(Gc.COLOR_LT_GRAY, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
	xI = xI - 3;
	yI = yI + 3;
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
	dc.setColor(Gc.COLOR_BLUE, Gc.COLOR_TRANSPARENT);
	dc.setPenWidth(2);
	xI = xI + 1;
	yI = yI - 3;
	dc.drawLine(xI + 4, yI + 5, xI + 4, yI + 7);									
	dc.drawLine(xI + 4, yI + 9, xI + 4, yI + 11);									
	dc.drawLine(xI + 1, yI + 7, xI + 1, yI + 9);									
	dc.drawLine(xI + 1, yI + 11, xI + 1, yI + 13);									
	dc.drawLine(xI - 2, yI + 5, xI - 2, yI + 7);									
	dc.drawLine(xI - 2, yI + 9, xI - 2, yI + 11);									
	dc.drawLine(xI - 5, yI + 7, xI - 5, yI + 9);									
	dc.drawLine(xI - 5, yI + 11, xI - 5, yI + 13);									
	dc.setPenWidth(1);
}

function draw_icon_10(dc,xI,yI) {
	xI = xI;
	yI = yI + 1;
	dc.setColor(0xffff00, Gc.COLOR_TRANSPARENT);
	dc.fillCircle(xI + 4, yI - 2, 5);
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
	dc.setColor(Gc.COLOR_BLUE, Gc.COLOR_TRANSPARENT);
	dc.setPenWidth(2);
	xI = xI + 1;
	yI = yI - 2;
	dc.drawLine(xI + 4, yI + 5, xI + 4, yI + 7);									
	dc.drawLine(xI + 4, yI + 9, xI + 4, yI + 11);									
	dc.drawLine(xI + 1, yI + 7, xI + 1, yI + 9);									
	dc.drawLine(xI + 1, yI + 11, xI + 1, yI + 13);									
	dc.drawLine(xI - 2, yI + 5, xI - 2, yI + 7);									
	dc.drawLine(xI - 2, yI + 9, xI - 2, yI + 11);									
	dc.drawLine(xI - 5, yI + 7, xI - 5, yI + 9);									
	dc.drawLine(xI - 5, yI + 11, xI - 5, yI + 13);									
	dc.setPenWidth(1);
}

function draw_icon_11(dc,xI,yI) {
	xI = xI + 2;
	yI = yI - 3;
	dc.setColor(Gc.COLOR_LT_GRAY, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
	xI = xI - 3;
	yI = yI + 3;
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	dc.fillRectangle(xI - 4, yI + 2, 10, 5);
	dc.fillCircle(xI - 4, yI + 3, 3);
	dc.fillCircle(xI + 6, yI + 3, 2);
	dc.fillCircle(xI - 2, yI, 3);
	dc.fillCircle(xI + 3, yI + 1, 3);
	dc.setColor(Gc.COLOR_ORANGE, Gc.COLOR_TRANSPARENT);
	dc.setPenWidth(2);
	dc.drawLine(xI + 2, yI + 1, xI - 1, yI + 5);							
	dc.drawLine(xI - 1, yI + 5, xI + 3, yI + 5);							
	dc.drawLine(xI + 3, yI + 5, xI - 1, yI + 11);							
	dc.setPenWidth(1);
}
//Schnee
function draw_icon_13(dc, xI, yI) {
	dc.drawLine(xI, yI + 1, xI, yI + 7);
	dc.drawPoint(xI + 1, yI + 5);
	dc.drawPoint(xI - 1, yI + 5);
	dc.drawLine(xI, yI + 1, xI, yI - 5);
	dc.drawPoint(xI + 1, yI - 3);
	dc.drawPoint(xI - 1, yI - 3);
	dc.drawLine(xI, yI + 1, xI - 6, yI - 2);
	dc.drawPoint(xI - 4, yI);
	dc.drawPoint(xI - 3, yI - 1);
	dc.drawLine(xI, yI + 1, xI + 6, yI + 4);
	dc.drawPoint(xI + 4, yI);
	dc.drawPoint(xI + 3, yI - 1);
	dc.drawLine(xI, yI + 1, xI + 6, yI - 2);
	dc.drawPoint(xI - 4, yI + 3);
	dc.drawPoint(xI - 3, yI + 4);
	dc.drawLine(xI, yI + 1, xI - 6, yI + 4);
	dc.drawPoint(xI + 4, yI + 3);
	dc.drawPoint(xI + 3, yI + 4);
}
//Nebel
function draw_icon_50(dc, xI, yI) {
	dc.drawLine(xI - 3, yI - 3, xI + 7, yI - 3);
	dc.drawLine(xI - 7, yI - 1, xI + 3, yI - 1);
	dc.drawLine(xI - 4, yI + 1, xI + 8, yI + 1);
	dc.drawLine(xI - 8, yI + 3, xI + 4, yI + 3);
	dc.drawLine(xI - 6, yI + 5, xI + 3, yI + 5);
	dc.drawLine(xI - 5, yI + 7, xI + 8, yI + 7);
}
