/**
 * Thing.pde
 * Author: Ajen Shireman
 * Course: CSIT 1520
 * Instrucor: David Brown
 * 
 * Base class for things in the Ecosystem
 *   contains common properties and methods
 *
 */
 
class Thing {
  float G = 0.667428;    // gravitatinal constant. move to Biosphere
  
  /* Properties */
  PVector location,      // location of the Thing
          velocity,      // velocity of the Thing
          acceleration;  // acceleration to be applied to the Thing
  float mass,            // mass of the Thing
        size,            // size of the Thing
        maxSpeed;        // the Thing's maximum speed ( velocity.mag() )
  boolean alive;         // is the creature alive?
  
  Biosphere biosphere;     // the Biosphere or 'world' the Thing exists in
  
  /* variables for perlin noise. */
  float tx, ty, tz;
  float xIncr, yIncr, zIncr;
  
  /* Constructors */
  Thing ( PVector location, float mass, float size ) {
    this.location = location.get();
    velocity = new PVector();
    acceleration = new PVector();
    this.mass = mass;
    this.size = size;
    alive = true;
    init();
  }
  
  /* Initializes values for use with Perlin noise */
  final void init () {
    tx = random(100000);
    ty = random(100000);
    tx = random(100000);
    xIncr = 0.01;
    yIncr = 0.01;
    zIncr = 0.01;
  }
  
  /* return string containing class name */
  String getType () { return "Thing"; }
  
  /* return true is the Thing is dead */
  boolean isDead () { return !alive; }
  
  /* Main methods, subclasses should override for custom behavior */
  // primary mehtod
  void run () {
    update();      // the Thing's behavior. forces acting on the thing are calculated here
    checkEdge();   // behavior at the edge
    accelerate();  // apply all forces to the Thing
    move();        // update location
    display();     // draw the Thing
  }
  
  // do the stuff the Thing should do
  void update () {
    
  }
  
  // draw the Thing. default is a circle
  void display () {
    stroke(0);
    fill(175);
    ellipse(location.x, location.y, size, size);
  }
  
  // changes the Thing's position
  void move () {
    location.add(velocity);
  }
  
  // add a force to the Thing
  void applyForce ( PVector force ) {
    if ( mass == 0 ) { acceleration.add(force); return; }  // in case of no-mass particle, jusy apply the force
    PVector f = PVector.div(force, mass);  // F = m * a, so adjust the strength of the force according to the Thing's mass
    acceleration.add(f);
  }
  
  // apply all forces to the Thing
  void accelerate () {
    velocity.add(acceleration);  // apply forces
    velocity.limit(maxSpeed);    // limit speed
    acceleration.mult(0);        // reset acceleration to 0
  }
  
  /* Edge behavior */
  void checkEdge () {
    
  }
  
  // bounce at all edges
  void bounce4 () {
    if ( location.x > width - (size/2) ) {
      velocity.x *= -1;
      location.x = width - (size/2);
    }
    else if ( location.x < (size/2) ) {
      velocity.x *= -1;
      location.x = (size/2);
    }
    if ( location.y > height - (size/2) ) {
      velocity.y *= -1;
      location.y = height - (size/2);
    }  
    else if ( location.y < (size/2) ) {
      velocity.y *= -1;
      location.y = (size/2);
    }
  }
  
  // bounce at bottom and sides
  void bounce3 () {
    if ( location.x > width - (size/2) ) {
      velocity.x *= -1;
      location.x = width - (size/2);
    }
    else if ( location.x < (size/2) ) {
      velocity.x *= -1;
      location.x = (size/2);
    }
    if ( location.y > height - (size/2) ) {
      velocity.y *= -1;
      location.y = height - (size/2);
    }
  }
  
  // bounce at bottom
  void bounce1 () {
    if ( location.y > height - (size/2) ) {
      velocity.y *= -1;
      location.y = height - (size/2);
    }
  }
  
  // bounce at sides
  void bounceSides () {
    if ( location.x > width - (size/2) ) {
      velocity.x *= -1;
      location.x = width - (size/2);
    }
    else if ( location.x < (size/2) ) {
      velocity.x *= -1;
      location.x = (size/2);
    }
  }
  
  // bounce at top and bottom
  void bounceTB () {
    if ( location.y > height - (size/2) ) {
      velocity.y *= -1;
      location.y = height - (size/2);
    }  
    else if ( location.y < (size/2) ) {
      velocity.y *= -1;
      location.y = (size/2);
    }
  }
  
  // wrap to other edge
  void wrap () {
    if ( location.x > width ) {
      location.x = 0;
    }
    else if ( location.x < 0 ) {
      location.x = width;
    }
    if ( location.y > height ) {
      location.y = 0;
    }  
    else if ( location.y < 0 ) {
      location.y = height;
    }
  }
  
  // wrap at left and right sides
  void wrapSides () {
    if ( location.x > width ) {
      location.x = 0;
    }
    else if ( location.x < 0 ) {
      location.x = width;
    }
  }
  
  // wrap at top and bottom
  void wrapTB () {
    if ( location.y > height ) {
      location.y = 0;
    }
    else if ( location.y < 0 ) {
      location.y = height;
    }
  }
  
  /* Gravitational Attraction */
  PVector gravitate ( Thing thing ) {
    PVector force = PVector.sub(location, thing.location);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    force.normalize();
    float strength = ( G * mass * thing.mass ) / ( distance * distance );
    force.mult(strength);
    return force;
  }
  
  /* Movement */
  // accelerate in a random direction
  void walkRandom () {
    float dx = map(noise(tx), 0, 1, -0.1, 0.1);
    float dy = map(noise(ty), 0, 1, -0.1, 0.1);
    applyForce(new PVector(dx, dy));
    tx += xIncr;
    ty += yIncr;
  }
  
  // accelerate in a random direction in three dimensions
  void walkRandom3D () {
    float dx = map(noise(tx), 0, 1, -0.1, 0.1);
    float dy = map(noise(ty), 0, 1, -0.1, 0.1);
    float dz = map(noise(ty), 0, 1, -0.1, 0.1);
    applyForce(new PVector(dx, dy, dz));
    tx += xIncr;
    ty += yIncr;
    tz += zIncr;
  }
  
  
  
}
