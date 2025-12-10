"
Class for HypeGravityEffect
"
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

{ #category : #applying }
HyperGravityEffect >> affectShip: aShip inGame: aGame [
    aGame trapShip: aShip withRequiredRoll: requiredRoll
]

{ #category : #applying }
HyperGravityEffect >> applyOn: aGame activatedBy: aShip [

	| maxRoll |
	maxRoll := aGame maxDiceRoll.

	requiredRoll > maxRoll ifTrue: [
		HyperGravityException signal:
			'El valor X de HyperGravity (' , requiredRoll printString
			, ') no puede ser mayor que la tirada maxima ('
			, maxRoll printString , ').' ].

	aGame trapShip: aShip withRequiredRoll: requiredRoll.

	super applyOn: aGame activatedBy: aShip
]

{ #category : #initialization }
HyperGravityEffect >> initializeWithRequiredRoll: aNumber [
    requiredRoll := aNumber
]
