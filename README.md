# sobrio-skills

Dupla de *Agent Skills* para programar con criterio de ingeniería y auditar cambios con evidencia verificable (compatible con Antigravity/Gemini, Codex, Claude Code y `~/.agents/skills`).

## El pipeline (en orden)

```text
[1. Antes / Durante]  diseno-sobrio          ──► Fuente única de verdad, "Good Taste", cero sobre-ingeniería
         │
         ▼
[2. Al cerrar diff]   revision-con-evidencia ──► 5 ejes de fallo + falsación + evidencia real de ejecución
```

1. **`diseno-sobrio`** *(ofensiva)*: impone un contrato breve antes de escribir código, limita la indentación a 3 niveles, prohíbe abstracciones especulativas y separa el núcleo puro de la capa de I/O.
2. **`revision-con-evidencia`** *(defensiva)*: recorre 5 ejes atómicos sobre el `diff` o código existente (TOCTOU, simetría en llamadores/errores/limpieza, alcance de mutaciones, normalización en fronteras y concurrencia/`flock`/I/O parcial), exige intentar refutar cada sospecha y calibra el reporte en **Confirmado / Hipótesis pendiente / Refutado**.

## Instalación

```bash
git clone https://github.com/ferzb7/sobrio-skills.git
cd sobrio-skills
chmod +x install.sh
./install.sh
```

El instalador enlaza ambas skills mediante symlinks en:
- `~/.gemini/config/skills/`
- `~/.codex/skills/`
- `~/.claude/skills/`
- `~/.agents/skills/`

## Licencia

MIT
