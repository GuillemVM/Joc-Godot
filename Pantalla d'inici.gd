extends Control

export (PackedScene) var scn_game



func _on_play_pressed():
	get_tree().change_scene_to(scn_game)
