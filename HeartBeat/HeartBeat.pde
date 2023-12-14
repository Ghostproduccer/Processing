color negro = 10;
color gris = 100;
color blanco = #f1f1f1;
color naranja = #ff9a00;



PImage img;


void setup() {
  size(600, 600);
  frameRate(30);
  img = loadImage("heart.png");
}

void draw() {
  background(blanco);
  
  noFill();
  stroke(negro);
  strokeWeight(5); 
  ellipse(width - mouseX, height - mouseY, 140, 140);
  
  imageMode(CENTER);
  if (keyPressed) {
    
    image(img, width/2, height/2, img.width/2 + 200, img.height/2 + 200);
  } else {
    
    image(img, width/2, height/2, img.width/2, img.height/2);
  }
  
  ellipse(mouseX, mouseY, 160, 160);
  
  strokeWeight(3);
  stroke(naranja);
  line(random(width), random(height), random(width), random(height));
  
  stroke(gris);
  line(random(width), random(height), random(width), random(height));
  
}
