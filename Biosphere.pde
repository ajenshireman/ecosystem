/**
 * Biophere.pde
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instrucor: David Brown
 * 
 * Creates and maintains an ArrayList 
 *   containing all the objects in the simulation
 * 
 * 
 */

import java.util.ArrayList; 
import java.util.List;
import java.util.Iterator;

class Biosphere {
  ArrayList<Thing> ecosystem;  // ArrayList that will contain all objects in the ecosystem
  
  /* Constructors */
  Biosphere () {
    ecosystem = new ArrayList<Thing>();
  }
  
  // add creature to the ecosystem
  void addCreature ( Thing thing ) {
    ecosystem.add(thing);
  }
  
  // process each Thing and make it do whatever it wants to do
  void run() {
    Iterator<Thing> creatures = ecosystem.iterator();
    
    while ( creatures.hasNext() ) {
      Thing creature = creatures.next();  // get next Thing in the ecosystem
      if ( creature.isDead() ) {          // if the Thing is dead, remove it from the ecosystem
        creatures.remove();
      }
      else creature.run();                // do that thing you do
    }
  }
  
  // tell the calling Creature what's around it.
  void search ( String[] validPredators,   // List of valid predators
                Thing[] predators,         // predators found.
                float[] predatorDistance,  // predator distance
                String[] validPrey,        // List of valid prey
                Thing[] prey,              // prey found
                float[] preyDistance,      // prey distance
                float maxDistance,         // maximum distance to look for things
                PVector location           // location to center search around
              ) {
    ArrayList<Thing> predatorList = new ArrayList<Thing>();  // ArrayList for storing predators
    //ArrayList<float> predatorDist = new ArrayList<float>();  // ArrayList for storing predator distances
    ArrayList<Thing> preyList = new ArrayList<Thing>();      // ArrayList for storing prey
    //ArrayList<float> preyDist = new ArrayList<float>();      // ArrayList for storing prey distances
    
    // search the ecosystem
    Iterator<Thing> things = ecosystem.iterator();
    while ( things.hasNext() ) {
      Thing t = things.next();
      String type = t.getType();
      boolean isPredator = false;
      // check for predator
      for ( int i = 0; i < validPredators.length; i++ ) {
        if ( type.equals(validPredators[i]) ) {
          PVector dir = PVector.sub(t.location, location);
          float mag = dir.mag();
          if ( mag <= maxDistance ) {
            predatorList.add(t);
            isPredator = true;
          }
        }
      }
      if ( isPredator ) break;
      for ( int i = 0; i < validPrey.length; i++ ) {
        if ( type.equals(validPrey[i]) ) {
          PVector dir = PVector.sub(t.location, location);
          float mag = dir.mag();
          if ( mag <= maxDistance ) {
            preyList.add(t);
          }
        }
      }
    }
    
    // output predatrs to array
    List<Thing> list = new ArrayList<Thing>();
    for ( Thing t : predatorList ) {
      list.add(t);
    }
    predators = list.toArray(new Thing[list.size()]);
    //predatorDistance = predatorDist.toArray();
    // output prey to array
    list = new ArrayList<Thing>();
    for ( Thing t : preyList ) {
      list.add(t);
    }
    prey = list.toArray(new Thing[list.size()]);
    //preyDistance = preyDist.toArray();
  }
  
  Thing findNearest ( String[] valid, PVector location, float maxDistance ) {
    Thing target = null;
    Iterator<Thing> creatures = ecosystem.iterator();
    float max = maxDistance;
    while ( creatures.hasNext() ) {
      Thing c = creatures.next();
      String ctype = c.getType();
      for ( int i = 0; i < valid.length; i++ ) {
        if ( ctype.equals(valid[i]) ) {
          PVector dir = PVector.sub(c.location, location);
          float mag = dir.mag();
          if ( mag <= maxDistance && mag < max ) { // add awareness check here?
            max = mag;
            target = c;
          }
        }
      }
    }
    return target;
  }
  
}
