/**
 * This sketch shows how to use the Waveform class to analyze a stream
 * of sound. Change the number of samples to extract and draw a longer/shorter
 * part of the waveform.
 */

import processing.sound.*;

// Declare the sound source and Waveform analyzer variables
SoundFile sample;
Waveform waveform;
float hue;

// Define how many samples of the Waveform you want to be able to read at once
int samples = 100;

public void setup() {
  size(640, 360);
  

  // Load and play a soundfile and loop it.
  sample = new SoundFile(this, "Soularflair-Jouhatsu.mp3");
  sample.loop();

  // Create the Waveform analyzer and connect the playing soundfile to it.
  waveform = new Waveform(this, samples);
  waveform.input(sample);
}

public void draw() {

  // Set background color, noFill and stroke style
  background(0);
  stroke(0);
  strokeWeight(2);
  noFill();

  // Perform the analysis
  waveform.analyze();

  beginShape();
  for(int i = 0; i < samples; i++){
    hue = map(waveform.data[i], -1, 1, 200, 255);
    background(hue,255,150);
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1 
    curveVertex(
      map(i, 0, samples, 0, width),
      map(waveform.data[i], -1, 1, 0, height)
    );
  }
  endShape();
}

void mouseClicked(){
  if(sample.isPlaying()){
  sample.pause();} else {
  sample.play();
  }
}
