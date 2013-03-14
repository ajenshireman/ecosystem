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
  
}
