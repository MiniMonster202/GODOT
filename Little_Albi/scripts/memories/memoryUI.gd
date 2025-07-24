# res://scenes/memories/memoryUI.gd
extends CanvasLayer

var from_inventory := false  # Por defecto no viene del inventario

func set_memory(memory):
	$CenterContainer/VBoxContainer/TextureRect.texture = memory.memory_image
	$CenterContainer/VBoxContainer/Label.text = memory.memory_text

func _ready():
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_close)

func _on_close():
	queue_free()
	
	if not from_inventory:
		get_tree().paused = false
		var player = get_tree().current_scene.get_node("Player")
		if player:
			player.set_physics_process(true)
