Class {
	#name : #CTHeapQ,
	#superclass : #Object,
	#instVars : [
		'heap',
		'indexes'
	],
	#category : #'Containers-HeapQ'
}

{ #category : #requirements }
CTHeapQ class >> empty [

	^ self heapify: {  }
]

{ #category : #'as yet unclassified' }
CTHeapQ class >> heapify: aCollection [

	^ self basicNew
		  heap: aCollection asOrderedCollection;
		  initialize;
		  heapify;
		  yourself
]

{ #category : #initialization }
CTHeapQ >> at: pos put: anObject [

	heap at: pos put: anObject.
	indexes at: anObject put: pos.
	^ anObject
]

{ #category : #accessing }
CTHeapQ >> heap: aCollection [

	heap := OrderedCollection ofSize: aCollection size.
	indexes := Dictionary new.
	aCollection withIndexDo: [ :each :i | self at: i put: each ]
]

{ #category : #'as yet unclassified' }
CTHeapQ >> heapify [

	heap size >> 1 to: 1 by: -1 do: [ :i | self siftUp: i ]
]

{ #category : #testing }
CTHeapQ >> isEmpty [

	^ heap isEmpty
]

{ #category : #removing }
CTHeapQ >> pop [

	| lastelt |
	lastelt := heap removeLast.
	^ heap
		  ifEmpty: [ 
			  indexes removeKey: lastelt.
			  lastelt ]
		  ifNotEmpty: [ 
			  | returnElt |
			  returnElt := heap first.
			  indexes removeKey: returnElt.
			  self
				  at: 1 put: lastelt;
				  siftUp: 1.
			  returnElt ]
]

{ #category : #initialization }
CTHeapQ >> push: anObject [

	heap add: anObject.
	self siftDown: 1 to: heap size.
	^ anObject
]

{ #category : #initialization }
CTHeapQ >> siftDown: startPos to: toPos [

	| newitem pos continue |
	pos := toPos.
	newitem := heap at: pos.
	continue := true.
	[ continue and: [ startPos < pos ] ] whileTrue: [ 
		| parentPos parent |
		parentPos := pos >> 1.
		parent := heap at: parentPos.
		newitem < parent
			ifTrue: [ 
				self at: pos put: parent.
				pos := parentPos ]
			ifFalse: [ continue := false ] ].
	self at: pos put: newitem
]

{ #category : #removing }
CTHeapQ >> siftUp: startpos [

	| pos endpos newitem childpos |
	newitem := heap at: startpos.
	pos := startpos.
	endpos := heap size.
	[ (childpos := pos << 1) <= endpos ] whileTrue: [ 
		| rightpos elt |
		rightpos := childpos bitOr: 1.

		(rightpos <= endpos and: [ 
			 (heap at: childpos) >= (heap at: rightpos) ]) ifTrue: [ 
			childpos := rightpos ].

		elt := heap at: childpos.
		self at: pos put: elt.
		pos := childpos ].

	self
		at: pos put: newitem;
		siftDown: startpos to: pos
]
