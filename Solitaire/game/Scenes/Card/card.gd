extends Node2D
class_name Card

var front_texture : Texture2D
var back_texture : Texture2D

var flipped : bool = false
var rank: String
var suit: String

func update_texture():
	if flipped:
		$Sprite2D.texture = front_texture
	else:
		$Sprite2D.texture = back_texture

func flip():
	flipped = !flipped
	update_texture()

func is_black():
	return suit == "Clubs" || suit == "Spades"

func is_red():
	return suit == "Hearts" || suit == "Diamonds"

func make_draggable():
	add_to_group("dragable")

func remove_draggable():
	remove_from_group("dragable")

func make_droppable():
	add_to_group("droppable")

func remove_droppable():
	remove_from_group("droppable")

static func create_card(_suit: String, _rank: String) -> Card:
	var new_card: Card = load("res://Scenes/Card/card.tscn").instantiate()
	new_card.rank = _rank
	new_card.suit = _suit

	new_card.set_name("card" + _suit + _rank)

	new_card.front_texture = load("res://Media/Cards/PNG/Cards/card" + _suit + _rank + ".png")
	new_card.back_texture = load("res://Media/Cards/PNG/Cards/cardBack_blue5.png")

	new_card.update_texture()

	return new_card


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('flip'):
			flip()

func is_mouse_hover(mouse_position : Vector2):
	return mouse_position.x > global_position.x - ($Sprite2D.texture.get_width() / 2) && mouse_position.x < global_position.x + ($Sprite2D.texture.get_width() / 2) && mouse_position.y > global_position.y - ($Sprite2D.texture.get_height() / 2) && mouse_position.y < global_position.y + ($Sprite2D.texture.get_height() / 2)
