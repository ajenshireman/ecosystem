/**
 * FloatArray.pde
 * Author: Ajen Shireman
 * 
 * expandable array of float
 */
package expandableArray;

public class FloatArray {
    private float array[];
    
    /* Constructors */
    // Create a new FloatArray with an initial size of 0
    public FloatArray () {
        array = new float[0];
    }
    
    // Create a new FloatArray with the specified initial size
    public FloatArray ( int size ) {
        array = new float[size];
    }
    
    // Create a new FloatArray from an existing array
    public FloatArray ( float[] array ) {
        this(array.length);
        
        for ( int i = 0; i < array.length; i++ ) {
            this.array[i] = array[i];
        }
    }
    
    /* Methods for getting information about the FloatArray */
    // return the number of elements in the floatArray
    public int size () {
        return array.length;
    }
    
    // return the element at the specified index
    public float get ( int index ) {
        return array[index];
    }
    
    // return a copy of the floatArray
    public FloatArray copy () {
        FloatArray newArray = new FloatArray(array);
        return newArray;
    }
    
    // return a copy of the FloatArray's array
    public float[] toArray () {
        float newArray[] = new float[array.length];

        for ( int i = 0; i < array.length; i++ ) {
            newArray[i] = array[i];
        }
        
        return newArray;
    }
    
    /* Methods for manipulating the FloatArray */
    // replace the value at the specified index with the specified value
    public void set ( int index, float value ) {
        array[index] = value;
    }
    
    // append a new element to the end of the FloatArray
    public void add ( float newElement ) {
        add(newElement, array.length);
    }
    
    // insert a new element into the FloatArray at the specified position
    public void add ( float newElement, int index ) {
        float[] e = { newElement };
        add(e, index);
    }
    
    // append a new array of elements to the end of the floatArray
    public void add ( float[] newElements) {
        add(newElements, array.length);
    }
    
    // insert a new array of elements into the floatArray at the specified position
    public void add ( float[] newElements, int index ) {
        float newArray[] = new float[array.length + newElements.length];

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
    
    // remove the element at the specified index
    public void remove ( int index ) {
        remove(index, index);
    }
    
    // remove all elements between two specified indices, inclusive
    public void remove ( int index1, int index2 ) {
        int elementsToRemove = index2 - index1 + 1;
        float newArray[] = new float[array.length - elementsToRemove];
        
        for ( int i = 0; i < index1; i++ ) {
                newArray[i] = array[i];
        }
        
        for ( int i = index1; i < array.length - elementsToRemove; i++ ) {
            newArray[i] = array[i + elementsToRemove];
        }
        
        array = newArray;
    }
    
    // remove all elements from the FloatArray
    public void clear () {
        remove(0, array.length - 1);
    }
}

