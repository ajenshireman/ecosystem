/**
 * Graser.pde
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instrucor: David Brown
 * 
 * Prototype herbivore
 * 
 * 
 */
 
 class Grazer extends Creature {
   /* Default creature type parameters */
   final static float MAXSPEED = 1,
                      MAXFORCE = 0.005,
                      SIGHTRANGE = 50,
                      AWARENESS = 50,
                      HIDING = 50,
                      WANDER = 0.3,
                      LIFESPAN = 300;
   
   /* Lists of predators and prey for this Creature type */            
   String[] prey = { "Grass" };        // this needs to be static but java won't allow it in an inner class.
   String[] predators = { "Chaser" };  // this needs to be static but java won't allow it in an inner class.
   
   /* Constructors */
   Grazer ( PVector location, Biosphere biosphere ) {
     super(location, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, WANDER, biosphere);
     setPlaceInFoodChain(predators, prey);
     lifespan = LIFESPAN;
   }
   
  /* return string containing class name */
  String getType () { return "Grazer"; }
  
  void display () {
    stroke(0);
    fill(175);
    ellipse(location.x, location.y, 10, 10);
    
    /* debuging */
    // highlight target
    if ( hasTarget && debug ) {
      noStroke();
      fill(0, 0, 255);
      rect(target.location.x, target.location.y, 5, 5);
    }
    // show sight range
    if ( debug ) {
      showSightRange();
    }
  }
   
  void checkEdge () {
    bounce4();
  }
  
  void aquireTarget () {
    if ( !hasTarget ) {
      aquireNearestTarget();
    }
  }
  
  void chase () {
    seek();
  }
  
 }
