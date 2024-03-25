extends MarginContainer

class_name Upgrade

signal upgrade_picked
@onready var description_label = $Upgrade_Visual_Container/BoxContainer/Description/Label
@onready var player = get_node("/root/Game/Player")
@export var icon_texture : Texture
@export var second_icons : Array[Texture]

@export_group("type choice")
@export var is_stat_upgrade : bool
@export var is_weapon_upgrade : bool

@export_group("stats upgrade")
@export var stat : GlobalData.stat_name
var amount : int
@export var amount_min_max : Vector2i
@export var is_multiplie : bool

@export_group("weapon upgrade")
@export var upgrade_name : String
@export var weapon : PackedScene

var upgrade_level = {
	1 : "1",
	2 : "2",
	3 : "3"
}

func _ready():
	random_upgrade()

func _on_button_pressed():
	upgrade_picked.emit()
	
	add_upgrade()
	

func add_upgrade():
	if is_stat_upgrade:
		if is_multiplie:
			GlobalData.stat_change_proc(stat, amount)
		else:
			GlobalData.stat_change_flat(stat, amount)
	if is_weapon_upgrade:
		#var player = get_tree().root.get_node("Game").get_node("Player") as Player
		player.add_weapon(weapon)
		

func random_upgrade():
	#stat = GlobalData.stat_name.values()[randi_range(0,GlobalData.stat_name.size()-1)]
	amount = randi_range(amount_min_max.x,amount_min_max.y)
	#is_multiplie = randi() % 2 == 0
	show_upgrade_description()
	show_upgrade_icon()
	show_second_icons()
	
func show_upgrade_icon():
	var image_parent = $Upgrade_Visual_Container/BoxContainer/Image
	var icon = image_parent.get_node("Icon")
	var temp_label = image_parent.get_node("Label")
	for x in image_parent.get_children():
		x.visible = false
	if icon_texture != null:
		icon.texture = icon_texture
		icon.visible = true
	else: 
		temp_label.visible = true

func show_second_icons():
	for x in 3:
		var secondary_icon_parent = $Upgrade_Visual_Container/BoxContainer/Icons/HBoxContainer.get_child(x)
		var texture_rect = secondary_icon_parent.get_node("TextureRect")
		secondary_icon_parent.visible = false
		
		if second_icons.size() > x:
			texture_rect.texture = second_icons[x]
			secondary_icon_parent.visible = true
			
func show_upgrade_description():
	if is_stat_upgrade:
		var adding_text : String = "points "
		if is_multiplie:
			adding_text = "% "
		description_label.text = "Ramp up your stats. You get {} {}to your {} applied".format([amount, adding_text, GlobalData.stat_name.keys()[stat]], "{}")
	
	if is_weapon_upgrade:
		var optional_text =""
		var count = 0
		if weapon in player.weapons:
			optional_text = "You already holding this weapon."
		description_label.text = "Add a new Weapon. You get a {}. {}".format([upgrade_name, optional_text], "{}")


