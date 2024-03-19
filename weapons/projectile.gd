extends Area2D

var travelled_distance : float
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $Scaler/Projectile/AnimationPlayer

@export var damage = 1
@export var speed : int = 1000
@export var max_range : int = 1200
var has_hit : bool

func _physics_process(delta):
	
	var direction = Vector2.RIGHT.rotated(rotation)
	if !has_hit:
		position += direction * speed * delta
	
	travelled_distance += speed * delta
	if travelled_distance > max_range:
		queue_free()


func _on_body_entered(body):
	has_hit = true
	collision_shape_2d.queue_free()
	animation_player.play("explode")
	if body.has_method("take_damage"):
		body.take_damage(GlobalData.damage_calculation(damage))
