Class {
	#name : #FreedomCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #event }
FreedomCard >> activate: aCardHandler withTarget: aTarget [
	aCardHandler freeShipInTurn.
	aCardHandler changeLastCardTo: self.
	^ self
]

{ #category : #comparing }
FreedomCard >> canPlayRightNow: theShipInTurn [
    ^ true
]
