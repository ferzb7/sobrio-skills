---
name: revision-con-evidencia
description: Usar al auditar o programar código, diffs, flujos con estado, checkpoints, cachés, permisos, concurrencia o reintentos para detectar y prevenir fallos de correctitud, corrupción de estado, pérdida de datos o regresiones.
---

# Revisión y Construcción con Evidencia

Regla base: **precisión antes que complacencia**. Nunca inventes fallos para parecer riguroso ni valides código sin trazar su ejecución real.

## 1. Modo de operación y contrato

1. Identifica el modo según la petición:
   - **Modo Auditoría (por defecto):** solo diagnostica; no edites archivos salvo que el usuario lo pida.
   - **Modo Programación / Corrección:** cuando el usuario pida implementar o arreglar algo, reproduce o fija primero el invariante en un test mínimo, implementa el cambio mínimo y **vuelve a pasar la Sección 2 sobre tu propio diff** antes de dar la tarea por terminada.
2. Delimita entradas válidas, contrato esperado y qué efecto lo violaría. Respeta los límites de archivos y herramientas permitidos.

## 2. Cinco ejes de fallo (Checklist atómico)

Recorre cada eje con preguntas binarias (no te detengas en el primer defecto):

1. **Orden de validación, mutación y uso (TOCTOU):**
   - ¿Puede cambiar una condición o archivo entre que se valida y se usa?
   - Si una comprobación tardía falla, ¿quedan efectos parciales en memoria o disco sin revertir?
   - En un reintento tras fallo, ¿el estado resultante permite avanzar o repite el bloqueo?
2. **Simetría entre llamadores y ramas de error:**
   - ¿Todos los llamadores **y métodos auxiliares** (limpieza, purga, borrado) aplican las mismas guardas (locks, permisos, aislamiento, rollback)?
   - ¿Alguna rama `except` / `catch` / retorno temprano oculta un fallo real bajo un diagnóstico falso o deja recursos sin cerrar?
3. **Alcance de mutaciones y propagación de estado:**
   - En bucles, cascadas o actualizaciones por lote, ¿hay guardas para no sobrescribir elementos ya completados, fallidos o bloqueados?
   - ¿Se distingue un reseteo exigido por el contrato de una pérdida accidental de estado?
4. **Representación y normalización en fronteras:**
   - ¿Qué pasa con rutas relativas vs. absolutas, `..`, symlinks, cadenas vacías, `None` o valores centinela que vienen de fuera?
   - Si el fallo solo ocurre bajo cierta representación, ¿quedó separado del impacto general?
5. **Concurrencia, bloqueos e I/O parcial:**
   - Si dos procesos ejecutan esto a la vez, ¿hay exclusión mutua real (`flock` / locks) y se evita borrar el archivo `.lock` mientras otros procesos puedan esperar sobre su inodo?
   - Si llega `SIGKILL` o falla el disco a mitad de escritura, ¿el archivo destino sobrevive íntegro (escritura temporal + `fsync` + reemplazo atómico)?

## 3. Falsación obligatoria (antes de afirmar un bug)

- Traza una entrada concreta desde el punto público hasta el efecto leyendo llamadores, ejecutores y tests accesibles.
- Antes de afirmar *"nunca se asigna"* o *"siempre falla"*, busca escrituras indirectas o normalizaciones en la entrada.
- Si puedes ejecutar código: construye una reproducción mínima en archivos temporales sobre el motor real. Registra comando, código de salida y salida real; si simulas una pieza, decláralo.
- Si solo hay análisis estático: etiqueta la evidencia como **estática** e indica qué archivo o prueba falta para cerrarla.

## 4. Calibración y formato de entrega

Clasifica por severidad (**Crítico**: pérdida/corrupción de datos o bypass de seguridad; **Alto**: fallo funcional o bloqueo; **Medio**: regresión acotada o asimetría; **Bajo**: borde menor) y certeza:

- **Confirmado:** evidencia completa en código o ejecución. Usa exactamente estos campos:
  - `[Severidad] Título` (`archivo:línea`)
  - **Entrada/Estado mínimo:** ...
  - **Esperado vs. Observado:** ...
  - **Consecuencia:** ...
- **Hipótesis pendiente:** depende de código o datos no vistos. Pon la condición en el título (*"Si [condición], entonces [efecto]"*), indica qué hecho sí comprobaste y **exclúyela del veredicto**.
- **Refutado:** sospecha descartada tras verificar (inclúyela brevemente si evita falsos positivos).

**Si no hay hallazgos confirmados:** dilo explícitamente (*"Sin fallos confirmados en el alcance revisado"*), lista las comprobaciones ejecutadas y no inventes observaciones menores de relleno.

**Veredicto final:** apóyalo únicamente en hallazgos **Confirmados** (o en tests ejecutados tras el último cambio en Modo Programación) y declara el alcance exacto revisado.
