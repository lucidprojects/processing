/*
 Nanjing to Brooklyn a story about Danqi - Friends Family Art Dogs & Exploration
 This program is about content generation and telling a story about travel and exploration.
 As you interact with the program you can create new content and you're left with new images to remind you of your exploration
 
 ##############  
 ## controls ##
 # 'left arrow' keypress - saves image to data directory (will be used later in random numImages array call & paintFlakes()
 # 'up arrow' keypress - begins blend between nanjing family, flightpath, and brooklyn family
 # 'down arrow' keypress - clears famFriendsImage
 # top left corner mouseclick - stops audio viz lines
 # top right corner mouseclick - restarts audio viz lines
 # bottom right corner mouseclick - calls paintFlakes() again - paintFlakes() also happens automatically once numImages.length > 30 (generated at least 12 new unique images)
 ##############
 
 *modified audio visualization by ALI JORJANDI https://discourse.processing.org/t/sound-mapping-problem/6154
 *modified snow pixels & blending two images by Daniel Rozin
 */


//audio visualization
import ddf.minim.*; // minim library
Minim minim; // initialize minim
AudioPlayer song; // setup up player
AudioPlayer nanjing; // setup up nanjing player
AudioPlayer brooklyn; // setup up brooklyn player

int spacing = 5; // distance between lines
int amplification = 40; // frequency amplification
int num = 100; // resolution in y direction
int pos, counter;

float[] x = new float[num]; // array of values in x direction
float[] y = new float[num];
// end audio visualization inits 


Flake[] snowFlakes= new Flake[0];
int [] floor = new int[1000];

PImage bgSample, bg, cursorImg, cursorImgL, flightPath, famImage, friendsImage, famFriendsImage, ranImg, myImage, myImage2;

int jpgNum = 18;
PImage[] picArray = new PImage[3];

int myFinalImg;
boolean finalPicked = false;

boolean planeDir;  //control direction of plane mouse icon
boolean famFriends;
boolean doLines = true;

int R, G, B, A;    // global varables for PxPGetPixel()

int bgTint = 175;
int widthDiv = 1;

//array for random images
int[] numImages = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};

void setup() {
  size(1000, 700);
  //set up some initial pImages
  picArray[0] = loadImage("flight_path_black.png");
  picArray[1] = loadImage("flight_path_red.png");

  flightPath = loadImage("worldmap.jpg");
  flightPath.resize(width, height);

  cursorImg = loadImage("airplane_sml_2.png");
  cursorImgL = loadImage("airplane_sml_3.png");
  cursor(cursorImg);

  famImage= loadImage("FamPlayingCards_1000.jpg");
  famImage.resize(width, height);

  friendsImage= loadImage("Friends.jpg");
  friendsImage.resize(width, height);

  famFriendsImage =  createImage(width, height, ARGB); 
  famFriends = false;

  myImage2= loadImage("danqi_wall.jpg");
  for (int i = 0; i < width; i++)floor[i]=height-2; //this array will accumolate the height of snow pile columns, we start at bottom = height

  //setup audio objects
  minim = new Minim(this);
  song = minim.loadFile("fourtet_2017.mp3"); // load song
  //song.loop(); // loop song
  song.play(); // play song

  nanjing =  minim.loadFile("nanjing.mp3");
  brooklyn =  minim.loadFile("brooklyn.mp3");

  background(255);
  noFill();
  strokeWeight(1);

  //starting image of Danqi
  bgSample = loadImage("Hobby_Polaroid.jpg");
  bgSample.resize (width, height);
  image(bgSample, 0, 0);
}

void draw() {

  if (doLines == true) {  // control whether to do the audio visualization lines or not
    beginShape(); // start custom shape
    stroke(random(255), random(255), random(255));
    curveVertex(x[0], y[0]);
    for (int i = 0; i < num; i++) { // loop through each element in array
      x[i] = pos + song.mix.get(i)*amplification; // assign frequency value at position
      y[i] = map( i, 0, num, 0, height); // map ‘i’ to canvas height
      curveVertex(x[i], y[i]); // draw curves
    }
    x[num-1] = x[0]; // set x and y value of last array item to ‘zero’
    y[num-1] = height;
    curveVertex(x[num-1], y[num-1]);
    endShape(); // close custom shape


    if (pos  < width) { // move lines across the screen
      pos += spacing;
    } else { // if we get to the end of the screen create new random image
      pos = 0;
      int myImg = (int) random(0, numImages.length);
      ranImg = loadImage(myImg + ".jpg");
      try { //try catch to prevent crashing on the occassional missing image.  not sure what this is happening
        image(ranImg, 0, 0);
      } 
      catch (java.lang.NullPointerException e) {
        e.printStackTrace();
      }
    }
  } //end audio viz code

  //check mouse position and paint red or black flightpath  
  if ( (mouseX >280 && mouseX < 800) && (mouseY >120 && mouseY < 325)) {
    float dx = mouseX - pmouseX;
    float dy = mouseY - pmouseY;

    if ( mouseX > (width/2) )
    {
      image(picArray[0], 0, 0);
    } else
    {
      image(picArray[1], 0, 0);
    }

    //change direction of plane mouse icon based on direction of the mouse
    if (pmouseX < mouseX && dx > 1) {
      planeDir = true;
    } else {
      planeDir = false;
    }
    if (planeDir == true) {
      cursor(cursorImgL);
    } else {
      cursor(cursorImg);
    }
    delay(10);
  } else {
    cursor(POINT);
  }

  friendsImage.loadPixels();     
  famImage.loadPixels();
  famFriendsImage.loadPixels();
  loadPixels();

  float transparancy = map (mouseX, 0, width, 0, 1);      // lets get a number 0-1  for the transparancy
  for (int x = 0; x< width; x++) {                        // visit all pixels
    for (int y = 0; y< height; y++) {
      int newR;                    // add them all together
      int newG;
      int newB;

      PxPGetPixel(x, y, famImage.pixels, width);            // get the RGB of our pixel in the fanImage
      float famR = R *  transparancy;                       // multiply the fanImage values by the transwparancy
      float famG = G *  transparancy;  
      float famB = B *  transparancy;

      PxPGetPixel(x, y, friendsImage.pixels, width);       // get the pixel value in the friendsImage
      float imageR = R *  (1-transparancy);                // multiply the friendsImage values by the opacity (1-transparency) 
      float imageG = G *  (1-transparancy);
      float imageB = B *  (1-transparancy);

      PxPGetPixel(x, y, flightPath.pixels, width);           // get the pixel value in the flightPath image
      float image_Fp_R = R *  (transparancy);                // multiply the flightPath image values by the transparency 
      float image_Fp_G = G *  (transparancy);
      float image_Fp_B = B *  (transparancy);

      PxPGetPixel(x, y, flightPath.pixels, width);           // get the pixel value in the flightPath image
      float image_Fp_RN = R *  (1-transparancy);             // multiply the flightPath image values by the opacity (1-transparency) 
      float image_Fp_GN = G *  (1-transparancy);
      float image_Fp_BN = B *  (1-transparancy);

      if ( mouseX > width/3 * 2) { 
        newR = int( famR+image_Fp_RN+imageR);               // add fam and flightpath neg trans
        newG = int( famG+image_Fp_GN+imageG);
        newB = int( famB+image_Fp_BN+imageB);
      } else if ( mouseX < width/3 * 1 && mouseX > width/3 *2) { 
        newR = int( famR+image_Fp_R);                       // add fam and flightpath
        newG = int( famG+image_Fp_G);
        newB = int( famB+image_Fp_B);
      } else {
        newR = int( image_Fp_R+imageR);                     // add flight path and friends image
        newG = int( image_Fp_G+imageG);
        newB = int( image_Fp_B+imageB);
      }
      if (famFriends == true) { // only do this on up arrow key press
        PxPSetPixel(x, y, newR, newG, newB, 255, pixels, width);
      }
    }
  }
  updatePixels();

  // randomly play Nanjing & Brooklyn samples based on framecount.  randomly rewind so they can be replayed
  if (frameCount % 210 == 0) {
    nanjing.play();
    //println("try to plan nanjing");
  }
  if (frameCount % 420 == 0) {
    brooklyn.play();
    //println("try to play brooklyn");
  }
  if (frameCount % 2050 == 0) {
    brooklyn.rewind();
    nanjing.rewind();
    println("rewind");
  }

  if (numImages.length > 30) {
    paintFlakes(17000);
  }
  
  if(!song.isPlaying()){
     //println("song is over"); 
     minim.stop(); 
     doLines = false;
  }
  
  
}//end draw

class Flake {                                           // our flake class that stores a pixel and its colors
  int posX, posY, Red, Green, Blue;
  Boolean dead = false;
  Flake(int _posX, int _posY, int _R, int _G, int _B) {
    posX= _posX;                                        // store the location of the pixel
    posY= _posY;
    Red= _R;                                            // store the colors of the pixel
    Green = _G;
    Blue = _B;
  }     
  void  drawFlake() {                                   // if your not dead go down
    if (!dead) { 
      posY+=1;
    }

    if (posY>floor[posX] && !dead) {                  // if you reached the floor
      floor[posX] = 697;                              // adjusted this to not build up 
      //}
      dead = true;
    }
    PxPSetPixel(posX, posY, Red, Green, Blue, 255, pixels, width);     // set the RGB of our to screen
  }

  
}

void picMyFinalImage() {
  if (finalPicked == false) {  
    myFinalImg = (int) random(0, numImages.length-1);
    finalPicked = true;
  }
}

void paintFlakes(int myFlakeCount) {
  picMyFinalImage();
  myImage =loadImage(myFinalImg + ".jpg");
  image(myImage, 0, 0);

  for (int i = 0; i< 1000; i++) {
    int randiX= (int)random(0, width);                // randomize an x and y positions
    int randiY= (int)random(0, floor[randiX]);    


    if (snowFlakes.length < myFlakeCount) {
      PxPGetPixel(randiX, randiY, myImage2.pixels, width); 
      snowFlakes = (Flake[])append(snowFlakes, new Flake(randiX, randiY, R, G, B)); // create new flake and add to our array
    }
  }

  myImage2.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 

  for (int i = 0; i < snowFlakes.length; i++) {
    snowFlakes[i].drawFlake();                             // draw all the flakes we have in our growing array
  }

   updatePixels();
}

//handle key press controlls
void keyPressed() {

  if (key == CODED) {
    if (keyCode == UP) {
      famFriends = true;
      println("up pressed");
      if (bgTint > 0) {
        bgTint=-1;
      } else {
        bgTint = 175;
      }
    } else if (keyCode == DOWN) {
      famFriends = false;
      famFriendsImage =  createImage(width, height, ARGB); 
      println("clear famFriendsImage");
    } else if (keyCode == LEFT) {
      save("/Users/dezbookpro/Documents/jakes_docs/ITP/spring_2020/pixel_by_pixel/midterm/nanjing_to_brooklyn/data/" + jpgNum + ".jpg");
      numImages = append(numImages, jpgNum);
      println(numImages);
      jpgNum++;
    } else if (keyCode == RIGHT) {
    }
  }
}

//handle mouse press controlls
void mousePressed() { 
  if ( mouseX < 150 && mouseY < 150) {
    println("topleft");
    doLines = false;
  }
  if ( mouseX > width - 150 && mouseY < 150) {
    println("topright");
    doLines = true;
  }
  if ( mouseX > width - 150 && mouseY > height - 150) {
    println("bottomright");
    finalPicked = false; // set this back to false to pick a new image
    try {
      paintFlakes(400000);
    } 
    catch (java.lang.NullPointerException e) {
      e.printStackTrace();
    }
  }
  if ( mouseX < 150 && mouseY > height - 150) {
    println("bttomleft");
    //doLines = true;
  }
} 

// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution)

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
