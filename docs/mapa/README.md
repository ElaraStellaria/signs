# Scripts de mapas — SEÑALES

Scripts en Python que generan las maquetas y diagramas del proyecto.
Todo se dibuja por código, así que cambiando números podés reajustar el layout sin rehacer nada.

## Requisitos

Solo hace falta Pillow:

```bash
pip install pillow
```

En Termux:

```bash
pkg install python
pip install pillow
```

## Uso

Ejecutar cada script desde su carpeta. El PNG se genera al lado.

```bash
python3 mapa_barrio.py       # → SENALES_maqueta_mapa_v2.png
python3 mapa_reves.py        # → SENALES_maqueta_reves.png
python3 diagrama_zonas.py    # → SENALES_mapa_barrio.png
python3 diagrama_flujo.py    # → SENALES_flujo_narrativo.png
```

## Qué hace cada uno

| Script | Genera |
| :---- | :---- |
| `mapa_barrio.py` | Maqueta/blockout del barrio real · 250×180 tiles |
| `mapa_reves.py` | Maqueta de El Revés · 200×150 tiles |
| `diagrama_zonas.py` | Diagrama esquemático de zonas y conexiones |
| `diagrama_flujo.py` | Flujo narrativo de los 5 actos + interludios de Pablo |

---

## Cómo modificar los mapas

### Tamaño del mundo

Arriba de todo en `mapa_barrio.py`:

```python
TILE = 8          # px por tile EN LA IMAGEN (no en el juego)
MW, MH = 250, 180 # ancho y alto del mundo EN TILES
```

`TILE` solo afecta la resolución de la imagen. Si querés la maqueta más grande para
imprimirla o verla en detalle, subilo a 12 o 16.

`MW, MH` es el tamaño real del mundo. Si lo cambiás, tenés que reubicar las zonas.

### Funciones de dibujo

Todas trabajan en **coordenadas de tile**, no en píxeles:

```python
rect(tx, ty, tw, th, color)      # rectángulo
ell(tx, ty, tw, th, color)       # elipse
line([(x1,y1),(x2,y2)], color, w)  # línea
checker(tx, ty, tw, th, c1, c2, paso)  # damero (para pasto, baldosas)
```

Ejemplo — mover Casa Torres:

```python
rect(6,68,9,6,(176,104,80))   # cambiá el 6,68 por la nueva posición
```

### Helpers de nivel alto

```python
bldg(tx,ty,tw,th,roof)   # edificio con tanque de agua y sombra
house(tx,ty,tw,th,roof)  # casa baja
block(bx,by,bw,bh)       # manzana entera de casas con patio
road_h(x,w,y,h)          # calle horizontal con veredas y línea central
road_v(x,y,h,w)          # calle vertical
```

Para agregar una manzana nueva al residencial:

```python
block(4,66,54,48)   # x, y, ancho, alto — todo en tiles
```

### Marcadores

```python
marker(tx, ty, COLOR, "etiqueta", "r")   # "r" o "l" = lado de la etiqueta
```

Colores ya definidos: `PINK` (señales), `GOLD` (anclajes), `VIOLET` (grietas/jefes), `TEAL` (zona neutral), `RED` (jefes), `AMBER` (guardianes).

Para mover una señal, buscá la lista:

```python
for tx,ty,l,s in [(10,80,"S1 Graciela","r"), ...]:
```

y cambiá las coordenadas.

### Etiquetas de zona

```python
zlabel(2, 64, "0", "RESIDENCIAL / CASA TORRES")
```

### Paleta

Todos los colores están declarados arriba como constantes RGB. Cambiando estos
valores cambiás la paleta del mapa entero de una:

```python
ROOF_A=(168,96,74)   # terracota
GRASS=(86,126,78)
PLAZA=(198,184,150)
```

---

## Nota sobre el aleatorio

Los scripts usan `random.seed(11)` para que el resultado sea siempre igual.
Si cambiás ese número, se redistribuyen los edificios, árboles y toldos —
útil si querés probar variantes del mismo layout.

---

## Pasar las coordenadas a Godot

Las coordenadas de tile de la maqueta se traducen directo a `Vector2i` en el TileMapLayer.

Ejemplo: el sauce viejo con la grieta está en la maqueta alrededor de `(224,108)`.
En Godot, ese tile lleva custom data:

```gdscript
# TileSet > Custom Data Layers
tipo: "zona_revers"
```

Y en `datos_interactuables.gd`:

```gdscript
const PARQUE: Dictionary = {
    Vector2i(224, 108): {
        'tipo': 'zona_revers',
        'destino': 'res://scenes/world/RevesParque.tscn'
    },
}
```

Ojo: si construís cada zona como su propia escena `.tscn` (recomendado), las
coordenadas locales de esa escena arrancan de cero. La maqueta te da la posición
**relativa dentro del mundo**, útil para mantener las proporciones coherentes
entre zonas, no para copiar el número tal cual.
