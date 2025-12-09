"
Game Class
"
Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'gameBoard',
		'gameShips',
		'dice',
		'gameTurnHandler',
		'shipBattleHandler',
		'theShipInCurrentTurn',
		'gameCardHandler',
		'lastEffect',
		'shipStates'
	],
	#classInstVars : [
		'isFinished'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #testing }
Game class >> isValid: aBoard with: aNameCollection and: aDice [

	aNameCollection isEmpty ifTrue: [
		Error signal: 'Game cannot be created without any Ship names' ].
	(aBoard respondsTo: #numbOfTiles) ifFalse: [
		Error signal: 'Game cannot be started without a board' ].
	(aDice respondsTo: #throw) ifFalse: [
		Error signal: 'Game cannot be started without at least one die' ]
]

{ #category : #'class initialization' }
Game class >> withBoard: aBoard withShipNames: aNameCollection withDice: aDice [

	| collectionOfCards |
	collectionOfCards := OrderedCollection new.
	aNameCollection size * 2 timesRepeat: [
		collectionOfCards add: NullCard ].

	self isValid: aBoard with: aNameCollection and: aDice.
	^ self new
		  initializeGameWith: aBoard
		  withShipNames: aNameCollection asSet
		  withDice: aDice
		  withGameDeck:
		  (LoadedDeck withCards: collectionOfCards)
]

{ #category : #'class initialization' }
Game class >> withBoard: aBoard withShipNames: aNameCollection withDice: aDice withDeck: aDeck [

	self isValid: aBoard with: aNameCollection and: aDice.
	^ self new
		  initializeGameWith: aBoard
		  withShipNames: aNameCollection
		  withDice: aDice
		  withGameDeck: aDeck
]

{ #category : #accessing }
Game >> adjustShipPosition: aShip [

	gameBoard adjustShipPosition: aShip.
	gameBoard snapToFinishTile: aShip
]

{ #category : #accessing }
Game >> allShipAmountOfShields [

	| shipShields |
	shipShields := Dictionary new.
	gameShips do: [ :aShip |
		shipShields
			at: aShip shipName put: aShip amountOfShieldsActive;
			yourself ].
	^ shipShields
]

{ #category : #accessing }
Game >> allShipsPosition [

	| shipPositions |
	shipPositions := Dictionary new.
	gameShips do: [ :aShip |
		shipPositions
			at: aShip shipName
			put: (OrderedCollection with: aShip position with: aShip lapsDone);
			yourself ].
	^ shipPositions
]

{ #category : #event }
Game >> applyEffectOnAllShips: anEffect [

	anEffect affectAShipCollection: gameShips.
	gameShips do: [ :aShip |
		gameBoard adjustShipPosition: aShip.]
]

{ #category : #event }
Game >> applyEffectOnAllShipsButOne: anEffect triggerByShip: aShip [

	anEffect affectAllShips: gameShips but: aShip.
	gameShips do: [ :anAffectedShip |
		gameBoard adjustShipPosition: anAffectedShip ]
]

{ #category : #event }
Game >> applyEffectOnOneShip: anEffect triggeredBy: aShip [

    anEffect affectShip: aShip inGame: self.
    gameBoard adjustShipPosition: aShip

]

{ #category : #generating }
Game >> applyLastEffectOn: aTarget [

	| aShip |
	aShip := self shipWithName: aTarget objective.
	lastEffect applyOn: self activatedBy: aShip
]

{ #category : #event }
Game >> applyMovementEffectsAndBattlesForShip: aShip [

    | postEffectTile |

    self adjustShipPosition: aShip.
    lastEffect := gameBoard effectInPosition: aShip position.

    gameBoard
        applyTileEffectOn: self
        triggeredBy: aShip.

    postEffectTile := gameBoard effectInPosition: aShip position.

    (postEffectTile allowsBattles)
        ifTrue: [
            shipBattleHandler
                checkShipBattle: aShip
                withCardHandler: gameCardHandler
        ].

]

{ #category : #testing }
Game >> canPlayNextTurnOf [

	self isFinished ifTrue: [
		Error signal: 'Game is Over you cant Keep Playing' ].

]

{ #category : #initialization }
Game >> ensureCorrectStateFor: aShip [
    aShip position = 1 ifTrue: [ self restartShipState: aShip ].
]

{ #category : #event }
Game >> giveCardToCurrentShip: aShip [

	gameCardHandler
		giveCardTo: aShip shipName.
]

{ #category : #modifying }
Game >> giveExtraTurnToCurrentShip [
    gameTurnHandler  giveExtraTurnToCurrentShip
]

{ #category : #initialization }
Game >> initializeGameWith: aBoard withShipNames: aNameCollection withDice: aDice withGameDeck: aDeck [

	gameBoard := aBoard.
	gameShips := aNameCollection asOrderedCollection collect: [ :aName |
		             Ship createWithName: aName ].

	dice := aDice.
	gameTurnHandler := TurnHandler withShips: gameShips.
	shipBattleHandler := ShipBattle withDice: dice withShips: gameShips.
	gameCardHandler := CardHandler withDeck: aDeck andGame: self.
	theShipInCurrentTurn := gameTurnHandler currentTurnShip.
	lastEffect := NullEffect new.
   shipStates := Dictionary new.

   gameShips do: [ :ship |
    shipStates at: ship put: FreeShipState new ].
	gameShips do: [ :ship | gameCardHandler startingCards: ship shipName ]
]

{ #category : #testing }
Game >> isFinished [

	^ gameShips anySatisfy: [ :aShip | gameBoard isInLastTile: aShip ]
]

{ #category : #accessing }
Game >> isShipInJail: aShip [
    ^ (self stateOfShip: aShip) isInJail
]

{ #category : #accessing }
Game >> isShipTrapped: aShip [
    ^ (self stateOfShip: aShip) isTrapped
]

{ #category : #testing }
Game >> maxDiceRoll [
    ^ dice maxRoll


]

{ #category : #event }
Game >> playCard: aCard by: aShipName toTarget: aTarget [

	| aCardToPlay |
	aCardToPlay := aCard withHolder: aShipName andTarget: NullTarget new.

	gameCardHandler validateCard: aCardToPlay.
	self targetIsValid: aTarget.
	(aCardToPlay canPlayRightNow: theShipInCurrentTurn) ifFalse: [
		CardExeption signal:
			'Ship cannot throw this card as its not his turn' ].

	[ gameCardHandler activateCard: aCardToPlay withTarget: aTarget ]
		on: CardExeption
		do: [ :ex | ^ ex messageText ].
		
	gameCardHandler removeCardFromShipDeck: aCardToPlay
]

{ #category : #modifying }
Game >> playTurn [
    | diceRoll movementFromCards |

    self canPlayNextTurnOf.

    [ gameTurnHandler turnShipCanPlayTurn ]
        on: TurnExeption
        do: [ :ex | ^ ex messageText ].

    diceRoll := dice throw.
    movementFromCards := gameCardHandler
        movementCardsActivated: theShipInCurrentTurn.
	 self ensureCorrectStateFor: theShipInCurrentTurn.
    (self stateOfShip: theShipInCurrentTurn)
        playTurnFor: theShipInCurrentTurn
        withRoll: diceRoll
        movementFromCards: movementFromCards
        inGame: self.

    gameTurnHandler checkForShipsWithNoShield.
    gameTurnHandler nextTurn.
    theShipInCurrentTurn := gameTurnHandler currentTurnShip


]

{ #category : #event }
Game >> releaseShip: aShip [
    self setState: FreeShipState new forShip: aShip

]

{ #category : #event }
Game >> releaseShipFromJail: aShip [
    "Por ahora Jail y HyperGravity comparten el mismo estado libre,
     pero semánticamente distinguimos 'liberar de Jail'."
    self setState: FreeShipState new forShip: aShip
]

{ #category : #initialization }
Game >> releaseShipFromJailNamed: aName [
    | ship |
    ship := self shipNamed: aName.
    ship ifNil: [ ^ self ].
    self releaseShipFromJail: ship.
]

{ #category : #initialization }
Game >> restartShipState: aShip [
	shipStates at: aShip put: FreeShipState new.
]

{ #category : #modifying }
Game >> reverseTurns [
    gameTurnHandler  reverseOrder
]

{ #category : #event }
Game >> sendShipToJail: aShip [
    self setState: JailedShipState new forShip: aShip
]

{ #category : #initialization }
Game >> setState: aState forShip: aShip [
    shipStates at: aShip put: aState
]

{ #category : #accessing }
Game >> shipCards: aShip [

	^ gameCardHandler inPlayDeck select: [ :card | card holder = aShip ]
]

{ #category : #accessing }
Game >> shipInCurrentTurn [
	^ theShipInCurrentTurn

]

{ #category : #initialization }
Game >> shipNamed: aName [
    ^ gameShips
        detect: [ :aShip | aShip shipName = aName ]
        ifNone: [ nil ].
]

{ #category : #accessing }
Game >> shipRankings [

	| sortedShips rankDictionary |
	sortedShips := gameShips asSortedCollection: [ :ship1 :ship2 |
		               ship1 > ship2 ].

	rankDictionary := Dictionary new.
	sortedShips withIndexDo: [ :elemento :indice |
		rankDictionary at: indice put: elemento ].

	^ rankDictionary
]

{ #category : #accessing }
Game >> shipWithName: aShipName [

	^ gameShips detect: [ :ship | ship shipName = aShipName ]
]

{ #category : #modifying }
Game >> skipTurn [

	| skipedTurn |
	self canPlayNextTurnOf.

	[ gameTurnHandler turnShipCanPlayTurn ]
		on: TurnExeption
		do: [ :ex | ^ ex messageText ].

	theShipInCurrentTurn healFullShields.

	gameTurnHandler nextTurn.
	skipedTurn := theShipInCurrentTurn shipName , ' skipped their turn'.
	theShipInCurrentTurn := gameTurnHandler currentTurnShip.
	
	^ skipedTurn
]

{ #category : #initialization }
Game >> stateOfShip: aShip [

    ^ shipStates at: aShip
]

{ #category : #validating }
Game >> targetIsValid: aTarget [

	(aTarget isValidWith: gameShips and: gameCardHandler) ifFalse: [
		CardExeption signal: 'Target is not valid' ]
]

{ #category : #generating }
Game >> trapShip: aShip withRequiredRoll: aNumber [
    | state |
    state := HyperGravityShipState withRequiredRoll: aNumber.
    self setState: state forShip: aShip

]

{ #category : #accessing }
Game >> winnerName [

	self isFinished ifFalse: [ ^ 'There is no winner yet' ].
	^ (gameShips detect: [ :aShip | gameBoard isInLastTile: aShip ])
		  shipName
]
