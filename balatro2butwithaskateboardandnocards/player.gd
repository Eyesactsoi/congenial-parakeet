extends CharacterBody2D

#intializing our variables
@export var speed = 400
var screen_size
var selfSpeed := 0.0
var acceleration := 2.5
var lastDirection: float

const MAX_SPEED = 600.0
const  JUMP_VELOCITY = -250.0
