void myKeyPressed(KeyEvent ke)
{
  key = ke.getKey();
  Calendar now = Calendar.getInstance();
  if (key == 's') save("RandomSpherePoints.png");
  if (key == ' ') noiseSeed(now.getTimeInMillis());
  if (key == 'e') exportSVG();
  if (key == 'r') changeFmods();
   
}

void myMousePressed(){
  noiseOctaves = int(map(mouseX, 0, width,1,12));
  noiseFallOff = map(mouseY, 0, height,0,0.5);
  noiseDetail(noiseOctaves,noiseFallOff);
  println("noiseOctaves :",noiseOctaves);
  println("noiseFallOff :", noiseFallOff);
}
