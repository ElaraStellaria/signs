# SEÑALES — El Umbral del Barrio
### Índice de archivos del proyecto

---

## 📕 Documentos

| Archivo | Páginas | Contenido |
| :---- | :---- | :---- |
| **`SENALES_DOCUMENTO_MAESTRO.docx`** | 76 | **Todo junto.** Historia, personajes, mundo, sistemas, misiones, guiones, diálogos ambientales, biblia de arte y anexo gráfico. |
| `SENALES_GDD_v3.docx` | 55 | Diseño de juego: historia, personajes, mundo, sistemas, misiones, guiones de diálogo. |
| `SENALES_dialogos_ambientales.docx` | 11 | Los 18 discos, inspecciones, barks por acto, cierres del Acto V, líneas de sistema. |
| `SENALES_biblia_arte.docx` | 10 | Specs técnicas, lista de ~1100 assets con prioridad P1-P4, notas de dirección de arte. |

**Cuál usar:** el maestro para buscar o hacer backup. Los separados para trabajar — cuando estés dibujando abrís solo la biblia de arte.

---

## 🗺️ Maquetas y diagramas

| Archivo | Contenido |
| :---- | :---- |
| `SENALES_maqueta_mapa_v2.png` | Blockout del barrio real · 250×180 tiles |
| `SENALES_maqueta_reves.png` | Blockout de El Revés · 200×150 tiles |
| `SENALES_mapa_barrio.png` | Diagrama de zonas y conexiones |
| `SENALES_flujo_narrativo.png` | Los 5 actos + interludios en paralelo |
| `SENALES_paleta.png` | Paleta maestra · 70 colores con hex |

---

## 📐 Hojas de construcción — carpeta `zonas/`

Barrio real:

| Archivo | Zona | Tiles |
| :---- | :---- | :---- |
| `zona0_casa_torres.png` | Casa Torres (interior) | 40×30 |
| `zona1_calle_principal.png` | Calle Principal | 60×40 |
| `zona2_plaza_mayor.png` | Plaza Mayor | 70×50 |
| `zona3_mercado_viejo.png` | Mercado Viejo | 60×45 |
| `zona4_parque_ribereno.png` | Parque Ribereño | 90×50 |
| `zona5_zona_alta.png` | Zona Alta | 80×60 |
| `zona7_el_mirador.png` | El Mirador | 30×25 |

El Revés:

| Archivo | Sub-zona | Tiles |
| :---- | :---- | :---- |
| `reves_A_reves_de_plaza_mayor.png` | árbol invertido · Jefe II | 60×50 |
| `reves_B_reves_del_mercado.png` | laberíntico | 55×45 |
| `reves_C_reves_del_parque.png` | agua invertida | 65×45 |
| `reves_D_reves_de_zona_alta.png` | tiempo inestable | 60×35 |
| `reves_T_el_telar.png` | El Telar · núcleo | 35×35 |

---

## 🎬 Hojas de interludio — carpeta `interludios/`

| Archivo | Interludio | Tiles |
| :---- | :---- | :---- |
| `interludio_I_el_papel_doblado_tres_veces.png` | I · cierre del Prólogo | 8×7 |
| `interludio_II_cinco_cuadras.png` | II · cierre del Acto I | 14×5 |
| `interludio_III_lo_que_dijo_hernan.png` | III · mitad del Acto II | 7×6 |
| `interludio_IV_la_entrevista.png` | IV · cierre del Acto II | 9×5 |
| `interludio_V_tres_semanas.png` | V · antes del Acto III | 10×6 |

---

## 🐍 Scripts — carpeta `scripts_mapas/`

Todos los gráficos se regeneran con Python + Pillow. Requisito: `pip install pillow`.

| Script | Genera |
| :---- | :---- |
| `mapa_barrio.py` | Maqueta del barrio real |
| `mapa_reves.py` | Maqueta de El Revés |
| `hojas_zonas.py` | Las 7 hojas de zona del barrio |
| `hojas_reves.py` | Las 5 hojas de El Revés |
| `hojas_interludios.py` | Las 5 hojas de interludio |
| `diagrama_zonas.py` | Diagrama de zonas |
| `diagrama_flujo.py` | Flujo narrativo |
| `paleta.py` | Hoja de paleta maestra |
| `README.md` | Cómo modificar cada uno |

---

## ▶️ Por dónde seguir

**Diseño:** terminado. No queda ninguna escena sin layout ni ningún personaje sin arco.

**Lo que sigue es producir.** Orden sugerido (sección 8.1 de la biblia de arte):

1. Tileset de interiores (32 tiles) → armar Casa Torres
2. Uma: idle + caminar 4 direcciones (16 frames)
3. Cuadro de diálogo + indicador de interacción
4. Bautista, Natalia, Darío (idles) → Prólogo jugable
5. Tileset de calle → salir a la Calle Principal
6. Graciela + Chino → primera visita del Acto I
7. El ícono de la señal de Pablo

Con esos 7 puntos tenés el vertical slice: 15-25 minutos de juego real.

**Pendiente de escribir (requiere ver tu código):**

- `save_manager.gd` — la base de todo lo demás
- `datos_interactuables.gd` — poblado con las coordenadas de las hojas de zona
- Los archivos `.dialogue` de la Parte IX
- `pablo.gd` + las 5 escenas de interludio

---

*Bit Hunter Dev · 2026*
