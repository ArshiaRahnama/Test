function ON_RAISE_HUE () {
	
}

function ON_SHOW(item) {
		//document.getElementById('container').style.visibility = 'collapse';
	if(item.show)
		document.getElementById('container').style.display = 'block';
	else
		document.getElementById('container').style.display = 'none';
}

function ON_HIGHLIGHT(item) {
		//document.getElementById('container').style.visibility = 'collapse';
	switch(item.marker){
		case 'hue':
			document.getElementById('hueMarker').style.display = 'block';
			document.getElementById('saturationMarker').style.display = 'none';
			document.getElementById('valueMarker').style.display = 'none';
			break;
		case 'saturation':
			document.getElementById('hueMarker').style.display = 'none';
			document.getElementById('saturationMarker').style.display = 'block';
			document.getElementById('valueMarker').style.display = 'none';
			break;
		case 'value':
			document.getElementById('hueMarker').style.display = 'none';
			document.getElementById('saturationMarker').style.display = 'none';
			document.getElementById('valueMarker').style.display = 'block';
			break;
	}
}

function ON_COLOR_CHANGED(item) {
	document.getElementById('huePicker').style.left = (item.h*100/360) + '%';
	document.getElementById('saturationPicker').style.left =  item.s + '%';
	document.getElementById('valuePicker').style.left =  item.v + '%';
	
	document.getElementById('hueValue').innerText = item.h + '°';
	document.getElementById('saturationValue').innerText =  item.s + '%';
	document.getElementById('valueValue').innerText =  item.v + '%';
	
	document.getElementById('saturationMod').style.opacity = 1-(item.s/100);
	document.getElementById('valueMod').style.opacity = 1-(item.v/100);
	
	var rgb = HSVtoRGB(item.h / 360, 1, 1);
	var colorstring = 'rgba('+rgb.r+','+rgb.g+','+rgb.b+',255)';
	document.getElementById('saturation').style.backgroundColor = colorstring;
	document.getElementById('value').style.backgroundColor = colorstring;
}

function HSVtoRGB(h, s, v) {
    var r, g, b, i, f, p, q, t;
	
    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    switch (i % 6) {
        case 0: r = v, g = t, b = p; break;
        case 1: r = q, g = v, b = p; break;
        case 2: r = p, g = v, b = t; break;
        case 3: r = p, g = q, b = v; break;
        case 4: r = t, g = p, b = v; break;
        case 5: r = v, g = p, b = q; break;
    }
    return {
        r: Math.round(r * 255),
        g: Math.round(g * 255),
        b: Math.round(b * 255)
    };
}