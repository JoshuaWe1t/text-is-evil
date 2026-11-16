extends Node

# Загружаем ресурс картинки
var hand_cursor = preload("res://assets/textures/ui/cursor/cursor-hand.png")
var eraser_cursor = preload("res://assets/textures/ui/cursor/mouse-1.png")

func _ready():
	EventBus.opened_for_editing.connect(set_eraser_cursor)
	EventBus.closed_editing.connect(set_hand_cursor)
	# Меняем стандартный курсор (стрелку)
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(0, 0))


func set_eraser_cursor(_item_id: String, _node: Node):
	Input.set_custom_mouse_cursor(eraser_cursor, Input.CURSOR_ARROW, Vector2(0, 0))


func set_hand_cursor() -> void:
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(0, 0))

func reset_cursor():
	# Чтобы вернуть системный курсор ОС, передайте null
	Input.set_custom_mouse_cursor(null)
