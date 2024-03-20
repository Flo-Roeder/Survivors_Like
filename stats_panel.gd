extends Panel


func _input(_event):
	if Input.is_action_pressed("stat_panel"):
		visible = !visible
