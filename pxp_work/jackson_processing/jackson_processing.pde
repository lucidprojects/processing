//modified from Paint Splash by A B H I N A V .  K R
//found here
//https://www.openprocessing.org/sketch/119786/

import processing.serial.*; // import the Processing serial library
Serial myPort;

float accelX;
float accelY;
float accelZ;

float startAccelX = 0;

float gyroX;
float gyroZ;
float startGryoZ = 0.00;


ArrayList paintArray;
PGraphics paintSplash;
void setup()
{
  size(800, 800);

  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  // read incoming bytes to a buffer
  // until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');

  paintArray = new ArrayList();
  paintSplash = createGraphics(width, height);
}

void draw() {
  //println(frameRate);
  background(-1);
  paintSplash.beginDraw();
  for (int i=0; i<paintArray.size(); i++) {
    Splash s = (Splash) paintArray.get(i);
    s.display();
    if (random(180)<100)
      s.update();

    if (random(180)<40)
      paintArray.remove(i);
  }
  paintSplash.endDraw();

  image(paintSplash, 0, 0);

  if (startAccelX != accelX) { // only create new paint objects if there is a different accelX val

    //change color based on modulo frameCount
    color splc = color(0, random(255));
    if (frameCount% 3 == 0) {
      splc = color(255, random(255));
    } else if (frameCount% 5 == 0) {
      splc = color(0, random(255));
    } else {
      splc = color(random(255), random(255), random(255), random(255));
    }

    for (float i=3; i<45; i+=.35) {  // number of ellipse making up one splater pattern
      Splash sp = new Splash(accelX, accelY, i, splc);
      paintArray.add(sp);
    }

    startAccelX = accelX;
  }
}

void mousePressed() {
  //background(255);
  paintSplash.clear();
}

class Splash {
  float x, y;
  float rad, ellipseangle, i;
  color c;
  float opacity;
  int opacityDir;

  Splash(float _x, float _y, float _i, color splc) {
    x = _x;
    y = _y;
    i = _i;
    rad = random(2, 50); // anything above 50 make paint splats too big
    ellipseangle = random(0, TWO_PI);
    c = splc;
  }

  void display() {

    paintSplash.fill(c);
    paintSplash.noStroke();
    float spotX = x + cos(ellipseangle)*2*i;
    float spotY = y + sin(ellipseangle)*3*i;

    paintSplash.ellipse(spotX, spotY, rad-i, rad-i+random(1, 2));
  }
  void update() {  // randomly change length of drips
    y = y+random(1, 15);
  }
}


void serialEvent(Serial myPort) {


  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    myString = trim(myString);
    // split the string at the commas
    // and convert the sections into integers:
    float sensors[] = float(split(myString, ','));

    // printArray(sensors);  


    // take values in sensors array and set individual vars
    if (sensors.length > 1) {

      float floatX = sensors[0];
      //accelX = map(floatX, -1, 1, 0, width);
      accelX = map(floatX, -4, 4, 0, width);

      float floatY = sensors[1];
      //accelY = map(floatY, -1, 1, 0, height);
      accelY = map(floatY, -4, 4, 0, height);

      float floatZ = sensors[2];
      //accelZ = map(floatZ, -1, 1, 0, height);
      accelZ = floatZ;


      gyroX = sensors[3];
      gyroZ = sensors[4];

      //print("accelX = ");
      //println(accelX);

      //print("accelY = ");
      //println(accelY);

      //  println(accelZ);

      //print("gyroX = ");
      //println(gyroX);

      //print("gyroZ = ");
      //println(gyroZ);
    }
  }
}
