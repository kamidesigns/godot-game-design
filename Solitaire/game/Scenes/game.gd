extends Node2D

var init_done: bool = true

var card_hovering: Card = null

var mouse_move_events: Array[InputEventMouseMotion] = []
var mouse_button_events: Array[InputEventMouseButton] = []
var filtered_mouse_button_events: Array[InputEventMouseButton] = []


var mouse_position: Vector2 = Vector2(0, 0)
var cards_hovering: Array[Card] = []
var top_card_hovering: Card = null

var deck: Deck = null

var all_interactables: Array[Card] = []

var card_dragging: Card = null
var card_dragging_previous_position: Vector2 = Vector2(0, 0)
var card_released: Card = null

func init_game():
	var foundation_pile_hearts = Card.create_card("Hearts", "A")
	foundation_pile_hearts.flip()
	foundation_pile_hearts.modulate.a = 0.4
	foundation_pile_hearts.position = Vector2(1100, 200)
	foundation_pile_hearts.set_name("FoundationPileHearts")
	var foundation_pile_diamonds = Card.create_card("Diamonds", "A")
	foundation_pile_diamonds.flip()
	foundation_pile_diamonds.modulate.a = 0.4
	foundation_pile_diamonds.position = Vector2(1300, 200)
	foundation_pile_diamonds.set_name("FoundationPileDiamonds")
	var foundation_pile_clubs = Card.create_card("Clubs", "A")
	foundation_pile_clubs.flip()
	foundation_pile_clubs.modulate.a = 0.4
	foundation_pile_clubs.position = Vector2(1500, 200)
	foundation_pile_clubs.set_name("FoundationPileClubs")
	var foundation_pile_spades = Card.create_card("Spades", "A")
	foundation_pile_spades.flip()
	foundation_pile_spades.modulate.a = 0.4
	foundation_pile_spades.position = Vector2(1700, 200)
	foundation_pile_spades.set_name("FoundationPileSpades")
	all_interactables.append(foundation_pile_hearts)
	all_interactables.append(foundation_pile_diamonds)
	all_interactables.append(foundation_pile_clubs)
	all_interactables.append(foundation_pile_spades)
	$CanvasLayer.add_child(foundation_pile_hearts)
	$CanvasLayer.add_child(foundation_pile_diamonds)
	$CanvasLayer.add_child(foundation_pile_clubs)
	$CanvasLayer.add_child(foundation_pile_spades)

	deck = Deck.create_deck()
	deck.position = Vector2(200, 500)
	$CanvasLayer.add_child(deck)
	for card in deck.get_cards():
		all_interactables.append(card)
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
			tween.tween_property(card, "position:y", deck.position.y + (j * 60), 0.05)
			if j == i:
				card.flip()
				card.make_draggable()
			await tween.finished
	init_done = true

func _ready():
	init_game()

func _input(event):
	if init_done == false:
		return
	if (event is InputEventMouseMotion):
		mouse_move_events.append(event)
	if (event is InputEventMouseButton):
		mouse_button_events.append(event)
	if (event is InputEventKey):
		var key_event = event as InputEventKey
		if (key_event.keycode == 4194305):
			get_tree().quit()

func _process(_delta):
	if init_done == false:
		return
	process_input_system()
	process_mouse_follow_system()
	process_cards_hovering_system()
	process_press_release()
	process_drag_system()
	process_release_system()
	process_cards_scaling()
	mouse_move_events.clear()
	mouse_button_events.clear()
	filtered_mouse_button_events.clear()

func process_input_system():
	var pressed_buttons = {}
	for event in mouse_button_events:
		if (pressed_buttons.has(event.button_index) && pressed_buttons[event.button_index].pressed == !event.pressed):
			pressed_buttons.erase(event.button_index)
			continue
		else:
			pressed_buttons[event.button_index] = event
	for button in pressed_buttons:
		filtered_mouse_button_events.append(pressed_buttons[button])

func process_mouse_follow_system():
	var last_mouse_move_event_this_frame: InputEventMouseMotion = mouse_move_events.pop_back()
	if (!last_mouse_move_event_this_frame): return
	mouse_position = last_mouse_move_event_this_frame.position

func process_cards_hovering_system():
	cards_hovering.clear()
	for card in all_interactables:
		if (card.is_mouse_hover(mouse_position) && card.is_in_group("dragable")):
			cards_hovering.append(card)
	cards_hovering.sort_custom(custom_array_sort)
	if (card_dragging):
		top_card_hovering = card_dragging
		return
	if !cards_hovering.is_empty():
		top_card_hovering = cards_hovering.front()
	else:
		top_card_hovering = null

func custom_array_sort(a: Card, b: Card):
	return a.get_index() > b.get_index()

func process_press_release():
	for event in filtered_mouse_button_events:
		if (event.button_index == 1 && event.pressed && top_card_hovering):
			card_dragging = top_card_hovering
			card_dragging_previous_position = card_dragging.global_position
		if (event.button_index == 1 && !event.pressed && card_dragging):
			card_released = card_dragging

func process_drag_system():
	if (card_dragging):
		var card_parent: Node = card_dragging.get_parent()
		if (card_parent.get_child(card_parent.get_child_count() - 1) != card_dragging):
			card_parent.move_child(card_dragging, card_parent.get_child_count() - 1)
		card_dragging.global_position.x = mouse_position.x
		card_dragging.global_position.y = mouse_position.y

func process_release_system():
	if (card_dragging && card_released):
		if (cards_hovering.size() > 1):
			var card_drop: Card = cards_hovering[1]
			print(cards_hovering)
			print(card_drop)
			if (card_drop.suit == "Spades"):
				print("test")
				card_dragging.global_position = card_drop.global_position - Vector2(0, -60)
			else:
				card_dragging.global_position = card_dragging_previous_position
		else:
			card_dragging.global_position = card_dragging_previous_position
		card_dragging = null
		card_released = null

func process_cards_scaling():
	for card in all_interactables:
		card.scale.x = 1.0
		card.scale.y = 1.0
	if top_card_hovering:
		top_card_hovering.scale.x = 1.05
		top_card_hovering.scale.y = 1.05
