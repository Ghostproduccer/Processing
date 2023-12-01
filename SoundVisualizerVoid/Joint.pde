class Joint {
  float[] p;
  float dep;
  float f=random(255);
  int index = floor(random(palette.length)); // Seleccionar un color aleatorio de la paleta
  int index2 = floor(random(palette.length)); // Seleccionar un color aleatorio de la paleta

  Joint() {
    dep=0;
    p=new float[NUM];
    for (int i=0; i<NUM; i++) {
      float rad=TWO_PI/NUM*i;
      p[i]=noise((1-cos(rad))*2, (1-sin(rad))*2, F*0.091);
    }
  }

  boolean update() {
    strokeWeight(dep*0.01+amplitude*50);
    
    float hue = map(dep, 0, height/2, 0, 255); // Mapear la profundidad a un valor de tono
    stroke(hue, 150, 255);
    
    //stroke(palette[index]);
    
    //stroke(255);
    
    //stroke(f,150,255);
    
    //blue
    //stroke(0,0,f);
    
    beginShape();
    //fill(255,100,200);
    noFill();
    //fill(palette[index2]);
    
    
    for (int i=0; i<NUM+2; i++) {
      float r=p[i%NUM];
      float rad=TWO_PI/NUM*i;
      float t=pow(dep, 1.4)*r;
      float x=cos(rad)*t;
      float y=sin(rad)*t;
      curveVertex(x, y);
    }
    
    endShape(CLOSE);
    //dep+=1;
    dep+=0.03+ amplitude*10;
    if (dep>height/2) {
      return false;
    }
    return true;
  }
}
