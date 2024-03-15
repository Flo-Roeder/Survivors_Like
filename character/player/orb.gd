extends Node2D


func play_idle_animation():
	print("idle")
	%AnimationPlayer.queue("idle")


func play_hurt_animation():
	print("hurt")
	%AnimationPlayer.play("hurt")
