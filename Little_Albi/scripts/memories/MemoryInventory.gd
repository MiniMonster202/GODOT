# res://scripts/memories/MemoryInventory.gd
extends Node
class_name MemoryInventory

var unlocked_memories: Array[MemoryData] = []

func add_memory(memory_data: MemoryData):
	if memory_data not in unlocked_memories:
		unlocked_memories.append(memory_data)

func get_all_memories() -> Array[MemoryData]:
	return unlocked_memories
