extends TextureRect

signal item_requested(item_id: String)

@onready var bulletin_shelf: TextureButton = $BulletinShelf
@onready var decree_shelf: TextureButton = $DecreeShelf
@onready var newspaper_shelf: TextureButton = $NewspaperShelf
@onready var book_shelf: TextureButton = $BookShelf


func _ready() -> void:
	bulletin_shelf.pressed.connect(_on_bulletin_shelf_pressed)
	decree_shelf.pressed.connect(_on_decree_shelf_pressed)
	newspaper_shelf.pressed.connect(_on_newspaper_shelf_pressed)
	book_shelf.pressed.connect(_on_book_shelf_pressed)


func _on_bulletin_shelf_pressed() -> void:
	# В будущем здесь можно добавить проверку на кулдаун или улучшение стеллажа
	print("book")
	item_requested.emit("bulletin")


func _on_decree_shelf_pressed() -> void:
	# В будущем здесь можно добавить проверку на кулдаун или улучшение стеллажа
	print("decree")
	item_requested.emit("decree")


func _on_newspaper_shelf_pressed() -> void:
	# В будущем здесь можно добавить проверку на кулдаун или улучшение стеллажа
	print("newspaper")
	item_requested.emit("newspaper")


func _on_book_shelf_pressed() -> void:
	# В будущем здесь можно добавить проверку на кулдаун или улучшение стеллажа
	print("book")
	item_requested.emit("book")
