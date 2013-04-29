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
        hiding,     // chance the Creature will not be noticed by other things
        wanderRate; // how much the Creature changes its directino while wandering
  
  float lifespan,   // average lifespan for Creature type
        lifetime,   // how long this creature has lived      
        hunger;     // how hungry the Creatur is. if this exceeds the limit for too long, the Creature will starve to death
  int meals;        // how many times the Creature has eaten.
  //boolean alive;    // is the creature alive?
  
  Neuron brain;     // the creature's "brain"
  
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
  float decay;        // Timer to remove the Creature from the ecosystem after it dies
  float mutationRate;
  
  float wanderTheta, change;
  final PVector nullVector = new PVector();
  
  boolean debug = false;
  
  /* Constructors */
  // only use for subclass
  Creature ( PVector location, Biosphere biosphere ) {
    super(location, 1, 1, biosphere);
    this.biosphere = biosphere;
    this.mutationRate = biosphere.mutationRate;
    this.brain = new Neuron(3);
    this.lifetime = 0;
    this.hunger =0;
    this.meals = 0;
    this.alive = true;
    this.remove = false;
    this.decay = 0;
    setArrays();
  }
  
  Creature ( PVector location,
             float size, 
             float maxSpeed, 
             float maxForce, 
             float sightRange, 
             float awareness, 
             float hiding, 
             float wanderRate, 
             Biosphere biosphere 
           ) {
    this(location, biosphere);
    this.size = size;
    this.maxSpeed = maxSpeed;
    this.maxForce = maxForce;
    this.sightRange = sightRange;
    this.awareness = awareness;
    this.hiding = hiding;
    this.wanderRate = wanderRate;
    this.wanderTheta = 0;
  }
  
  Creature ( PVector location,
             float size, 
             float maxSpeed, 
             float maxForce, 
             float sightRange, 
             float awareness, 
             float hiding, 
             float wanderRate, 
             float[] weights, 
             Biosphere biosphere 
           ) {
  this(location, size, maxSpeed, maxForce, sightRange, awareness, hiding, wanderRate, biosphere);
  this.brain = new Neuron(weights);
  }
  
  /* set predator and prey lists to the correct ones for the creature's type */
  final void setPlaceInFoodChain ( String[] predators, String[] prey ) {
    this.predators = predators;
    this.prey = prey;
  }
  
  // initialize arrays that will be used for seaching the creature's suroundings
  final void setArrays () {
    thingsFound = new ArrayList<Thing>();
    thingDistance = new FloatArray();
    predatorsFound = new ArrayList<Thing>();
    predatorDistance = new FloatArray();
    preyFound = new ArrayList<Thing>();
    preyDistance = new FloatArray();
  }
  
  // return string containing class name
  String getType () { return "Creature"; }
  
  void update () {
    // If target is dead, do calculations to see if it should be removed
    // Always skip the rest of update() since the creature is dead and therefore can't do anything
    if ( !alive ) {
      if ( decay < -1 ) remove = true;
      velocity.mult(0);
      decay--;
      return;
    }
    
    // Aquire list of Things in range
    search();
    // Sort found things into predators and prey
    sortThings(predators, prey);
    
    // aquire a target and calulate movement vectors
    aquireTarget();
    PVector escape = flee();
    PVector attack = chase();
    PVector wander = wander(wanderRate);
    PVector[] vectors = {escape, attack, wander};
    PVector desired = brain.feedForward(vectors);
    steer(desired);
    
    if ( meals >= 5 ) {
      reproduce();
    }
    if ( hunger > 1200 ) {
      die();
    }
    if ( oldAge(lifetime, lifespan) ) {
      //println(getType() + " lived " + lifetime + " cycles out of " + lifespan);
      die();
    }
    
    // lived another cycle
    hunger++;
    //println(hunger);
    lifetime++;
  }
  
  /*
  // Template for what each creature should do. Left in for reference
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
  */
  
  // this is a pretty pointless method. the descion for what action to take has just been cut out of update()
  PVector decide ( PVector[] inputs ) {
    // If predators are found, run away from them
    if ( fleeing ) {
      return inputs[0];
    }
    // Not runnig from predators, so try to find food 
    // if prey is found, go after it
    else  if ( hasTarget ) {
      return inputs[1];
    }
    // No food found, wander around a bit
    else {
      return inputs[2];
    }
  }
  
  /**
   * calculate whether the creature dies of old age.
   * 
   */
  boolean oldAge ( float life, float span ) {
    // set upper and lower bounds for lifetime
    // bounds were chosen so a creature always has a chance to die and a chance to not die
    if ( life >= span ) life = span - 1;
    else if ( life < span / 2 ) life = span / 2;
    
    // calculate chance to die
    // young creatures should have a very small chance to die, and that chance should increase
    //   dramatically as the creature nears lifespan
    float p = pow(life / (2 * span), 8.5); // if span is not doubled, the average lifetime if only half of lifespan
    
    // don't fear the reaper
    float r = random(1);
    if ( r < p ) return true;  // a time to die
    else return false;  // a time to live
  }
  
  // Creature dies
  void die () {
    target = null;
    hasTarget = false;
    fleeing = false;
    alive = false;
    decay = 1000;
  }
  
  // Creature is eaten
  void eaten () {
    die();
    remove = true;
  }
  
  // Creature eats another
  void eat (Creature target) {
    if ( target.remove() ) {
      hasTarget = false;
      target = null;
      return;
    }
    else {
      target.eaten();
      hunger /= 2; // Add method for getting how "filling" the meal was
      if ( hunger < 0 ) hunger = 0;
      meals++;
      hasTarget = false;
    }
  }
  
  // Reproduction
  void reproduce () {
    // Must be overridden
  }
  
  // How to go towards the target.
  // Override for individual behavior.
  PVector chase () {
    return nullVector;
  }
  
  // move towards a static target. slow down on approach
  PVector seek () {
    if ( target == null ) return nullVector;
    //if (hasTarget ) {
      if ( target.remove() ) {
        hasTarget = false;
        return nullVector;
      }
      PVector desired = PVector.sub(target.location, location);
      float mag = desired.mag();
      if ( mag < 1 ) {
        eat(target);
        return nullVector;
      }
      desired.normalize();
      desired.mult(map(mag, 0, sightRange, 0, maxSpeed));
      //steer(desired);
      return desired;
    //}
  }
  
  // chasing a moving target. use traget's velocity to predict where it's going and try to intercept
  PVector pursue () {
    if ( target == null ) return nullVector;
    if ( target.remove() ) {
      hasTarget = false;
      return nullVector;
    }
    PVector tloc = PVector.add(target.location, target.velocity);
    PVector desired = PVector.sub(tloc, location);
    float mag = desired.mag();
    if ( mag < 1 ) {
      eat(target);
      return nullVector;
    }
    desired.normalize();
    desired.mult(maxSpeed);
    //steer(desired);
    return desired;
    /* debug
    stroke(0);
    line(tloc.x + 10, tloc.y, tloc.x - 10, tloc.y);
    line(tloc.x, tloc.y + 10, tloc.x, tloc.y - 10);*/
  }
  
  // look at all predators and calculate the best escape vector
  PVector flee () {
    fleeing = false;
    if ( predatorsFound.size() <= 0 ) return nullVector;
    hasTarget = false;
    fleeing = true;
    PVector escape = new PVector();
    for ( Thing c : predatorsFound ) {
      PVector eDist = PVector.sub(location, c.location);
      /* debug
      stroke(0);
      line(location.x, location.y, c.location.x, c.location.y);*/
      escape.add(eDist);
    }
    escape.x /= predatorsFound.size();
    escape.y /= predatorsFound.size();
    //steer(escape);
    escape.normalize();
    escape.mult(maxSpeed);
    return escape;
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
    //desired.normalize();
    //desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  /*
  void accelerate () {
    super.accelerate();
    if ( !fleeing && !hasTarget ) {
      velocity.limit(maxSpeed/2);
    }
  }
  */
  // "wandering" motion. taken from The Nature of Code
  PVector wander ( float change ) {
    float D = sightRange * 1.5;
    float R = sightRange * 0.5;
    //change = 0.1;
    wanderTheta += random(-change, change);
    PVector cLoc = velocity.get();
    cLoc.normalize();
    cLoc.mult(D);
    cLoc.add(location);
    float heading = velocity.heading2D();
    PVector offset = new PVector(R * cos(wanderTheta + heading), R * sin(wanderTheta + heading));
    PVector desired = PVector.add(cLoc, offset);
    //steer(PVector.sub(desired, location));
    /* debug *
    stroke(0);
    noFill();
    ellipseMode(CENTER);
    ellipse(cLoc.x, cLoc.y, R*2, R*2);
    ellipse(desired.x, desired.y, 4, 4);
    line(location.x, location.y, cLoc.x, cLoc.y);
    line(cLoc.x, cLoc.y, desired.x, desired.y);
    //textSize(16);
    //fill(0);
    //text("X: " + location.x + " Y: " + location.y, 100, 50);*/
    desired = PVector.sub(desired, location);
    desired.normalize();
    desired.mult(maxSpeed / 2);
    return desired;
  }
  
  // "wandering" motion. taken from The Nature of Code
  void evade ( float evadeChance ) {
    float D = sightRange * 1.5;
    float R = sightRange * 0.5;
    //change = 0.1;
    float evadeTheta = random( (PI / 4), ( (7 * PI) / 4 ));
    evadeTheta += PI;
    PVector cLoc = velocity.get();
    cLoc.normalize();
    cLoc.mult(D);
    cLoc.add(location);
    float heading = velocity.heading2D();
    PVector offset = new PVector(R * cos(evadeTheta + heading), R * sin(evadeTheta + heading));
    PVector desired = PVector.add(cLoc, offset);
    steer(PVector.sub(desired, location));
    /* debug *
    stroke(0);
    noFill();
    ellipseMode(CENTER);
    ellipse(cLoc.x, cLoc.y, R*2, R*2);
    ellipse(desired.x, desired.y, 4, 4);
    line(location.x, location.y, cLoc.x, cLoc.y);
    line(cLoc.x, cLoc.y, desired.x, desired.y);
    //textSize(16);
    //fill(0);
    //text("X: " + location.x + " Y: " + location.y, 100, 50);*/
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
  
  // behavior for selecting a target.
  // Override for individual behavior
  void aquireTarget () {
    
  }
  
  // Aquire closest prey creature
  void aquireNearestTarget () {
    if ( preyFound.size() <= 0 ) {
      hasTarget = false;
      target = null;
      return;
    }
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
  
  
  /* Determine location of child */
  PVector getSpawnLocation( PVector parentLocation, float spawnDistance ) {
    // spawn at a random angle
    float spawnAngle = random(TWO_PI);
    float spawnDistanceX = cos(spawnAngle) * spawnDistance;
    float spawnDistanceY = sin(spawnAngle) * spawnDistance;
    // convert to global co-ords
    float spawnX = location.x + spawnDistanceX;
    float spawnY = location.y + spawnDistanceY;
    // final location of child
    PVector spawnLoc = new PVector(spawnX, spawnY);
    
    return spawnLoc;
  }
  
  /* Randomize the child's attributes */
  float randomAtt ( float parentAtt, float mutationRate ) {
    if ( random(1) < mutationRate ) {
      return random(parentAtt * 0.5, parentAtt * 1.5);
    }
    else {
      return parentAtt;
    }
  }
  
  float[] randomAtt ( float[] attributes, float mutationRate ) {
    for ( int i = 0; i > attributes.length; i++ ) {
      if ( random(1) < mutationRate ) {
        attributes[i] = random(1);
      }
    }
    return attributes;
  }
}
