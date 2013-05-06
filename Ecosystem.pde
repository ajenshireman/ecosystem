/**
 * Ecosystem.pde
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instrucor: David Brown
 * 
 * Driver for semseter long ecosystem project
 * 
 * 
 */

import java.util.Iterator;

int bgColor = 255;  // background color
PVector center;     // center of the processing window

Biosphere biosphere;     // Biosphere object which will contain all the things in the simulation
float grassdensity = 5;  // amount of grass in the simulation

void setup () {
  size(1280, 720, P3D);
  background(bgColor - 10);
  center = new PVector(width / 2, height / 2);
  
  biosphere = new Biosphere();
  // move setup to Biosphere?
  // generate grass
  for ( int i = 0; i < width; i+=5 ) {
    for ( int j = 0; j <height; j +=5 ) {
      if ( random(100) < grassdensity ) {
        Thing c = new Grass(new PVector(i, j), biosphere);
        biosphere.addCreature(c);
      }
    }
  }
  // add Grazers
  for ( int i = 0; i < 500; i++ ) {
    Thing c = new Grazer(new PVector(random(width), random(height)), biosphere);
    biosphere.addCreature(c);
  }
  // add Chasers
  for ( int i = 0; i < 50; i++ ) {
    Thing c = new Chaser(new PVector(random(width), random(height)), biosphere);
    biosphere.addCreature(c);
  }
}

void draw () {
  background(bgColor);
  biosphere.run();
}
