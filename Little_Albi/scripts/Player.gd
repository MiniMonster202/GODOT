extends CharacterBody3D

@export var speed := 5.0
@export var gravity := 9.8
@export var jump_velocity := 6.0

var direction := Vector3.ZERO

func _physics_process(delta):
	# Movimiento lateral en el eje X
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity

	# Movimiento en 2.5D: restringimos Z
	velocity.x = direction.x * speed
	velocity.z = 0

	move_and_slide()
