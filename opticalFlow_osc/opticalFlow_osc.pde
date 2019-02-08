import gab.opencv.*;
import processing.video.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

OpenCV opencv;
Capture video;

PVector smoothedFlow;

void setup() {
  size(320, 240);
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  video.start(); 
  smoothedFlow = new PVector(0, 0);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 1234);
  dest = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  background(0);
  if (video.available() == true) {
    video.read();
  }
  opencv.loadImage(video);
  opencv.flip(opencv.HORIZONTAL);
  opencv.calculateOpticalFlow();

  pushMatrix();
  scale(-1.0, 1.0);
  image(video, -video.width, 0);
  popMatrix();

  //image(video, 0, 0);
  stroke(255, 0, 0);
  //opencv.drawOpticalFlow();

  PVector aveFlow = opencv.getAverageFlow();
  PVector diff = PVector.sub(aveFlow, smoothedFlow);
  smoothedFlow.add( diff.mult(.1));

  stroke(255);
  strokeWeight(2);
  translate(width/2, height/2);
  line(0, 0, 50*smoothedFlow.x, 50*smoothedFlow.y);
  sendOsc();
}

void sendOsc() {
  OscMessage msg = new OscMessage("/opticalFlow");
  msg.add((float)smoothedFlow.x); 
  msg.add((float)smoothedFlow.y);
  oscP5.send(msg, dest);
}