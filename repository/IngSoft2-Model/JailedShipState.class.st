"
Class to describe the movements and behaviour in JT
"
Class {
	#name : #JailedShipState,
	#superclass : #ShipState,
	#category : #'IngSoft2-Model'
}

{ #category : #testing }
JailedShipState >> isInJail [
    ^ true

]

{ #category : #testing }
JailedShipState >> isTrapped [
    ^ true
]

{ #category : #'as yet unclassified' }
JailedShipState >> playTurnFor: aShip withRoll: diceRoll movementFromCards: movementFromCards inGame: aGame [

    (diceRoll = aGame maxDiceRoll)
        ifFalse: [ ^ self ]. 
    aGame releaseShip: aShip.
    (aGame stateOfShip: aShip)
        playTurnFor: aShip
        withRoll: diceRoll
        movementFromCards: movementFromCards
        inGame: aGame

]
