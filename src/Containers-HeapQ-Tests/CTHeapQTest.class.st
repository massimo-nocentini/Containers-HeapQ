"
A CTHeapQTest is a test class for testing the behavior of CTHeapQ
"
Class {
	#name : #CTHeapQTest,
	#superclass : #TestCase,
	#category : #'Containers-HeapQ-Tests'
}

{ #category : #checking }
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
CTHeapQTest >> test100ShuffledInterval [
	<gtExample>
	^ (1 to: 63) asArray shuffleBy: (Random seed: 11)
]

{ #category : #tests }
CTHeapQTest >> test100ShuffledIntervalHeapified [

	| heapq |
	heapq := CTHeapQ new heapify: self test100ShuffledInterval.

	self invariant: heapq.

	^ heapq
]

{ #category : #tests }
CTHeapQTest >> test100ShuffledIntervalRawHeapSlot [
	<gtExample>
	^ self test100ShuffledIntervalHeapified instVarNamed: #heap
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

{ #category : #tests }
CTHeapQTest >> testUpdate [

	| keys heapq random n |
	"Init."
	n := 1000.
	random := Random seed: 11.
	heapq := CTHeapQ new.

	"Collecting objects that may vary their `key` slot."
	keys := (1 to: n) collect: [ :each | 
		        CTHeapQKeyedObject new
			        key: each;
			        addDependent: heapq;
			        yourself ].

	"Create an heapq by heapifying the keys."
	heapq heapify: keys.
	self invariant: heapq.

	(Array with: 1 with: n with: n - 1)
	, ((1 to: n - 3) collect: [ :i | random nextInteger: n ]) do: [ 
		:index | 
		(keys at: index) key: n + 1.

		self invariant: heapq ]
]
