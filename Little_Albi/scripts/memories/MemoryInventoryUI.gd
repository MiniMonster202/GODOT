# res://scripts/memories/MemoryInventoryUI.gd
extends CanvasLayer

@onready var memory_list = $Panel/MemoryList

func _ready():
	hide() # Oculto por defecto

func toggle_inventory():
	var player = get_tree().current_scene.get_node("Player")
	if visible:
		print("ocultando inventario")
		hide()
		if player:
			player.set_physics_process(true)
	else:
		print("mostrando inventario")
		show_inventory()
		if player:
			player.set_physics_process(false)

func show_inventory():
	visible = true
	clear() # Borra recuerdos anteriores

	for memory in MemInventory.get_all_memories():
		var button = TextureButton.new()
		
		# Usa la imagen del recuerdo o un placeholder
		button.texture_normal = preload("res://icon.svg")
		
		button.custom_minimum_size = Vector2(64, 64)
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		# Conectamos el botón a una función para reproducir la memoria
		button.pressed.connect(func(): _on_memory_button_pressed(memory))

		memory_list.add_child(button)

func _on_memory_button_pressed(memory_data: MemoryData):
	var player = get_tree().current_scene.get_node("Player")
	if player:
		player.show_memory(memory_data, true) #From_inventory = true

func clear():
	for child in memory_list.get_children():
		child.queue_free()
