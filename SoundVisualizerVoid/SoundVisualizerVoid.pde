import processing.sound.*;              //import sound
Amplitude amp;                          //via amplitude
AudioIn in;
SoundFile file;

int NUM=128;
int F;

float amplitude;

ArrayList joints=new ArrayList();

//paleta de colores
color[] palette = {color(125,255,0), color(179,255,106), color(203,255,154), color(224,255,194), color(240,255,225)};

void setup() {
  //size(1000,1000);
  //size(450,800); // till dawn 1,58 -- stormzy 0.25
  fullScreen();
  noFill();
  stroke(255);
  
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
  colorMode(HSB);
}

void draw() {
  amplitude = amp.analyze();
  
  background(0);
  translate(width/2, height/2);

  F=frameCount;
  if (F%20==0) {
    joints.add(new Joint());
  }
  for (int i=0; i<joints.size(); i++) {
    Joint j = (Joint)joints.get(i);
    if (j.update()==false) {
      joints.remove(i);
    }
  }
  
  if (mousePressed){
    //TODO implement
  }
}

//aero chord - boundless
