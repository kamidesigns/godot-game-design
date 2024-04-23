extends Node2D
class_name Card

const my_scene: PackedScene = preload("res://Scenes/Card/card.tscn")

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

static func create_card(_suit: String, _rank: String) -> Card:
	var new_card: Card = my_scene.instantiate()
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
