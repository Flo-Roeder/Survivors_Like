extends CharacterBody2D

var speed
@onready var weapon_holder = $WeaponHolder

@export var weapons : Array[PackedScene]

func _ready():
	%Orb.play_idle_animation()

	GlobalXp.xp_changed.connect(update_xp)
	GlobalData.stats_changed.connect(update_stats)
	
	GlobalData.weapons_array = weapons
	GlobalData.weapons_max = weapon_holder.get_child_count()
	
	update_xp()
	update_stats()
		
	instantiate_weapons()
	
func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction* speed
	move_and_slide()
	
	if velocity.length()>0.0:
		%Orb.play_idle_animation()

func _process(delta):
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

func instantiate_weapons():
	#clear the slots
	for x in weapon_holder.get_children():
		if x.get_child_count() == 0:
			break
		x.get_child(0).queue_free()
	#instantiate the weapons
	for x in weapons.size():
		weapon_holder.get_child(x).add_child(weapons[x].instantiate())

func add_weapon(weapon : PackedScene):
	GlobalData.weapons_array.append(weapon)
	weapons = GlobalData.weapons_array
	#weapons.append(weapon)
	instantiate_weapons()
