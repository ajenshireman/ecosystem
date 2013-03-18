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
                      LIFESPAN = 300;
   
   /* Override default values */            
   String[] prey = { "Grass" }; // this needs to be static but Processing won't allow it
   String[] predators = { "Chaser" };
   
   /* Constructors */
   Grazer ( PVector location, Biosphere biosphere ) {
     super(location, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, biosphere);
     lifespan = LIFESPAN;
   }
   
   /* return string containing class name */
  String getType () { return "Grazer"; }
  
  void update () {
    // Aquire list of Things in range
    search();
    // Sort found things into predators and prey
    sortThings(predators, prey);
    // For now, run directly away from the first predator seen.
    // TODO -- use all predators seen to calulate best path to take to avoid all of them
    fleeing = false;
    if ( predatorsFound.size() > 0 ) {
      /*hasTarget = false;
      fleeing = true;
      enemy = (Creature)predatorsFound.get(0);*/
      flee();
    }
    
    // Runaway
    // TODO -- merge with previous method and andd some erratic movement to try to shake pursuers
    /*if ( fleeing ) {
      PVector desired = PVector.sub(location, enemy.location);  // run away. need to add some random motion, weaving from side to side etc
      //if ( random(1) < 0.5 ) {
        desired.x += random(-maxSpeed, maxSpeed);
        desired.y += random(-maxSpeed, maxSpeed);
      //}
      steer(desired);
    }*/
    // Not runnig from predators, so try to find food
    else {
      if ( !hasTarget && preyFound.size() > 0 ) {
        aquireTarget();
      }  
      if ( hasTarget ) {
        seek();
      }
      else {
        wander(0.3);
      }
    }
  }
  
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
   
 }
