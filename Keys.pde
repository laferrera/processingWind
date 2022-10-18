void myKeyPressed(KeyEvent ke)
{
  key = ke.getKey();
  Calendar now = Calendar.getInstance();
  if (key == 's') save("RandomSpherePoints.png");
  if (key == ' ') noiseSeed(now.getTimeInMillis());
  if (key == 'e') exportSVG();
  if (key == 'r') changeFmods();
   
}
