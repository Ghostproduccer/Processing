PImage img;
float TILES_X = 60;
float TILES_Y = TILES_X;
float TILE_W, TILE_H;

void setup() {
  size(900, 900);
  img = loadImage("img/sonic.jpg");
  img.resize(width, height);
  
  TILE_W = width / TILES_X;
  TILE_H = height / TILES_Y;
}

void draw() {
  background(#f1f1f1);
  noStroke();
  
  //fill(#00FF00);

  for (int x = 0; x < TILES_X; x++) {
    for (int y = 0; y < TILES_Y; y++) {
      int px = int(x* TILE_W);
      int py = int(y* TILE_H);
      
      color c = img.get(px, py);
      
      //float b = brightness(c);
      
      fill(c);

      rect(x * TILE_W, y * TILE_H, TILE_W, TILE_H);
    }
  }
}
