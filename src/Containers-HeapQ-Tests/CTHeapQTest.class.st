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

	| heap indexes |
	heap := heapq instVarNamed: #heap.
	indexes := heapq instVarNamed: #indexes.

	2 to: heap size do: [ :i | 
	self assert: (heap at: i >> 1) <= (heap at: i) ].

	indexes keysAndValuesDo: [ :elt :pos | 
		self assert: (heap at: pos) equals: elt ]
]

{ #category : #tests }
CTHeapQTest >> testPushPop [

	| random heapq data resultStream |
	resultStream := Array new writeStream.
	random := Random seed: 11.
	heapq := CTHeapQ empty.

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
