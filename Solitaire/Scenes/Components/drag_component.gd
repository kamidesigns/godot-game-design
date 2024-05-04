extends Area2D
class_name DragComponent

@export var use_offset : bool = true

var dragging : bool = false
var offset : Vector2 = Vector2.ZERO
var previous_position : Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	connect("input_event", _on_input_event)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	get_parent().remove_from_group("dragable")

func _exit_tree() -> void:
	disconnect("input_event", _on_input_event)
	disconnect("mouse_entered", _on_mouse_entered)
	disconnect("mouse_exited", _on_mouse_exited)
	get_parent().add_to_group("dragable")
	
func on_resource_saved(resource: Resource) -> void:
	print("Resource saved: %s" % [ resource ])

func _process(_delta):
	if dragging:
		get_parent().global_position = get_global_mouse_position() + offset

func _on_mouse_entered():
	get_parent().add_to_group("dragable_hovered")

func _on_mouse_exited():
	get_parent().remove_from_group("dragable_hovered")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('click'):
			if is_on_top():
				previous_position = get_parent().global_position
				dragging = true
				offset = get_parent().global_position - get_global_mouse_position()
		if Input.is_action_just_released('click'):
			dragging = false
			offset = Vector2.ZERO
			get_parent().global_position = previous_position

func is_on_top():
	for dragable in get_tree().get_nodes_in_group("dragable_hovered"):
		if dragable.get_index() > get_parent().get_index():
			return false
	return true
