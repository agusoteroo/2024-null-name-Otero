Class {
	#name : #FreedomCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #event }
FreedomCard >> activate: aCardHandler withTarget: aTarget [

	| shipToFree freed |
	shipToFree := aTarget shipInGame: aCardHandler game.

	shipToFree ifNil: [
		CardExeption signal: 'El objetivo de Freedom no es una nave valida.' ].

	freed := aCardHandler freeShipNamed: shipToFree shipName.

	freed ifFalse: [
		CardExeption signal:
			'Solo podes usar Freedom sobre una nave en la carcel.' ].
	aCardHandler changeLastCardTo: self.
	^ self
]

{ #category : #comparing }
FreedomCard >> canPlayRightNow: theShipInTurn [

	^ true
]
