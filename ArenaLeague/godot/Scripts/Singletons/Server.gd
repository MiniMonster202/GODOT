extends Node

# Declare member variables here. Examples:
@onready var Network = ENetConnection.new()
var ip = "127.0.0.1"
var port = 1989

# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectToServer()
	#get_tree().connect("connection_failed", self, "_Connection_failed")
	#get_tree().connect("connected_to_server", self, "_connected_ok")

func ConnectToServer():
	Network.create_client(ip, port)
	get_tree().set_network_peer(Network)

func _connected_ok():
	print("Yeah Son of Bitch I'm in")
	
func _Connection_failed():
	print("Nada a tu casa a jugar, porque aqui no")
