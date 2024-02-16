extends Node

var damage = 0 setget set_damage, get_damage
func set_damage(d):
	damage = d
func get_damage():
	return damage
	
func destroy():
	pass

var speedCalc1
var speedCalc2
var Delta
