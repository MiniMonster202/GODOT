extends Node2D

var screen_size = DisplayServer.screen_get_size()
var window_size = DisplayServer.window_get_size_with_decorations()

func _ready():
	get_window().set_position(screen_size * 0.5 - window_size * 0.5)
	get_window().borderless = false
