# res://scenes/memories/memento.gd
extends Node3D

@onready var visual = $Visual
var float_timer := 0.0

# Memoria actual asociada
var memory_data

func _process(delta):
	if visual.get_child_count() > 0:
		float_timer += delta
		var offset = sin(float_timer * 2.0) * 0.1
		visual.position.y = offset
		visual.rotate_y(delta * 0.5)

func set_memory_data(data):
	memory_data = data

	if not memory_data:
		return

	# Borrar contenido anterior por si acaso
	for child in visual.get_children():
		child.queue_free()

	if memory_data.memory_model_scene:
		var model_instance = memory_data.memory_model_scene.instantiate()
		visual.add_child(model_instance)
	elif memory_data.memory_mesh:
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = memory_data.memory_mesh
		if memory_data.memory_material:
			mesh_instance.set_surface_override_material(0, memory_data.memory_material)
		visual.add_child(mesh_instance)
