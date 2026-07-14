extends Node2D

# Aqui crearemos todos los estados necesarios para el personaje
enum State {IDLE, ACTION}
var _state = State.IDLE

# Aqui crearemos las acciones disponible para el personaje
enum Action {NONE ,WAIT, MOVE, ATTACK}
var _action = Action.NONE

# Constantes a usar
const CELL_SIZE = Vector2i(120,120)

# Variables exportadas para editarlas en el entorno
@export var speed: float = 1.0

# Variables usadas para conectar nodos
@onready var tile_map = $"../TileMap"

# Declaramos el AstarGrid2D
var astar: AStarGrid2D
var current_id_path: Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready():
	astar = AStarGrid2D.new()
	astar.region = tile_map.get_used_rect()
	astar.cell_size = CELL_SIZE
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	_change_state(State.IDLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _action == Action.MOVE && not current_id_path.is_empty():
		var target_position = tile_map.map_to_local(current_id_path.front())
		_move_to(target_position)


# Funcion para crear inputs para cambiar de estado
func _input(event):
	if _state == State.IDLE: # por alguna razon se queda pillado si pongo esto
		if event.is_action_pressed("Action_on"):
			_change_state(State.ACTION)
	if event.is_action_pressed("Attack"):
		_choose_action(Action.ATTACK)
	if event.is_action_pressed("Move"):
		_choose_action(Action.MOVE)
	if event.is_action_pressed("Wait"):
		_choose_action(Action.WAIT)

# Funcion que se ejecuta para el estado MOVE
func _move_to(target_position):
	global_position = global_position.move_toward(target_position,speed)
	
	if global_position == target_position:
		current_id_path.pop_front()
	if current_id_path.is_empty() && _action == Action.MOVE:
		_change_state(State.IDLE)

# Maquina de estados para las distintas acciones de nuestro player
func _change_state(new_state):
	if _state == State.IDLE:
		print("IDLE")
	if _state == State.ACTION:
		_check_path()
		print("ACTION MENU")
		print("Pulse A to Attack, M to Move or W to Wait on site")
	_state = new_state

# Funcion para elegir accion
func _choose_action(new_action):
	if _state == State.ACTION:
		if _action == Action.WAIT:
			print("WAIT")
		if _action == Action.MOVE:
			print("MOVE")
		if _action == Action.ATTACK:
			print("ATTACK")
		_action = new_action
	else: _action = Action.NONE

# Funcion para saber si el path está vacío o no
func _check_path():
	var id_path = astar.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(get_global_mouse_position())
		).slice(1) # desplazamos 1 el vector para evitar la casilla actual
	if not id_path.is_empty():
			current_id_path = id_path
	print(id_path)

# Funcion para atacar
func _attack_to(target):
	pass
	
# PDTE ARREGLAR QUE EXISTA UN ORDEN PARA PULSAR LAS TECLAS Y NO
# SE SUPERPONGAN LOS INPUTS
