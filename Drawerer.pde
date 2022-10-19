void renderWind3D(){
  float f0 = f0Mod*frameCount; // 0.002
  float f1 = f1Mod*frameCount; // 0.02
  float f2 = f2Mod*frameCount; // 0.008
  pg.beginDraw();
  pg.colorMode(HSB);
  pg.fill(0,0,0);
  //pg.fill(0,0,0,(10*2.0/vMult));
  //pg.fill(0,0,255,(10*2.0/vMult)); // white fill
  pg.noStroke();
  pg.rect(0, 0, width, height);
  pg.stroke(255);
  for (int i=0; i<numOfVectors; i++) {
    PVector p = ps[i];
    float ang=(noise( angMod*p.x + f0, angMod*p.y ))*4*PI;
    //PVector v = new PVector(0.7*cos(ang)+ 0.4*cos(f1), sin(ang));
    PVector v = new PVector(0.7*cos(ang)+ 0.4*cos(f1), sin(ang),cos(ang));
    //magnitude (length) of the vector, square    
    float magSq= v.magSq();
    v = v.setMag(vMult);
    p.add(v);
    if ( random(1.0)<0.01 || 
         p.x<0 || p.x>width || 
         p.y<0 || p.y>height ||
         p.z<0 || p.z>zDepth ){
      ps[i] = randomVector(i);
      psBuff1[i] = ps[i].copy();
      psBuff2[i] = ps[i].copy();
      psBuff3[i] = ps[i].copy();
      //ps[i]= new PVector(random(width), random(height));
    } else {
      psBuff3[i] = psBuff2[i].copy();
      psBuff2[i] = psBuff1[i].copy();
      psBuff1[i] = ps[i].copy();
      ps[i] = p;
    }
     
    pg.strokeWeight(strokeMod + strokeMod/(0.004+magSq));
    pg.strokeWeight(strokeMod + strokeMod/(0.004+magSq));
    float hue = (255 * (float(i)/numOfVectors + noise(f2)))%255;  
    float bright = 195 + 64 * 0.5/(0.004+magSq); // light stroke
    //float bright = 72 - 64 * 0.5/(0.004+magSq); // dark stroke 
    pg.stroke(hue, 64, bright);
    //pg.point(p.x, p.y);
    //pg.line(ps[i].x,  ps[i].y, psBuff1[i].x,  psBuff1[i].y);
    //pg.line(psBuff1[i].x,  psBuff1[i].y, psBuff2[i].x,  psBuff2[i].y);
    //pg.line(psBuff2[i].x,  psBuff2[i].y, psBuff3[i].x,  psBuff3[i].y);
    pg.line(ps[i].x,  ps[i].y,ps[i].z, psBuff1[i].x, psBuff1[i].y, psBuff1[i].z);
    pg.line(psBuff1[i].x, psBuff1[i].y, psBuff1[i].z, psBuff2[i].x,  psBuff2[i].y, psBuff2[i].z);
    pg.line(psBuff2[i].x, psBuff2[i].y, psBuff2[i].z, psBuff3[i].x, psBuff3[i].y, psBuff3[i].z);
    
    
  }
  pg.endDraw();
  //arrayCopy(psBuff2,psBuff3);  
  //arrayCopy(psBuff1,psBuff2);
  //arrayCopy(ps,psBuff1); 
}
