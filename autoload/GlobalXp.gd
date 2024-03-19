extends Node

signal xp_changed
signal level_up

var xp = 0
var level = 1
var needed_xp = 100.0

func add_xp(_xp : int):
	xp += _xp
	
	if xp >= needed_xp:
		level +=1
		xp = 0 
		printerr("level up makes stronger")
		GlobalData.stat_change_proc(GlobalData.stat_name.speed, 10)
		GlobalData.stat_change_proc(GlobalData.stat_name.attack_speed_mult, 10)
		GlobalData.stat_change_proc(GlobalData.stat_name.max_health, 10)
		GlobalData.stat_change_proc(GlobalData.stat_name.range_mult, 100)
		level_up.emit()
	xp_changed.emit()

func how_much_to_next_level():
	needed_xp = 100.0 * level
	var progress : float = xp/needed_xp * 100
	return progress
