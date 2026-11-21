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
