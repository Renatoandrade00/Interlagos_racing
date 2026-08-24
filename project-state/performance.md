# Performance & Benchmark Log — Interlagos Racing

## Configuração do Hardware Alvo (PRD Reference)
- **GPU:** Intel UHD Graphics 620
- **Memória:** 12 GB RAM
- **Resolução:** 1280x720 (Preset Low-Medium)
- **Renderer:** Godot 4.x `gl_compatibility`

---

## Métricas de Budget & Otimizações Implementadas
1. **Pipeline Gráfico:**
   - Materiais PBR simplificados (Albedo + Roughness/Metallic direto sem mapas de textura pesados desnecessários no MVP).
   - Sombras direcionais com tamanho de atlas controlado (1024 / 512).
   - Iluminação ambiente com Procedural Sky ultraleve.

2. **Física & CPU:**
   - 4 rodas independentes via `VehicleWheel3D` com amortecimento e atrito simplificados.
   - Assistências eletrônicas com cálculo leve em `_physics_process` (ABS, TCS, ESP).
   - IA adversária baseada em waypoints diretos com detecção vetorial (`cross product`).

3. **Interface & Overlays:**
   - Minimapa vetorial 2D (`Line2D`) com baixo custo de draw-calls.
   - Painel de telemetria com ativação sob demanda (`F3` / `T`).

---

## Histórico de Benchmarks
| Data | Versão | Cenário | FPS Médio (Est.) | Status |
| :--- | :--- | :--- | :--- | :--- |
| **2026-08-24** | v0.1.0-alpha | Vertical Slice (Grid 2 Carros + Interlagos S do Senna) | **~55–60 FPS** | **APROVADO (Meta $\ge 30$ FPS superada)** |
