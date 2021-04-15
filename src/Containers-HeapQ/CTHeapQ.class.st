Class {
	#name : #CTHeapQ,
	#superclass : #Object,
	#instVars : [
		'heap',
		'indexes',
		'tally'
	],
	#category : #'Containers-HeapQ'
}

{ #category : #initialization }
CTHeapQ >> at: pos put: anObject [

	heap at: pos put: anObject.
	indexes at: anObject put: pos.
	^ anObject
]

{ #category : #accessing }
CTHeapQ >> heapify: aCollection [

	tally := aCollection size.
	heap := Array
		        new: (aCollection log: 2) ceiling
		        streamContents: [ :aStream | 
		        aStream nextPutAll: aCollection ].
	indexes := Dictionary new.
	aCollection withIndexDo: [ :each :i | self at: i put: each ].
	heap size >> 1 to: 1 by: -1 do: [ :i | self siftUp: i ]
]

{ #category : #initialization }
CTHeapQ >> initialize [

	tally := 0.
	heap := Array new: 1.
	indexes := Dictionary new
]

{ #category : #testing }
CTHeapQ >> isEmpty [

	^ tally = 0
]

{ #category : #removing }
CTHeapQ >> pop [

	^ self isEmpty
		  ifTrue: [ CollectionIsEmpty signal ]
		  ifFalse: [ 
			  | lastelt |
			  lastelt := heap at: tally.
			  tally := tally - 1.
			  self isEmpty
				  ifTrue: [ 
					  indexes removeKey: lastelt.
					  lastelt ]
				  ifFalse: [ 
					  | returnElt |
					  returnElt := heap first.
					  indexes removeKey: returnElt.
					  self
						  at: 1 put: lastelt;
						  siftUp: 1.
					  returnElt ] ]
]

{ #category : #initialization }
CTHeapQ >> push: anObject [

	tally = heap size ifTrue: [ heap := heap grownBy: tally ].
	tally := tally + 1.
	heap at: tally put: anObject.
	self siftDown: 1 to: tally.
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

	| pos newitem childpos |
	newitem := heap at: startpos.
	pos := startpos.
	[ (childpos := pos << 1) <= tally ] whileTrue: [ 
		| rightpos elt |
		rightpos := childpos bitOr: 1.

		(rightpos <= tally and: [ 
			 (heap at: childpos) >= (heap at: rightpos) ]) ifTrue: [ 
			childpos := rightpos ].

		elt := heap at: childpos.
		self at: pos put: elt.
		pos := childpos ].

	self
		at: pos put: newitem;
		siftDown: startpos to: pos
]
