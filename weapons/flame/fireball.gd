extends Area2D

var travelled_distance : float
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $Projectile/AnimationPlayer

@export var damage = 1

var has_hit : bool

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	if !has_hit:
		position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	has_hit = true
	collision_shape_2d.queue_free()
	animation_player.play("explode")
	if body.has_method("take_damage"):
		body.take_damage(GlobalData.damage_calculation(damage))
