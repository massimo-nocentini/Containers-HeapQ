Extension { #name : #CTHeapQ }

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> gtBubblesLiveFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Bubbles';
		painting: [ :m | 
			| nodes |
			nodes := heap copyFrom: 1 to: tally.
			m nodes
				shape: [ :x | 
					BlElement new
						geometry: BlEllipseGeometry new;
						size: x @ x;
						border: (BlBorder paint: Color black);
						yourself ];
				with: nodes.
			m edges
				connectToAll: [ :each | 
					| index |
					index := indexes at: each.
					Array
						streamContents: [ :aStream | 
							| i j |
							i := index << 1.
							j := i bitOr: 1.
							i <= tally
								ifTrue: [ aStream nextPut: (nodes at: i) ].
							j <= tally
								ifTrue: [ aStream nextPut: (nodes at: j) ] ] ].
			m layout custom: GtGraphHorizontalTreeLayout new ]
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> gtLiveFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Heap';
		painting: [ :m | 
			| nodes |
			nodes := heap copyFrom: 1 to: tally.
			m nodes
				shape: [ :x | 
					BlTextElement new
						text: x gtDisplayString asRopedText;
						constraintsDo: [ :constraints | constraints padding: (BlInsets all: 5) ] ];
				with: nodes.
			m edges
				connectToAll: [ :each | 
					| index |
					index := indexes at: each.
					Array
						streamContents: [ :aStream | 
							| i j |
							i := index << 1.
							j := i bitOr: 1.
							i <= tally
								ifTrue: [ aStream nextPut: (nodes at: i) ].
							j <= tally
								ifTrue: [ aStream nextPut: (nodes at: j) ] ] ].
			m layout
				horizontalTree;
				yourself ]
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> gtTreeFor: aView [
	<gtView>
	^ aView tree
		title: 'Tree';
		items: [ {heap first} ];
		children: [ :each | 
			| index |
			index := indexes at: each.
			Array
				streamContents: [ :aStream | 
					| i j |
					i := index << 1.
					j := i bitOr: 1.
					i <= tally
						ifTrue: [ aStream nextPut: (heap at: i) ].
					j <= tally
						ifTrue: [ aStream nextPut: (heap at: j) ] ] ];
		expandAll
]
