# res://scripts/memories/MemoryTrigger.gd
extends Node3D

@export var memory_data: MemoryData
@export var symbol_scene: PackedScene = preload("res://scenes/memories/Memento.tscn")

@onready var audio_player = $AudioStreamPlayer

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)

	if symbol_scene:
		var visual = symbol_scene.instantiate()
		add_child(visual)
		visual.set_memory_data(memory_data)

# Player en contacto con el trigger
func _on_body_entered(body):
	if body.name == "Player" and memory_data:
		audio_player.stream = memory_data.memory_audio
		audio_player.play()
		MemInventory.add_memory(memory_data)  # GUARDAMOS
		body.show_memory(memory_data)
