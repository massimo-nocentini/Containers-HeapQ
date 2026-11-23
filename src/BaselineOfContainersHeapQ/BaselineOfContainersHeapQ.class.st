"
I am the baseline of `Containers-HeapQ`: I load the packages `Containers-HeapQ`, `Containers-HeapQ-Visualizations` and `Containers-HeapQ-Tests`, and the project `Containers-Essentials` that they require.

```smalltalk
Metacello new
	baseline: 'ContainersHeapQ';
	repository: 'github://massimo-nocentini/Containers-HeapQ:master/src';
	load
```
"
Class {
	#name : #BaselineOfContainersHeapQ,
	#superclass : #BaselineOf,
	#category : #BaselineOfContainersHeapQ
}

{ #category : #baselines }
BaselineOfContainersHeapQ >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Externals."
		spec
			baseline: 'ContainersEssentials'
			with: [ spec repository: 'github://massimo-nocentini/Containers-Essentials:master' ].

		"Packages"
		spec
			package: 'Containers-HeapQ'
			with: [ spec requires: #( 'ContainersEssentials' ) ];
			package: 'Containers-HeapQ-Visualizations'
			with: [ spec requires: #( 'Containers-HeapQ' ) ];
			package: 'Containers-HeapQ-Tests'
			with: [ spec requires: #( 'Containers-HeapQ' ) ] ]
]
