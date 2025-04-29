extends Control


@export var card_scene: String = "res://cards.tscn"

@onready var line_edit: LineEdit = $LineEdit


func _on_line_edit_text_submitted(new_text: String) -> void:
	if line_edit.text == "805772":
		get_tree().change_scene_to_file(card_scene)
