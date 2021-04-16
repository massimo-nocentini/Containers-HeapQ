"
A CTHeapQTest is a test class for testing the behavior of CTHeapQ
"
Class {
	#name : #CTHeapQTest,
	#superclass : #TestCase,
	#category : #'Containers-HeapQ-Tests'
}

{ #category : #'as yet unclassified' }
CTHeapQTest >> invariant: heapq [

	| heap indexes tally |
	tally := heapq instVarNamed: #tally.
	heap := heapq instVarNamed: #heap.
	indexes := heapq instVarNamed: #indexes.

	2 to: tally do: [ :i | 
	self assert: (heap at: i >> 1) <= (heap at: i) ].

	indexes keysAndValuesDo: [ :elt :pos | 
		self assert: (heap at: pos) equals: elt ]
]

{ #category : #tests }
CTHeapQTest >> testHeapify [

	| random |
	random := Random seed: 11.

	(0 to: 29) , { 20000 } do: [ :size | 
		| data heapq |
		data := (1 to: size) collect: [ :i | random next ].
		heapq := CTHeapQ new
			         heapify: data;
			         yourself.
		self invariant: heapq ]
]

{ #category : #tests }
CTHeapQTest >> testPushPop [

	| random heapq data resultStream |
	resultStream := Array new writeStream.
	random := Random seed: 11.
	heapq := CTHeapQ new.

	self invariant: heapq.

	data := (1 to: 256) collect: [ :i | 
		        | r |
		        r := heapq push: random next.
		        self invariant: heapq.
		        r ].

	[ heapq isEmpty ] whileFalse: [ 
		resultStream nextPut: heapq pop.
		self invariant: heapq ].

	self assert: resultStream contents equals: data sorted
]
