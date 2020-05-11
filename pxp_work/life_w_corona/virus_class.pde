class Virus {

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

  

  //PImage[] virusImg;
  PImage virusImg;
  //Virus(PImage temp, float _w, float _h, float _s) {
  //Virus(PImage temp) {
  Virus(PImage temp, float _s, float _a) {
    x = random(width);
    y = height - vSize;
    //diameter = tempD;
    yspeed = random(0.5, 2.5);
    xspeed = random(0.2, 2.5);


    virusImg = temp;
    //w = _w;
    //h = _h;
    myScale = _s;
    alpha = _a;
  }


  void shake() {
    x = x + random(-3, 3);
  }

  void display() {
    image(virusImg, x, y);
  }
  
 
  void displayRandom() {
    float randomX = random (0, width);
    float randomY = random (0, height);
    
    image(virusImg, randomX, randomY);
  }
  

  void reScale(){
    scale(myScale);
  }

  
  void reTint(){
     tint( 255, alpha);
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

}
