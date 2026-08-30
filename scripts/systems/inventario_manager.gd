#inventario_manager.gd
extends Node

# ── CONSUMIBLES ───────────────────────────────────────────────────────────────

func agregar_consumible(id: String, cantidad: int = 1) -> void:
	var lista: Array = SaveManager.get_inventario("consumibles")
	var encontrado = false
	for item in lista:
		if item["id"] == id:
			item["cantidad"] += cantidad
			encontrado = true
			break
	if not encontrado:
		lista.append({"id": id, "cantidad": cantidad})
	SaveManager.set_inventario("consumibles", lista)
	SaveManager.guardar()

func usar_consumible(id: String) -> bool:
	var lista: Array = SaveManager.get_inventario("consumibles")
	for item in lista:
		if item["id"] == id and item["cantidad"] > 0:
			item["cantidad"] -= 1
			if item["cantidad"] == 0:
				lista.erase(item)
			SaveManager.set_inventario("consumibles", lista)
			_aplicar_efecto_consumible(id)
			SaveManager.guardar()
			return true
	return false

func _aplicar_efecto_consumible(id: String) -> void:
	var datos = ItemsData.ITEMS.get(id)
	if datos == null:
		return
	match datos["efecto"]:
		"animo":
			print("Restaurar animo: +", datos["valor"])

func cantidad_consumible(id: String) -> int:
	var lista: Array = SaveManager.get_inventario("consumibles")
	for item in lista:
		if item["id"] == id:
			return item["cantidad"]
	return 0

# ── EQUIPAMIENTO ──────────────────────────────────────────────────────────────

func equipar(id: String) -> void:
	var datos = ItemsData.ITEMS.get(id)
	if datos == null or datos["tipo"] != "equipamiento":
		return
	var slot = datos["slot"]
	var equip: Dictionary = SaveManager.get_inventario("equipamiento")
	equip[slot] = id
	SaveManager.set_inventario("equipamiento", equip)
	SaveManager.guardar()
	_aplicar_efecto_equip(id)

func desequipar(slot: String) -> void:
	var equip: Dictionary = SaveManager.get_inventario("equipamiento")
	equip[slot] = null
	SaveManager.set_inventario("equipamiento", equip)
	SaveManager.guardar()

func item_en_slot(slot: String) -> String:
	return SaveManager.get_inventario("equipamiento").get(slot, "")

func esta_equipado(id: String) -> bool:
	return id in SaveManager.get_inventario("equipamiento").values()

func _aplicar_efecto_equip(id: String) -> void:
	var datos = ItemsData.ITEMS.get(id)
	if datos == null:
		return
	match datos["efecto"]:
		"animo_max":  print("Animo maximo: +", datos["valor"])
		"cooldown":   print("Cooldown: -", datos["valor"])
		"revers_libre": print("Acceso libre al Revers")

# ── SEÑALES ───────────────────────────────────────────────────────────────────

func agregar_senal(id: int) -> void:
	var senales: Array = SaveManager.get_inventario("señales")
	if id not in senales:
		senales.append(id)
		SaveManager.set_inventario("señales", senales)
		SaveManager.guardar()

func tiene_senal(id: int) -> bool:
	return id in SaveManager.get_inventario("señales")

# ── FRAGMENTOS ────────────────────────────────────────────────────────────────

func agregar_fragmento(id: int) -> void:
	var fragmentos: Array = SaveManager.get_inventario("fragmentos")
	if id not in fragmentos:
		fragmentos.append(id)
		SaveManager.set_inventario("fragmentos", fragmentos)
		SaveManager.guardar()

# ── CONSULTAS ─────────────────────────────────────────────────────────────────

func get_consumibles() -> Array:
	return SaveManager.get_inventario("consumibles")

func get_senales() -> Array:
	return SaveManager.get_inventario("señales")

func get_fragmentos() -> Array:
	return SaveManager.get_inventario("fragmentos")

func get_equipamiento() -> Dictionary:
	return SaveManager.get_inventario("equipamiento")
