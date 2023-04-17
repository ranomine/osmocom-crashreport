Class {
	#name : #BaselineOfOsmoCrashReportClient,
	#superclass : #BaselineOf,
	#category : #BaselineOfOsmoCrashReportClient
}

{ #category : #baselines }
BaselineOfOsmoCrashReportClient >> baseline: spec [
	<baseline>

	spec baseline: 'OsmoLogging' with: [
		spec
			repository: 'github://ranomine/osmocom-logging:v8/source'.
	].

	spec package: 'OsmoCrashReportClient' with: [
		spec requires: #('OsmoLogging')
	]
]
