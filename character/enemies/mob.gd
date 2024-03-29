extends CharacterBody2D

@export var health = 3
@export var xp_gain = 20
@export var speed = 300
@onready var player = get_node("/root/Game/Player")
func _ready():
	pass
	#%Wisp.play_walk()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func take_damage(damage : float):
	health -= damage
	%Wisp.play_hurt()
	
	if health <= 0:
		queue_free()
		
		const SMOKE_EXPLOSION = preload("res://tutorial/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
		GlobalXp.add_xp(xp_gain)		
