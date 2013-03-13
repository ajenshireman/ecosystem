/**
 * Chaser.pde
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instructor: David Brown
 * 
 * Prototype predator class
 * Chases and eats Grazers
 * 
 */

class Chaser extends Creature {
   /* Default values */
   final static float MAXSPEED = 1,
                      MAXFORCE = 0.01,
                      SIGHTRANGE = 50,
                      AWARENESS = 50,
                      HIDING = 50,
                      LIFESPAN = 300;
   
   /* Override default values */            
   String[] prey = { "Grazer" }; // this needs to be static but Processing won't allow it
   
   Chaser ( PVector location, ArrayList<Thing> ecosystem ) {
     super(location, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, ecosystem);
     lifespan = LIFESPAN;
     size = 4;
   }
   
   /* return string containing class name */
  String getType () { return "Chaser"; }
  
  void update () {
    search(prey);
    if ( hasTarget ) {
      pursue();
    }
    else {
      wander(0.3);
    }
    
  }
  
  void display () {
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    endShape(CLOSE);
    popMatrix();
    
    
    /* debuging */
    // highlight target
    if ( hasTarget && debug ) {
      noStroke();
      fill(255, 0, 0);
      ellipse(target.location.x, target.location.y, 9, 9);
    }
    // show sight range
    if ( debug ) {
      showSightRange();
    }
  }
   
  void checkEdge () {
    soft();
    wrap();
    //bounce4();
  }
  
}
