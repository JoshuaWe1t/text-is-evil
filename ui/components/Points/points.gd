extends Control

@onready var reputation_points: Label = $MarginContainer/HBoxContainer/ReputationPoints
@onready var censor_points: Label = $MarginContainer/HBoxContainer/CensorPoints


func _ready() -> void:
	print("UI_POINTS are initialized")
	
	reputation_points.text = str(0)
	censor_points.text = str(0)
	
	EventBus.reputation_changed.connect(_on_reputation_changed)


func _on_reputation_changed(_points: int) -> void:
	print("UI_POINTS: reputation was changed")
	
	reputation_points.text = "%d" % [GameManager.reputation]
