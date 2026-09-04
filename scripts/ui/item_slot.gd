#item_slot.gd
extends Button

signal presionado

var item_id: String = ""
var es_slot_equipo: bool = false

@onready var icono = $Panel/MarginContainer/VBoxContainer/TextureRect
@onready var label = $Panel/MarginContainer/VBoxContainer/Label
@onready var seleccion_rect = $SeleccionRect

func _ready() -> void:
	flat = true
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	presionado.emit()

# 🔥 NUEVO: recibe TODO en un solo Dictionary
func setup(item_data: Dictionary) -> void:
	if item_data == null or item_data.is_empty():
		limpiar()
		return

	item_id = item_data.get("id", "")

	var ruta_icono = item_data.get("icono", "")
	var nombre     = item_data.get("nombre", "")
	var cantidad   = item_data.get("cantidad", 0)

	# Icono
	if ruta_icono != "" and ResourceLoader.exists(ruta_icono):
		icono.texture = load(ruta_icono)
		icono.visible = true
	else:
		icono.texture = null
		icono.visible = false

	# Texto
	if cantidad > 1:
		label.text = "x" + str(cantidad)
	else:
		label.text = nombre

func limpiar() -> void:
	item_id = ""
	icono.texture = null
	label.text = ""
	deseleccionar()

func seleccionar() -> void:
	if seleccion_rect:
		seleccion_rect.visible = true

func deseleccionar() -> void:
	if seleccion_rect:
		seleccion_rect.visible = false
