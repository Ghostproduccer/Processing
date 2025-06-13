PImage mainImage;
PImage backgroundImage;
PGraphics mainPg;
PGraphics bgPg;

float TILES_X = 100;
float TILES_Y = TILES_X;
float TILE_W, TILE_H;

// Background visual parameters
float glitchAmount = 0;
float scanlineOffset = 0;
boolean glitchEffect = false;
float rotationAngle = 0;

// Character sets for ASCII art
String CHARS = "▁▄0▜B▟1▙▄█▓▀▐3▌E▞4▓▒░";

// Visual Generator parameters
String[] charSets = {
  "█▀▄▌▐",           // Minimal blocks
  "┃━┏┓┗┛┣┫",        // Box drawing
  "▁▂▃▄▅▆▇█",        // Progressive blocks
  "░▒▓█",            // Density
  "▗▘▜▟▙▄▀▐▌▞",     // Geometric
  "01",              // Binary
  "エラー",           // Error in Japanese
  "×ØΦ†‡",           // Symbols
  "▒░█▓▒░",         // Noise
  "/\\|/\\|"         // Patterns
};

int currentCharSet = 0;
String BG_CHARS = charSets[currentCharSet];

color[] palette = {
  #CFF27E, // Lime Green
  #FF220C, // Bright Red
  #868686, // Medium Gray
  #000000, // Black
  #FFFFFF  // White
};

PFont font;
boolean needsRedraw = true;

void setup() {
  size(900, 900, P3D);
  
  // Load default image or create blank one
  mainImage = createImage(width, height, RGB);
  backgroundImage = createImage(width, height, RGB);
  
  font = createFont("IBMPlexMono-Regular.ttf", 1000);
  
  mainPg = createGraphics(width, height, P3D);
  bgPg = createGraphics(width, height, P3D);
  
  TILE_W = width / TILES_X;
  TILE_H = height / TILES_Y;
  
  // Initialize with black
  mainImage.loadPixels();
  for (int i = 0; i < mainImage.pixels.length; i++) {
    mainImage.pixels[i] = color(0);
  }
  mainImage.updatePixels();
}

void draw() {
  if (needsRedraw) {
    generateBackground();
    drawMainAscii();
    needsRedraw = false;
  }
}

void generateBackground() {
  bgPg.beginDraw();
  bgPg.background(palette[4]);
  bgPg.imageMode(CENTER);
  bgPg.translate(width/2, height/2);
  bgPg.rotate(rotationAngle);
  
  // Apply glitch effect
  if (glitchEffect && random(1) < 0.7) {
    bgPg.filter(POSTERIZE, random(2, 6));
    for (int i = 0; i < 10; i++) {
      float x = random(-glitchAmount, glitchAmount);
      float y = random(-glitchAmount, glitchAmount);
      float w = random(20, 100);
      float h = random(2, 20);
      int sx = int(random(width));
      int sy = int(random(height));
      bgPg.copy(backgroundImage, sx, sy, int(w), int(h), int(sx + x), int(sy + y), int(w), int(h));
    }
  }
  
  bgPg.tint(255, 180);
  bgPg.image(backgroundImage, 0, 0);
  
  // Add scanlines
  for (int y = 0; y < height; y += 4) {
    bgPg.stroke(0, 30);
    bgPg.line(0, y + scanlineOffset, width, y + scanlineOffset);
  }
  
  bgPg.endDraw();
  
  background(palette[4]);
  noStroke();
  
  textFont(font);
  textSize(24);
  textAlign(CENTER, CENTER);
  translate(TILE_W / 2, TILE_H / 2);
  
  PImage buffer = bgPg.get();
  
  // Draw background ASCII art
  for (int x = 0; x < TILES_X; x++) {
    for (int y = 0; y < TILES_Y; y++) {
      int px = int(x * TILE_W);
      int py = int(y * TILE_H);
      
      color c = buffer.get(px, py);
      float b = brightness(c);
      
      int selector = int(map(b, 0, 255, 0, BG_CHARS.length() - 1));
      selector = constrain(selector, 0, BG_CHARS.length() - 1);
      char ch = BG_CHARS.charAt(selector);
      
      color selectedColor;
      if (b < 85) {
        selectedColor = (random(1) < 0.7) ? palette[2] : palette[1];
      } else if (b > 170) {
        selectedColor = (random(1) < 0.8) ? palette[4] : palette[0];
      } else {
        selectedColor = palette[2];
      }
      
      push();
      translate(x * TILE_W, y * TILE_H);
      
      if (random(1) < 0.05) {
        textSize(32);
        fill(palette[1]);
      } else {
        fill(selectedColor);
      }
      
      text(ch, 0, 0);
      pop();
    }
  }
  translate(-TILE_W / 2, -TILE_H / 2); // Reset translation for main ASCII
}

void drawMainAscii() {
  mainPg.beginDraw();
  mainPg.background(0);
  mainPg.imageMode(CENTER);
  mainPg.translate(width/2, height/2);
  mainPg.image(mainImage, 0, 0);
  mainPg.endDraw();
  
  textFont(font);
  textSize(8); // Smaller text size for more detail
  textAlign(CENTER, CENTER);
  
  // Calculate the center region for the main ASCII art (2/3 of the screen)
  float centerScale = 0.66;
  float centerWidth = width * centerScale;
  float centerHeight = height * centerScale;
  float startX = (width - centerWidth) / 2;
  float startY = (height - centerHeight) / 2;
  
  // Create a white rectangle behind the ASCII art
  noStroke();
  fill(255);
  rect(startX, startY, centerWidth, centerHeight);
  
  PImage buffer = mainPg.get();
  
  // Draw main ASCII art in the center
  float tileScaleX = centerWidth / TILES_X;
  float tileScaleY = centerHeight / TILES_Y;
  
  for (int x = 0; x < TILES_X; x++) {
    for (int y = 0; y < TILES_Y; y++) {
      // Calculate position in the center region
      float px = map(x, 0, TILES_X, startX, startX + centerWidth);
      float py = map(y, 0, TILES_Y, startY, startY + centerHeight);
      
      // Sample the image at this position
      color c = buffer.get(int(map(x, 0, TILES_X, 0, width)),
                          int(map(y, 0, TILES_Y, 0, height)));
      float b = brightness(c);
      
      // Use a simpler character set for more figurative representation
      char ch = ' ';
      if (b < 51) ch = '█';
      else if (b < 102) ch = '▓';
      else if (b < 153) ch = '▒';
      else if (b < 204) ch = '░';
        fill(0); // Always black for better contrast
      push();
      translate(px, py);
      text(ch, 0, 0);
      pop();
    }
  }
}

void keyPressed() {
  if (key == 'g' || key == 'G') {
    glitchEffect = !glitchEffect;
    glitchAmount = random(10, 30);
    needsRedraw = true;
  } else if (key == 'r' || key == 'R') {
    rotationAngle = random(-PI/8, PI/8);
    needsRedraw = true;
  } else if (key == ' ') {
    selectInput("Select an image to process:", "fileSelected");
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    currentCharSet = (currentCharSet + 1) % charSets.length;
    BG_CHARS = charSets[currentCharSet];
  } else if (mouseButton == LEFT) {
    TILES_X = random(20, 40);
    TILES_Y = TILES_X;
    TILE_W = width / TILES_X;
    TILE_H = height / TILES_Y;
    glitchEffect = random(1) < 0.5;
    glitchAmount = random(10, 30);
    rotationAngle = random(-PI/8, PI/8);
    currentCharSet = int(random(charSets.length));
    BG_CHARS = charSets[currentCharSet];
    palette[0] = color(random(100, 255), random(100, 255), random(100, 255));
    palette[1] = color(random(200, 255), 0, 0);
  }
  noiseSeed(int(random(10000)));
  needsRedraw = true;
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    mainImage = loadImage(selection.getAbsolutePath());
    mainImage.resize(width, height);
    needsRedraw = true;
  }
}
