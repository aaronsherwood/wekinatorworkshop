//This demo triggers a text display with each new message
// Works with 5 regression outputs
//Listens on port 12000 for message /wek/outputs (defaults)

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
import processing.sound.*;
int trackAmount = 5;

SoundFile[] soundfiles = new SoundFile[trackAmount];
float[] volumes = new float[trackAmount];
float[] volumeDestinations = new float[trackAmount];

//No need to edit:
PFont myFont, myBigFont;
final int myHeight = 400;
final int myWidth = 400;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "";

//all included soundfiles are 120bpm

void setup() {
  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)

  size(400, 400, P3D);
  smooth();
  background(255);

  String typeTag = "f";
  //myFont = loadFont("SansSerif-14.vlw");
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 80);
  for (int i=0; i<soundfiles.length; i++) {
    String name = "soundfile";
    name+=str(i);
    name+=".wav";
    println(name);
    soundfiles[i] = new SoundFile(this, name);
    soundfiles[i].loop();
    soundfiles[i].amp(0);
    volumes[i]=0;
    volumeDestinations[i]=0;
  }
  volumeDestinations[0]=1;
}

void draw() {
  frameRate(30);
  background(0);
  drawSections();
  drawText();

  for (int i=0; i<soundfiles.length; i++) {
    volumes[i]=smoothing(volumes[i], volumeDestinations[i]);
    soundfiles[i].amp(volumes[i]);
  }
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("fffff")) {
      volumeDestinations[0] = theOscMessage.get(0).floatValue();
      volumeDestinations[1] = theOscMessage.get(1).floatValue();
      volumeDestinations[2] = theOscMessage.get(2).floatValue();
      volumeDestinations[3] = theOscMessage.get(3).floatValue();
      volumeDestinations[4] = theOscMessage.get(4).floatValue();
    }
  }
}


//Write instructions to screen.
void drawText() {
  stroke(0);
  textFont(myFont);
  textAlign(LEFT, TOP); 
  fill(currentTextHue, 255, 255);

  text("Receives 5 regression output messages from wekinator", 10, 10);
  text("Listening for OSC message /wek/outputs, port 12000", 10, 30);

  textFont(myBigFont);
  text(currentMessage, 190, 180);
}

void drawSections() {
  stroke(255);
  line(0,50,width,50);
  for (int i=0; i<5; i++) {
    fill(0,255,0);
    noStroke();
    rect(i*width/5,height-volumes[i]*(height-50),width/5, volumes[i]*(height-50));
  }
}

float smoothing(float current, float destination) {
  current += (destination-current)*.5;
  return current;
}