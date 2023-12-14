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
  
   for (int i = 0; i < mouseX/50; i++) {
    push();
    strokeWeight(3);
    // Elige un número aleatorio de 1 a 4
    int numeroAleatorio = int(random(1, 4));

    // Elige un color correspondiente al número aleatorio
    switch(numeroAleatorio) {
      case 1:
        stroke(negro);
        break;
      case 2:
        stroke(gris);
        break;
      case 3:
        stroke(naranja);
        break;
    }
    
    line(random(width), random(height), random(width), random(height));
    pop();
  }
  
}
