extends Node2D


func play_idle_animation():
	%AnimationPlayer.queue("idle")


func play_hurt_animation():
	%AnimationPlayer.play("hurt")
