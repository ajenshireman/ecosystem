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
  void search ( String[] predators,               // List of valid predators
                ArrayList<Thing> predatorsFound,  // predators found.
                FloatArray predatorDistance,      // predator distance
                String[] prey,                    // List of valid prey
                ArrayList<Thing> preyFound,       // prey found
                FloatArray preyDistance,          // prey distance
                float maxDistance,                // maximum distance to look for things
                PVector location                  // location to center search around
              ) {
    
    // search the ecosystem
    Iterator<Thing> things = ecosystem.iterator();
    while ( things.hasNext() ) {
      Thing t = things.next();
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
    
    /* output predatrs to array
    List<Thing> list = new ArrayList<Thing>();
    for ( Thing t : predatorList ) {
      list.add(t);
    }
    predators = list.toArray(new Thing[list.size()]);
    predatorDistance = predatorDist.toArray();
    // output prey to array
    list = new ArrayList<Thing>();
    for ( Thing t : preyList ) {
      list.add(t);
    }
    prey = list.toArray(new Thing[list.size()]);
    preyDistance = preyDist.toArray();*/
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
