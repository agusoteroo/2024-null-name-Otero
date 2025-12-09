"
State pattern used to change the way a ship moves without using ifs and acting as a single class.
"
Class {
	#name : #ShipState,
	#superclass : #Object,
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
