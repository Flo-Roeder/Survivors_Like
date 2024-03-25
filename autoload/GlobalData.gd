extends Node

signal game_over
signal stats_changed

var speed : float = 1000.0
var attack_speed_mult = 100.0
var health = 100.0
var max_health = 100.0
var damage_mult = 100.0
var crit_chance = 10.0
var crit_mult = 150
var range_mult = 100

#take all the stats names to handle the switch
enum stat_name {
	speed,
	attack_speed_mult,
	health,
	max_health,
	damage_mult,
	crit_chance,
	crit_mult,
	range_mult
}

func stat_change_flat(_stat_name : GlobalData.stat_name ,amount : int):
	printerr("flat")
	printerr(str(_stat_name)+str(amount))
	#apply to correct variable
	match (_stat_name):
		stat_name.speed:
			speed += amount
		stat_name.attack_speed_mult:
			attack_speed_mult += amount	
		stat_name.health:
			heal(amount)
		stat_name.max_health:
			max_health += amount	
		stat_name.damage_mult:
			damage_mult += amount
		stat_name.crit_chance:
			crit_chance += amount
		stat_name.crit_mult:
			crit_mult += amount
		stat_name.range_mult:
			range_mult += amount
	#emit the signal for scripts to react
	stats_changed.emit()

func stat_change_proc(_stat_name : GlobalData.stat_name, amount : int):
	printerr("proc")
	printerr(str(_stat_name)+str(amount))
	#calculate the change amount to a procentual factor and then apply on switch
	#i.e. 10 -> 1,10
	var	change = (100+amount)/100.00
	#apply to correct variable
	match (_stat_name):
		stat_name.speed:
			speed *= change
		stat_name.attack_speed_mult:
			attack_speed_mult *= change	
		stat_name.health:
			#heal just for the overflow
			heal(health * (change-1))
		stat_name.max_health:
			max_health *= change	
		stat_name.damage_mult:
			damage_mult *= change
		stat_name.crit_chance:
			crit_chance *= change
		stat_name.crit_mult:
			crit_mult *= change
		stat_name.range_mult:
			range_mult *= change

	#emit the signal for scripts to react
	stats_changed.emit()

func get_stat(_stat_name : GlobalData.stat_name):
	match (_stat_name):
		stat_name.speed:
			return speed
		stat_name.attack_speed_mult:
			return attack_speed_mult
		stat_name.health:
			return health
		stat_name.max_health:
			return max_health
		stat_name.damage_mult:
			return damage_mult
		stat_name.crit_chance:
			return crit_chance
		stat_name.crit_mult:
			return crit_mult
		stat_name.range_mult:
			return range_mult
			
func get_fire_rate(base : float):
	var change = base * attack_speed_mult / 100
	return 1 / change 

func heal(amount : float):
	var temp = health+amount
	if temp > max_health:
		health = max_health
	else:
		health = temp
		
	stats_changed.emit()
	
	if health <= 0.0:
		GlobalData.game_over.emit()

func damage_calculation(base : float):
	var calc_damage = base * damage_mult / 100
	
	if check_crit():
		calc_damage *= crit_mult / 100
	
	return calc_damage

func check_crit():
	var roll = randf() * 100
	if crit_chance > roll:
		return true
	else:
		return false
