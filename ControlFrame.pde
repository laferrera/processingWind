class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  CallbackListener cb;
  int curSliderY = 10;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{_name}, this);
  }

  public void settings() {
    size(w, h, P2D);
  }

  private int heightOffset(){
    heightOffset(20);
    return curSliderY;
  }

  private int heightOffset(int offset){
    curSliderY += offset;
    return curSliderY;
  }
  

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);
    int cp5width = 200;
       
;

       
    cp5.addSlider("vMult")
       .setValue(vMult)
       .plugTo(parent, "vMult")
       .setRange(0.5, 8.0)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
    cp5.addSlider("f0Mod")
       .setValue(f0Mod)
       .plugTo(parent, "f0Mod")
       .setRange(0.001, 0.01)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
    cp5.addSlider("f1Mod")
       .setValue(f0Mod)
       .plugTo(parent, "f1Mod")
       .setRange(0.001, 0.01)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
    cp5.addSlider("strokeMod")
       .setValue(strokeMod)
       .plugTo(parent, "strokeMod")
       .setRange(0.01, 2.0)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
    cp5.addSlider("hsbSat")
       .setValue(hsbSat)
       .plugTo(parent, "hsbSat")
       .setRange(0, 255)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;

    // cp5.addToggle("lfoAnimate")
    //   .setValue(lfoAnimate)    
    //   .plugTo(parent, "lfoAnimate")
    //   .setPosition(20, heightOffset())
    //   .setSize(cp5width, 10)
    //   .setMode(ControlP5.SWITCH)
    // ;


    //cp5.addButton("exportSVG")
    //   .plugTo(parent, "exportSVG")
    //   .setPosition(20, heightOffset(80))
    //   .setSize(100,10)
    //   ;
       

     

       
   
    cb = new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        ////println(event.getController().getName());
        ////println(event.getController());
        ////println(event.getAction());
        //switch(event.getAction()) {
        //  case(ControlP5.ACTION_BROADCAST):

        //    switch(event.getController().getName()){
        //      case("randomPointSize"):
        //        randomizePointSize();
        //        break;
        //      case("point size"):
        //        randomizePointSize();
        //        break;   
        //      case("num of points"):
        //        rs = new RandomSphere (randomPoints, radius);
        //        break;
        //      //case("ambient color"):
        //      //  setColor();
        //      //  break;   
        //    }
        //    break;
        //  // case(ControlP5.ACTION_CLICK):
        //  // case(ControlP5.ACTION_DRAG):          
        //  // case(ControlP5.ACTION_RELEASE):
        //  default:
        //    if(event.getController().getName().contains("color")){
        //        setColor();
        //        break;
        //    }
        //}

      }
    };
    
    cp5.addCallback(cb);
       
  }

  void gui() {
    cp5.draw();
  }
  
  void keyPressed(KeyEvent ke){
    myKeyPressed(ke);
  }

  void draw() {
    background(190);
  }
}
