extends Area2D

@onready var flame = $Flame
@onready var player = $".."

@export var fire_rate = 5

var  enemies_in_range : Array[Node2D]

func _ready():
	GlobalData.stats_changed.connect(set_weapon_stats)
	set_weapon_stats()
	
func _physics_process(_delta):
	enemies_in_range.clear()
	enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() == 0:
		return
	
	var check_distance = 100000
	var target_enemy
	for enemy in enemies_in_range:
		if check_distance > player.global_position.distance_to(enemy.global_position):
			check_distance = player.global_position.distance_to(enemy.global_position)
			target_enemy = enemy
		%WeaponPivot.look_at(target_enemy.global_position)
		flame.global_position = %ShootingPoint.global_position

func shoot():
	const _flame = preload("res://weapons/flame/fireball.tscn")
	var new_flame = _flame.instantiate()
	new_flame.position = %ShootingPoint.global_position
	new_flame.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_flame)

func set_weapon_stats():
	%Timer.start(GlobalData.get_fire_rate(fire_rate))

func _on_timer_timeout():
	shoot()
