// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  color tintCol;  // Almacena el color de tinte
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];
    tintCol = color(255, 204, 0);  // Color de tinte predeterminado

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }
  
  void setTintColor(int r, int g, int b) {
    tintCol = color(r, g, b);
  }

  void display(float xpos, float ypos, float mouseX) {
    frame = (frame + 1) % imageCount;

    // Ajusta la posición basada en las coordenadas del ratón
    float imageWidth = images[frame].width;
    
    //aplica el tinte
    tint(tintCol);

    if (mouseX < xpos+100) {
      // Si el ratón está a la derecha de la imagen, no se voltea
      image(images[frame], xpos, ypos);
    } else {
      // Si el ratón está a la izquierda, se voltea horizontalmente
      pushMatrix();
      translate(xpos + imageWidth, ypos);
      scale(-1, 1);  // Invierte la escala en el eje x
      image(images[frame], 0, 0);
      popMatrix();
    }
  }
  
  int getWidth() {
    return images[0].width;
  }
}
