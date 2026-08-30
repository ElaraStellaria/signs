#items_data.gd
class_name ItemsData

const ITEMS: Dictionary = {
	# ── CONSUMIBLES ──────────────────────────────────────────────────
	"medialunas": {
		"nombre":      "Medialunas",
		"descripcion": "Del kiosco de Chino. Nada mejor para el calor.",
		"tipo":        "consumible",
		"efecto":      "animo",
		"valor":       25,
		"icono":       "res://assets/sprites/ui/telefono.png",
	},
	"mate": {
		"nombre":      "Mate",
		"descripcion": "Recargable en cualquier kiosco. 3 usos por carga.",
		"tipo":        "consumible",
		"efecto":      "animo",
		"valor":       15,
		"icono":       "",
	},
	"alfajor": {
		"nombre":      "Alfajor",
		"descripcion": "30 de Animo. Uma dice que no necesita justificacion.",
		"tipo":        "consumible",
		"efecto":      "animo",
		"valor":       30,
		"icono":       "",
	},
	"esencia_revers": {
		"nombre":      "Esencia del Revers",
		"descripcion": "Energia concentrada de El Revers. 40 de Animo.",
		"tipo":        "consumible",
		"efecto":      "animo",
		"valor":       40,
		"icono":       "",
	},
	# ── EQUIPAMIENTO ─────────────────────────────────────────────────
	"cordones_rosa": {
		"nombre":      "Cordones Rosa",
		"descripcion": "Los de Graciela. Una historia guardada en cada ojal.",
		"tipo":        "equipamiento",
		"slot":        "slot_1",
		"efecto":      "animo_max",
		"valor":       15,
		"icono":       "",
	},
	"guante_resonancia": {
		"nombre":      "Guante de Resonancia",
		"descripcion": "Reduce el cooldown de habilidades un 15%.",
		"tipo":        "equipamiento",
		"slot":        "slot_2",
		"efecto":      "cooldown",
		"valor":       0.15,
		"icono":       "",
	},
	"hilo_carmen": {
		"nombre":      "Hilo de Dona Carmen",
		"descripcion": "Permite entrar al Revers sin grieta cercana.",
		"tipo":        "equipamiento",
		"slot":        "slot_3",
		"efecto":      "revers_libre",
		"valor":       1,
		"icono":       "",
	},
}

# Datos narrativos de las señales — separados de los items comunes
const SEÑALES: Dictionary = {
	1: {
		"titulo":      "Señal 1",
		"texto":       "Siempre te fijas en lo que los demas no ven.",
		"icono":       "",
	},
	2: {
		"titulo":      "Señal 2",
		"texto":       "Hablas con los que estan solos. Eso no es pequeno.",
		"icono":       "",
	},
	# ... agregar el resto
}

# Datos de fragmentos de memoria
const FRAGMENTOS: Dictionary = {
	10: {
		"titulo":      "Diario de Dona Carmen — Entrada 1",
		"texto":       "Los anclajes no son lugares. Son puntos donde alguien dejo algo de si mismo.",
		"icono":       "",
	},
	# ...
}
