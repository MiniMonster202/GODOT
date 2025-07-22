# res://scripts/memories/MemoryTrigger.gd
extends Node3D

@export var memory_data: MemoryData
@onready var audio_player = $AudioStreamPlayer

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and memory_data:
		audio_player.stream = memory_data.memory_audio
		audio_player.play()
		body.show_memory(memory_data) # Llamamos a una función del jugador
