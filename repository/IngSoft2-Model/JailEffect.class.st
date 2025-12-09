Class {
	#name : #JailEffect,
	#superclass : #EffectOnOneShip,
	#category : #'IngSoft2-Model'
}

{ #category : #applying }
JailEffect >> affectAShip: aShip [

	^ self 
]

{ #category : #'as yet unclassified' }
JailEffect >> affectShip: aShip inGame: aGame [
    aGame sendShipToJail: aShip.

	
]
