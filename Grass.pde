/**
 * Grass.java
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instrucor: David Brown
 * 
 * Prototype plant
 * plants are Creatures, but cannot move on their own
 *   and do not make decisions
 * 
 */
 
class Grass extends Creature {
  /* Default creature type parameters */
  final static float LIFESPAN = 1200; 
  
  /* plants are Creatures, but cannot move on their own
   *   and do not make decisions
   */
  
  /* Constructors */
  Grass ( PVector location, ArrayList<Thing> ecosystem ) {
    super(location, ecosystem);
    lifespan = LIFESPAN;
  }
  
  /* return string containing class name */
  String getType () { return "Grass"; }
  
  // plants don't move, so only need to update() and display()
  void run () {
    //update();
    display();
  }
  
  void update () {
    // do check for lifetime eventually
  }
  
  void display () {
    noStroke();
    fill(50, 175, 50, 175);
    rect(location.x, location.y, 5, 5);
  }
  
}
