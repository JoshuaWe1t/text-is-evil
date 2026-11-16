extends Control

@onready var journal_upgrades: TextureButton = $MarginContainer/JournalUpgrades


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	journal_upgrades.pressed.connect(_on_journal_upgrades_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_journal_upgrades_pressed() -> void:
	print("Open a window upgrades")
