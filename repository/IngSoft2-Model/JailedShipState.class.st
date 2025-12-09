Class {
	#name : #JailedShipState,
	#superclass : #ShipState,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
JailedShipState >> isInJail [
    ^ true

]

{ #category : #'as yet unclassified' }
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
