Globe[] globes = new Globe[20];
PImage globeImg; 
int total = 0;

PShape globe_sml;

class Globe {

  float x;
  float y;
  float w;
  float h;
  float yspeed;
  float xspeed;
  int xdirection = 1;  // Left or Right
  int ydirection = 1;  // Top to Bottom
  float myScale;
  int vSize = 95;
  float alpha;
  Movie myMovie;
  float level;

  PShape globeImg;
    Globe(PShape temp, float _s, float _a, float myLevel) {
    x = random(width);
    y = height - vSize;
    yspeed = random(0.5, 2.5);
    xspeed = random(0.2, 2.5);


    globeImg = temp;
    myScale = _s;
    alpha = _a;
    level = myLevel;
   
  }


  void shake() {
    x = x + random(-3, 3);
  }

  void display(float level) {
    //fill(0, 51, 102);
    //lightSpecular(255, 255, 255);
    //directionalLight(204, 204, 204, x, y, -1);
    
    push();
    if (level > 0.1) {
    translate(0, 0, random(50, 100));
    }
    shape(globeImg, x, y);
    pop();
    
    
  }

  void reScale() {
    scale(myScale);
  }

  

  void bounce() {
    x = x - ( xspeed * xdirection );
    y = y - ( yspeed * ydirection );
    if (x > width - vSize || x < 5) {
      xdirection *= -1;
    }
    if (y > height - vSize || y < 5) {
      ydirection *= -1;
    }
  }
  
  
  void levelBounce(float level) {
    println(level);
    
    if (level > 0.21) {
     //println("\n Globe translate \n");
    //translate(0, 0, random(50, 500));
    }
    
    
    
  }
    
}
