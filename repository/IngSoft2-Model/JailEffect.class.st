"
Class for JailEffect
"
Class {
	#name : #JailEffect,
	#superclass : #EffectOnOneShip,
	#category : #'IngSoft2-Model'
}

{ #category : #applying }
JailEffect >> affectAShip: aShip [

	^ self 
]

{ #category : #applying }
JailEffect >> affectShip: aShip inGame: aGame [
    aGame sendShipToJail: aShip.

	
]

{ #category : #generators }
JailEffect >> handlePostMovementFor: aShip
    inGame: aGame
    withCardHandler: aCardHandler
    andBattleHandler: aBattleHandler [


]
