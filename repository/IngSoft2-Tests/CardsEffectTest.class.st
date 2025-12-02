Class {
	#name : #CardsEffectTest,
	#superclass : #CardsTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
CardsEffectTest >> testFreedomCardReleasesShipFromJailEvenWithNonMaxRoll [

    | aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray
      collectionOfCards aDeck aTarget |

    aTileArray := OrderedCollection new.
    20 timesRepeat: [ aTileArray add: NullEffect new ].
	aTileArray at: 3 put: JailEffect new.

    aBoard := Board
        withTileEffectCollection: aTileArray
        withLengthInUnits: (Parsec withNominalValue: 20)
        withAmountOfLaps: 1.

    aCollectionOfNames := OrderedCollection
        with: 'Juan'
        with: 'Pedro'.

    aCollectionOfDie := OrderedCollection with:
        ( SequenceDie withSequence: #(2 1 ) ).

    collectionOfCards := OrderedCollection new.
    10 timesRepeat: [ collectionOfCards add: FreedomCard  ].
    aDeck := LoadedDeck withCards: collectionOfCards.

    aGame := Game
        withBoard: aBoard
        withShipNames: aCollectionOfNames
        withDice: (Dice with: aCollectionOfDie)
        withDeck: aDeck.

    aTarget := ShipTarget    withObjective: 'Pedro'.
		
    aGame playTurn.
	aGame playTurn.
		aGame playCard: FreedomCard  by: 'Juan' toTarget: aTarget  .
    
    aGame playTurn. 

    self assert: (aGame allShipsPosition at: 'Juan') first equals: 5.
    self assert: (aGame allShipsPosition at: 'Pedro') first equals: 2.
]

{ #category : #tests }
CardsEffectTest >> testWhenApplingRepeatCardLastEffectIsAppliedToTheTargetedShip [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget |
	aTileArray := OrderedCollection new.
	15 timesRepeat: [ aTileArray add: NullEffect new ].
	
	aTileArray at: 10 put: BlackHoleEffect new.
	
	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Jose'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 9 4 )).

	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: RepeatCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.
	
	
	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.

	aTarget := ShipTarget withObjective: 'Juan'.

	aGame playTurn.
	aGame playCard: RepeatCard by: 'Jose' toTarget: aTarget.
	
	self assert: (aGame allShipsPosition at: 'Juan') equals: #(2 1) asOrderedCollection 
]

{ #category : #tests }
CardsEffectTest >> testWhenDoubleCardIsPlayedCurrentShipPlaysTwoConsecutiveTurns [

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
        ( SequenceDie withSequence: #(1 2) ).

    collectionOfCards := OrderedCollection new.
    10 timesRepeat: [ collectionOfCards add: DoubleCard ].
    aDeck := LoadedDeck withCards: collectionOfCards.

    aGame := Game
        withBoard: aBoard
        withShipNames: aCollectionOfNames
        withDice: (Dice with: aCollectionOfDie)
        withDeck: aDeck.

    aTarget := AllShipsTarget new.
		
    aGame playTurn.
	aGame playCard: DoubleCard by: 'Pedro' toTarget: aTarget.
    aGame playTurn.
    aGame playTurn. 

    self assert: (aGame allShipsPosition at: 'Juan') first equals: 2.
    self assert: (aGame allShipsPosition at: 'Pedro') first equals: 4.
]

{ #category : #tests }
CardsEffectTest >> testWhenOneAccelerationCardIsPlayedShipsMoveOneExtraTile [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget |
	aTileArray := OrderedCollection new.
	10 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Jose'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 5 4 )).

	
	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: AccelerationCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.
	
	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.
	
	aTarget := AllShipsTarget new.
	
	aGame playCard: AccelerationCard by: 'Juan' toTarget:  aTarget.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame allShipsPosition at: 'Juan') first equals: 7.
	self assert: (aGame allShipsPosition at: 'Jose') first equals: 6
]

{ #category : #tests }
CardsEffectTest >> testWhenOneSpeedCardIsPlayedTargetedShipMoveOneExtraTile [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget|
	aTileArray := OrderedCollection new.
	10 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Jose'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 5 4 )).

	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: SpeedCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.

	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.
	
	aTarget := ShipTarget withObjective: 'Juan'.
	
	aGame playCard: SpeedCard by: 'Juan' toTarget: aTarget.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame allShipsPosition at: 'Juan') first equals: 7.
	self assert: (aGame allShipsPosition at: 'Jose') first equals: 5
]

{ #category : #tests }
CardsEffectTest >> testWhenOneSpeedCardIsPlayedWhenShipBattelsItThrowResultIsIncreasedByOne [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget|
	aTileArray := OrderedCollection new.
	10 timesRepeat: [ aTileArray add: NullEffect new ].

	aBoard := Board
		          withTileEffectCollection: aTileArray
		          withLengthInUnits: (Parsec withNominalValue: 10)
		          withAmountOfLaps: 1.
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Jose'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 4 5 4 4)).

	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: SpeedCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.

	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.
	
	aTarget := ShipTarget withObjective: 'Juan'.
	
	aGame playCard: SpeedCard by: 'Juan' toTarget: aTarget.
	aGame playTurn.
	aGame playTurn.
	
	self assert: (aGame allShipAmountOfShields  at: 'Juan') equals: 3.
	self assert: (aGame allShipAmountOfShields  at: 'Jose') equals: 2.
	
]

{ #category : #tests }
CardsEffectTest >> testWhenReverseTurnsCardIsPlayedTurnOrderIsReversed [ 


    | aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget |

    "Tablero simple sin efectos"
    aTileArray := OrderedCollection new.
    20 timesRepeat: [ aTileArray add: NullEffect new ].

    aBoard := Board
        withTileEffectCollection: aTileArray
        withLengthInUnits: (Parsec withNominalValue: 20)
        withAmountOfLaps: 1.
    collectionOfCards := OrderedCollection new.
    10 timesRepeat: [ collectionOfCards add: ReverseTurnsCard  ].
    aDeck := LoadedDeck withCards: collectionOfCards.
    aCollectionOfNames := OrderedCollection
        with: 'Juan'
        with: 'Pedro'
        with: 'Paco'.

    aCollectionOfDie := OrderedCollection with: (SequenceDie withSequence: #(1 2 3 4)).

    aGame :=
        Game
            withBoard: aBoard
            withShipNames: aCollectionOfNames
            withDice: (Dice with: aCollectionOfDie)
				withDeck: aDeck .

	aTarget := AllShipsTarget new.
   
    aGame playTurn.   
    aGame playTurn.   
	aGame playCard: ReverseTurnsCard  by: 'Juan' toTarget: aTarget.
    aGame playTurn.  
	 aGame playTurn. 

    self assert: (aGame allShipsPosition at: 'Juan')  first equals: 2.
    self assert: (aGame allShipsPosition at: 'Pedro') first equals: 7.
	self assert: (aGame allShipsPosition at:  'Paco')  first equals: 4


]

{ #category : #tests }
CardsEffectTest >> testWhenShipWithMercenariesBattleAllOfThenThrowTheDice [

	| aGame aBoard aCollectionOfNames aCollectionOfDie aTileArray collectionOfCards aDeck aTarget |
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
		                    (SequenceDie withSequence: #( 7 4 4 )).
	
	collectionOfCards := OrderedCollection new.
	10 timesRepeat: [ collectionOfCards add: MercenaryCard ].
	aDeck := LoadedDeck withCards: collectionOfCards.
	
	aGame := Game
		         withBoard: aBoard
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie)
		         withDeck: aDeck.

	aTarget := ShipTarget withObjective: 'Juan'.
	
	aGame playTurn.
	aGame playCard: MercenaryCard by: 'Jose' toTarget: aTarget.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame allShipAmountOfShields at: 'Pedro') equals: 2.
]

{ #category : #tests }
CardsEffectTest >> testWhenSkipCardIsPlayedCurrentShipDoesNotMoveInNextTurn [

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
