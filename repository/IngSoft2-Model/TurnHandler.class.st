"
Turn Handler Class
"
Class {
	#name : #TurnHandler,
	#superclass : #Object,
	#instVars : [
		'turnsPerRound',
		'ships',
		'currentTurnShip',
		'shipLostTurns',
		'lostTurnPenalty',
		'direction',
		'extraTurns'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'class initialization' }
TurnHandler class >> withShips: anAmountOfTurns [

	^ self new initializeWithShips: anAmountOfTurns
]

{ #category : #modifying }
TurnHandler >> checkForShipsWithNoShield [

	ships do: [ :ship |
		((shipLostTurns at: ship) = 0 and: (ship amountOfShieldsActive = 0))
			ifTrue: [ shipLostTurns at: ship put: lostTurnPenalty ] ]
]

{ #category : #accessing }
TurnHandler >> currentTurnShip [

	^ currentTurnShip
]

{ #category : #modifying }
TurnHandler >> giveExtraTurnToCurrentShip [
    | currentExtra |
    currentExtra := extraTurns
        at: currentTurnShip
        ifAbsent: [ 0 ].
    extraTurns at: currentTurnShip put: currentExtra + 1
]

{ #category : #testing }
TurnHandler >> initializeWithShips: aCollectionOfShips [

	currentTurnShip := aCollectionOfShips first.
	turnsPerRound := aCollectionOfShips size.
	ships := aCollectionOfShips.
	lostTurnPenalty := 2.
	shipLostTurns := Dictionary new.
	ships do: [ :ship | shipLostTurns at: ship put: 0 ].
	direction:=1.
	extraTurns := Dictionary new.

]

{ #category : #modifying }
TurnHandler >> nextShipAccordingToDirection [ 
	|index nextIndex|
	index := ships indexOf: currentTurnShip .
	nextIndex := index +direction .
	nextIndex > turnsPerRound ifTrue: [ nextIndex := 1 ].
   nextIndex < 1 ifTrue: [ nextIndex := turnsPerRound ].

   ^ ships at: nextIndex
]

{ #category : #modifying }
TurnHandler >> nextTurn [

    | remainingExtraTurns |
    remainingExtraTurns := extraTurns
        at: currentTurnShip
        ifAbsent: [ 0 ].
    remainingExtraTurns > 0
        ifTrue: [
            extraTurns at: currentTurnShip put: remainingExtraTurns - 1.
            ^ currentTurnShip 
        ].
    currentTurnShip := self nextShipAccordingToDirection.
    ^ currentTurnShip

]

{ #category : #modifying }
TurnHandler >> reverseOrder [
    direction := direction * -1

]

{ #category : #accessing }
TurnHandler >> turnShipCanPlayTurn [

	| lostTurns |
	lostTurns := shipLostTurns at: currentTurnShip.

	(shipLostTurns at: currentTurnShip) > 0 ifTrue: [
		shipLostTurns at: currentTurnShip put: lostTurns - 1.
		^ TurnExeption signal: currentTurnShip shipName,' lost their turn' ].

	(currentTurnShip amountOfShieldsActive = 0 and:
		 (shipLostTurns at: currentTurnShip) = 0) ifTrue: [
		currentTurnShip healFullShields ]
]
