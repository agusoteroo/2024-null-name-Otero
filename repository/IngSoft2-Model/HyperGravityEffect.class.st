Class {
	#name : #HyperGravityEffect,
	#superclass : #EffectOnOneShip,
	#instVars : [
		'requiredRoll'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperGravityEffect class >> withRequiredRoll: aNumber [
    ^ self new 
	initializeWithRequiredRoll: aNumber;
        yourself
]

{ #category : #applying }
HyperGravityEffect >> affectAShip: aShip [
    ^ self
]

{ #category : #initialization }
HyperGravityEffect >> initializeWithRequiredRoll: aNumber [
    requiredRoll := aNumber
]
