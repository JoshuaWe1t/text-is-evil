extends TextureRect

@export var text_blocks: Array[RichTextLabel]
@export var block_char_limits: Array[int]

var original_texts: Array[String] = []
var censor_indices: Array[int] = []

var current_desk_item: Node = null 


func _ready() -> void:
	EventBus.opened_for_editing.connect(_on_opened_for_editing)

	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)


func _on_opened_for_editing(incoming_id: String, node: Node) -> void:
	if incoming_id == "bulletin":
		current_desk_item = node
		
		# Проверяем, есть ли уже сгенерированный текст внутри объекта DeskItem
		if not node.has_meta("is_initialized"):
			_generate_new_content(node)
		else:
			_load_existing_content(node)
			
		show()
		move_to_front()
		
		var screen_size = get_viewport_rect().size
		global_position = (screen_size - size) / 2


func _generate_new_content(node: Node) -> void:
	original_texts.clear()
	censor_indices.clear()
	
	for i in range(text_blocks.size()):
		var target_length = 100
		if i < block_char_limits.size():
			target_length = block_char_limits[i]
			
		var gen_text = TextGenerator.generate_text(target_length)
		
		text_blocks[i].text = gen_text
		original_texts.append(gen_text)
		censor_indices.append(0)
		
	# Сохраняем сгенерированные тексты прямо в объект DeskItem на столе
	node.set_meta("is_initialized", true)
	node.set_meta("original_texts", original_texts.duplicate())
	node.set_meta("censor_indices", censor_indices.duplicate())


func _load_existing_content(node: Node) -> void:
	# Загружаем сохраненные тексты и индексы из объекта DeskItem
	original_texts = node.get_meta("original_texts").duplicate()
	censor_indices = node.get_meta("censor_indices").duplicate()
	
	# Восстанавливаем внешний вид (что уже зацензурено, а что еще нет)
	for i in range(text_blocks.size()):
		var og_text = original_texts[i]
		var c_idx = censor_indices[i]
		
		var erased_part = og_text.substr(0, c_idx)
		var visible_part = og_text.substr(c_idx)
		
		text_blocks[i].text = "[color=transparent]" + erased_part + "[/color]" + visible_part


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LBM"):
		censor_next_char()
	elif event.is_action_pressed("RBM"):
		rewrite_next_char()


func censor_next_char() -> void:
	for i in range(text_blocks.size()):
		var og_text = original_texts[i]
		var c_idx = censor_indices[i]
		
		if c_idx < og_text.length():
			while c_idx < og_text.length() and og_text[c_idx] in [" ", "\n"]:
				c_idx += 1
				
			if c_idx < og_text.length():
				c_idx += 1 
				censor_indices[i] = c_idx
				
				var erased_part = og_text.substr(0, c_idx)
				var visible_part = og_text.substr(c_idx)
				
				text_blocks[i].text = "[color=transparent]" + erased_part + "[/color]" + visible_part
				
				# ВАЖНО: сохраняем обновленный прогресс цензуры обратно в объект на столе
				if current_desk_item != null:
					current_desk_item.set_meta("censor_indices", censor_indices.duplicate())
				
				GameManager.add_reputation(1)
				return
				
	print("Все блоки текста на документе полностью отцензурированы!")


func rewrite_next_char() -> void:
	print("Вызвано переписывание символа (ПКМ)")


func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		hide()
		current_desk_item = null # Очищаем ссылку при закрытии
