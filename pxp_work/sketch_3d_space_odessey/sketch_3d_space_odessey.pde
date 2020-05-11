/* A 3D space odessey by jake sherwood
 camera function code found here http://workshop.softlabnyc.com/sound-4-sound-sponge/
 modified 3D grid of boxes by Danny Rozin.
 Adapted from minim library examples.
 
 Song - Space Walk by Lemon Jelly
 
 Uses Minim lib to adjust variables best on amplitude and levels to sync changes in graphics with music.
 
 ##### Controls ####
 scroll mouse wheel to zoom in and out of the scene
 click drag to pan around the scene
 down arrow to reset cam vals to 0
 click anywhere on X in lower 50 px (height - 50) to cue to another place in the song.  
 ***Note - quieng messes up some of the timing that is based off of millis() need to figure out how to time to song.length() instead
 ###################
 
 */





import ddf.minim.*;
Minim minim;

AudioPlayer song;

int beatBands = 30;                  //Number of bands to montiter, higher for more accuracy, lower for speed
int beatCounter = 0;
int slowDownBeatCounter = 50;

float amplitude = 150;
float leftLevel, rightLevel, spacing;
float rotateXVal, rotateYVal;



///camera varibles
int oldx = mouseX;
int oldy = mouseY;
float rotx = 0;
float roty = 0;
float zcam = 0;


//3D objects

PShape mouse, earth, spaceMan, rocket;
float spaceMouseX = -8000;
float spaceMouseY = 0;


float angle, spaceManAngle, rocketAngle;
//int earthScale =0;
int earthScale =140;
int earthScaleZ =-150;

float spaceManScale =1.2;
float spaceManScaleX = -100;
float spaceManScaleY = height;
int spaceManScaleZ =600;

float rocketScale =1.2;
float rocketScaleX = -100;
float rocketScaleY = height;
int rocketScaleZ =600;



//////////////////////////////////

void setup() {

  size(1270, 650, P3D);                                      //Sets up window
  noStroke();
  smooth();
  colorMode(RGB);

  minim = new Minim(this);                                      //Sets up minim

  song = minim.loadFile("LemonJelly_SpaceWalk.mp3", 2048);
  song.play();


  mouse = loadShape("space_humster.obj");
  earth = loadShape("earthlp.obj");
  spaceMan = loadShape("Astronaut.obj");

//  rocket = loadShape("rocketship.obj");
}

//////////////////////////////////
void draw() {





  push();
  cam();  
  // background(0);



  noStroke();

  beatCounter += 1;

  if (millis() >= 239000 && millis() < 240000) {
    beatCounter = slowDownBeatCounter;
    println("beatCounter = slowDownBeatCounter");
  }



  if ( rightLevel < 0.12) {
    rotateXVal = 940/100.0;
    rotateYVal = 940/100.0;
    spacing = beatCounter;
    amplitude = 150;
  } else if ( rightLevel > 0.12 && rightLevel <  0.30) {
    if (millis() < 240000) {
      rotateXVal = (width-90)/beatBands; 
      rotateYVal = random(0, width)/100.0;
      spacing = rightLevel *1000;
      amplitude = 450;
      spaceMouseY =    (width-90)/beatCounter;
    } else if (millis() > 240000 &&  millis() < 280000 ) {
      //beatCounter = slowDownBeatCounter;
      rotateXVal = 940/100.0;
      rotateYVal = 940/100.0;
      spacing = beatCounter;
    } else {
      rotateXVal = (width-90)/beatBands; 
      rotateYVal = random(0, width)/100.0;
      spacing = rightLevel *1000;
      amplitude = 450;
      spaceMouseY =    (width-90)/beatCounter;
    }




    //rotx = 0;
    //roty = 0;
    //zcam = 0;
  } else {
    rotateXVal = 940/100.0;
    rotateYVal = 940/100.0;
    spacing = random(40, 240);
    //println("we got here " + beatCounter +" " + rightLevel );
  }



  push();
  lights();                                 // must call lights() in draw() or it wont work
  background(0);
  translate(width/2, height/2, -200);       // translating to the center of screen so we can rotate around center
  rotateX(rotateXVal);
  rotateY(rotateYVal);
  translate(-width/2, -height/2, 200);     // after establishing the rotation we reverse the translation for the rest of the drawing
  // setting spacing in above if stmt
  translate (100, 100);                    // translating left and down a bit so we dont start at the corner
  for (int x= 0; x< 12; x++) {               // 3 repeat loops of 12 yield 1728 boxes
    for (int y= 0; y< 12; y++) {
      for (int z= 0; z< 12; z++) {
        pushMatrix();                      // for each box we will translate to where we want so we say pushMatrix, so we can revert to it
        translate(x*spacing, y*spacing, -z*spacing);    // translating by absolute amounts on the X,Y,Z
        fill(x*(random(20, 255)), y*(random(20, cos(40))), z*(random(20, 255)));                            // setting a fill color based on X,Y,Z
        box(12);                                            // the4 box is always drawn at 0,0,0 but since we did a transaltion it will be in the right lace
        popMatrix();                                    // revertig our matrix so it will be ready for the next box
      }
    }
  }

  pop();

  //////////////////// //mouse section
  push(); 
  lights(); 
  scale(20);

  rotateY(radians(angle));
  rotateX(160);  
  if ( millis() <85088) {
    spaceMouseX = -8000;
  } else if ( millis() >85088 && millis() < 105088) {
    if ( rightLevel > 0.26) {

      spaceMouseX = 0;
    }
  } else if (millis() > 105088) {
    scale(random(rightLevel * 50, rightLevel * 100));
    spaceMouseX = rightLevel * random(10, 200);
    spaceMouseY = leftLevel * random(10, 200);

    float calcRight = rightLevel * random(10, 30);
    float calcLeft = leftLevel * random(10, 30);

    //println("calcLeft = " + calcLeft + "\t" + "calcRight = " + calcRight);
  }


  shape(mouse, spaceMouseX, spaceMouseY);


  pop();

  ////////////////////  //earth section
  push(); 
  lights(); 
  scale(earthScale);
  translate(0, 0, earthScaleZ);
  rotateY(radians(angle));  

  tint(255, 25);
  shape(earth, 0, 0);
 
  if ( millis() >76888) {
    earthScaleZ+=10;
    earthScaleZ = constrain(earthScaleZ, -150, 0);
  }
  pop();


  ////////////////////   //spaceMan section

  push();


  lights(); 
  scale(spaceManScale);
  translate(spaceManScaleX, spaceManScaleY, spaceManScaleZ);

  rotateX(9);

  //rotateZ(5); 
  rotateY(radians(spaceManAngle));  
  //angle++;


  shape(spaceMan, 0, 0);

  if (millis() > 22088) {
    spaceManAngle+=.35;
    spaceManScaleZ--;

    spaceManScaleZ = constrain(spaceManScaleZ, -100, 600);

    spaceManScaleX+=0.25;
    spaceManScaleX = constrain(spaceManScaleX, -100, 200);
  }

  pop();


  //REVISIT
  // I was trying to also add a rocketship but it was some how compounding some of my scales and translates even though they are all wrapped in push pop

  ////////////////////   //rocket section 
  //push();


  //lights(); 
  //scale(rocketScale);
  //translate(rocketScaleX, rocketScaleY, rocketScaleZ);

  //rotateX(9);

  ////rotateZ(5); 
  //rotateY(radians(rocketAngle));  
  ////angle++;


  //shape(rocket, 0, 0);

  //if (millis() > 6088) {
  //  println("where's rocket yo?");
  //  rocketAngle+=.35;
  //  rocketScaleZ--;

  //  rocketScaleZ = constrain(rocketScaleZ, -100, 600);

  //  rocketScaleX+=0.25;
  //  rocketScaleX = constrain(rocketScaleX, -100, 200);
  //}

  //pop();

  // below is end of cam push pop
  pop();


  textSize(32);
  text(millis(), 50, height - 50 );

  leftLevel = song.left.level();
  rightLevel = song.right.level();
  //print("rightLevel = ");
  //println(rightLevel);


  angle++;


  //println(millis());

  //println(song.length());

  stroke(150);

  // draw the waveform with a loop
  for (int i = 0; i < song.bufferSize()-1; i++) {
    line( i, height/2 + song.mix.get(i)*amplitude, i+1, height/2 + song.mix.get(i+1)*amplitude);
    //float amplitudeVal =song.mix.get(i)*amplitude;
    //println(amplitudeVal);
  }

  if (millis() > 425000) {
    earthScaleZ-=20;
    spaceManScaleZ+=40;
    println("scaleout earth");
  }
}



void stop()                                //Closes everything on stop
{
  song.close();                              //Always close Minim audio classes when you are finished with them
  minim.stop();                            //Always stop Minim before exiting
  super.stop();                            //This closes the sketch
}




void mousePressed()
{
  // choose a position to cue to based on where the user clicked.
  if (mouseY > height -50) {
    int position = int( map( mouseX, 0, width, 0, song.length() ) );
    song.cue( position );
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == DOWN) {
      rotx = 0;
      roty = 0;
      zcam = 0;
    }  
    if (keyCode == UP) {
      //noOp;
    }
  }
}


void cam() {
  int newx = mouseX;
  int newy = mouseY;
  translate(width/2, height/2, zcam);
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
