Class {
	#name : #ReverseTurnsCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #event }
ReverseTurnsCard >> activate: aCardHandler withTarget: aTarget [

	aCardHandler reverseTurns.
    ^ self
]
