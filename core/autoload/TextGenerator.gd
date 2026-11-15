extends Node

var markov_data: Dictionary = {}
var is_loaded: bool = false

func _ready() -> void:
	# Инициализируем генератор случайных чисел
	randomize()
	# Укажите путь к вашему JSON файлу
	load_model("res://core/data/markov_cheims_data.json")


func load_model(file_path: String) -> void:
	if not FileAccess.file_exists(file_path):
		printerr("Файл марковских цепей не найден: ", file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())

	if error == OK:
		markov_data = json.data
		is_loaded = true
		print("Цепи Маркова загружены. Количество связей: ", markov_data.size())
	else:
		printerr("Ошибка парсинга JSON: ", json.get_error_message())


func generate_text(target_chars: int) -> String:
	if not is_loaded or markov_data.is_empty():
		return "Ошибка генерации текста. Проверьте JSON."

	var keys = markov_data.keys()
	var current_key: String = keys[randi() % keys.size()]
	var generated_text: String = current_key

	# Генерируем слова, пока не достигнем нужной длины
	while generated_text.length() < target_chars:
		if markov_data.has(current_key):
			var next_words: Array = markov_data[current_key]
			var next_word: String = next_words[randi() % next_words.size()]
			
			generated_text += " " + next_word
			
			# Формируем новый ключ: берем последнее слово из старого ключа и добавляем новое
			var key_parts = current_key.split(" ")
			if key_parts.size() > 0:
				current_key = key_parts[key_parts.size() - 1] + " " + next_word
			else:
				current_key = next_word
		else:
			# Если цепочка оборвалась (тупик), начинаем с нового случайного ключа
			current_key = keys[randi() % keys.size()]
			generated_text += " " + current_key

	# Обрезаем строку ровно до нужного количества символов и добавляем многоточие
	if generated_text.length() > target_chars:
		# Ищем ближайший пробел перед лимитом, чтобы не обрезать слово посередине
		var slice_index = generated_text.rfind(" ", target_chars)
		if slice_index == -1:
			slice_index = target_chars
		generated_text = generated_text.substr(0, slice_index).strip_edges() + "..."
	
	return generated_text[0].to_upper() + generated_text.substr(1,-1)
	#return generated_text
