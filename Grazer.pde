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
   Grazer ( PVector location, ArrayList<Thing> ecosystem ) {
     super(location, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, ecosystem);
     lifespan = LIFESPAN;
   }
   
   /* return string containing class name */
  String getType () { return "Grazer"; }
  
  void update () {
    // search for predators
    Iterator<Thing> creatures = ecosystem.iterator();
    fleeing = false;
    while ( creatures.hasNext() ) {
        Thing c = creatures.next();
        String ctype = c.getType();
        for ( int i = 0; i < predators.length; i++ ) {
          if ( ctype.equals(predators[i]) ) {
            enemy = c;
          }
          if ( enemy != null ) {
            PVector desired = PVector.sub(location, enemy.location);
            if ( desired.mag() <= sightRange ) {
              fleeing = true;
              hasTarget = false;
            }
          }
        }
        
    }
    // end predator search
    
    if ( fleeing ) {
      PVector desired = PVector.sub(location, enemy.location);  // run away. need to add some random motion, weaving from side to side etc
      //if ( random(1) < 0.5 ) {
        desired.x += random(-maxSpeed, maxSpeed);
        desired.y += random(-maxSpeed, maxSpeed);
      //}
      steer(desired);
    }
    else {
      /*if ( !hasTarget ) {
        target = (Creature)biosphere.findNearest(prey, location, sightRange);
        if ( target != null ) {
          hasTarget = true;
        }
      }*/
      search(prey);
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
