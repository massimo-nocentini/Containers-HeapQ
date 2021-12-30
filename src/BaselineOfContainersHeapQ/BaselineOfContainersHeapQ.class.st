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
			with: [ 
			spec repository: 'github://massimo-nocentini/Containers-Essentials' ].

		"Packages"
		spec
			package: 'Containers-HeapQ';
			package: 'Containers-HeapQ-Visualizations';
			package: 'Containers-HeapQ-Tests' ]
]
