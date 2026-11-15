extends TextureRect

@export var desk_item_scene: PackedScene 
@onready var spawn_area = $SpawnArea

func _ready() -> void:
	# Подписываемся на запрос предмета из стеллажа
	EventBus.item_requested.connect(spawn_item_on_desk)


func spawn_item_on_desk(item_id: String) -> void:
	if not desk_item_scene:
		return
		
	var new_item = desk_item_scene.instantiate()
	add_child(new_item) 
	
	var random_offset = Vector2(randf_range(-30, 30), randf_range(-30, 30))
	new_item.global_position = spawn_area.global_position + random_offset
	
	new_item.setup(item_id)
