Class {
	#name : #ShipState,
	#superclass : #Object,
	#instVars : [
		'tileEffectArray',
		'maxLap',
		'parsecs',
		'lightYears'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
ShipState >> isInJail [
    ^ false

]

{ #category : #'as yet unclassified' }
ShipState >> isTrapped [
    ^ false

]

{ #category : #'as yet unclassified' }
ShipState >> playTurnFor: aShip withRoll: diceRoll movementFromCards: movementFromCards inGame: aGame [

    ^ self subclassResponsibility
]
