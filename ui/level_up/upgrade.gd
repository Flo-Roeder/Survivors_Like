extends MarginContainer

signal upgrade_picked
@onready var description_label = $MarginContainer/BoxContainer/Description/Label

var stat
var amount : int
var is_multiplie : bool
func _ready():
	random_upgrade()

func _on_button_pressed():
	printerr("picked")
	upgrade_picked.emit()
	if is_multiplie:
		GlobalData.stat_change_proc(stat, amount)
	else:
		GlobalData.stat_change_flat(stat, amount)

func random_upgrade():
	stat = GlobalData.stat_name.values()[randi_range(0,GlobalData.stat_name.size()-1)]
	amount = randi_range(1,10)
	is_multiplie = randi() % 2 == 0
	var adding_text : String = "points "
	if is_multiplie:
		adding_text = "% "
	#description_label.text = str(GlobalData.stat_name.keys()[stat]) + adding_text + str(amount)
	description_label.text = "Ramp up your stats. You get {} {}to your {} applied".format([amount, adding_text, GlobalData.stat_name.keys()[stat]], "{}")
