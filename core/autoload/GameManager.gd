extends Node

# --- Данные игрока ---
var reputation: int = 0
var upgrades_levels: Dictionary = {}
var stats: Dictionary = {
	"total_chars_erased": 0,
	"total_documents_processed": 0
}


# --- Базы данных (Листы Excel) ---
var upgrades_db: Dictionary = {}
var objects_db: Dictionary = {}
var constants_db: Dictionary = {}


func _ready() -> void:
	# Загружаем все три листа
	upgrades_db = load_csv_data("res://core/data/upgrades.csv")
	objects_db = load_csv_data("res://core/data/items.csv")
	constants_db = load_csv_data("res://core/data/global_consts.csv")
	
	# Инициализируем уровни всех улучшений нулями
	for upgrade_id in upgrades_db.keys():
		upgrades_levels[upgrade_id] = 0
		
	print("Баланс загружен. Улучшений: %d, Объектов: %d, Констант: %d" % [upgrades_db.size(), objects_db.size(), constants_db.size()])


# --- Универсальный парсер CSV ---
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
			
		var row_data: Dictionary = {}
		for i in range(headers.size()):
			var key = headers[i].strip_edges()
			var value = line[i].strip_edges()
			
			# Автоматическое приведение типов
			if value.is_valid_int():
				row_data[key] = value.to_int()
			elif value.is_valid_float() and "." in value:
				row_data[key] = value.to_float()
			else:
				# Если это строка типа "true"/"false", можно перевести в bool
				if value.to_lower() == "true":
					row_data[key] = true
				elif value.to_lower() == "false":
					row_data[key] = false
				else:
					row_data[key] = value
					
		# Берем значение из первой колонки (например, 'id') как ключ для словаря
		var item_id = row_data[headers[0]]
		result[item_id] = row_data
		
	return result


func add_reputation(amount: int) -> void:
	reputation += amount
	print(reputation)
	EventBus.reputation_changed.emit(reputation)


func get_upgrade_cost(upgrade_id: String) -> int:
	if not upgrades_db.has(upgrade_id):
		return 999999
		
	var data = upgrades_db[upgrade_id]
	var current_level = upgrades_levels.get(upgrade_id, 0)
	
	return int(data["base_cost"] * pow(data["cost_mult"], current_level))


func buy_upgrade(upgrade_id: String) -> bool:
	var cost = get_upgrade_cost(upgrade_id)
	
	if reputation >= cost and upgrades_levels[upgrade_id] < upgrades_db[upgrade_id]["max_level"]:
		reputation -= cost
		upgrades_levels[upgrade_id] += 1
		return true
		
	return false
