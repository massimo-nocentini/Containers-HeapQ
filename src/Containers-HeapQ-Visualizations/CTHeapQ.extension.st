Extension { #name : #CTHeapQ }

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasBubblesTree [

	<inspectorPresentationOrder: 90 title: 'Bubbles tree'>
	| shapes aCanvas |
	shapes := self heap collect: [ :each | 
		          RSCircle new
			          model: each;
			          radius: (each / Float pi) sqrt;
			          color: Color white;
			          withBorder;
			          addInteraction: RSPopup new ].

	aCanvas := self
		           onCanvas: RSCanvas new @ RSCanvasController
		           drawHorizontalTreeWithShapes: shapes.

	^ aCanvas inspectorCanvas
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasBubblesTreeContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasValuesTree [

	<inspectorPresentationOrder: 90 title: 'Values tree'>
	| shapes aCanvas |
	shapes := self heap collect: [ :each | 
		          | valueShape indexShape i |
		          valueShape := RSLabel new
			                        model: each;
			                        yourself.
		          i := indexes at: each.
		          indexShape := RSLabel new
			                        model: i;
			                        text: '(' , i asString , ')';
			                        fontSize: valueShape fontSize >> 1;
			                        yourself.
		          RSLocation new bottom right
			          offset: indexShape textWidth + 2 @ 0;
			          move: indexShape on: valueShape.
		          RSComposite new
			          model: each;
			          addShape: valueShape;
			          addShape: indexShape;
			          adjustToChildren;
			          padding: 2;
			          yourself ].

	aCanvas := self
		           onCanvas: RSCanvas new @ RSCanvasController
		           drawHorizontalTreeWithShapes: shapes.

	^ aCanvas inspectorCanvas
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> inspectorCanvasValuesTreeContext: aContext [

	aContext withoutEvaluator
]

{ #category : #'*Containers-HeapQ-Visualizations' }
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

	RSHorizontalGaussianJitterVanDerPloegTreeLayout
		on: aCollectionOfShapes
		edges: edges.

	^ aCanvas
		  addAll: aCollectionOfShapes;
		  addAll: edges;
		  yourself
]
