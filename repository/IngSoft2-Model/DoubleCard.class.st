Class {
	#name : #DoubleCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #event }
DoubleCard >> activate: aCardHandler withTarget: aTarget [
    aCardHandler giveExtraTurnToCurrentShip.
    ^ self
]
