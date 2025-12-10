Class {
	#name : #LoadedDieTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #asserting }
LoadedDieTest >> should: aErrorBlock raise: anErrorClass withMessage: anErrorMessage [

	self
		should: aErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : #asserting }
LoadedDieTest >> testALoadedDieCanThrowASequenceOfDifferentRolls [

	| aDie |
	aDie := SequenceDie withSequence: #( 4 9 5 ).

	self assert: aDie throw equals: 4.
	self assert: aDie throw equals: 9.
	self assert: aDie throw equals: 5.
	self assert: aDie throw equals: 4
]

{ #category : #asserting }
LoadedDieTest >> testDieCanBeCreatedWithAnAmountOfFaces [

	| aDie |
	aDie := LoadedDie of: 5.
	self assert: aDie throw equals: 5
]

{ #category : #asserting }
LoadedDieTest >> testDieCannotBeCreatedWithLessThanThreeFaces [

	self
		should: [ LoadedDie of: 2 ]
		raise: Error
		withMessage: 'Faces should be more than 2'
]

{ #category : #asserting }
LoadedDieTest >> testHyperGravityRaisesExceptionWhenRequiredRollExceedsMaxRoll [

    | aBoard aGame aTileArray aShipNames |

    aTileArray := OrderedCollection new.
    10 timesRepeat: [ aTileArray add: NullEffect new ].
    aTileArray at: 3 put: (HyperGravityEffect withRequiredRoll: 7).

    aBoard := Board
        withTileEffectCollection: aTileArray
        withLengthInUnits: (Parsec withNominalValue: 10)
        withAmountOfLaps: 1.
    aShipNames := OrderedCollection with: 'Juan'.
    aGame := Game
        withBoard: aBoard
        withShipNames: aShipNames
        withDice: (Dice with:
                    (OrderedCollection with:
                        (SequenceDie
                            withSequence: #( 2 )   
                            maxFace: 6))).

    self
        should: [ aGame playTurn ]
        raise: HyperGravityException.

]

{ #category : #tests }
LoadedDieTest >> testWhenDieIsThrownThenValueIsBetweenOneAndNumberedFaces [

	| aDie |
	aDie := LoadedDie of: 4.

	self assert: aDie throw equals: 4
]
