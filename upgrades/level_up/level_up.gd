extends CanvasLayer

@onready var box_container = $MarginContainer/BoxContainer

@export var upgrade_amount : int


@export var stat_upgrades : Array[PackedScene]

func _ready():
	visible = false
	GlobalXp.level_up.connect(level_up)
	cleanup_container()
	
func level_up():
	get_tree().paused = true
	visible = true
	show_upgrades()

func cleanup_container():
	for x in box_container.get_children():
		x.queue_free()

func show_upgrades():
	cleanup_container()

	for x in upgrade_amount:
		var upgrade = stat_upgrades.pick_random()
		var instance = upgrade.instantiate()
		box_container.add_child(instance)
		instance.upgrade_picked.connect(pick_upgrade)
		
		#stat_upgrades.erase(upgrade)
		
func pick_upgrade():
	printerr("upgrade choosen")
	cleanup_container()
	visible = false
	get_tree().paused = false
