/* A modified version of the ArrayObject example found at
 * http://processing.org/examples/arrayobjects
 
 * I will leave extra comment only for codes addes by me
*/

int unit = 20;
int count;
Module[] mods;

boolean counter = false;                      // A counter just to choose background and points color
float ZPOS = 0;                               // Variable to store the move of the "camera". Initial Z position is 0
float VELOCITY = 1;                           // Camera moving velocity
int fr = 0;                                   // Variable to store the number of frames
int MAX_DEPTH = 270;                          // Max depth move (Z position) of the camera

void setup() {
  size(1920, 1080, OPENGL);                   // FullHD 1080p resolution
  noStroke();
  frameRate(25);                              // 25 fps
  int wideCount = width / unit;
  int highCount = height / unit;
  count = wideCount * highCount;
  mods = new Module[count];

  int index = 0;
  for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {
      mods[index++] = new Module(x*unit, y*unit, unit/2, unit/2, random(0.05, 0.8), unit);
    }
  }
}

void draw() {
  
  // If the counter boolean is true so background will be black and point white, 
  // Otherwise background will be white and points black. This will change everytime
  // ZPOS will be bigger than MAX_DEPTH.
  if (counter) {
    background(0);
  } 
  else {
    background(255);
  }
  
  // As we don't have a real camera, we have to simulate it by moving the entire world
  // to the camera. So I translate all the world bye ZPOS
  translate(0, 0, ZPOS);
  
  // Add velocity of the camera to ZPOS
  ZPOS += VELOCITY;
  
  // Add velocity to camera, so the video will be a bit faster each frame
  VELOCITY += 0.0002;
  
  /* If ZPOS is bigget than MAX_DEPTH (in other world if the maximum distance for the camera has been reached)
   * subtract 10 to unit and reinitialize all the points, so there will be more points in the drawing window
   * as the number of points is given by width/unit and height/unit.
   * Tt the same time, reset the ZPOS of the world (reset the position of the camera) and increase the value
   * for the maximum distance of the camera.
  */
  
  if (ZPOS > MAX_DEPTH) {
    MAX_DEPTH += 2;                            // Increase maximum distance of the camera
    if (unit > 30) {
      unit = unit - 10;                        // If unit is bigger than 30, increase unit variable, so that there will be more points
    }                                          // This because we can fall in a ompletely black (or completely white) window for too many points
    else if (unit > 20 && unit <= 30) {
      unit -= 1;                               // When unit is between 20 and 30 subtract only 1 to unit, to extend the change time
    }
    ZPOS = 0;                                  // Reset ZPOS
    counter = !counter;                        // If counter is true, it became false and if it is false, it became true, this to change background and points color
    
    // Reinitialize objects
    int wideCount = width / unit;
    int highCount = height / unit;
    count = wideCount * highCount;
    mods = new Module[count];

    int index = 0;
    for (int y = 0; y < highCount; y++) {
      for (int x = 0; x < wideCount; x++) {
        mods[index++] = new Module(x*unit, y*unit, unit/2, unit/2, random(0.05, 0.8), unit);
      }
    }
  }
  
  for (int i = 0; i < count; i++) {
    mods[i].update();
    mods[i].draw(counter);
  }
  
  // Save each frame a PNG of the rendered window
  saveFrame("/data/frame" + fr + ".png");
  fr++;
}




class Module {
  int xOffset;
  int yOffset;
  float x, y;
  int unit;
  int xDirection = 1;
  int yDirection = 1;
  float speed; 

  // Contructor
  Module(int xOffsetTemp, int yOffsetTemp, int xTemp, int yTemp, float speedTemp, int tempUnit) {
    xOffset = xOffsetTemp;
    yOffset = yOffsetTemp;
    x = xTemp;
    y = yTemp;
    speed = speedTemp;
    unit = tempUnit;
  }

  // Custom method for updating the variables
  void update() {
    x = x + (speed * xDirection);
    if (x >= unit || x <= 0) {
      xDirection *= -1;
      x = x + (1 * xDirection);
      y = y + (1 * yDirection);
    }
    if (y >= unit || y <= 0) {
      yDirection *= -1;
      y = y + (1 * yDirection);
    }
  }

  // Custom method for drawing the object
  void draw(boolean counter_) {
    if (counter_) {
      fill(255);
    } 
    else {
      fill(0);
    }
    ellipse(xOffset + x, yOffset + y, 6, 6);
  }

  public float xPos() {
    return xOffset+x;
  }

  public float yPos() {
    return yOffset+y;
  }
}

