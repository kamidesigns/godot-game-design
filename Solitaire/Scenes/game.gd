extends Node2D



func load_resources():
	pass

func init_game():
	var deck : Deck = Deck.create_deck()
	deck.position = Vector2(200,200)
	$CanvasLayer.add_child(deck)
	for i in range(7):
		for j in range(i + 1):
			var card: Card = deck.draw()
			card.position += deck.position
			$CanvasLayer.add_child(card)
			var tween = $CanvasLayer.create_tween()
			tween.tween_property(card, "position:y", 1400, 0.05)
			await tween.finished
			card.position = Vector2(500 + (i * 200), 1400)
			tween = $CanvasLayer.create_tween()
			tween.tween_property(card, "position:y", 200 + (j * 40), 0.05)
			if j == i:
				card.flip()
				card.make_draggable()
			await tween.finished



func _ready():
	load_resources()
	init_game()

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
