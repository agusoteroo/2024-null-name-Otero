Class {
	#name : #SkipCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #event }
SkipCard >> activate: aCardHandler withTarget: aTarget [

    aCardHandler skipCurrentShipTurn.
    ^ self
]
