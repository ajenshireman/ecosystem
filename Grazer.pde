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
  final static float SIZE = 10,
                     MAXSPEED = 1,
                     MAXFORCE = 0.005,
                     SIGHTRANGE = 50,
                     AWARENESS = 50,
                     HIDING = 50,
                     WANDER = 0.3,
                     LIFESPAN = 3000;
  
  /* Lists of predators and prey for this Creature type */            
  String[] prey = { "Grass" };        // this needs to be static but java won't allow it in an inner class.
  String[] predators = { "Chaser" };  // this needs to be static but java won't allow it in an inner class.
   
  /* Constructors */
  /*
  Grazer ( PVector location, Biosphere biosphere ) {
    super(location, SIZE, MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, WANDER, biosphere);
    setPlaceInFoodChain(predators, prey);
    lifespan = LIFESPAN;
  }
  */
  Grazer ( PVector location, Biosphere biosphere ) {
    super(location, 
          SIZE, 
          random(MAXSPEED * 0.5, MAXSPEED * 1.5), 
          random(MAXFORCE * 0.5, MAXFORCE * 1.5), 
          random(SIGHTRANGE * 0.5, SIGHTRANGE * 1.5), 
          random(AWARENESS * 0.5, AWARENESS * 1.5), 
          random(HIDING * 0.5, HIDING * 1.5), 
          random(WANDER * 0.5, WANDER * 1.5), 
          biosphere);
    setPlaceInFoodChain(predators, prey);
    lifespan = LIFESPAN;
  }
  
  Grazer ( PVector location, 
           float size,
           float maxSpeed, 
           float maxForce, 
           float sightRange, 
           float awareness, 
           float hiding, 
           float wanderRate, 
           Biosphere biosphere 
           ) {
    super(location, size, maxSpeed, maxForce, sightRange, awareness, hiding, wanderRate, biosphere);
    setPlaceInFoodChain(predators, prey);
    lifespan = LIFESPAN;
  }
  
  void die () {
    super.die();
    // additional death stuff
  }
  
  void reproduce () {
    PVector spawnLoc = getSpawnLocation(location, size);
    
    // randomize child attributes
    
    float mutationRate = 1;
    Thing child = new Grazer( spawnLoc, 
                              size, 
                              randomAtt(maxSpeed, MAXSPEED, mutationRate), 
                              randomAtt(maxForce, MAXFORCE, mutationRate), 
                              randomAtt(sightRange, SIGHTRANGE, mutationRate), 
                              randomAtt(awareness, AWARENESS, mutationRate),
                              randomAtt(hiding, HIDING, mutationRate),
                              randomAtt(wanderRate, WANDER, mutationRate),
                              biosphere);
    biosphere.addCreature(child);
    
    meals = 0;
  }
  
  /* return string containing class name */
  String getType () { return "Grazer"; }
  
  void display () {
    stroke(0);
    fill(175);
    ellipse(location.x, location.y, size, size);
    
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
