extends Node2D

@export_group("spawn")
@export var spawn_time : float
@onready var spawn_timer : Timer = %Spwan_Timer

var game_time : float
var timer_on : bool = true
@onready var time_label = %TimeLabel

func _ready():
	spawn_timer.start(spawn_time)

func _process(delta):
	count_time(delta)

func spawn_mob():
	var new_mob = preload("res://character/enemies/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_spwan_timer_timeout():
	spawn_mob()

func count_time(delta : float):
	if timer_on:
		game_time += delta
	var secs = fmod(game_time, 60)
	var mins = fmod(game_time, 60*60)/60
	var time_formated = "%02d : %02d" % [mins,secs]
	time_label.text = time_formated
