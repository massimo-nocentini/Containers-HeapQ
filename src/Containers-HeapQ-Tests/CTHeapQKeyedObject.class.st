Class {
	#name : #CTHeapQKeyedObject,
	#superclass : #Object,
	#instVars : [
		'key'
	],
	#category : #'Containers-HeapQ-Tests'
}

{ #category : #mn }
CTHeapQKeyedObject >> < aCTHeapQKeyedObject [

	"Quick and dirty without further dispatchings."

	^ self key < aCTHeapQKeyedObject key
]

{ #category : #mn }
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

	key := anObject
]
