"
I am a binary heap and mimic the one found in the Python standard library.
! Heapify
Consider the following shuffled array of 63 elements:
${example:name=CTHeapQTest>>#test100ShuffledInterval|previewShow=#gtBoxesFor:|noCode=}$
that can be heapified as ${example:name=CTHeapQTest>>#test100ShuffledIntervalRawHeapSlot|previewShow=#gtBoxesFor:|noCode=}$
and visualized as a tree
${example:name=CTHeapQTest>>#test100ShuffledIntervalHeapified|noCode=|previewShow=#gtLiveFor:|previewHeight=800}$
and the same heap can also be visualized as ""bubbles"" in order to emphasize the __heap invariant__:
${example:name=CTHeapQTest>>#test100ShuffledIntervalHeapified|noCode=|previewShow=#gtBubblesLiveFor:|previewHeight=800}$


"
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

{ #category : #initialization }
CTHeapQ >> defaultSize [

	^ 16
]

{ #category : #accessing }
CTHeapQ >> heap [

	^ heap copyFrom: 1 to: tally
]

{ #category : #accessing }
CTHeapQ >> heapify: aCollection [

	| size |
	size := aCollection size.
	size := size isZero
		        ifTrue: [ self defaultSize ]
		        ifFalse: [ size ].
	size := 2 raisedTo: (size log: 2) ceiling.
	tally := aCollection size.
	indexes := IdentityDictionary new.
	heap := Array ofSize: size.
	aCollection withIndexDo: [ :each :i | self at: i put: each ].
	tally + 1 >> 1 to: 1 by: -1 do: [ :i | self siftUp: i ]
]

{ #category : #initialization }
CTHeapQ >> initialize [

	tally := 0.
	heap := Array new: self defaultSize.
	indexes := IdentityDictionary new
]

{ #category : #accessing }
CTHeapQ >> inspectorCanvasBubblesTree [

	<inspectorPresentationOrder: 90 title: 'Bubbles tree'>
	| shapes aCanvas |
	shapes := self heap collect: [ :each | 
		          RSEllipse new
			          model: each;
			          size: each asPoint;
			          color: Color white;
			          withBorder;
			          addInteraction: RSPopup new ].

	aCanvas := self
		           onCanvas: RSCanvas new @ RSCanvasController
		           drawHorizontalTreeWithShapes: shapes.

	^ aCanvas inspectorCanvas
]

{ #category : #accessing }
CTHeapQ >> inspectorCanvasBubblesTreeContext: aContext [

	aContext withoutEvaluator
]

{ #category : #accessing }
CTHeapQ >> inspectorCanvasValuesTree [

	<inspectorPresentationOrder: 90 title: 'Values tree'>
	| shapes aCanvas |
	shapes := self heap collect: [ :each | 
		          | value index i |
		          value := RSLabel new
			                   model: each;
			                   yourself.
		          i := indexes at: each.
		          index := RSLabel new
			                   model: i;
			                   text: '(' , i asString , ')';
			                   fontSize: value fontSize >> 1;
			                   yourself.
		          RSLocation new bottom right
			          offset: index textWidth + 1 @ 0;
			          move: index on: value.
		          RSComposite new
			          model: each;
			          addShape: value;
			          addShape: index;
			          adjustToChildren;
			          padding: 2;
			          yourself ].

	aCanvas := self
		           onCanvas: RSCanvas new @ RSCanvasController
		           drawHorizontalTreeWithShapes: shapes.

	^ aCanvas inspectorCanvas
]

{ #category : #accessing }
CTHeapQ >> inspectorCanvasValuesTreeContext: aContext [

	aContext withoutEvaluator
]

{ #category : #testing }
CTHeapQ >> isEmpty [

	^ tally = 0
]

{ #category : #accessing }
CTHeapQ >> onCanvas: aCanvas drawHorizontalTreeWithShapes: aCollectionOfShapes [

	| edgeBuilder evenEdges oddEdges edges |
	edgeBuilder := RSEdgeBuilder horizontalBezier
		               withBorderAttachPoint;
		               shapes: aCollectionOfShapes.

	evenEdges := edgeBuilder connectTo: [ :each | 
		             | index |
		             index := (indexes at: each) << 1.
		             index <= tally ifTrue: [ heap at: index ] ].

	oddEdges := edgeBuilder dashed connectTo: [ :each | 
		            | index |
		            index := (indexes at: each) << 1 bitOr: 1.
		            index <= tally ifTrue: [ heap at: index ] ].

	edges := evenEdges , oddEdges.

	RSHorizontalTreeLayout on: aCollectionOfShapes edges: edges.

	^ aCanvas
		  addAll: aCollectionOfShapes;
		  addAll: edges;
		  yourself
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
					  indexes
						  removeKey: lastelt;
						  itself: lastelt ]
				  ifFalse: [ 
					  | returnElt |
					  returnElt := heap first.
					  indexes removeKey: returnElt.
					  self
						  at: 1 put: lastelt;
						  siftUp: 1;
						  itself: returnElt ] ]
]

{ #category : #enumerating }
CTHeapQ >> popPush: anObject [

	^ self isEmpty
		  ifTrue: [ anObject ]
		  ifFalse: [ 
			  heap first < anObject
				  ifTrue: [ self replace: anObject ]
				  ifFalse: [ anObject ] ]
]

{ #category : #initialization }
CTHeapQ >> push: anObject [

	tally = heap size ifTrue: [ heap := heap grownBy: tally ].
	tally := tally + 1.
	^ self
		  at: tally put: anObject;
		  siftDown: 1 to: tally;
		  itself: anObject
]

{ #category : #enumerating }
CTHeapQ >> replace: anObject [

	| elt |
	elt := heap first.
	indexes removeKey: elt.
	^ self
		  at: 1 put: anObject;
		  siftUp: 1;
		  itself: elt
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

		(rightpos <= tally and: [ (heap at: rightpos) < (heap at: childpos) ]) 
			ifTrue: [ childpos := rightpos ].

		elt := heap at: childpos.
		self at: pos put: elt.
		pos := childpos ].

	self
		at: pos put: newitem;
		siftDown: startpos to: pos
]

{ #category : #enumerating }
CTHeapQ >> update: anObject [

	| parentIndex index |
	index := indexes at: anObject.
	parentIndex := index >> 1.
	(parentIndex > 0 and: [ anObject < (heap at: parentIndex) ])
		ifTrue: [ self siftDown: 1 to: index ]
		ifFalse: [ self siftUp: index ].
	^ anObject
]
