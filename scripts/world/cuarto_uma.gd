#cuarto_uma.gd
extends Node2D

@onready var uma = $Uma
@onready var luz1 = $luz1
@onready var luz2 = $luz2

	
func _ready() -> void:
	uma.set_interactuables(DatosInteractuables.CUARTO_UMA)
	uma.set_sonidos_pasos(SonidosPasos.CUARTO_UMA)
	uma.recibirNodo(luz1, luz2)
	
	
	InventarioManager.agregar_consumible("medialunas", 3)
	InventarioManager.agregar_consumible("mate", 1)
	InventarioManager.agregar_senal(1)
	InventarioManager.agregar_senal(2)
	InventarioManager.agregar_fragmento(10)
	
