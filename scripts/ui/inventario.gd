#inventario.gd
extends CanvasLayer

@onready var tab_container    = $Fondo/Panel/VBoxContainer/TabContainer
@onready var grid_senales     = $Fondo/Panel/VBoxContainer/TabContainer/Señales/GridContainer
@onready var grid_consumibles = $Fondo/Panel/VBoxContainer/TabContainer/Mochila/VBox/GridConsumibles
@onready var slot_1           = $Fondo/Panel/VBoxContainer/TabContainer/Mochila/VBox/Slots/Slot1
@onready var slot_2           = $Fondo/Panel/VBoxContainer/TabContainer/Mochila/VBox/Slots/Slot2
@onready var slot_3           = $Fondo/Panel/VBoxContainer/TabContainer/Mochila/VBox/Slots/Slot3
@onready var grid_fragmentos  = $Fondo/Panel/VBoxContainer/TabContainer/Fragmentos/VBoxContainer
@onready var panel_detalle    = $Fondo/Panel/VBoxContainer/PanelDetalle
@onready var label_detalle    = $Fondo/Panel/VBoxContainer/PanelDetalle/Label

const SLOT_SCENE = preload("res://scenes/ui/item_slot.tscn")

var item_seleccionado: String = ""
var slot_seleccionado: Control = null   # el slot actualmente seleccionado
var id_seleccionado: String = ""        # el ID del item seleccionado

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	$Fondo/Panel/VBoxContainer/HBox_Header/BtnCerrar.pressed.connect(cerrar)
	$Fondo/Panel/VBoxContainer/PanelDetalle/BtnUsar.pressed.connect(_on_btn_usar_pressed)

func abrir() -> void:
	get_tree().paused = true
	_refrescar()
	show()

func cerrar() -> void:
	get_tree().paused = false
	hide()

func _refrescar() -> void:
	_refrescar_senales()
	_refrescar_consumibles()
	_refrescar_equipamiento()
	_refrescar_fragmentos()

func _refrescar_senales() -> void:
	for child in grid_senales.get_children():
		child.queue_free()

	for id in InventarioManager.get_senales():
		var datos = ItemsData.SEÑALES.get(id)
		if datos == null:
			continue

		var slot = SLOT_SCENE.instantiate()
		grid_senales.add_child(slot)

		var item_data = {
			"id": str(id),
			"icono": datos["icono"],
			"nombre": datos["titulo"]
		}

		slot.setup(item_data)
		slot.presionado.connect(func(): _mostrar_detalle_senal(id))

func _refrescar_consumibles() -> void:
	for child in grid_consumibles.get_children():
		child.queue_free()

	var consumibles = InventarioManager.get_consumibles()

	for item in consumibles:
		var datos = ItemsData.ITEMS.get(item["id"])
		if datos == null:
			continue

		var slot = SLOT_SCENE.instantiate()
		grid_consumibles.add_child(slot)

		# 🔥 unificamos datos
		var item_data = datos.duplicate()
		item_data["id"] = item["id"]
		item_data["cantidad"] = item["cantidad"]

		slot.setup(item_data)
		slot.presionado.connect(_on_slot_click.bind(slot))

	# Slots vacíos
	var total_celdas = 12
	var vacios = total_celdas - consumibles.size()

	for i in vacios:
		var slot = SLOT_SCENE.instantiate()
		grid_consumibles.add_child(slot)
		slot.setup({})
		slot.presionado.connect(_on_slot_click.bind(slot))

func _refrescar_equipamiento() -> void:
	var equip = InventarioManager.get_equipamiento()
	_actualizar_slot_ui(slot_1, equip.get("slot_1"))
	_actualizar_slot_ui(slot_2, equip.get("slot_2"))
	_actualizar_slot_ui(slot_3, equip.get("slot_3"))

func _actualizar_slot_ui(nodo_slot, id) -> void:
	if id == null or id == "":
		nodo_slot.limpiar()
		return

	var datos = ItemsData.ITEMS.get(id)
	if datos:
		var item_data = datos.duplicate()
		item_data["id"] = id

		nodo_slot.setup(item_data)
		nodo_slot.presionado.connect(func(): _mostrar_detalle_item(id))

func _refrescar_fragmentos() -> void:
	for child in grid_fragmentos.get_children():
		child.queue_free()
	for id in InventarioManager.get_fragmentos():
		var datos = ItemsData.FRAGMENTOS.get(id)
		if datos == null:
			continue
		var label = Label.new()
		label.text = datos["titulo"]
		label.gui_input.connect(func(e): 
			if e is InputEventMouseButton and e.pressed:
				_mostrar_detalle_fragmento(id))
		grid_fragmentos.add_child(label)

func _seleccionar_consumible(id: String) -> void:
	var datos = ItemsData.ITEMS.get(id)
	if datos == null:
		return
	label_detalle.text = datos["nombre"] + "\n\n" + datos["descripcion"]
	panel_detalle.show()
	item_seleccionado = id

func _mostrar_detalle_item(id: String) -> void:
	var datos = ItemsData.ITEMS.get(id)
	if datos == null:
		return
	label_detalle.text = datos["nombre"] + "\n\n" + datos["descripcion"]
	panel_detalle.show()

func _mostrar_detalle_senal(id: int) -> void:
	var datos = ItemsData.SEÑALES.get(id)
	if datos == null:
		return
	label_detalle.text = datos["titulo"] + "\n\n" + datos["texto"]
	panel_detalle.show()

func _mostrar_detalle_fragmento(id: int) -> void:
	var datos = ItemsData.FRAGMENTOS.get(id)
	if datos == null:
		return
	label_detalle.text = datos["titulo"] + "\n\n" + datos["texto"]
	panel_detalle.show()

func _on_btn_usar_pressed() -> void:
	if item_seleccionado == "":
		return
	InventarioManager.usar_consumible(item_seleccionado)
	item_seleccionado = ""
	panel_detalle.hide()
	_refrescar_consumibles()

func _on_btn_cerrar_pressed() -> void:
	cerrar()
	
func _on_slot_presionado(slot: Control, id: String) -> void:
	# Si no hay nada seleccionado — seleccionar este slot
	if slot_seleccionado == null:
		if id == "":
			return  # slot vacío, nada que seleccionar
		slot_seleccionado = slot
		id_seleccionado   = id
		slot.seleccionar()
		_mostrar_detalle_item(id)
		return
	
	# Si se toca el mismo slot — deseleccionar
	if slot_seleccionado == slot:
		slot_seleccionado.deseleccionar()
		slot_seleccionado = null
		id_seleccionado   = ""
		panel_detalle.hide()
		return
	
	# Si hay uno seleccionado y se toca otro — intercambiar
	_intercambiar_slots(slot_seleccionado, id_seleccionado, slot, id)
	slot_seleccionado.deseleccionar()
	slot_seleccionado = null
	id_seleccionado   = ""

func _intercambiar_slots(_slot_a: Control, id_a: String, slot_b: Control, id_b: String) -> void:
	# Solo consumibles pueden intercambiarse entre celdas del grid
	# El equipamiento solo puede ir a sus slots fijos

	var datos_a = ItemsData.ITEMS.get(id_a)
	var datos_b = ItemsData.ITEMS.get(id_b) if id_b != "" else null

	if datos_a == null:
		return

	# Si el destino es un slot de equipamiento
	if slot_b.es_slot_equipo:
		if datos_a["tipo"] == "equipamiento" and datos_a["slot"] == slot_b.name.to_lower():
			InventarioManager.equipar(id_a)
			# Si habia algo en el slot de equipo, va al inventario general
			if id_b != "":
				InventarioManager.desequipar(slot_b.name.to_lower())
			_refrescar()
		return

	# Si ambos son consumibles — solo reordenar visualmente
	# El orden en el array del save no importa para la lógica
	# pero podemos reordenar para que se vea bien
	_reordenar_consumibles(id_a, id_b)
	_refrescar_consumibles()

func _reordenar_consumibles(id_a: String, id_b: String) -> void:
	var lista = InventarioManager.get_consumibles()
	var idx_a = -1
	var idx_b = -1
	for i in lista.size():
		if lista[i]["id"] == id_a: idx_a = i
		if lista[i]["id"] == id_b: idx_b = i
	if idx_a == -1: return
	if idx_b == -1:
		# destino vacío — mover el item al final (no hace nada visible)
		return
	# Intercambiar posiciones en el array
	var temp = lista[idx_a].duplicate()
	lista[idx_a] = lista[idx_b].duplicate()
	lista[idx_b] = temp
	SaveManager.set_inventario("consumibles", lista)
	SaveManager.guardar()

func _on_slot_click(slot: Control) -> void:
	var id = slot.item_id

	# Seleccionar
	if slot_seleccionado == null:
		if id == "":
			return

		slot_seleccionado = slot
		id_seleccionado = id
		slot.seleccionar()
		_mostrar_detalle_item(id)
		return

	# Deseleccionar
	if slot_seleccionado == slot:
		slot.deseleccionar()
		slot_seleccionado = null
		id_seleccionado = ""
		panel_detalle.hide()
		return

	# Intercambiar
	_intercambiar_slots(slot_seleccionado, id_seleccionado, slot, id)

	slot_seleccionado.deseleccionar()
	slot_seleccionado = null
	id_seleccionado = ""
