extends HBoxContainer

@export var stat : GlobalData.stat_name

@onready var name_label = $name_Label
@onready var amount_label = $amount_Label

func _ready():
	show_stat()
	GlobalData.stats_changed.connect(show_stat)

func show_stat():
	name_label.text = str(GlobalData.stat_name.keys()[stat])
	amount_label.text = str(GlobalData.get_stat(stat))
