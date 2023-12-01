/**
 * Animated Sprite (Shifty + Teddy)
 * by James Paterson. 
 * 
 * Press the mouse button to change animations.
 * Demonstrates loading, displaying, and animating GIF images.
 * It would be easy to write a program to display 
 * animated GIFs, but would not allow as much control over 
 * the display sequence and rate of display. 
 */

Animation animation1, animation2;

float xpos;
float ypos;
float drag = 30.0;

void setup() {
  size(640, 360);
  background(255, 204, 0);
  frameRate(20);
  animation1 = new Animation("frame_", 10);
  animation2 = new Animation("PT_Teddy_", 60);
  ypos = height * 0.25;
}

void draw() { 
  float dx = mouseX - xpos;
  xpos = xpos + dx/drag;
  
  // Display the sprite at the position xpos, ypos
  if (mousePressed) {
    background(200, 200, 0);
    animation1.setTintColor(255, 204, 0);
    animation1.display(xpos-animation1.getWidth()/2, ypos, mouseX);
  } else {
    background(255, 204, 0);
    animation1.setTintColor(300, 300, 0);
    animation1.display(xpos-animation1.getWidth()/2, ypos, mouseX);
  }
}
