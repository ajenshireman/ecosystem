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
   /* Default creature type parameters */
   final static float MAXSPEED = 1,
                      MAXFORCE = 0.01,
                      SIGHTRANGE = 50,
                      AWARENESS = 50,
                      HIDING = 50, 
                      WANDER = 0.3, 
                      LIFESPAN = 300;
   
   /* Lists of predators and prey for this Creature type */
   String[] predators = { "" };   // this needs to be static but java won't allow it in an inner class.
   String[] prey = { "Grazer" };  // this needs to be static but java won't allow it in an inner class.
   
   /* Constructors */
   Chaser ( PVector location, Biosphere biosphere ) {
     super(location, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, WANDER, biosphere);
     setPlaceInFoodChain(predators, prey);
     lifespan = LIFESPAN;
     size = 4;
   }
   
   /* return string containing class name */
  String getType () { return "Chaser"; }
  /*
  void update () {
    // Aquire list of Things in range
    search();
    // Sort found things into predators and prey
    sortThings(predators, prey);
     
    fleeing = false;
    // If predators are found, run away from them
    if ( predatorsFound.size() > 0 ) {
      flee();
    }
    // Not runnig from predators, so try to find food
    else {
      if ( preyFound.size() > 0 ) {
        aquireTarget();
      }
      else {
        hasTarget = false;
      }
      
      if ( hasTarget ) {
        chase();
      }
      // No food found, wander around a bit
      else {
        wander(0.3);
      }
    }
  }
  */
  /*
  void update () {
    search();
    sortThings(predators, prey);
    
    if ( preyFound.size() > 0 ) {
      aquireTarget();
    }
    else {
     hasTarget = false;
    }
    
    if ( hasTarget ) {
      chase();
    }
    else {
      wander(0.3);
    }
    
  }
  */
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
    //soft();
    wrap();
    //bounce4();
  }
  
  void aquireTarget () {
    aquireNearestTarget();
  }
  
  void chase () {
    pursue();
  }
  
}
