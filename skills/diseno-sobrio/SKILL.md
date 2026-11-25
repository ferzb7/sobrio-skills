---
name: diseno-sobrio
description: Usar antes de diseñar o programar funcionalidades nuevas, refactors o módulos desde cero para imponer simplicidad radical, diseño centrado en datos ("good taste"), eliminación de casos especiales y cero sobre-ingeniería.
---

# Diseño Sobrio: Ingeniería de Alto Criterio

Principio rector: **"Los malos programadores se preocupan por el código. Los buenos programadores se preocupan por las estructuras de datos y sus relaciones."** — El objetivo es producir el diseño más simple, plano y verificable que resuelva el problema real sin parches ni capas gratuitas.

## 1. Contrato breve antes de escribir código

Antes de crear archivos o editar módulos no triviales, fija en 4 puntos (máximo 8 líneas):
1. **Fuente única de verdad:** qué estructura de datos o archivo en disco manda y cuál es su invariante irrompible.
2. **Eliminación de casos especiales (*Good Taste*):** cómo representas los datos para que los bordes (`inicio`, `vacío`, `expirado`, `último`) sigan el mismo flujo uniforme en vez de acumular `if/else`.
3. **Qué NO vas a construir:** qué abstracciones, patrones o generalizaciones especulativas descartas por innecesarias.
4. **Prueba real prevista:** cómo se verifica el núcleo con entradas reales (sin `unittest.mock` ocultando el flujo principal).

## 2. Reglas de diseño e implementación

1. **Presupuesto de indentación y profundidad:**
   - Máximo 3 niveles de indentación por función. Si sube de ahí, extrae un helper con nombre claro o usa retornos tempranos (*early returns*).
2. **Cero abstracciones especulativas (YAGNI estricto):**
   - Prohibido crear clases base abstractas, fábricas, adaptadores o *wrappers* para un único consumidor.
   - Si una función de 15 líneas resuelve el problema con claridad, no la dividas en 4 archivos.
3. **Causas raíz, cero parches:**
   - Nunca tapes un fallo de diseño con `try/except` genéricos, banderas booleanas extra o `sleep` arbitrarios. Corrige la estructura o el estado que permite el fallo.
4. **Núcleo puro vs. fronteras I/O:**
   - Separa la lógica de decisión pura de la lectura/escritura en disco, red o subprocesos para que el código sea trivial de leer y probar.
5. **Resuelve el 99% real:**
   - No añadas opciones de configuración, hooks ni soporte a formatos que el usuario no pidió.

## 3. Puerta de salida (Sinergia con `revision-con-evidencia`)

Una vez implementado el diseño mínimo:
- Comprueba si alguna abstracción agregada puede eliminarse sin perder claridad.
- Verifica que la solución pasa pruebas reales y aplica `/revision-con-evidencia` sobre el diff para confirmar que la simplicidad no dejó brechas de estado, concurrencia ni fronteras.
