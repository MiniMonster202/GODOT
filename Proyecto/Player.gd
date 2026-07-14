extends CharacterBody2D

const GRAVITY = 1300
const JUMP = -900

@export var speed = 10
@export var vida_max = 100
@export var vida_actual = 100
var is_running = false
var is_punching = false
var is_blocking = false
var combo_max = 100
var combo_actual = 0
var speed1 = speed
var screensize
var barra_de_vida
var barra_de_combo
var direction = Vector2()

func _ready():
	screensize = get_viewport_rect().size
	$Player_Sprite.animation = "Stand"
	barra_de_vida = get_tree().get_nodes_in_group("HP")[0]
	barra_de_combo = get_tree().get_nodes_in_group("CP")[0]


func _physics_process(delta):
	_move(delta)
	_HP_Update()
	_CP_Update()
	
	#CLAMPS (acotar objetos en rangos)
	position.x = clamp(position.x, 0, screensize.x)
	vida_actual = clamp(vida_actual, 0, vida_max)
	combo_actual = clamp(combo_actual, 0, combo_max)


func _move(delta):
	direction.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))) * speed1
	
	if direction.x != 0 and is_punching == false and is_blocking == false: #cambiar sprite con el movimiento
		$Player_Sprite.animation = "MoveRight"
		$Player_Sprite.playing = true
		is_running = true
	
	if direction.y != 0 and is_punching == false and is_blocking == false: #cambiar sprite al saltar
		$Player_Sprite.animation = "jumpUp"
	elif direction.x == 0 and direction.y == 0 and is_punching == false and is_blocking == false: #volver a la sprite inicial si esta quieto
		$Player_Sprite.animation = "Stand"
	
	
	if direction.x > 0: #facing right nothing done
		$Player_Sprite.flip_h = false
	elif direction.x < 0: #facing left flip sprite
		$Player_Sprite.flip_h = true
		
	if Input.is_action_just_pressed("ui_punch") and is_punching == false and is_blocking == false:
		is_punching = true
		if is_on_floor():
			$Player_Sprite.play("Punch")
			velocity.x = 0
			speed1 = 0
		else:
			$Player_Sprite.play("AirPunch")
	
	if Input.is_action_pressed("ui_block") and is_blocking == false and is_punching == false:
		is_blocking = true
		if is_on_floor():
			$Player_Sprite.animation = "Block"
			$Player_Sprite.playing = false
			velocity.x = 0
			speed1 = 0
		elif velocity.y != 0:
			$Player_Sprite.animation = "AirBlock"
			$Player_Sprite.playing = false
			velocity.x = 0
			speed1 = 0

	if is_on_floor() and $Player_Sprite.animation == "AirBlock":
		$Player_Sprite.animation = "Block"
		$Player_Sprite.playing = false
		velocity.x = 0
		speed1 = 0
	
	if is_on_floor() and $Player_Sprite.animation == "AirPunch":
		$Player_Sprite.play("Punch")
		velocity.x = 0
		speed1 = 0
	
	if Input.is_action_just_released("ui_block"):
		is_blocking = false
		$Player_Sprite.animation = "Stand"
		speed1 = speed
	
	
	velocity.x = (direction.x) / delta #formula de la velocidad v = x/t
	velocity.y += GRAVITY * delta #la velocidad incrementa ya que la gravedad es una aceleracion
	set_velocity(velocity)
	set_up_direction(Vector2(0,-1))
	move_and_slide()
	velocity = velocity #(0,-1) vector normal al suelo
	
	if is_on_floor(): 
		direction.y = 0 #al estar en el suelo no hay movimiento en y
		velocity.y = 0 #al estar en el suelo no hay velocidad en y
		
		if Input.is_action_pressed("ui_up") and is_punching == false and is_blocking == false: #salto
			velocity.y = JUMP
			direction.y = 1
		
		if Input.is_action_pressed("ui_down") and is_punching == false and is_blocking == false and is_running == false: #agacharse
			$Player_Sprite.animation = "Down"  


func _HP_Update(): #funcion para actualizar la barra de vida
	barra_de_vida.value = vida_actual * barra_de_vida.max_value / vida_max


func _CP_Update():
	barra_de_combo.value = combo_actual * barra_de_combo.max_value / combo_max

func _on_Player_Sprite_animation_finished():
		is_punching = false
		is_running = false
		speed1 = speed
