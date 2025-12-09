"
Superclass for tile effects
"
Class {
	#name : #Effect,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #generators }
Effect >> allowsBattles [
    ^ true

]

{ #category : #applying }
Effect >> applyOn: aGame activatedBy: aShip [

	self subclassResponsibility.
]

{ #category : #generators }
Effect >> generateParameters: aTileEffectCreator [

	^ self
]
