import java.util.*;
import processing.svg.*;
import controlP5.*;
import processing.video.*;
import com.hamoid.*;

VideoExport videoExport;
Movie video;

ControlFrame cf;
boolean beginExportSVG = false;
boolean exportingVideo = false;

int numOfVectors=9400;
int zDepth = 10;
PVector[] ps = new PVector[numOfVectors];
PVector[] psBuff1 = new PVector[numOfVectors];
PVector[] psBuff2 = new PVector[numOfVectors];
PVector[] psBuff3 = new PVector[numOfVectors];
PGraphics pg;
float f0Mod= 0.004; // 0.002
float f1Mod= 0.02; // 0.02
float f2Mod= 0.008; // 0.008
float vMultLerpAmount = 1.; 
float vMult = 1.25;
float vMultLast = vMult;
float angMod = 0.005; //0.003
float strokeMod = 0.5;
int noiseOctaves;
float noiseFallOff;
int hsbSat = 48;

PShader starglowstreak;
PShader radialStreak;
PShader tv;
PShader gaussian;
PShader myBlur2;
PShader channels;
PShader saturation;
 
void setup() {
  //size(640, 640,P3D);   
  size(540, 960,P3D);   
  for (int i=0; i<numOfVectors; i++){ 
    ps[i] = randomVector(i);
    psBuff1[i] = ps[i].copy();
    psBuff2[i] = ps[i].copy();
    psBuff3[i] = ps[i].copy();
    //ps[i]= new PVector(random(width), random(height));  
    //ps[i]= new PVector(random(width), random(height), random(-10,10));
  }
  pg = createGraphics(width, height, P3D);
  background(0);
  colorMode(HSB);
  cf = new ControlFrame(this, 300, 500, "Controls");
  
  starglowstreak = loadShader("myStarglowstreaks.glsl");
  radialStreak = loadShader("myRadialStreak.glsl");
  tv = loadShader("tv1.glsl");
  gaussian = loadShader("myGaussian.glsl");
  myBlur2 = loadShader("myBlur2.glsl");
  channels = loadShader("channels.glsl");
  saturation = loadShader("mySaturation.glsl");
}

PVector randomVector(int i){
  //float x = width * noise(i);
  //float y = height * noise(i+numOfVectors);
  //PVector p = new PVector(x,y);
  //PVector p = new PVector(random(width), random(height), random(zDepth));
  PVector p = new PVector(random(width), random(height));
  return p;
}


void keyPressed(KeyEvent ke){
  myKeyPressed(ke);
}

void mousePressed(){
   myMousePressed();
}

public void exportSVG(){
  beginExportSVG = true;
 
  //println("begining export");
  //clear();
  //// P3D needs begin Raw
  //beginRecord(SVG, "data/exports/export_"+timestamp()+".svg");
  ////beginRaw(SVG, "data/exports/export_"+timestamp()+".svg");
  
  ////render
  
  
  //endRecord();
  ////endRaw();
  //println("finished export");  
  //exporting = false;
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void videoExport(){
  if(exportingVideo){
    exportingVideo = false;
    videoExport.endMovie();
  } else{
    videoExport = new VideoExport(this, "data/exports/video_export_"+timestamp()+".mp4");
    videoExport.setFrameRate(60);  
    videoExport.startMovie();
    exportingVideo = true;
  }
}

void renderWind(){
  float f0 = f0Mod*frameCount; // 0.002
  float f1 = f1Mod*frameCount; // 0.02
  float f2 = f2Mod*frameCount; // 0.008
  pg.beginDraw();
  pg.colorMode(HSB);
  pg.noStroke();
  pg.fill(0,0,0,(10*2.0/vMult));
  //pg.fill(0,0,255,(10*2.0/vMult)); // white fill

  pg.rect(0, 0, width, height);
  pg.stroke(255);
  for (int i=0; i<numOfVectors; i++) {
    PVector p = ps[i];
    float ang=(noise( angMod*p.x + f0, angMod*p.y ))*4*PI;
    PVector v = new PVector(0.7*cos(ang)+ 0.4*cos(f1), sin(ang));
    //magnitude (length) of the vector, square    
    float magSq= v.magSq();
    v.setMag(vMult);
    p.add(v);
    if ( random(1.0)<0.01 || 
         p.x<0 || p.x>width || 
         p.y<0 || p.y>height){
      ps[i] = randomVector(i);
    }
     
    pg.strokeWeight(strokeMod + strokeMod/(0.004 + magSq));
    //pg.strokeWeight(strokeMod);
    float hue = (255 * (float(i)/numOfVectors + noise(f2)))%255;  
    float bright = 195 + 64 * 0.5/(0.004+magSq); // light stroke
    //float bright = 72 - 64 * 0.5/(0.004+magSq); // dark stroke 
    pg.stroke(hue, hsbSat, bright);
    pg.point(p.x, p.y);
  }
  pg.endDraw();
 
}


void changeFmods(){
  //f0Mod= 0.004; 
  //f1Mod= 0.02; 
  f0Mod = map(noise(frameCount+f0Mod),0,1,.001,0.01);
  f1Mod = map(noise(frameCount+f1Mod),0,1,.001,0.01);
  swellVmult();
}

void swellVmult(){
  vMultLerpAmount = 0.1;
  vMultLast = vMult;
  vMult = .5;
}

void printInfo(){
  println("ps[5]", ps[5]);
  println("psBuff3[5]", psBuff3[5]);
}

void draw() {  
  if(vMultLerpAmount < 1.0){
    vMult = lerp(vMult,vMultLast , vMultLerpAmount);
    println("vmMult: ", vMult);
    println("vmMultLast: ", vMultLast);
    vMultLerpAmount += 0.05;
  }

  renderWind();
  image(pg, 0, 0,width,height);
  
  channels.set("rbias", 0.0, 0.0);
  //channels.set("gbias", map(mouseY, 0, height, -0.2, 0.2), 0.0);
  //float gbias = -0.01 + .01 * cos(.005 * float(frameCount)) + 0.008 * noise(frameCount);
  float gbias = -0.001 + .0025 * sin(.052 * float(frameCount))- 0.0013 * noise(frameCount);    
  channels.set("gbias", gbias, 0.0);
  channels.set("bbias", 0.0, 0.0);
  //channels.set("rmult", map(mouseX, 0, width, 0.8, 1.5), 1.0);
  float rmult = 1.001 + .0035 * sin(.035 * float(frameCount)) - 0.001 * noise(frameCount);
  channels.set("rmult", rmult, 1.0);
  channels.set("gmult", 1.0, 1.0);
  channels.set("bmult", 1.0, 1.0);
  
  
  starglowstreak.set("time", (float) millis()/1000.0);
  filter(starglowstreak);
  
  //radialStreak.set("time", (float) millis()/1000.0);
  //filter(radialStreak);
  
  filter(channels);
  
  gaussian.set("time", (float) millis()/1000.0);
  filter(gaussian);
   
  myBlur2.set("time", (float) millis()/1000.0);
  filter(myBlur2);
   
   //filter(saturation);
  if(exportingVideo){videoExport.saveFrame();}
}
