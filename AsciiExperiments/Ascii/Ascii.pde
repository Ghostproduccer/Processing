PImage img;
PGraphics pg;

float hue;

// Define how many samples of the Waveform you want to be able to read at once
int samples = 100;

float TILES_X = 100;
float TILES_Y = TILES_X;
float TILE_W, TILE_H;


PFont font;

String CHARS = "▁▄0▜B▟1▙▄█▓▀▐3▌E▞4▓▒░";
//String CHARS = "▗▘▜▟▙▄▀▐▌▞▚▝▖▛█";
//String CHARS = " ._▂▃▄▅▆▇ ░▒▓█ ▊▋▌▍▎.";
//String CHARS = " ._▂▃▄▀▀▅▆▇░░▒▓█░ ";
//String CHARS = " ┃━┏┓┗┛┣┫┳┻╋ ";
//String CHARS = " ▐░▒▓▔▔▊▋▌▍▎▏";
//String CHARS = " ▁▂▃▄▅▆▇█";
//String CHARS = " ░▒▓█▂▃▄▅▆▇█";
//String CHARS = " ▁▄█▓▒░"; 

void setup() {
  size(900, 900, P3D);
  img = loadImage("img/sonic.png");
  img.resize(width, height);
  font = createFont("IBMPlexMono-Regular.ttf", 1000);
  
  pg = createGraphics(width, height, P3D);
  TILE_W = width / TILES_X;
  TILE_H = height / TILES_Y;
}

void draw() {
  
  pg.beginDraw();
  pg.background(0);
  pg.imageMode(CENTER);
  pg.translate((width / 2), height / 2);
  pg.image(img, 0, 0);
  pg.endDraw();
  background(251, 237, 252);
  noStroke();
  
  textFont(font);
  textSize(12);
  textAlign(CENTER, CENTER);
  translate(TILE_W / 2, TILE_H / 2);
  PImage buffer = pg.get();
  for (int x = 0; x < TILES_X; x++) {
    for (int y = 0; y < TILES_Y; y++) {
      int px = int(x* TILE_W);
      int py = int(y* TILE_H);
      
      color c = buffer.get(px, py);
      
      float b = brightness(c);
      
      int selector = int(map(b, 0, 255, CHARS.length() - 1, 0));
      
      char ch = CHARS.charAt(selector);
      
      fill(hue);
      push();
      translate(x * TILE_W, y * TILE_H);
      text(ch, 0, 0);
      pop();
    }
  }
  //image(pg,0,0);
}
