"
I am an helper that holds a key object that could change while contained in a CTHeapQ.

If the key changes then I notify my dependents (aka the heap container) that I am changed.
"
Class {
	#name : #CTHeapQKeyedObject,
	#superclass : #Object,
	#instVars : [
		'key'
	],
	#category : #'Containers-HeapQ-Tests'
}

{ #category : #comparing }
CTHeapQKeyedObject >> < aCTHeapQKeyedObject [

	"Quick and dirty without further dispatchings."

	^ self key < aCTHeapQKeyedObject key
]

{ #category : #comparing }
CTHeapQKeyedObject >> <= aCTHeapQKeyedObject [

	"Quick and dirty without further dispatchings."

	^ self < aCTHeapQKeyedObject or: [ 
		  self key = aCTHeapQKeyedObject key ]
]

{ #category : #accessing }
CTHeapQKeyedObject >> key [

	^ key
]

{ #category : #accessing }
CTHeapQKeyedObject >> key: anObject [

	key := anObject.

	self changed
]
