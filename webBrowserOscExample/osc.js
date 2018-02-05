var x=0;
var y=0;
var socket;

//*****************Connect to Websocket*****************//
function setupOsc(oscPortIn, oscPortOut) {
	var ipPort = ipAddress+':8081';
	socket = io.connect(ipPort, { port: 8081, rememberTransport: false });
	socket.on('connect', function() {
		socket.emit('config', {
			server: { port: oscPortIn,  host: ipAddress},
			client: { port: oscPortOut, host: ipAddress}
		});
	});
	socket.on('message', function(msg) {
		if (msg[0] == '#bundle') {
			for (var i=2; i<msg.length; i++) {
				receiveOsc(msg[i][0], msg[i].splice(1));
			}
		} else {
			receiveOsc(msg[0], msg.splice(1));
		}
	});
}

var JSLink = "http://"+ipAddress+":8081/socket.io/socket.io.js"
var JSElement = document.createElement('script');
JSElement.src = JSLink;
JSElement.onload = OnceLoaded;
document.getElementsByTagName('head')[0].appendChild(JSElement);

var tilt = function(stuff){
	document.getElementById("Tilt").innerHTML ="Sending Tilt OSC: "+stuff;
	socket.emit('message', ['/wek/inputs', stuff[0], stuff[1], x, y]);
}

function OnceLoaded() {
    setupOsc(7500, 6448);
		if (window.DeviceOrientationEvent) {
    window.addEventListener("deviceorientation", function () {
        tilt([event.beta, event.gamma]);
    }, true);
} else if (window.DeviceMotionEvent) {
    window.addEventListener('devicemotion', function () {
        tilt([event.acceleration.x * 2, event.acceleration.y * 2]);
    }, true);
} else {
    window.addEventListener("MozOrientation", function () {
        tilt(orientation.x * 50, orientation.y * 50]);
    }, true);
}
}

document.onmousemove = function(e) {
	document.getElementById("OSCbaby").innerHTML = "Sending OSC - MouseX: "+e.clientX+" MouseY: "+e.clientY;
	socket.emit('message', ['/wek/inputs', e.clientX, e.clientY]);
}

document.ontouchmove = function(e) {
	document.getElementById("OSCbaby").innerHTML = "Sending Touch X & Y: "+e.touches[0].clientX+" "+e.touches[0].clientY;
	x = e.touches[0].clientX;
	y = e.touches[0].clientY;
}
