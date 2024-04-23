extends Node2D
class_name Deck

const my_scene: PackedScene = preload("res://Scenes/Deck/deck.tscn")

const suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
const ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

var cards = []

var rng = RandomNumberGenerator.new()

func _ready():
	for suit in suits:
		for rank in ranks:
			var card : Card = Card.create_card(suit, rank)
			card.position = Vector2(200,200)
			add_child(card)

func shuffle():
	for i in range(get_children().size() - 1):
		var random_index = rng.randi_range(0, i + 1)
		var child1 : Node = get_child(i)
		var child2 : Node = get_child(random_index)
		move_child(child1, random_index)
		move_child(child2, i)

static func create_deck() -> Deck:
	var new_deck: Deck = my_scene.instantiate()
	return new_deck

