Class {
	#name : #BattleTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BattleTest >> testShipsCanBattleInAHyperGravityEffectTile [

	| aGame aCollectionOfNames aCollectionOfDie aTileArray |
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Pedro'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 3 3 5 4 6) maxFace:12).


	aTileArray := OrderedCollection new.
	16 timesRepeat: [ aTileArray add: NullEffect new ].
	aTileArray at: 4 put:( HyperGravityEffect withRequiredRoll: 8) .

	
	aGame := Game
		         withBoard: (Board
				          withTileEffectCollection: aTileArray
				          withLengthInUnits: (Parsec withNominalValue: 16)
				          withAmountOfLaps: 1)
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	aGame playTurn.
	aGame playTurn.
	aGame playTurn .
	
	self assert: (aGame allShipsPosition at: 'Pedro') first equals: 4.
	self assert: (aGame allShipsPosition at: 'Juan') first equals:7.

	self assert: (aGame allShipAmountOfShields at: 'Pedro') equals:3.
	self assert: (aGame allShipAmountOfShields at: 'Juan') equals:2
	
	
]

{ #category : #tests }
BattleTest >> testShipsCanNotBattleInAJailEffect [

	| aGame aCollectionOfNames aCollectionOfDie aTileArray |
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Pedro'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 3 3 5 4 6) maxFace:12).


	aTileArray := OrderedCollection new.
	16 timesRepeat: [ aTileArray add: NullEffect new ].
	aTileArray at: 4 put: JailEffect new .

	
	aGame := Game
		         withBoard: (Board
				          withTileEffectCollection: aTileArray
				          withLengthInUnits: (Parsec withNominalValue: 16)
				          withAmountOfLaps: 1)
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame allShipsPosition at: 'Pedro') first equals: 4.
	self assert: (aGame allShipsPosition at: 'Juan') first equals: 4.
	self assert: (aGame allShipAmountOfShields at: 'Pedro') equals:3.
	self assert: (aGame allShipAmountOfShields at: 'Juan') equals:3
	
	
]

{ #category : #tests }
BattleTest >> testShipsCanNotBattleInAJailEffectEvenAfterLandingDueToAnotherEffect [

	| aGame aCollectionOfNames aCollectionOfDie aTileArray |
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Pedro'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 3 7  6 12) maxFace:12).


	aTileArray := OrderedCollection new.
	18 timesRepeat: [ aTileArray add: NullEffect new ].
	aTileArray at: 4 put: JailEffect new .
	aTileArray at: 8 put: BlackHoleEffect new.
	
	aGame := Game
		         withBoard: (Board
				          withTileEffectCollection: aTileArray
				          withLengthInUnits: (Parsec withNominalValue: 16)
				          withAmountOfLaps: 1)
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	aGame playTurn.
	aGame playTurn.
	aGame playTurn .
	aGame playTurn . 

	self assert: (aGame allShipsPosition at: 'Pedro') first equals: 16.
	self assert: (aGame allShipsPosition at: 'Juan') first equals: 4.
	self assert: (aGame allShipAmountOfShields at: 'Pedro') equals:3.
	self assert: (aGame allShipAmountOfShields at: 'Juan') equals:3
	
	
]

{ #category : #tests }
BattleTest >> testShipsCannotBattleInTheFirstTileOfABoard [

	| aGame aCollectionOfNames aWormHoleTilePair aCollectionOfDie aTileArray aParsecAmount |
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Pedro'.
	aWormHoleTilePair := #( 10 15 ).
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 16 16 4 5 )).
	aParsecAmount := Parsec withNominalValue: 16.
	aTileArray := OrderedCollection new.

	16 timesRepeat: [ aTileArray add: NullEffect new ].

	aGame := Game
		         withBoard: (Board
				          withTileEffectCollection: aTileArray
				          withLengthInUnits: aParsecAmount
				          withAmountOfLaps: 3)
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame allShipAmountOfShields at: 'Juan') equals: 3.
	self assert: (aGame allShipAmountOfShields at: 'Pedro') equals: 3
]

{ #category : #tests }
BattleTest >> testWhenShipInAGameLandsInATileWithAnotherShipThenTheyBattle [

	| aGame aCollectionOfNames aCollectionOfDie aTileArray |
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Pedro'.
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 10 10 5 4)).


	aTileArray := OrderedCollection new.
	16 timesRepeat: [ aTileArray add: NullEffect new ].
	
	aGame := Game
		         withBoard: (Board
				          withTileEffectCollection: aTileArray
				          withLengthInUnits: (Parsec withNominalValue: 16)
				          withAmountOfLaps: 1)
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame allShipAmountOfShields at: 'Pedro') equals: 3
]

{ #category : #tests }
BattleTest >> testWhenShipLosesABattleThenGoBackToFirstTile [

	| aGame aCollectionOfNames aWormHoleTilePair aCollectionOfDie aTileArray|
	aCollectionOfNames := OrderedCollection with: 'Juan' with: 'Pedro'.
	aWormHoleTilePair := #( 10 15 ).
	aCollectionOfDie := OrderedCollection with:
		                    (SequenceDie withSequence: #( 10 10 5 4 3 )).
	
	aTileArray := OrderedCollection new.

	39 timesRepeat: [ aTileArray add: NullEffect new ].

	aGame := Game
		         withBoard: (Board
				          withTileEffectCollection: aTileArray
				          withLengthInUnits: (Parsec withNominalValue: 16)
				          withAmountOfLaps: 1)
		         withShipNames: aCollectionOfNames
		         withDice: (Dice with: aCollectionOfDie).

	aGame playTurn.
	aGame playTurn.
	aGame playTurn .


	self
		assert: (aGame allShipsPosition at: 'Pedro')
		equals: #( 11 1 ) asOrderedCollection.
	self assert: (aGame allShipsPosition at: 'Juan')
		first equals: 4.
]
