# res://scripts/memories/MemoryData.gd
extends Resource
class_name MemoryData

@export var memory_id: String
@export var memory_text: String
@export var memory_image: Texture2D
@export var memory_audio: AudioStream

# OPCIÓN 1: Malla + material
@export var memory_mesh: Mesh
@export var memory_material: Material

# OPCIÓN 2: Escena 3D completa (por ejemplo, un glb)
@export var memory_model_scene: PackedScene
