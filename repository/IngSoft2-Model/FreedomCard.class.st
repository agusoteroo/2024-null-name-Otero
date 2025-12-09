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
        "La nave objetivo no estaba en Jail: aviso y NO consumo la carta."
        CardExeption signal: 'Solo podes usar Freedom sobre una nave en la carcel.' ].

    "Si llegó hasta acá, realmente liberó una nave:
     recien ahora se considera 'jugada'."
    aCardHandler changeLastCardTo: self.
    ^ self

]

{ #category : #comparing }
FreedomCard >> canPlayRightNow: theShipInTurn [
    ^ true
]
