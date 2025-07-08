extends CharacterBody3D

var grabbed_by = null
@export var push_pull_speed := 2.0
@onready var gravity = 9.8
#Aplicar el agarre
func set_grabbed_by(player):
	grabbed_by = player

#Soltar
func release():
	grabbed_by = null

#Chequeo instantaneo
func _physics_process(delta):
	if grabbed_by:
		# Copia directamente el movimiento lateral del jugador
		var move = Vector3(grabbed_by.direction.x, 0, 0) * push_pull_speed
		velocity.x = move.x
		velocity.y -= gravity * delta # Aplica gravedad para que no flote si es necesario
		move_and_slide()
	else:
		velocity = Vector3.ZERO
