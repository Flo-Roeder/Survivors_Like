extends CharacterBody2D

signal game_over

@export var health = 100.0
@export var speed = 600

func _onready():
	%Orb.play_idle_animation()

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction* speed
	move_and_slide()
	
	if velocity.length()>0.0:
		%Orb.play_idle_animation()

	
	const DAMAGE_RATE = 50.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		%Orb.play_hurt_animation()
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			game_over.emit()
