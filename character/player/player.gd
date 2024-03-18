extends CharacterBody2D

#used for better performance
var speed



func _ready():
	%Orb.play_idle_animation()

	GlobalXp.xp_changed.connect(update_xp)
	GlobalData.stats_changed.connect(update_stats)
	update_xp()
	update_stats()
	
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
		
		GlobalData.stat_change_flat(GlobalData.stat_name.health,-DAMAGE_RATE * overlapping_mobs.size() * delta)


func update_xp():
	var progress = GlobalXp.how_much_to_next_level()
	%ProgressBar2.value = progress
	%ProgressBar2/Label.text = "LEVEL " + str(GlobalXp.level)

func update_stats():
	speed = GlobalData.speed

	%ProgressBar.value = GlobalData.health/GlobalData.max_health*100
	%ProgressBar/Label.text = str(GlobalData.health as int) + " / " + str(GlobalData.max_health as int)
