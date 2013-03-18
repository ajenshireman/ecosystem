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
   
   /* Override default values */            
   String[] myprey = { "Grass" }; // this needs to be static but Processing won't allow it
   String[] mypredators = { "Chaser" };
   
   /* Constructors */
   Grazer ( PVector location, Biosphere biosphere ) {
     super(location, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, WANDER, biosphere);
     lifespan = LIFESPAN;
     predators = mypredators;
     prey = myprey;
   }
   
   /* return string containing class name */
  String getType () { return "Grazer"; }
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
