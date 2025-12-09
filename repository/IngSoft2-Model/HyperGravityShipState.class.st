"
Class to describe the movements and behaviour in HGT
"
Class {
	#name : #HyperGravityShipState,
	#superclass : #ShipState,
	#instVars : [
		'requiredRoll'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperGravityShipState class >> withRequiredRoll: aNumber [
    ^ self new
        initializeWithRequiredRoll: aNumber;
        yourself
       
]

{ #category : #initialization }
HyperGravityShipState >> initializeWithRequiredRoll: aNumber [
        requiredRoll := aNumber
]

{ #category : #initialization }
HyperGravityShipState >> isTrapped [
    ^ true
]

{ #category : #initialization }
HyperGravityShipState >> playTurnFor: aShip withRoll: diceRoll movementFromCards: movementFromCards inGame: aGame [
		self assert: requiredRoll notNil.
    (diceRoll < requiredRoll)
        ifTrue: [ ^ self ].  
    aGame releaseShip: aShip.

    (aGame stateOfShip: aShip)
        playTurnFor: aShip
        withRoll: diceRoll
        movementFromCards: movementFromCards
        inGame: aGame
]
