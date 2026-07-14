extends CharacterBody2D
class_name player

# Declare member variables here. Examples:
@export var speed = 400
var Movimiento = Vector2()
var right = Input.is_action_pressed("ui_right")
var left = Input.is_action_pressed("ui_left")
var up = Input.is_action_pressed("ui_up")
var down = Input.is_action_pressed("ui_down")

# Called when the node enters the scene tree for the first time.
func _ready():
	
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Movimiento.x = (int(right) - int(left)) * speed
	Movimiento.y = (int(down) - int(up)) * speed
	position += Movimiento * delta
