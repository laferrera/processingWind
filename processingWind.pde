import java.util.*;
import processing.svg.*;
import controlP5.*;

ControlFrame cf;
boolean beginExportSVG = false;

int n=9400;
PVector[] ps = new PVector[n];
PGraphics pg;
PShader starglowstreak;
PShader radialStreak;
PShader tv;
PShader gaussian;
PShader myBlur2;
float f0Mod= 0.004; // 0.002
float f1Mod= 0.02; // 0.02
float f2Mod= 0.008; // 0.008
float vMult = 1.0;
float angMod = 0.005; //0.003
float strokeMod = 0.25;
 
void setup() {
  size(640, 640,P3D);   
  //size(540, 960,P3D);   
  for (int i=0; i<n; i++) 
    ps[i]= new PVector(random(width), random(height));
  pg = createGraphics(width, height);
  background(0);
  //colorMode(RGB);
  colorMode(HSB);
  starglowstreak = loadShader("myStarglowstreaks.glsl");
  radialStreak = loadShader("myRadialStreak.glsl");
  tv = loadShader("tv1.glsl");
  gaussian = loadShader("myGaussian.glsl");
  myBlur2 = loadShader("myBlur2.glsl");
  cf = new ControlFrame(this, 300, 500, "Controls");
}


void renderWind(){
  float f0 = f0Mod*frameCount; // 0.002
  float f1 = f1Mod*frameCount; // 0.02
  float f2 = f2Mod*frameCount; // 0.008
  pg.beginDraw();
  pg.colorMode(HSB);
  pg.fill(0,0,0,(10*2.0/vMult));
  //pg.fill(0,0,255,10); // white fill
  pg.noStroke();
  pg.rect(0, 0, width, height);
  pg.stroke(255);
  for (int i=0; i<n; i++) {
    PVector p = ps[i];
    float ang=(noise( angMod*p.x + f0, angMod*p.y ))*4*PI;
    PVector v = new PVector(0.7*cos(ang)+ 0.4*cos(f1), sin(ang));
    //magnitude (length) of the vector, square    
    float magSq= v.magSq();
    v = v.mult(vMult);
    p.add(v);
    if ( random(1.0)<0.01 ||p.x<0 || p.x>width || p.y<0 || p.y>height){
      ps[i]= new PVector(random(width), random(height));
    }
     
    pg.strokeWeight(0.5 + strokeMod/(0.004+magSq));
    //pg.strokeWeight(1 + 0.25/(0.004+magSq));
    
    float hue = (255 * (float(i)/n + noise(f2)))%255;  
    float bright = 195 + 64 * 0.5/(0.004+magSq);
    //float bright = 72 - 64 * 0.5/(0.004+magSq); // dark bright 
    pg.stroke(hue, 40, bright);
    pg.point(p.x, p.y);
  }  
  pg.endDraw();
  
}

void keyPressed(KeyEvent ke){
  myKeyPressed(ke);
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


void draw() {
  //fill(0);
  //fill(0,0,0,10);
  //noStroke();
  //rect(0, 0, width, height);
  //stroke(255);
  //for (int i=0; i<n; i++) {
  //  PVector p = ps[i];
  //  float ang=(noise( 0.003*p.x + f0, 0.003*p.y ))*4*PI;
  //  PVector v = new PVector(0.7*cos(ang)+ 0.4*cos(f1),sin(ang));
  //  p.add(v);
  //  if ( random(1.0)<0.01 ||p.x<0 || p.x>width || p.y<0 || p.y>height)
  //    ps[i]= new PVector(random(width), random(height));
  //  //magnitude (length) of the vector, squared
  //  float magSq= v.magSq();
  //  strokeWeight(1 + 0.25/(0.004+magSq)); 
  //  //strokeWeight(1);
  //  stroke(255);
  //  point(p.x, p.y);
  //}
  
  renderWind();
  image(pg, 0, 0,width,height); 
  starglowstreak.set("time", (float) millis()/1000.0);
  //filter(starglowstreak);
  
  radialStreak.set("time", (float) millis()/1000.0);
  //filter(radialStreak);
  
   gaussian.set("time", (float) millis()/1000.0);
   filter(gaussian);
   
   myBlur2.set("time", (float) millis()/1000.0);
   filter(myBlur2);
}