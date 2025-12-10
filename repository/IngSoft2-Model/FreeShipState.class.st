"
Describes the way the ship was used to move.
"
Class {
	#name : #FreeShipState,
	#superclass : #ShipState,
	#category : #'IngSoft2-Model'
}

{ #category : #behavior }
FreeShipState >> playTurnFor: aShip withRoll: diceRoll movementFromCards: movementFromCards inGame: aGame [

	| movement |
	movement := diceRoll + movementFromCards.
	aShip moveTiles: movement.
	aGame applyMovementEffectsAndBattlesForShip: aShip
]
