/**
 * Creature.pde
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instrucor: Davis Brown
 * 
 * Autonomous agents in the sumlation
 *   Creatures can make their own decisions about 
 *     how to resond to outside stimuli
 * 
 */
 
import java.util.ArrayList; 
import java.util.Iterator;

class Creature extends Thing {
  //float maxSpeed, // maximum speed, declared in Thing.pde
  float maxForce,   // maximum acceleration, i.e. turning speed
        sightRange, // maximum range the Creature can detect thigs at
        awareness,  // chance the Creature will notice things in range
        hiding;     // chance the Creature will not be noticed by other things
  
  float lifespan,   // average lifespan for Creature type
        lifetime,   // how long this creature has lived      
        hunger;     // how hungry the Creatur is. if this exceeds the limit for too long, the Creature will starve to death
  int meals;        // how many times the Creature has eaten.
  //boolean alive;    // is the creature alive?
  
  ArrayList<Thing> ecosystem; // the biosphere the Creature is a part of
  
  String[] predators,  // which types of creatures eat the Creature
           prey;       // which types of creature this Creature eats
           
  // Arrays for searching the Biosphere
  ArrayList<Thing> thingsFound;
  FloatArray thingDistance;
  // Arrays for sorting found Things
  ArrayList<Thing> predatorsFound;
  FloatArray predatorDistance;
  ArrayList<Thing> preyFound;
  FloatArray preyDistance;
  
  boolean hasTarget;  // whether the creature is trying to get somewhere   
  Creature target;    // the creature this creature is heading towards
  
  boolean fleeing;    // whether the creature is running form another
  Thing enemy;        // creature this creature is running from
  
  float wanderTheta;
  
  boolean debug = false;
  
  /* Constructors */
  // only use for subclass
<<<<<<< HEAD
<<<<<<< HEAD
  Creature ( PVector location, ArrayList<Thing> ecosystem ) {
    super(location, 1, 1);
    this.ecosystem = ecosystem;
    alive = true;
=======
  
=======
>>>>>>> origin/search_in_biosphere
  Creature ( PVector location, Biosphere biosphere ) {
    super(location, 1, 1, biosphere);
    this.biosphere = biosphere;
    alive = true;
    setArrays();
  }
  
  Creature ( PVector location, 
             float maxSpeed, 
             float maxForce, 
             float sightRange, 
             float awareness, 
             float hiding, 
             Biosphere biosphere 
           ) {
    this(location, biosphere);
    this.maxSpeed = maxSpeed;
    this.maxForce = maxForce;
    this.sightRange = sightRange;
    this.awareness = awareness;
    this.hiding = hiding;
    wanderTheta = 0;
    alive = true;
  }
  
  // initialize arrays that will be used for seaching the creature's suroundings
  final void setArrays () {
    thingsFound = new ArrayList<Thing>();
    thingDistance = new FloatArray();
    predatorsFound = new ArrayList<Thing>();
    predatorDistance = new FloatArray();
    preyFound = new ArrayList<Thing>();
    preyDistance = new FloatArray();
>>>>>>> origin/search_in_biosphere
  }
  
  // return string containing class name
  String getType () { return "Creature"; }
  
  void update () {
    // get nearby objects
    
    // use awareness to see if Creature notices them
    
    // run from predators
    
    // go towards prey
    
    // if at prey, eat it
    
    // reproduce if requirements are met
    
    // if life is up, die
    
    // if starved to death, die
    
    // lived another cycle
    
  }
  
  // move towards a static target. slow down on approach
  void seek () {
    if (hasTarget ) {
      if ( target.isDead() ) {
        hasTarget = false;
        return;
      }
      PVector desired = PVector.sub(target.location, location);
      float mag = desired.mag();
      if ( mag < 1 ) { 
        target.alive = false; // changing target's status directly: need to invoke a method for this. set lifespan to private for all Creatures?
        hasTarget = false;
        return;
      }
      steer(desired, mag);
    }
  }
  
  // chasing a moving target. use traget's velocity to predict where it's going and try to intercept
  void pursue () {
    PVector tloc = PVector.add(target.location, target.velocity);
    PVector desired = PVector.sub(tloc, location);
    float mag = desired.mag();
    if ( mag < 1 ) { 
        target.alive = false; // changing target's status directly: need to invoke a method for this. set lifespan to private for all Creatures?
        hasTarget = false;
        return;
      }
    else steer(desired);
  }
  
  // apply a force to turn in the desired direction, limit the maximum steering force to mag.
  void steer ( PVector desired, float mag ) {
    desired.normalize();
    desired.mult(map(mag, 0, sightRange, 0, maxSpeed)); // non-moving target. creature will stop and eat. preadtors will need a different method; they will want to move as fast as possible while in pursuit.
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  
  // apply a force to turn in the desired direction, do not limit the force
  void steer ( PVector desired ) {
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  
  // "wandering" motion. taken from The Nature of Code
  void wander ( float change ) {
    float D = sightRange * 1.5;
    float R = sightRange / 2;
    //change = 0.1;
    wanderTheta += random(-change, change);
    PVector cLoc = velocity.get();
    cLoc.normalize();
    cLoc.mult(D);
    cLoc.add(location);
    float heading = velocity.heading2D();
    PVector offset = new PVector(R * cos(wanderTheta + heading), R * sin(wanderTheta + heading));
    PVector desired = PVector.add(cLoc, offset);
    steer(PVector.sub(desired, location));
    /* debug 
    stroke(0);
    noFill();
    ellipseMode(CENTER);
    ellipse(cLoc.x, cLoc.y, R*2, R*2);
    ellipse(desired.x, desired.y, 4, 4);
    line(location.x, location.y, cLoc.x, cLoc.y);
    line(cLoc.x, cLoc.y, desired.x, desired.y);
    textSize(16);
    fill(0);
    text("X: " + location.x + " Y: " + location.y, 100, 50);*/
  }
  
  // veer away from the edge rather than bouncing off it.
  // not working properly
  void soft () {
    float d = sightRange;
    
    PVector desired = null;
    float edgeDistance = 0;
    
    if (location.x < d) {
      desired = new PVector(maxSpeed, velocity.y);
      edgeDistance = location.x;
    } 
    else if (location.x > width -d) {
      desired = new PVector(-maxSpeed, velocity.y);
      edgeDistance = width - location.x;
    } 

    if (location.y < d) {
      desired = new PVector(velocity.x, maxSpeed);
      edgeDistance = location.y;
    } 
    else if (location.y > height-d) {
      desired = new PVector(velocity.x, -maxSpeed);
      edgeDistance = height - location.y;
    } 

    if (desired != null) {
      desired.normalize();
      desired.mult(abs(d - edgeDistance) * abs(d - edgeDistance));
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      applyForce(steer);
      /* debug
      textSize(16);
      fill(0);
      text("EdgeDistance: " + abs(d - edgeDistance), 100, 30);*/
    }
  }
  
  // examine surroundings, determine locations of prey. 
  /**** need to write a second method to return list of predators for flee calculations 
   *     perhaps move to Biosphere class?
   */
  void search (String[] valid) {
    Iterator<Thing> creatures = ecosystem.iterator();
    hasTarget = false;
    float max = sightRange;
    while ( creatures.hasNext() ) {
      Thing c = creatures.next();
      String ctype = c.getType();
      for ( int i = 0; i < valid.length; i++ ) {
        if ( ctype.equals(valid[i]) ) {
          PVector dir = PVector.sub(c.location, location);
          float mag = dir.mag();
          if ( mag <= sightRange && mag < max ) { // add awareness check here?
            max = mag;
            target = (Creature)c;
            hasTarget = true;
          }
        }
      }
    }  
  }
  
  /* Methods for examining the surronding environment */
  // Aquire list of Things in the area
  void search () {
    clearSearchLists();
    biosphere.search(location, sightRange, thingsFound, thingDistance);
  }
  
  // Sort found things 
  void sortThings (String[] predators, String[] prey) {
    clearSortLists();
    
    for ( int i = 0; i < thingsFound.size(); i++ ) {
      Thing t = thingsFound.get(i);
      String type = t.getType();
      boolean isPredator = false;
      for ( String s : predators ) {
        if ( s.equals(type) ) {
          isPredator = true;
          predatorsFound.add(t);
          predatorDistance.add(thingDistance.get(i));
          break;
        }
      }
      if ( !isPredator ) {
        for ( String s : prey ) {
          if ( s.equals(type) ) {
            preyFound.add(t);
            preyDistance.add(thingDistance.get(i));
            break;
          }
        }
      }
    }
  }
  
  // clear lists of found things
  void clearSearchLists () {
    thingsFound.clear();
    thingDistance.clear();
  }
  
  // clear sorted lists
  void clearSortLists () {
    predatorsFound.clear();
    predatorDistance.clear();
    preyFound.clear();
    preyDistance.clear();
  }
  
  void aquireTarget () {
    float max = sightRange;
    int index = 0;
    for ( int i = index; i < preyDistance.size(); i++ ) {
      if ( preyDistance.get(i) < max ) {
        max = preyDistance.get(i);
        index = i;
      }
    }
    target = (Creature)preyFound.get(index);
    hasTarget = true;
  }
  
  /* debug methods */
  
  // show circle indicating the Creature's sight range
  void showSightRange () {
    stroke(0);
    fill(0, 0);
    ellipseMode(RADIUS);
    ellipse(location.x, location.y, sightRange, sightRange);
    ellipseMode(CENTER);
  }
  
}
