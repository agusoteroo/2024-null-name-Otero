"
State pattern used to change the way a ship moves without using ifs and acting as a single class.
"
Class {
	#name : #ShipState,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #testing }
ShipState >> isInJail [
    ^ false

]

{ #category : #testing }
ShipState >> isTrapped [
    ^ false

]

{ #category : #behavior }
ShipState >> playTurnFor: aShip withRoll: diceRoll movementFromCards: movementFromCards inGame: aGame [

    ^ self subclassResponsibility
]
