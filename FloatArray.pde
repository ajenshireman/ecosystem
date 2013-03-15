/**
 * FloatArray.pde
 * Author: Ajen Shireman
 * 
 * expandable array of float
 */

public class FloatArray {
    private float[] array;
    
    /* Constructors */
    // Contsructs a new FloatArray with an initial size of 0
    public FloatArray () {
        array = new float[0];
    }
    
    // Contsructs a new FloatArray with the specified initial size
    public FloatArray ( int initialSize ) {
        array = new float[initialSize];
    }
    
    // Contsructs a new FloatArray from an existing array
    public FloatArray ( float[] array ) {
        this(array.length);
        
        for ( int i = 0; i < array.length; i++ ) {
            this.array[i] = array[i];
        }
    }
    
    /* Methods for getting information about the FloatArray */
    // Returns the number of elements in the FloatArray
    public int size () {
        return array.length;
    }
    
    // Returns the element at the specified index
    public float get ( int index ) {
        return array[index];
    }
    
    // Returns a copy of the FloatArray
    public FloatArray copy () {
        FloatArray newArray = new FloatArray(array);
        return newArray;
    }
    
    // Returns a copy of the FloatArray's array
    public float[] toArray () {
        float[] newArray = new float[array.length];

        for ( int i = 0; i < array.length; i++ ) {
            newArray[i] = array[i];
        }
        
        return newArray;
    }
    
    // Checks if two FloatArrays are equal
    // Returns true if both FLoatArrays are the same size and if all elements 
    //   are the same and in the same place, else returns false
    public boolean equals ( FloatArray fArray ) {
        if ( array.length != fArray.size() ) {
            return false;
        }
        else {
            for ( int i = 0; i < this.size(); i++ ) {
                if ( array[i] != fArray.get(i) ) {
                    return false;
                }
            }
            return true;
        }
    }
    
    /* Methods for manipulating the FloatArray */
    // Replaces the value at the specified index with the specified value
    public void set ( int index, float value ) {
        array[index] = value;
    }
    
    // Appends a new element to the end of the FloatArray
    public void add ( float newElement ) {
        add(newElement, array.length);
    }
    
    // Inserts a new element into the FloatArray at the specified position
    public void add ( float newElement, int index ) {
        float[] e = { newElement };
        add(e, index);
    }
    
    // Appends a new array of elements to the end of the FloatArray
    public void add ( float[] newElements) {
        add(newElements, array.length);
    }
    
    // Inserts a new array of elements into the FloatArray at the specified position
    public void add ( float[] newElements, int index ) {
        float[] newArray = new float[array.length + newElements.length];

        for ( int i = 0; i < index; i++ ) {
            newArray[i] = array[i];
        }
        
        for ( int i = 0; i < newElements.length; i++ ) {
            newArray[i + index] = newElements[i];
        }
        
        for ( int i = index; i < array.length; i++ ) {
            newArray[i + newElements.length] = array[i];
        }
        
        array = newArray;
    }
    
    // Removes the element at the specified index
    public void remove ( int index ) {
        remove(index, index);
    }
    
    // Removes all elements between two specified indices, inclusive
    public void remove ( int index1, int index2 ) {
        int elementsToRemove = index2 - index1 + 1;
        float[] newArray = new float[array.length - elementsToRemove];
        
        for ( int i = 0; i < index1; i++ ) {
                newArray[i] = array[i];
        }
        
        for ( int i = index1; i < array.length - elementsToRemove; i++ ) {
            newArray[i] = array[i + elementsToRemove];
        }
        
        array = newArray;
    }
    
    // Removes all elements from the FloatArray
    public void clear () {
        remove(0, array.length - 1);
    }
    
    // Increases the FloatArray's size to the specified size if needed
    public void ensureCapacity ( int minSize ) {
        if ( array.length >= minSize ) return;
        else {
            float[] newArray = new float[minSize];

            for ( int i = 0; i < array.length; i++ ) {
                newArray[i] = array[i];
            }
            
            array = newArray;
        }
    }
}

