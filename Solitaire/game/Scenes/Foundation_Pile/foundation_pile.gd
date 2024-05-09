extends Node2D
class_name FoundationPile

var texture : Texture2D

var suit : String

func update_texture():
	$Sprite2D.texture = texture

static func create_foundation_pile(_suit: String) -> FoundationPile:
	var new_foundation_pile: FoundationPile = load("res://Scenes/Foundation_Pile/foundation_pile.tscn").instantiate()
	new_foundation_pile.suit = _suit

	new_foundation_pile.texture = load("res://Media/Cards/PNG/Cards/card" + _suit + "A.png")
	new_foundation_pile.update_texture()
	
	new_foundation_pile.set_name("foundation_pile" + _suit)

	return new_foundation_pile
