extends Node2D
class_name Deck

const suits = ["Clubs", "Spades", "Hearts", "Diamonds"]
const ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

var cards = []

var rng = RandomNumberGenerator.new()

func _enter_tree():
	for i in len(suits):
		for j in len(ranks):
			var card : Card = Card.create_card(suits[i], ranks[j])
			card.position = Vector2(-((len(ranks) * i + j) / 4.0), -((len(ranks) * i + j) / 4.0))
			add_child(card)
	shuffle()

func shuffle():
	for i in range(get_children().size() - 1):
		var random_index = rng.randi_range(0, i + 1)
		var child1 : Node = get_child(i)
		var child2 : Node = get_child(random_index)
		move_child(child1, random_index)
		move_child(child2, i)
		var old_position : Vector2 = child1.position
		child1.position = child2.position
		child2.position = old_position

func draw() -> Card:
	var card = get_child(-1)
	remove_child(card)
	return card

static func create_deck() -> Deck:
	var new_deck: Deck = load("res://Scenes/Deck/deck.tscn").instantiate()
	new_deck.set_name("deck")
	return new_deck

