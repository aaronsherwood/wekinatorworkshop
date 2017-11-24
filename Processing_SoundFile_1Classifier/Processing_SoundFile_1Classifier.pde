//This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
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

  colorMode(HSB);
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
  background(currentHue, 255, 255);
  drawText();

  for (int i=0; i<soundfiles.length; i++) {
    volumes[i]=smoothing(volumes[i], volumeDestinations[i]);
    soundfiles[i].amp(volumes[i]);
  }
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      //println("received1");
      showMessage((int)f);
      changeTracks((int)f);
    }
  }
}

void showMessage(int i) {
  currentHue = (int)generateColor(i);
  currentTextHue = (int)generateColor((i+1));
  currentMessage = Integer.toString(i);
}

//Write instructions to screen.
void drawText() {
  stroke(0);
  textFont(myFont);
  textAlign(LEFT, TOP); 
  fill(currentTextHue, 255, 255);

  text("Receives 1 classifier output message from wekinator", 10, 10);
  text("Listening for OSC message /wek/outputs, port 12000", 10, 30);

  textFont(myBigFont);
  text(currentMessage, 190, 180);
}


float generateColor(int which) {
  float f = 100; 
  int i = which;
  if (i <= 0) {
    return 100;
  } else {
    return (generateColor(which-1) + 1.61*255) %255;
  }
}

void changeTracks(int which) {
  //use here for adding only one sound at a time
  for (int i=0; i<soundfiles.length; i++) {
    volumeDestinations[i]=0;
  }
    volumeDestinations[which-1]=1;

  //uncomment below for adding sounds and layering
  //for (int i=1; i<soundfiles.length; i++) {
  //  if (i<which)
  //    volumeDestinations[i]=1;
  //  else
  //    volumeDestinations[i]=0;
  //}
}

float smoothing(float current, float destination) {
  current += (destination-current)*.5;
  return current;
}