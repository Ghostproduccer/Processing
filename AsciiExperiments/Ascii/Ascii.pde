PImage img;
PGraphics pg;

float TILES_X = 80;
float TILES_Y = TILES_X;
float TILE_W, TILE_H;


PFont font;

//String CHARS = " ▗A▘0▜B▟1▙C▄2▀D▐3▌E▞4▚F▝5";
//String CHARS = " ▗▘▜▟▙▄▀▐▌▞▚▝▖▛█";
//String CHARS = " ._▂▃▄▅▆▇ ░▒▓█ ▊▋▌▍▎▏";
String CHARS = " ._▂▃▄▀▀▅▆▇░░▒▓█░ ";
//String CHARS = "┃━┏┓┗┛┣┫┳┻╋";
//String CHARS = " ▐░▒▓▔▔▊▋▌▍▎▏";

void setup() {
  size(900, 900);
  img = loadImage("img/sonic.jpg");
  img.resize(width, height);
  font = createFont("IBMPlexMono-Regular.ttf", 1000);
  
  pg = createGraphics(width, height);
  TILE_W = width / TILES_X;
  TILE_H = height / TILES_Y;
}

void draw() {
  
  pg.beginDraw();
  pg.background(0);
  pg.imageMode(CENTER);
  pg.translate(width / 2, height / 2);
  float wave = map(sin(radians(frameCount)), 1, -1, 0.2, 1);
  pg.scale(wave);
  pg.image(img, 0, 0);
  pg.endDraw();
  
  background(#f1f1f1);
  noStroke();
  
  textFont(font);
  fill(0);
  textSize(16);
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
      //fill(c);
      push();
      translate(x * TILE_W, y * TILE_H);
      text(ch, 0, 0);
      pop();
    }
  }
}
