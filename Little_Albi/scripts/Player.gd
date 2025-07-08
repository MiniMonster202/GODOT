extends CharacterBody3D

@export var speed := 5.0
@export var gravity := 9.8
@export var jump_velocity := 6.0

# Manejo de Animaciones
@onready var anim_tree = $Model/AnimationPlayer/AnimationTree
@onready var state_machine = $Model/AnimationPlayer/AnimationTree.get("parameters/playback")
var current_state := "Idle" # Estado inicial

var direction := Vector3.ZERO

# Agarrar
var speed_reset := 5.0
var is_grabbing := false
var grabbed_object = null
@export var push_pull_speed := 2.0
@onready var grab_area = $GrabArea

#Función ejecutada al entrar al mundo
func _ready() -> void:
		anim_tree.active = true
		state_machine.travel(current_state) # Estado por defecto

#Función ejecutada cada instante, fisicas
func _physics_process(delta):
	# Giramos el modelo en funcion de la dirección
	if direction.x < 0:
		$Model.scale.x = -1
	elif direction.x > 0:
		$Model.scale.x = 1
	
	# Chequear si tira o empuja para las animaciones
	if is_grabbing:
		if velocity.x == 0: _change_state("Idle")
		if direction.x != 0:
			var relative_pos = global_position.x - grabbed_object.global_position.x
			if sign(direction.x) == sign(relative_pos):
				_change_state("Pull")
			else:
				_change_state("Push")

	
	# Determinar el estado de animación si no está saltando
	if is_on_floor() and not is_grabbing:
		if velocity.x == 0: _change_state("Idle")
		else: _change_state("Run")
	
	# Movimiento lateral en el eje X
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			release_object()
			velocity.y = jump_velocity
			_change_state("Jump")

	# Movimiento en 2.5D: restringimos Z
	velocity.x = direction.x * speed
	velocity.z = 0

	move_and_slide()

#Función para manejar entradas
func _input(event):
	if Input.is_action_just_pressed("grab"):
		print("Intentando agarrar...")
		if not is_grabbing:
			var bodies = grab_area.get_overlapping_bodies()
			print("Cuerpos detectados:", bodies)
			for body in bodies:
				if body.has_method("set_grabbed_by"):
					grabbed_object = body
					body.set_grabbed_by(self)
					print("Agarrando:", grabbed_object.name)
					speed = push_pull_speed
					is_grabbing = true
					break
		else: #Estamos agarrando y queremos soltar presionando otra vez
			release_object()

#Función para generica para soltar objetos
func release_object() -> void:
	if grabbed_object:
		grabbed_object.release()
		speed = speed_reset
		grabbed_object = null
	is_grabbing = false

#Función para cambiar entre animaciones
func _change_state(new_state: String) -> void:
	if new_state != current_state:
		current_state = new_state
		state_machine.travel(current_state)
		print("Estado: ",current_state)
