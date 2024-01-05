using Toybox.Graphics as Gc;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;

function draw_moon(dc, xMond, yMond) {

	//Der erste VM muss immer kleiner sein als Heute
	var arrMond = [ "2021.09.21.01.54.42","2021.10.13.16.56.42","2021.11.19.09.57.30","2021.12.19.05.35.36","2022.01.18.00.48.30","2022.02.16.17.56.30","2022.03.18.07.17.36","2022.04.16.20.55.06","2022.05.16.06.14.12","2022.06.14.13.51.48","2022.07.13.20.37.42","2022.08.12.03.35.48","2022.09.10.11.59.06","2022.10.09.22.55.00","2022.11.08.12.02.12","2022.12.08.05.08.12","2023.01.07.00.07.54","2023.02.05.19.28.36","2023.03.07.13.40.24","2023.04.06.06.34.36","2023.05.05.19.34.06","2023.06.04.05.41.48","2023.07.03.13.38.42","2023.08.01.20.31.42","2023.09.29.11.57.36","2023.10.28.22.24.06","2023.11.27.10.16.24","2023.12.27.01.33.12"]; 

	var vm;
	var vmOld = 0;
	var vmPhase = 0;
	var m = 0;

	for (m = 0; m < arrMond.size(); m = m + 1 ) {
		var options = {
			:year => arrMond[m].substring(0, 4).toNumber(),
			:month  => arrMond[m].substring(5, 7).toNumber(),
			:day    => arrMond[m].substring(8, 10).toNumber(),
			:hour   => arrMond[m].substring(11, 13).toNumber(),
			:min    => arrMond[m].substring(14, 15).toNumber(),
			:sec	=> arrMond[m].substring(16, 17).toNumber()
		};
		vm = Gregorian.moment(options).value(); 
		if (m > 0) {
			var options1 = {
				:year => arrMond[m-1].substring(0, 4).toNumber(),
				:month  => arrMond[m-1].substring(5, 7).toNumber(),
				:day    => arrMond[m-1].substring(8, 10).toNumber(),
				:hour   => arrMond[m-1].substring(11, 13).toNumber(),
				:min    => arrMond[m-1].substring(14, 15).toNumber(),
				:sec	=> arrMond[m-1].substring(16, 17).toNumber()
			};
			vmOld = Gregorian.moment(options1).value(); 
		}
		var now = new Time.Moment(Time.now().value());
		var now1 = now.value();
		if (vm > now1) {
			var nowDays = now1.toFloat() / 86400; //Den heutigen Tag berechnen, in Tagen
			var vmOldDays = vmOld.toFloat() / 86400; //Letzter Vollmond in Tagen
			var vmDays = vm.toFloat() / 86400;
			var lunaDiff = vmDays - vmOldDays - 29.530589;
//						System.println(lunaDiff);
			vmPhase = (nowDays - vmOldDays) / (29.530589 + lunaDiff);
			vmPhase = Math.round(vmPhase * 1000) / 1000;
			break;
		}
	}
	if (vmPhase == 0.0) { vmPhase = 1;} //Wenn Null dann auf Eins setzen
	
	var KlHalbaxe = 99.0; //Die Default-Unsinnige-Grösse der kleinen Halbachse der Ellipse
	
	if (vmPhase < 0.5) {
		KlHalbaxe = Math.cos(vmPhase * 2 * Math.PI);
	} else {
		KlHalbaxe = Math.cos(vmPhase * 2 * Math.PI) * (-1);
	}				
	dc.setColor(0xffff00, Gc.COLOR_TRANSPARENT); //Gelb
	if (vmPhase <= 0.005) {  //Zeit des wirklichen Vollmonds hervorheben ca. 8 Std
		dc.setPenWidth(2);
		dc.fillCircle(xMond, yMond, 11);
		dc.setColor(Gc.COLOR_BLACK, Gc.COLOR_TRANSPARENT);
		dc.drawText(xMond + 1, yMond,  Gc.FONT_XTINY, "F" , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
	} else if (vmPhase <= 0.25) {
		dc.fillCircle(xMond, yMond, 10);
		dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
		dc.fillRectangle(xMond, yMond - 10, 11, 21);
		dc.setColor(0xffff00, Gc.COLOR_TRANSPARENT);
		dc.fillEllipse(xMond, yMond, KlHalbaxe.abs() * 10, 10);
	} else if (vmPhase <= 0.490) {
		dc.fillCircle(xMond, yMond, 10);
		dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
		dc.fillRectangle(xMond, yMond - 10, 11, 21);
		dc.fillEllipse(xMond, yMond, KlHalbaxe.abs() * 10, 10);
	} else if (vmPhase <= 0.505) { 
		dc.drawCircle(xMond, yMond, 11);
		dc.drawText(xMond + 1, yMond,  Gc.FONT_XTINY, "E" , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
	} else if (vmPhase <= 0.75) {
		dc.fillCircle(xMond, yMond, 10);
		dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
		dc.fillRectangle(xMond - 11, yMond - 10, 12, 21);
		dc.fillEllipse(xMond, yMond, KlHalbaxe.abs() * 10, 10);
	} else if (vmPhase <= 0.990) {
		dc.fillCircle(xMond, yMond, 10);
		dc.setColor(MyTimeBg, Gc.COLOR_TRANSPARENT);
		dc.fillRectangle(xMond - 11, yMond - 10, 12, 21);
		dc.setColor(0xffff00, Gc.COLOR_TRANSPARENT);
		dc.fillEllipse(xMond, yMond, KlHalbaxe.abs() * 10, 10); 
	} else if (vmPhase <= 1.00) { 
		dc.setPenWidth(2);
		dc.fillCircle(xMond, yMond, 11);
		dc.setColor(Gc.COLOR_BLACK, Gc.COLOR_TRANSPARENT);
		dc.drawText(xMond + 1, yMond,  Gc.FONT_XTINY, "F" , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
	}
	dc.setPenWidth(1);
	dc.setColor(MyTimeFg, Gc.COLOR_TRANSPARENT);
	var vmTxt = arrMond[m].substring(8, 10);
	dc.drawText(xMond + 22, yMond - 1,  FT_ForeTemp, vmTxt , Gc.TEXT_JUSTIFY_CENTER | Gc.TEXT_JUSTIFY_VCENTER);
}
