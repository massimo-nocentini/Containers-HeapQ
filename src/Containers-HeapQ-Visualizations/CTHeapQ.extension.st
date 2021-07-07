Extension { #name : #CTHeapQ }

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> asShapeBubblesHorizontalTree [

	"This visualization represents the current Heap object as a binary tree,
	 where a solid edge denotes the child at position 2n and a dashed edge
	 denotes a child at position 2n + 1, where n is the position of the parent.
	
	 Nodes are represented as circles such that their areas equals their #value."

	| shapes |
	shapes := self heap collect: [ :each | 
		          RSCircle new
			          model: each;
			          radius: (each / Float pi) sqrt;
			          color: Color white;
			          withBorder;
			          addInteraction: RSPopup new ].

	^ self asShapeHorizontalTreeWithShapes: shapes
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> asShapeHorizontalTreeWithShapes: aCollectionOfShapes [

	| edgeBuilder evenEdges oddEdges edges |
	edgeBuilder := RSEdgeBuilder horizontalBezier
		               withHorizontalAttachPoint;
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

	RSHorizontalGaussianJitterVanDerPloegTreeLayout
		on: aCollectionOfShapes
		edges: edges.

	^ RSComposite new
		  shapes: aCollectionOfShapes , edges;
		  yourself
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> asShapeValuesHorizontalTree [

	"This visualization represents the current Heap object as a binary tree,
	 where a solid edge denotes the child at position 2n and a dashed edge
	 denotes a child at position 2n + 1, where n is the position of the parent.
	
	 Nodes are represented as labels with their corresponding positions as subscripts."

	| shapes |
	shapes := self heap collect: [ :each | 
		          | valueShape indexShape i |
		          valueShape := RSLabel new
			                        model: each;
			                        fontName: 'Source Code Pro';
			                        yourself.
		          i := indexes at: each.
		          indexShape := RSLabel new
			                        model: i;
			                        text: '(' , i asString , ')';
			                        fontSize: valueShape fontSize >> 1;
			                        yourself.
		          RSLocation new bottom right
			          offset: indexShape textWidth + Float goldenRatio @ 0;
			          move: indexShape on: valueShape.
		          RSComposite new
			          model: each;
			          addShape: valueShape;
			          addShape: indexShape;
			          adjustToChildren;
			          padding: Float goldenRatio double;
			          yourself ].

	^ self asShapeHorizontalTreeWithShapes: shapes
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasBubblesTree [

	<inspectorPresentationOrder: 90 title: 'Bubbles tree'>
	^ RSCanvas new
		  @ RSCanvasController;
		  add: self asShapeBubblesHorizontalTree;
		  inspectorCanvas
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasBubblesTreeContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasValuesTree [

	<inspectorPresentationOrder: 90 title: 'Values tree'>
	^ RSCanvas new
		  @ RSCanvasController;
		  add: self asShapeValuesHorizontalTree;
		  inspectorCanvas
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasValuesTreeContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> instVarsNamesOrderedCollection [

	^ super instVarsNamesOrderedCollection , { 
		  (#asShapeValuesHorizontalTree asSlotDescriptor
			   inline: true;
			   quote).
		  (#asShapeBubblesHorizontalTree asSlotDescriptor
			   inline: true;
			   quote) }
]
