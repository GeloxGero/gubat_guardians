extends Node

var random = RandomNumberGenerator.new()

var TIMER = 0

var two_to_one = false

var hp = 5
var trash = 0

func reset():
	hp = 5
	two_to_one = false
