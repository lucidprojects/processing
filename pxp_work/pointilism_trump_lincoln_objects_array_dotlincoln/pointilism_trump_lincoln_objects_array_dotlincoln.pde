/*
The Honest President? 
by jake sherwood
adapted pointilism example code https://processing.org/examples/pointillism.html
modified to create points as objects and add to array to spead up paint
added button clicks to change the reference image and show target on american flag or not
*/

PImage flag;
PImage eyes;

PImage bg;

PImage target;

PresDots[] pointilizePresident;

PImage dotImage;

Boolean showTarget = true;

void setup() {
  size(600, 452);
  pointilizePresident = new PresDots[20];
  dotImage = loadImage("05f.png");

  for (int i=0; i < pointilizePresident.length; i++) {
    pointilizePresident[i] = new PresDots(dotImage, 4, 40);
  }
  smooth();

  flag = loadImage( "flag.jpg" );
  target = loadImage("target.png");
  imageMode(CENTER);
  noStroke();
  background(255);
}

void draw() { 

  flag.resize(150, 100);
  image(flag, width-100, height-100 );
  for (int i=0; i < pointilizePresident.length; i++) {
    pointilizePresident[i].display();
  }
  
  if (showTarget == true){
    println("show target");
    target.resize(100, 100);
    image(target, width-100, height-100 );
  
  }else {
    println("hide target");
    dotImage = loadImage("05f.png");
  }
  
}

void mousePressed() { 
  
  if (showTarget == true){
    dotImage = loadImage("lincoln.jpg");
    println("show target");
    target.resize(100, 100);
    image(target, width-100, height-100 );
  
  }else {
    println("hide target");
    dotImage = loadImage("05f.png");
  }  

  if ( (mouseX > 400 && mouseX < width -25) && (mouseY > 300 && mouseY < height -50 ) ) { 
    println("in area");
    //dotImage = loadImage("lincoln.jpg");
    for (int i=0; i < pointilizePresident.length; i++) {
      //pointilizePresident[i].display();
      pointilizePresident[i].updateImg(dotImage);
    }
    
    if ( showTarget == false) {
      showTarget = true;
    } else {
      showTarget = false;
    }
    
    
  } else { 
    println("not in area");
    println(pointilizePresident.length);
  }
  
  
} 




class PresDots {
  PImage img;
  int smallPoint, largePoint;

  PresDots(PImage tempImg, int tempSmallPoint, int tempLargePoint) {

    img = tempImg;
    smallPoint = tempSmallPoint;
    largePoint = tempLargePoint;
  }

  void display() {
    float pointillize = map(mouseX, 0, width, smallPoint, largePoint);
    int x = int(random(img.width));
    int y = int(random(img.height));
    color pix = img.get(x, y);
    fill(pix, 128);
    ellipse(x, y, pointillize, pointillize);
  }

  void updateImg(PImage newImg) {
    img = newImg;
  }
}
