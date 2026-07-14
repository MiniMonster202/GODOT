extends Node

# Variables
@onready var Network = ENetMultiplayerPeer.new()
var port = 1989
var max_players = 100

# Ready function : first executed
func _ready():
	StartServer()
	pass

# Functions
func StartServer():
	Network.create_server(port, max_players)
	get_tree().set_multiplayer(Network)
	print("Server started")
	
	Network.connect("peer_connected", Callable(self, "_Peer_connected"))
	Network.connect("peer_disconnected", Callable(self, "_Peer_disconnected"))

func _Peer_connected(id):
	print(str(id) + " Bienvenido a la Liga de las Arenas")

func _Peer_disconnected(id):
	print("Alguien se tilteo y abandono la Liga, F en el chat por " + str(id))
