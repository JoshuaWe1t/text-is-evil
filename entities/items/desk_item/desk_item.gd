extends TextureRect

var item_id: String = ""
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_click_pos: Vector2 = Vector2.ZERO


func setup(id: String) -> void:
	item_id = id
	# Меняем текстуру базовой сцены в зависимости от того, что запросил игрок
	match item_id:
		"bulletin":
			texture = load("res://entities/items/desk_item/bulletin1.png")
		#"decree":
			#texture = load("res://entities/items/decree/sprites/decree_sprite.png")
		#"newspaper":
			#texture = load("res://entities/items/newspaper/sprites/newspaper_sprite.png")
		"book":
			texture = load("res://entities/items/desk_item/book1.png")


func _gui_input(event: InputEvent) -> void:
	if event.is_action("LBM"):
		if event.pressed:
			# Кнопку зажали — начинаем Drag and Drop
			is_dragging = true
			start_click_pos = global_position
			drag_offset = get_global_mouse_position() - global_position
			move_to_front() # Объект прыгает поверх остальных при взятии
		else:
			# Кнопку отпустили — заканчиваем Drag and Drop
			is_dragging = false
			
			# Если за время удержания объект почти не сдвинулся, считаем это кликом
			if global_position.distance_to(start_click_pos) < 5.0:
				print("Click once")
				EventBus.opened_for_editing.emit(item_id, self)

	# Двигаем объект вслед за мышью, если он в состоянии перетаскивания
	elif event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position() - drag_offset
