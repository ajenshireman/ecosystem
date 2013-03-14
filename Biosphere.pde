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
  
<<<<<<< HEAD
=======
  // tell the calling Creature what's around it.
  void search ( PVector location,             // locatin to center search around
                float maxDistance,            // maximum distance form location to look for Things
                ArrayList<Thing> thingsFound, // List of Things found
                FloatArray thingDistance      // List of distances of Things found from location
              ) {
      
    // search the ecosystem
    for ( Thing t : ecosystem ) {
      // get the distance from the thing to the location
      PVector dir = PVector.sub(t.location, location);
      float mag = dir.mag();
      // if the thing is within range, add the thing and its distance to the lists
      if ( mag <= maxDistance ) {
        thingsFound.add(t);
        thingDistance.add(mag);
      }
    }
  }
  
<<<<<<< HEAD
  // sort things
  void search ( PVector location,                 // location to center search around
                float maxDistance,                // maximum distance to look for things
                String[] predators,               // List of valid predators
                String[] prey,                    // List of valid prey
                ArrayList<Thing> predatorsFound,  // predators found
                ArrayList<Thing> preyFound,       // prey found
                FloatArray predatorDistance,      // predator distance
                FloatArray preyDistance           // prey distance
              ) {
    for ( Thing t : ecosystem ) {
      String type = t.getType();
      boolean isPredator = false;
      // check for predator
      for ( int i = 0; i < predators.length; i++ ) {
        if ( type.equals(predators[i]) ) {
          PVector dir = PVector.sub(t.location, location);
          float mag = dir.mag();
          if ( mag <= maxDistance ) {
            predatorsFound.add(t);
            predatorDistance.add(mag);
            isPredator = true;
          }
        }
      }
      if ( isPredator ) break;
      for ( int i = 0; i < prey.length; i++ ) {
        if ( type.equals(prey[i]) ) {
          PVector dir = PVector.sub(t.location, location);
          float mag = dir.mag();
          if ( mag <= maxDistance ) {
            preyFound.add(t);
            preyDistance.add(mag);
          }
        }
      }
    }
  }
  
  // Return the closest valid Thing to the given location, within the give maximum distance
  Thing findNearest ( PVector location, float maxDistance, String[] valid ) {
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
  
>>>>>>> origin/search_in_biosphere
=======
>>>>>>> origin/search_in_biosphere
}
