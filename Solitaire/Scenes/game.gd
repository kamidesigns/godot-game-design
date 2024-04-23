extends Node2D



func load_resources():
	pass
	
func init_game():
	var deck : Deck = Deck.create_deck()
	$CanvasLayer.add_child(deck)

func _ready():
	load_resources()
	init_game()

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
