Extension { #name : #CTHeapQ }

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> asShapeBubblesHorizontalTree [

	^ (Heap asShapeBubblesHorizontalTree: self heap indexes: indexes)
		  model: self;
		  yourself
]

{ #category : #'*Containers-HeapQ-Visualizations' }
CTHeapQ >> asShapeValuesHorizontalTree [

	^ (Heap asShapeValuesHorizontalTree: self heap indexes: indexes)
		  model: self;
		  yourself
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
