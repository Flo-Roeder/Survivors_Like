extends Control

func _ready():
	GlobalData.game_over.connect(game_over)
	visible = false
	
func game_over():
	visible = true
	get_tree().paused = true


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://survivors_game.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
