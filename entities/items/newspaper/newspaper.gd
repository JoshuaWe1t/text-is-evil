extends TextureRect

@export var text_blocks: Array[RichTextLabel]
@export var block_char_limits: Array[int] = [30, 150, 75] 

var original_texts: Array[String] = []
var censor_indices: Array[int] = []

func _ready() -> void:
	for i in range(text_blocks.size()):
		var target_length = 100 # Значение по умолчанию
		if i < block_char_limits.size():
			target_length = block_char_limits[i]
			
		# Вызываем глобальный генератор
		var gen_text = TextGenerator.generate_text(target_length)
		
		# Записываем сгенерированный текст в блок и в наши массивы
		text_blocks[i].text = gen_text
		original_texts.append(gen_text)
		censor_indices.append(0)
		
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)


func _on_gui_input(event: InputEvent) -> void:
	# Проверяем ЛКМ через InputMap (действие "LBM")
	if event.is_action_pressed("LBM"):
		censor_next_char()
		
	# Проверяем ПКМ через InputMap (действие "RBM")
	elif event.is_action_pressed("RBM"):
		rewrite_next_char()


func censor_next_char() -> void:
	for i in range(text_blocks.size()):
		var og_text = original_texts[i]
		var c_idx = censor_indices[i]
		
		if c_idx < og_text.length():
			# Пропускаем пробелы и спецсимволы
			#while c_idx < og_text.length() and og_text[c_idx] in [" ", "\n", ",", ".", "!", "?", "-", ":"]:
			while c_idx < og_text.length() and og_text[c_idx] in [" ", "\n"]:
				c_idx += 1
				
			if c_idx < og_text.length():
				c_idx += 1 # Сдвигаем индекс, включая текущую букву
				censor_indices[i] = c_idx
				
				# Разделяем оригинальный текст на "стертую" и "видимую" части
				var erased_part = og_text.substr(0, c_idx)
				var visible_part = og_text.substr(c_idx)
				
				# Применяем прозрачность только к стертой части
				text_blocks[i].text = "[color=transparent]" + erased_part + "[/color]" + visible_part
				
				# Начисляем репутацию
				GameManager.add_reputation(1)
				return
				
	print("Все блоки текста на документе полностью отцензурированы!")


func rewrite_next_char() -> void:
	# Заготовка для механики переписывания (ПКМ)
	print("Вызвано переписывание символа (ПКМ)")
	# Здесь будет логика замены символа или слова
