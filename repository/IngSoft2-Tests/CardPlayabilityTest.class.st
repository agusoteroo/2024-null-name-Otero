Class {
	#name : #CardPlayabilityTest,
	#superclass : #CardsTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
CardPlayabilityTest >> testAnPermanentCardCanOnlyBePlayedDuringAShipsTurnInAGame [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget |
	aTileArray := OrderedCollection new.
	2 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 10.
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Jose'.
	aCollectionOfDie := OrderedCollection with: (LoadedDie of: 10).

	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: AccelerationCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.

	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.
	
	aTarget := AllShipsTarget new.
	
	self
		should: [
		aGame playCard: AccelerationCard by: 'Jose' toTarget: aTarget ]
		raise: CardExeption
		withMessage: 'Ship cannot throw this card as its not his turn'
]

{ #category : #tests }
CardPlayabilityTest >> testCannotPlayACardThatDoesNotBelongToAShip [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray |
	aTileArray := OrderedCollection new.
	2 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan'.
	aCollectionOfDie := OrderedCollection with: (LoadedDie of: 10).

	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	self
		should: [
		aGame playCard: AccelerationCard by: 'Jose' toTarget: AllShipsTarget new ]
		raise: CardExeption
		withMessage: 'Ship does not have that card'
]

{ #category : #tests }
CardPlayabilityTest >> testCannotPlayACardThatDoesNotHaveASetTarget [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray |
	aTileArray := OrderedCollection new.
	2 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan'.
	aCollectionOfDie := OrderedCollection with: (LoadedDie of: 10).

	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).
	
	self
		should: [
			aGame
				playCard: NullCard
				by: 'Juan'
				toTarget: NullTarget new ]
		raise: Error
		withMessage: 'No target has been set'
]

{ #category : #tests }
CardPlayabilityTest >> testCannotPlayACardThatHasInvalidTarget [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget |
	aTileArray := OrderedCollection new.
	2 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.

	aCollectionOfNames := OrderedCollection with: 'Jose'.
	aCollectionOfDie := OrderedCollection with: (LoadedDie of: 10).

	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: SpeedCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.
	
	
	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.
	
	aTarget := ShipTarget withObjective: 'Juan'.
	
	self
		should: [ aGame playCard: SpeedCard by: 'Jose' toTarget: aTarget ]
		raise: CardExeption
		withMessage: 'Target is not valid'
]

{ #category : #tests }
CardPlayabilityTest >> testWhenCardsAreTakenFormDeckTheyFollowTheProbabilityDistribution [

	| aDeck aCollectionOfCards |
	aDeck := Deck withCardProbabilities:
		         (OrderedCollection with: (ProbabilityAssociation
				           associate: CancellationCard
				           withProbability: 100)).

	aCollectionOfCards := OrderedCollection new.
	10 timesRepeat: [ aCollectionOfCards add: aDeck cardAtRandom ].

	self assert:
		(aCollectionOfCards allSatisfy: [ :card | card = CancellationCard ])
]

{ #category : #tests }
CardPlayabilityTest >> testWhenDoubleCardIsPlayedCurrentShipPlaysTwoConsecutiveTurns [

    | aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray
      collectionOfCards aDeck aTarget |

    aTileArray := OrderedCollection new.
    20 timesRepeat: [ aTileArray add: NullEffect new ].

    aBoard := Board
        withTileEffectCollection: aTileArray
        withLengthInUnits: (Parsec withNominalValue: 20)
        withAmountOfLaps: 1.

    aCollectionOfNames := OrderedCollection
        with: 'Juan'
        with: 'Pedro'.

    aCollectionOfDie := OrderedCollection with:
        (LoadedDie of: 5).

    collectionOfCards := OrderedCollection new.
    10 timesRepeat: [ collectionOfCards add: DoubleCard ].
    aDeck := LoadedDeck withCards: collectionOfCards.

    aGame := Game
        withBoard: aBoard
        withShipNames: aCollectionOfNames
        withDice: (Dice with: aCollectionOfDie)
        withDeck: aDeck.

    aTarget := AllShipsTarget new.
    aGame playCard: DoubleCard by: 'Juan' toTarget: aTarget.

    aGame playTurn.
    aGame playTurn.
    aGame playTurn. 

    self assert: (aGame allShipsPosition at: 'Juan') first equals: 11.
    self assert: (aGame allShipsPosition at: 'Pedro') first equals: 6.
]

{ #category : #tests }
CardPlayabilityTest >> testWhenGameIsStartedShipsHave2Cards [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray aDeck collectionOfCards|
	aTileArray := OrderedCollection new.
	10 timesRepeat: [ aTileArray add: NullEffect new ].


	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan'.
	aCollectionOfDie := OrderedCollection with: (LoadedDie of: 10).
	
	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: SpeedCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.
	
	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	self assert: (aGame shipCards: 'Juan') size equals: 2
]

{ #category : #tests }
CardPlayabilityTest >> testWhenPlayingACardShipCardsDeckSizeChanges [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray aTarget |
	aTileArray := OrderedCollection new.
	2 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Jose'.
	aCollectionOfDie := OrderedCollection with: (LoadedDie of: 10).

	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).
	
	aTarget := ShipTarget withObjective: 'Juan'.
	aGame playCard: NullCard by: 'Juan'  toTarget:  aTarget.

	self assert: (aGame shipCards: 'Juan') size equals: 1.
	self assert: (aGame shipCards: 'Jose') size equals: 2
]

{ #category : #tests }
CardPlayabilityTest >> testWhenReverseTurnsCardIsPlayedTurnOrderIsReversed [

    | aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray
      collectionOfCards aDeck aTarget |

    aTileArray := OrderedCollection new.
    10 timesRepeat: [ aTileArray add: NullEffect new ].

    aBoard := Board
        withTileEffectCollection: aTileArray
        withLengthInUnits: (Parsec withNominalValue: 10)
        withAmountOfLaps: 1.

    aCollectionOfNames := OrderedCollection
        with: 'Juan'
        with: 'Jose'
        with: 'Pedro'.

    aCollectionOfDie := OrderedCollection with:
        (SequenceDie withSequence: #( 1 2 3 1 2 3 )).

    collectionOfCards := OrderedCollection new.
    10 timesRepeat: [ collectionOfCards add: ReverseTurnsCard ].
    aDeck := LoadedDeck withCards: collectionOfCards.

    aGame := Game
        withBoard: aBoard
        withShipNames: aCollectionOfNames
        withDice: (Dice with: aCollectionOfDie)
        withDeck: aDeck.

    aTarget := AllShipsTarget new. 

    aGame playTurn. 
    aGame playTurn. 
    aGame playTurn. 

    aGame playCard: ReverseTurnsCard by: 'Pedro' toTarget: aTarget.

    aGame playTurn.
aGame playTurn. 
    aGame playTurn. 

    self assert: (aGame allShipsPosition at: 'Juan') first equals: 4.
    self assert: (aGame allShipsPosition at: 'Jose') first equals: 4.
    self assert: (aGame allShipsPosition at: 'Pedro') first equals: 7.
]

{ #category : #tests }
CardPlayabilityTest >> testWhenSkipCardIsPlayedCurrentShipDoesNotMoveInNextTurn [

    | aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray
      collectionOfCards aDeck aTarget |

    aTileArray := OrderedCollection new.
    20 timesRepeat: [ aTileArray add: NullEffect new ].

    aBoard := Board
        withTileEffectCollection: aTileArray
        withLengthInUnits: (Parsec withNominalValue: 20)
        withAmountOfLaps: 1.

    aCollectionOfNames := OrderedCollection
        with: 'Juan'
        with: 'Pedro'.

    aCollectionOfDie := OrderedCollection with:
        (LoadedDie of: 5).

    collectionOfCards := OrderedCollection new.
    10 timesRepeat: [ collectionOfCards add: SkipCard ].
    aDeck := LoadedDeck withCards: collectionOfCards.

    aGame := Game
        withBoard: aBoard
        withShipNames: aCollectionOfNames
        withDice: (Dice with: aCollectionOfDie)
        withDeck: aDeck.

    aTarget := AllShipsTarget new. 

 
    aGame playCard: SkipCard by: 'Juan' toTarget: aTarget.

    aGame playTurn.

    self assert: (aGame allShipsPosition at: 'Juan') first equals: 1.
    self assert: (aGame allShipsPosition at: 'Pedro') first equals: 6.
]
