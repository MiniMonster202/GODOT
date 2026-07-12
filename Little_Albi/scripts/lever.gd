extends Area3D
class_name Palanca

signal activada          # se emite cuando pasa a estado ON
signal desactivada        # se emite cuando pasa a estado OFF
signal estado_cambiado(activa: bool)  # útil si solo te importa el estado

@export var permite_alternar: bool = true   # false = solo se puede activar una vez (tipo "de un solo uso")
@export var bloqueada: bool = false          # true = ignora interacciones (para lógica de llaves, etc.)
@export var angulo_apagado: float = 45.0
@export var angulo_encendido: float = -45.0
@export var duracion_animacion: float = 0.70

# Arrastra aquí en el editor los nodos que quieras conectar (puertas, mecanismos...)
@export var objetos_conectados: Array[Node] = []

@onready var mesh_palanca: Node3D = $Node3D  # ajusta el nombre/ruta a tu nodo visual

var activa: bool = false
var animando: bool = false
var jugador_en_rango: bool = false


func _ready() -> void:
	mesh_palanca.rotation_degrees.z = angulo_apagado

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") or body.has_method("release_object"):
		jugador_en_rango = true
		print("Puedes tirar de la palanca kronk")


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") or body.has_method("release_object"):
		jugador_en_rango = false
		print("Ya no, kronk")


func _input(event: InputEvent) -> void:
	if jugador_en_rango and event.is_action_pressed("grab"):
		interactuar()


## Llama a esto desde tu sistema de interacción (Area3D del jugador, raycast, etc.)
func interactuar() -> void:
	if bloqueada or animando:
		return
	if activa and not permite_alternar:
		return
	_activar()


func _activar() -> void:
	animando = true
	activa = not activa
	var angulo_destino: float = angulo_encendido if activa else angulo_apagado

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(mesh_palanca, "rotation_degrees:z", angulo_destino, duracion_animacion)
	tween.tween_callback(func(): animando = false)

	estado_cambiado.emit(activa)
	if activa:
		activada.emit()
	else:
		desactivada.emit()

	_notificar_objetos_conectados()


## Conexión genérica: cualquier objeto (puerta, plataforma, luz...) puede
## registrarse aquí, en tiempo de diseño (array exportado) o en tiempo de
## ejecución con este método.
func conectar_objeto(objeto: Node) -> void:
	if objeto == null:
		return
	if not objetos_conectados.has(objeto):
		objetos_conectados.append(objeto)


func desconectar_objeto(objeto: Node) -> void:
	objetos_conectados.erase(objeto)


func _notificar_objetos_conectados() -> void:
	for objeto in objetos_conectados:
		if objeto == null:
			continue
		# Convención: el objeto conectado implementa on_palanca_activada(estado, palanca)
		if objeto.has_method("on_palanca_activada"):
			objeto.on_palanca_activada(activa, self)
		else:
			push_warning("El objeto '%s' no implementa on_palanca_activada(estado, palanca)" % objeto.name)
