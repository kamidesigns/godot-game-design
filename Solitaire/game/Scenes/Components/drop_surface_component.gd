extends Area2D
class_name DropSurfaceComponent

func _enter_tree() -> void:
	get_parent().remove_from_group("dropable")

func _exit_tree() -> void:
	get_parent().add_to_group("dropable")
