PImage img;
PGraphics pg;
ArrayList<PImage> sourceImages;
int currentImage = 0;

float glitchAmount = 0;
float scanlineOffset = 0;
boolean glitchEffect = false;
float rotationAngle = 0;

float TILES_X = 30; // Reduced for larger characters
float TILES_Y = TILES_X;
float TILE_W, TILE_H;

// Glitch timing
float lastGlitchTime = 0;
float glitchInterval = 2000; // 2 seconds


PFont font;

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
String CHARS = charSets[currentCharSet];

color[] palette = {
  #CFF27E, // Lime Green
  #FF220C, // Bright Red
  #868686, // Medium Gray
  #000000, // Black
  #FFFFFF  // White
};

boolean needsRedraw = true;

void setup() {
  size(900, 900, P3D);
  sourceImages = new ArrayList<PImage>();
  // Load all images from img folder
  File folder = new File(sketchPath("img"));
  File[] files = folder.listFiles();
  for (File file : files) {
    if (file.getName().endsWith(".jpg") || file.getName().endsWith(".png")) {
      PImage loadedImg = loadImage("img/" + file.getName());
      loadedImg.resize(width, height);
      sourceImages.add(loadedImg);
    }
  }
  
  img = sourceImages.get(0);
  font = createFont("IBMPlexMono-Regular.ttf", 1000);
  
  pg = createGraphics(width, height, P3D);
  TILE_W = width / TILES_X;
  TILE_H = height / TILES_Y;
}

void draw() {
  if (needsRedraw) {
    generateImage();
    needsRedraw = false;
  }
}

void generateImage() {
  pg.beginDraw();
  pg.background(palette[4]);
  pg.imageMode(CENTER);
  pg.translate(width/2, height/2);
  pg.rotate(rotationAngle);
  
  // Apply glitch effect
  if (glitchEffect && random(1) < 0.7) {
    pg.filter(POSTERIZE, random(2, 6));
    for (int i = 0; i < 10; i++) {
      float x = random(-glitchAmount, glitchAmount);
      float y = random(-glitchAmount, glitchAmount);
      float w = random(20, 100);
      float h = random(2, 20);
      int sx = int(random(width));
      int sy = int(random(height));
      pg.copy(img, sx, sy, int(w), int(h), int(sx + x), int(sy + y), int(w), int(h));
    }
  }
  
  pg.tint(255, 180);
  pg.image(img, 0, 0);
  
  // Add scanlines
  for (int y = 0; y < height; y += 4) {
    pg.stroke(0, 30);
    pg.line(0, y + scanlineOffset, width, y + scanlineOffset);
  }
  
  pg.endDraw();
  
  background(palette[4]); // White background
  noStroke();
  
  textFont(font);
  textSize(24); // Larger base text size
  textAlign(CENTER, CENTER);
  translate(TILE_W / 2, TILE_H / 2);
  PImage buffer = pg.get();
  
  for (int x = 0; x < TILES_X; x++) {
    for (int y = 0; y < TILES_Y; y++) {
      int px = int(x * TILE_W);
      int py = int(y * TILE_H);
      
      color c = buffer.get(px, py);
      float b = brightness(c);
      
      int selector = int(map(b, 0, 255, 0, CHARS.length() - 1));
      selector = constrain(selector, 0, CHARS.length() - 1);
      char ch = CHARS.charAt(selector);
      
      // Refined color selection focusing on greys and whites
      color selectedColor;
      if (b < 85) {
        selectedColor = (random(1) < 0.7) ? palette[2] : palette[1]; // Mostly gray, some red
      } else if (b > 170) {
        selectedColor = (random(1) < 0.8) ? palette[4] : palette[0]; // Mostly white, some lime
      } else {
        selectedColor = palette[2]; // Mid-tones are gray
      }
      
      push();
      translate(x * TILE_W, y * TILE_H);
      
      // Occasional high-impact effects
      if (random(1) < 0.05) {
        textSize(32); // Even larger for emphasis
        fill(palette[1]); // Red for impact
      } else {
        fill(selectedColor);
      }
      
      text(ch, 0, 0);
      pop();
    }
  }
}

void keyPressed() {
  if (key == 'g' || key == 'G') {
    glitchEffect = !glitchEffect;
    glitchAmount = random(10, 30);
  } else if (key == 'r' || key == 'R') {
    rotationAngle = random(-PI/8, PI/8);
  } else if (key == ' ') {
    // Cycle through available images
    currentImage = (currentImage + 1) % sourceImages.size();
    img = sourceImages.get(currentImage);
  }
  needsRedraw = true;
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    // Cycle through character sets
    currentCharSet = (currentCharSet + 1) % charSets.length;
    CHARS = charSets[currentCharSet];
  } else if (mouseButton == LEFT) {
    // Randomize everything for a new look
    TILES_X = random(20, 40);
    TILES_Y = TILES_X;
    TILE_W = width / TILES_X;
    TILE_H = height / TILES_Y;
    glitchEffect = random(1) < 0.5;
    glitchAmount = random(10, 30);
    rotationAngle = random(-PI/8, PI/8);
    currentCharSet = int(random(charSets.length));
    CHARS = charSets[currentCharSet];
    // Random color variations
    palette[0] = color(random(100, 255), random(100, 255), random(100, 255)); // Random bright color
    palette[1] = color(random(200, 255), 0, 0); // Keep red but vary intensity
  }
  noiseSeed(int(random(10000)));
  needsRedraw = true;
}
