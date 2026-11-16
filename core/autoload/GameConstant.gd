extends Node

var constants_db: Dictionary = {}

func _ready() -> void:
	print("GameConstant is initialized")
	constants_db = load_csv_data("res://core/data/global_consts.csv")


func load_csv_data(file_path: String) -> Dictionary:
	var result: Dictionary = {}
	
	if not FileAccess.file_exists(file_path):
		printerr("Ошибка: Файл баланса не найден - ", file_path)
		return result

	var file = FileAccess.open(file_path, FileAccess.READ)
	var headers = file.get_csv_line()
	
	while not file.eof_reached():
		var line = file.get_csv_line()
		# Пропускаем пустые строки
		if line.size() < headers.size() or line[0].is_empty():
			continue
		
		for i in range(headers.size()):
			var key = line[0].strip_edges()
			var value = line[1].strip_edges()
			# Автоматическое приведение типов
			if value.is_valid_int():
				result[key] = value.to_int()
			elif value.is_valid_float() and "." in value:
				result[key] = value.to_float()
			else:
				# Если это строка типа "true"/"false", можно перевести в bool
				if value.to_lower() == "true":
					result[key] = true
				elif value.to_lower() == "false":
					result[key] = false
				else:
					result[key] = value

	return result
