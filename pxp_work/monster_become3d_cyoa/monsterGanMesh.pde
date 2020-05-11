void ganMesh() {

  lights();


  if (gotCellVall == 0) {
    cell = myCell;
    println("my cell val = " + myCell + "\n");
    gotCellVall = 1 ;
  }


  push();
  noStroke();
  translate(width/2, height/2);                                   // translating to center of screen 

  translate(200, -10, -220);
  scale(0.6);                                            // scaling to create the zoom effect with mouseY
  

  rotateY(radians(125));   

  translate(-width/2, -height/2, 0);                             // translating back so our coordinates are synced between screen and video
  if (video.available ()) video.read();
  video.loadPixels();
  //video.filter(BLUR, cell);                                    // try bluring to soften

  for (int x=0; x< video.width-cell; x+= cell) {                      // visiting all pixels skipping every cell amount
    for (int y=0; y< video.height-cell; y+= cell) {
      beginShape();                                                  // we will make two triangles for each cell, start the first triangle

      PxPGetPixel(x, y, video.pixels, width);                      // get the RGB of our pixel        
      int brightness = (R+G+B)/-3;
      fill(R, G, B);
      vertex (x, y, brightness);

      PxPGetPixel(x+cell, y, video.pixels, width);                  //get the RGB of the top right
      brightness = (R+G+B)/-3;
      fill(R, G, B);
      vertex (x+cell, y, brightness);

      PxPGetPixel(x+cell, y+cell, video.pixels, width);            //get the RGB of the bottom right
      brightness = (R+G+B)/-3;
      fill(R, G, B);
      vertex (x+cell, y+cell, brightness);

      endShape(CLOSE);                                              // close the first triangle

      beginShape();                                                 // start second triangle

      PxPGetPixel(x+cell, y+cell, video.pixels, width);            //get the RGB of the bottom right
      brightness = (R+G+B)/-3;
      fill(R, G, B);
      vertex (x+cell, y+cell, brightness);

      PxPGetPixel(x, y+cell, video.pixels, width);                 //get the RGB of the bottom left
      brightness = (R+G+B)/-3;
      fill(R, G, B);
      vertex (x, y+cell, brightness);

      PxPGetPixel(x, y, video.pixels, width);                      //get the RGB of the top left
      brightness = (R+G+B)/-3;
      fill(R, G, B);
      vertex (x, y, brightness);

      endShape(CLOSE);                                             // close the second triangle
    }
  }

  pop();
}
