Class {
	#name : #OsmoCrashReportErrorHandler,
	#superclass : #Object,
	#instVars : [
		'reportUrl',
		'username',
		'password'
	],
	#category : #OsmoCrashReportClient
}

{ #category : #'as yet unclassified' }
OsmoCrashReportErrorHandler >> handleError: anError on: block [ 
	self reportError: anError
]

{ #category : #'as yet unclassified' }
OsmoCrashReportErrorHandler >> handleTimerError: anError on: aTimer [
	self reportError: anError
]

{ #category : #'as yet unclassified' }
OsmoCrashReportErrorHandler >> reportError: anError [ 
	| backTrace serializer data |
	backTrace := anError signalerContext stack collect: [:each | each asString ].

	serializer := FLSerializer newDefault.
	serializer at: #backtrace putAdditionalObject: backTrace.

	"TODO: write stuff about the application"

	serializer addPostMaterializationAction: [ :materialization | 
		Smalltalk tools debugger
			openOn: Processor activeProcess 
			context: materialization root 
			label: 'Unhandled exception' 
			contents: nil 
			fullView: false ].

	data := #[] writeStream.
	serializer serialize: anError signalerContext on: data.

	"Fire and forget..."
	[ 
		ZnEasy client
			url: reportUrl;
			setBasicAuthenticationUsername: username password: password;
			entity: (ZnByteArrayEntity  bytes: data contents);
			ifFail: [:err |
				err logException: 'Failed to upload crash' area: #core];
			put;
			response.
	] fork.
]

{ #category : #'as yet unclassified' }
OsmoCrashReportErrorHandler >> reportUrl: aUrl [  
	reportUrl := aUrl
]

{ #category : #'as yet unclassified' }
OsmoCrashReportErrorHandler >> username: aUsername password: aPassword [ 
	username := aUsername.
	password := aPassword.
]
