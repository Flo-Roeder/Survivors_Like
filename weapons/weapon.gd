extends Area2D

@onready var weapon_sprite = $WeaponSprite

@onready var player = $"../.."

@export_group("base_stats")
@export var fire_rate : float = 5 #shoots per second

@export var base_range = 300
var target_range
@onready var collision_shape_2d = $CollisionShape2D

@export_group("instances")
@export var projectile : PackedScene

var has_target : bool

var  enemies_in_range : Array[Node2D]

func _ready():
	GlobalData.stats_changed.connect(set_weapon_stats)
	set_weapon_stats()
	
func _physics_process(_delta):
	#reset enemies and calculate new
	enemies_in_range.clear()
	enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() == 0:
		has_target = false
		return

	var check_distance = target_range
	var target_enemy
	#check enemies in range and set the nearest aas target
	for enemy in enemies_in_range:
		if check_distance > player.global_position.distance_to(enemy.global_position):
			check_distance = player.global_position.distance_to(enemy.global_position)
			target_enemy = enemy
			
	#double check for target and point at it
	if target_enemy != null:
		weapon_sprite.look_at(target_enemy.global_position)
	
	#set shooting bool when there is a target
	has_target = true

	
func shoot():

	var projectile_instance = projectile.instantiate()
	projectile_instance.position = %ShootingPoint.global_position
	projectile_instance.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(projectile_instance)

func set_weapon_stats():
	#fire rate
	%Timer.start(GlobalData.get_fire_rate(fire_rate))
	#range
	target_range = base_range * GlobalData.range_mult
	collision_shape_2d.shape.radius = target_range-50

func _on_timer_timeout():
	if has_target:
		shoot()
