class Neuron {
  private float[] weights;
  
  /* Constructors */
  // Constructs a new neuron for n inputs with random initial weights
  Neuron ( int n ) {
    weights = new float[n];
    for ( int i = 0; i < weights.length; i++ ) {
      weights[i] = random(1);
    }
  }
  
  // Constructs a new neuron with given weights
  Neuron ( float[] weights ) {
    this.weights = new float[weights.length];
    for ( int i = 0; i < this.weights.length; i++ ) {
      this.weights[i] = weights[i];
    }
  }
  
  /* Methods for getting information about the Neuron */
  // Returns the weights as an array of float
  float[] getWeights () {
    float[] weights = new float[this.weights.length];
    for ( int i = 0; i < weights.length; i++ ) {
      weights[i] = this.weights[i];
    }
    return weights;
  }
  
  /* Apply weights to an input set and return the result */
  PVector feedForward ( PVector[] inputs ) {
    PVector desired = new PVector();
    for ( int i = 0; i < weights.length; i++ ) {
      inputs[i].mult(weights[i]);
      desired.add(inputs[i]);
    }
    return desired;
  }
}
