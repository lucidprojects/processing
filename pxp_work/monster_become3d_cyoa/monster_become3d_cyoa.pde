import processing.video.*;
import ddf.minim.*;
Minim minim;

AudioPlayer song;

int beatBands = 30;                  //Number of bands to montiter, higher for more accuracy, lower for speed
int beatCounter = 0;
int slowDownBeatCounter = 50;
float leftLevel, rightLevel;
int cell = floor(random(10, 20));                                                           // this will be the size of our mesh cells
int myCell; //value calculated from left slound level

Movie video, castleGan, crystalGanMovie, waterfallGan;  // variable(s) to hold the videos

PImage photo, maskImage, selectedMonster, monster1, wormonster, monster1Mask, wormonsterMask, ganImage, backupGanImage, whichMonster, whichMask, exploreImg, ganImageTrans, smlGanImage;

PShape globe;
int globeSize = 250;

PImage result;

int bgColor = 255;
int grow = 0;

String mytext = "Choose Your Monster:";

String text1 = "Yes";
String text2 = "No";

String finishText;

String myTextCube, text1Cube, text2Cube;

int fantX = -10;
int fantY = 10;

PFont monsterFont;

PFont plainFont;

int fontColor = 0;

float myRotation;

//booleans to control scenes / cyoa
boolean start = true;
boolean monsterSelected = false;
boolean scene2 = false;
boolean scene3 = false;
boolean goTo4 = false;
boolean scene4 = false;
boolean scene4fantasy = false;
boolean scene5 = false;
boolean doYouSeeCastles = false;
boolean doCubeRoom = false;
boolean scene6 = false;
boolean scene7 = false;
boolean scene8 = false;
boolean scene9 = false;

int gotCellVall = 0;

// the End Scene
boolean theEnd = false;

// explore scene 
boolean explore = false;

///camera varibles
int oldx = mouseX;
int oldy = mouseY;
float rotx = 0;
float roty = 0;

float zcam = 0;

String answerClick;

PImage tex;

int zz = 1;

//3D objs
PShape monster13d;
PShape wormonster13d;
float angle;
float monsterScale =50.2; 

void setup() {
  size(1024, 1024, P3D);
  hint(ENABLE_DEPTH_SORT);  // ***** this is needed to show graphics and text with masks in cubeRoom
  noStroke();

  //// setup Runway
  runway = new RunwayHTTP(this);
  //// disable automatic polling: request data manually when a new frame is ready
  runway.setAutoUpdate(false);

  wormonster = loadImage("wormonster.jpg");
  monster1 = loadImage("monster1.jpg");
  wormonsterMask = loadImage("wormonster_mask.jpg");
  monster1Mask = loadImage("monster1_mask.jpg");
  ganImageTrans = loadImage("alphatest.png");
  exploreImg = loadImage("explore.png");
  backupGanImage = loadImage("000000010.jpeg");

  // Uncomment the following two lines to see the available fonts 
  //String[] fontList = PFont.list();
  //printArray(fontList);

  monsterFont = createFont("Mrs.MonsterRotated2", 52);
  plainFont = createFont("ITCAvantGardeW04-Bold", 24);
  video = new Movie(this, "monsterganvid.mp4"); 
  video.loop();
  castleGan = new Movie(this, "castlegan.mp4"); 

  sceneChangeDebug("setup");
  tex = loadImage("000000010.jpeg");
  textureMode(NORMAL);

  crystalGanMovie = new Movie(this, "crystalcanvid.mp4"); 
  crystalGanMovie.loop();

  waterfallGan = new Movie(this, "waterfallgan.mp4");

  globe = createShape(SPHERE, 250);
  globe.setTexture(crystalGanMovie);

  globe_sml = createShape(SPHERE, 75);
  for (int i = 0; i < globes.length; i++) {
    globes[i] = new Globe(globe_sml, random(0.85, 1.15), floor(random(127, 255)), leftLevel);
  }  

  monster13d = loadShape("monster1.obj");
  wormonster13d = loadShape("wormonster1.obj");

  minim = new Minim(this);                                      //Sets up minim
  song = minim.loadFile("whereismymind_piano.mp3", 2048);
  song.loop();
}

void draw() {
  background(bgColor);
  push();
  image(video, 1200, 0);

  leftLevel = song.left.level();
  rightLevel = song.right.level();
  //  println("rightLevel = " + rightLevel);
  myCell = floor(leftLevel * random(100, 400));

  if (leftLevel > 0.09999) {
    //println("we have a left beat leftLevel = " + leftLevel);
    //globe.scale(random(50, 150));
  }
  pop();

  //hiding explore it's buggy and hard to control
  //image(exploreImg, width -50, 25);
  //exploreImg.resize(30, 30);
  //push();
  //textSize(22);
  //textAlign(CENTER);
  //fill(fontColor);
  //text("explore", width - 100, 50);
  //pop();

  textFont(monsterFont);
  textAlign(CENTER);
  fill(fontColor);
  push();
  text(mytext, width/2, 150);
  pop();


  if (explore == true) cam(); 

  // show initial monster select
  if (start == true) {
    image(wormonster, 400, 150);
    wormonster.resize(700, 700);
    image(monster1, -60, 150);
    monster1.resize(700, 700);
  }

  //check for click areas
  answerClicks();

  // set initial text area
  if (start != true) {
    text(text1, width/4 *1, 850);
    text(text2, width/4 *3, 850);
  }

  if (monsterSelected == true) {
    image(ganImage, 0, 0);
  }

  if (scene3 == true) {
    push();
    rotateY(64.25);
    image(ganImage, 0, 0);
    pop();
    ganMesh();
    mytext = "Go Inside?";
  }

  if (scene4 == true) {
    castleGan.loop();
    push();
    translate(0, 0, -850);
    image(castleGan, 0, 0);
    pop();

    push();
    translate(-20, 320, 150);
    image(ganImage, 0, 0);
    //scale(-1, 1);
    pop();
  }


  if (scene4fantasy == true) {
    mytext = "Real or Fantasy?";

    finishText = ("What is Real. What is Fantasy.");
    text(finishText, width/2, 850); 
    text1 = "";
    text2 = "";
    waterfallGan.loop();
    push();
    translate(width /2, height/2, -250);
    rotateY(roty);
    rotateX(rotx);
    scale(190);
    TexturedCube(waterfallGan);
    //image(waterfallGan, 0, 0);
    pop();
  }


  if (scene5 == true ) {
    goInside();
  }


  if (scene6 == true ) {
    goCrystal();
  }


  if (scene7 == true ) {
    println("in yes area scene7");
    push();
    translate(width/2 - 50, 20, -10);
    // scale(50);
    image(ganImage, -60, 150);
    pop();
    be3d();
  }

  if (scene8 == true ) {
    println("in yes area scene8");
    iam3d();
  }

  if (doCubeRoom == true) {
    mytext = "";
    text1 = "";
    text2 = "";

    push();
    fill(255);
    translate(width/2.0 - 40, height/2.0, 495);

   
    // myTextCube = "";
    //text1Cube = "";
    //text2Cube = "";
    
    myTextCube = "Now What?";
    text1Cube = "Stay";
    text2Cube = "LEAVE!";
    push();
    textSize(24);
    text(myTextCube, 40, -160);
    text(text1Cube, -100, 140);
    text(text2Cube, 160, 140);
    pop();

    push();
    translate(-20, 20, 0);
    image(smlGanImage, -50, 0);
    smlGanImage.resize(200, 200);
    //scale(-1, 1);
    pop();

    rotateX(-18.234606);
    rotateY(0.44539816);
    scale(290);
    TexturedCube(video);

    pop();

    //println(zz++);
  }

  //if (grow == 1 ) translate(0, 0, mouseY);
  //else if (grow ==2) rotateY(mouseX * 0.1);

  test = random(-0.1, 0.1);  // randomize one point of vector
  myInput = inputs[floor(random(0, 44))];
  beatCounter += 1;

  //println("mouseX = " + mouseX);
  //println("mouseY = " + mouseY);
}


void movieEvent(Movie m) {
  m.read();
}

void selectMonster(PImage myMon) {
  //try to connect to runway
  try {
    runway.query(myInput); // querey Runway

    if (result != null) {  // if result set ganImage
      ganImage = runwayResult;
    } else {              
      // otherwise set back up static image
      ganImage = backupGanImage;
      println("runway is not running");
    }
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  smlGanImage = ganImage;
  whichMonster = myMon;
  start = false;
  monsterSelected = true;
  mytext = "Do you like adventures?";
  sceneChangeDebug("selectmonster");
}

void goToScene4() {
  sceneChangeDebug("go to 4");
  int i;
  for (i = 0; i < width; i +=5) {
    image(ganImage, i, 0);
  }

  if (i >= width) {
    println("at the end of width");
    whatDoYouSee();
  }
}  


void goInside() {
  sceneChangeDebug("go inside");
  doCubeRoom = true;
}

void whatDoYouSee() {
  mytext = "What do you see?";
  text1 = "Castles";
  text2 = "Not Sure?";
  sceneChangeDebug("what do you see");
}

void makeGlobe() {
  push();
  translate(width/2, height/2, -300);   
  push();

  if (leftLevel > 0.11) {
    //println("\n Globe translate \n");
    translate(0, 0, random(50, 500));
  }
  rotateY(PI * frameCount / 500);
  shape(globe);
  //else translate(0,0,0);
  pop();
  pop();
}

void makeGlobeSml() {
  for (int i = 0; i < total; i++) {
    globes[i].display(leftLevel);
    globes[i].bounce();
    globes[i].shake();
    globes[i].reScale();
    //globes[i].levelBounce(leftLevel);
  }

  // needed to texturize globes
  globe_sml.setTexture(crystalGanMovie);
}


void goCrystal() {
  //mytext = "";
  //text1 = "";
  //text2 = "";
  
  mytext = "What is 3D?";
  text1 = "Shape";
  text2 = "Volume";
  
  sceneChangeDebug("whatis3d");
  makeGlobe();
}

void be3d() {
  mytext = "Become 3D?";
  text1 = "YES!";
  text2 = "NO";
  sceneChangeDebug("be3d?");
  makeGlobeSml();

  if (leftLevel > 0.11 && total < 20) {
    total = total + 1;
  }
}

void iam3d() {
  mytext = "The worlds is 3D!";
  finishText = ("Go on another adventure?");
  text(finishText, width/2, 850);

  text1 = "";
  text2 = "";
  sceneChangeDebug("iam3d");
  waterfallGan.loop();
  push();
  makeGlobeSml();
  total = 5;
  pop();

  push();
  lights(); 
  monster13d.setTexture(waterfallGan); 
  wormonster13d.setTexture(waterfallGan); 
  translate(width/2, height/2);
  //translate(-300, 0, 0);
  scale(monsterScale);
  rotateX(9.35);
  rotateY(radians(angle));  
  angle+=PI/4;
  if (whichMonster == monster1Mask)shape(monster13d, 0, 0);
  else shape(wormonster13d, 0, 0);
  pop();
}

void startOver() {
  mytext = "Choose Your Monster:";
  start = true;
  monsterSelected = false;
  scene3 = false;
  scene4 = false;
  scene4fantasy = false;
  scene5 = false;
  doCubeRoom = false;
  scene6 = false;
  scene7 = false;
  scene8 = false;
  text1 = "Yes";
  text2 = "No";
  sceneChangeDebug("startover");
  gotCellVall = 0;
  smlGanImage.resize(1024, 1024);
}

//void sceneChangeDebug(String debug, boolean myBool) {
void sceneChangeDebug(String debug) {

//  println(" ");
//  println("*****************");
//  //println("my scene = " + debug + " = " + myBool);
//  println(debug);
//  println("scene change vals");
//  print("start = ");
//  println(start);
//  print("monsterSelected = ");
//  println(monsterSelected);
//  print("scene2 = ");
//  println(scene2);
//  print("scene3 = ");
//  println(scene3);
//  print("goTo4 = ");
//  println(goTo4);
//  print("scene4 = ");
//  println(scene4);
//  print("scene4fantasy = ");
//  println(scene4fantasy);
//  print("scene5 = ");
//  println(scene5);
//  print("doYouSeeCastles = ");
//  println(doYouSeeCastles);  
//  print("doCubeRoom = ");
//  println(doCubeRoom);

//  print("scene6 = ");
//  println(scene6);
//  print("scene7 = ");
//  println(scene7);
//  print("scene8 = ");
//  println(scene8);
//  print("scene9 = ");
//  println(scene9);
//  println(millis());
}

//######### USER INPUTS BELOW ##############


void mousePressed(MouseEvent evt) {
  //void mousePressed() {
  //if (start != true) {
  //  //  grow = 1;

  //  if (evt.getCount() == 2)doubleClicked();
  //  if (evt.getCount() == 3) grow = 0 ;
  //}


  //###########################
  //controll variou scenes here once monster is seleted.
  //###########################



  // scene1 select your monster
  if (start == true) {
    //runway.query(myInput);
    if ( (mouseX > 165 && mouseX < 415) && (mouseY > 360 && mouseY < 615 ) ) { 
      println("in monster1 area");
      selectMonster(monster1Mask);
    } else if ( (mouseX > 624 && mouseX < 875) && (mouseY > 360 && mouseY < 615 ) ) {   
      println("in wormonster area");
      selectMonster(wormonsterMask);
    } else { 
      println("not in area");
      //println(pointilizePresident.length);
    }
    if ( whichMonster != null) {
      ganImage.mask(whichMonster);
      image(ganImage, 0, 0);
    }
  }

  if ( (mouseX > 885 && mouseX < 1010) && (mouseY > 23 && mouseY < 70 ) ) {   
    println("in explore area");
    explore = true;
  }


  //scene2 Do you like adventures
  if (monsterSelected == true && answerClick == "left") { 
    println("in yes area scene2");
    scene3 = true;
    monsterSelected = false;
    answerClick = "null";
    sceneChangeDebug("scene2");
  } else if (monsterSelected == true && answerClick == "right" ) {   
    println("in no area scene 2");
    // theEnd = true;
    startOver();
    answerClick = "null";
    monsterSelected = false;
    sceneChangeDebug("do you like adventures no");
  }

  //scene3 Go inside? (mesh(
  if (scene3 == true && answerClick == "left") {
    println("in yes area scene3");
    scene4 = true;
    scene3 = false;
    goToScene4();
    answerClick = "null";
  } else if (scene3 == true && answerClick == "right") {   
    println("in no area scene3");
    startOver();
    scene3 = false;
    answerClick = "null";
  }


  //scene4 What do you see? (castles?)
  if (scene4 == true && answerClick == "left") {
    println("in yes area scene4");
    scene5 = true;
    scene4 = false;
    goToScene4();
    answerClick = "null";
  } else if (scene4 == true && answerClick == "right") {   
    println("in no area scene4");
    scene4fantasy = true;
    scene4 = false;
    answerClick = "null";
  }


  //scene4 What do you see? (castles?)
  if (scene4fantasy == true && answerClick == "left") {
    println("in yes area scene4fantasy");
    startOver();
    answerClick = "null";
  } else if (scene4 == true && answerClick == "right") {   
    println("in no area scene4fantasy");
    startOver();
    answerClick = "null";
  }



  //scene5? whats inside 
  if (scene5 == true && answerClick == "left") {
    println("in yes area scene5");

    //scene4fantasy = true;
    //scene5 = false;
    //mytext = "Is it a fantasy?";
    answerClick = "null";
  } else if (scene5 == true && answerClick == "right") {   
    println("in no area scene5");
    scene6 = true;
    scene5 = false;
    doCubeRoom = false;
    answerClick = "null";
  }


  //scene6? whats 3d 
  if (scene6 == true && answerClick == "left") {
    println("in yes area scene6");
    scene7 = true;
    scene6 = false;

    answerClick = "null";
  } else if (scene6 == true && answerClick == "right") {   
    println("in no area scene6");
    scene4fantasy = true;
    scene6 = false;
    answerClick = "null";
  }


  //scene7 be 3d 
  if (scene7 == true && answerClick == "left") {
    println("in yes area scene7");
    scene8 = true;
    scene7 = false;

    answerClick = "null";
  } else if (scene7 == true && answerClick == "right") {   
    println("in no area scene7");
    scene4fantasy = true;
    scene7 = false;
    answerClick = "null";
  }


  //scene8 its 3d 
  if (scene8 == true && answerClick == "left") {
    println("in yes area scene8");
    startOver();
    //scene9 = true;
    //scene8 = false;
    answerClick = "null";
  } else if (scene7 == true && answerClick == "right") {   
    println("in no area scene8");
    startOver();
  }



  // end scene click stmts
}



void doubleClicked() {
  grow = 2 ;
 
}

void answerClicks() {
  if ( (mouseX > 215 && mouseX < 290) && (mouseY > 800 && mouseY < 835 ) ) { 
    answerClick = "left";
  } else if ( (mouseX > 734 && mouseX < 800) && (mouseY > 800 && mouseY < 835 ) ) {   
    answerClick = "right";
  }
}


void mouseDragged() {  


  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mouseReleased() {
}


void keyPressed() {
  if (key == CODED) {

    if (keyCode == UP) {
      startOver();
    } else if (keyCode == DOWN) {
      explore = false;
      // reset cam();
      rotx = 0;
      roty = 0;
      zcam = 0;
    } else if (keyCode == LEFT) {
      println("mouseX = " + mouseX);
      println("mouseY = " + mouseY);
      //goInverse = 1;
    } else if (keyCode == RIGHT) {
      total = total + 1;
      //goInverse = 0;
    }
  } else {

    print("no key");
  }

  if (key == ' ') {
    // query a set vector
    runway.query(myInput);
  }

  if (key == 's' && runwayResult != null) {
    runwayResult.save(dataPath("result.png"));
  }
}








void cam() {
  int newx = mouseX;
  int newy = mouseY;

  translate(0, 0, zcam);
  //translate(width/2, height/2, zcam);
  //  translate(-width/2, -height/2,zcam);
  rotateY(rotx);
  rotateX(roty);
  //rotateZ(PI);
  if ((mousePressed == true)) {
    rotx = rotx + (oldx-newx)/50.0;
    roty = roty + (oldy-newy)/50.0;
  }
  oldx = newx;
  oldy = newy;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zcam = zcam - e*5;
}

int R, G, B, A;

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to define the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
