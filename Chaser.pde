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
  final static float SIZE = 4,
                     MAXSPEED = 1,
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
  /*
  Chaser ( PVector location, Biosphere biosphere ) {
    super(location, SIZE,  MAXSPEED, MAXFORCE, SIGHTRANGE, AWARENESS, HIDING, WANDER, biosphere);
    setPlaceInFoodChain(predators, prey);
    lifespan = LIFESPAN;
  }
  */
  Chaser ( PVector location, Biosphere biosphere ) {
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
  
  Chaser ( PVector location, 
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
   
  /* return string containing class name */
  String getType () { return "Chaser"; }
  
  void die () {
    super.die();
    // additional death stuff
  }
  
  void reproduce () {
    PVector spawnLoc = getSpawnLocation(location, size);
    
    // randomize child attributes
    Thing child = new Chaser( spawnLoc, 
                              size, 
                              randomAtt(maxSpeed, mutationRate), 
                              randomAtt(maxForce, mutationRate), 
                              randomAtt(sightRange, mutationRate), 
                              randomAtt(awareness, mutationRate),
                              randomAtt(hiding, mutationRate),
                              randomAtt(wanderRate, mutationRate),
                              biosphere);
    biosphere.addCreature(child);
    
    meals = 0;
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
    //soft();
    wrap();
    //bounce4();
  }
  
  void aquireTarget () {
    aquireNearestTarget();
  }
  
  PVector chase () {
    return pursue();
  }
  
}
