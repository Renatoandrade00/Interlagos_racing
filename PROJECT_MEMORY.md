# Memória do Projeto — Interlagos Racing (Persistent Knowledge & Architecture Decisions)

**Projeto:** Interlagos Racing  
**Modelo:** AI-First / Multi-Agent Architecture  
**Data de Atualização:** 2026-08-24  

---

## 1. Decisões Arquiteturais Fundamentais

### 1.1 Renderer & Target de Hardware
- **Decisão:** Uso estrito do **`gl_compatibility` (OpenGL)** no Godot 4.x com viewport nativo a **1280x720**.
- **Justificativa:** Garantir no mínimo 30–45+ FPS contínuos em GPUs integradas como a **Intel UHD Graphics 620** sem sobrecarga de pipelines dinâmicos pesados de luz/sombra.

### 1.2 Desacoplamento Físico de Veículos
- **Decisão:** Criação da classe de recurso [`VehicleData.gd`](file:///d:/Renato/PROJETOS/06%20-%20GAME%20TESTE/Vehicles/VehicleData.gd) e arquivos `.tres`.
- **Justificativa:** Agentes e designers podem calibrar relações de marcha, torque, peso e atrito sem mexer no script core [`VehicleBase.gd`](file:///d:/Renato/PROJETOS/06%20-%20GAME%20TESTE/Vehicles/VehicleBase.gd), eliminando riscos de regressão no motor físico.

### 1.3 Câmeras & Percepção de Velocidade
- **Decisão:** Sistema de multi-câmeras [`CameraManager.gd`](file:///d:/Renato/PROJETOS/06%20-%20GAME%20TESTE/Core/CameraManager.gd) com interpolação física amortecida e FOV dinâmico responsivo à aceleração.
- **Justificativa:** Aumenta a imersão e transmite com fidelidade a sensação de aceleração típica do benchmark de GT4.

### 1.4 Loop Completo do Vertical Slice
- **Decisão:** Conectar `MainMenu` $\rightarrow$ `CarSelectionMenu` $\rightarrow$ `CountdownController` $\rightarrow$ `LapCheckpointsManager` $\rightarrow$ `RaceResultsScreen`.
- **Justificativa:** Entrega um jogo 100% jogável de ponta a ponta desde a fase inicial de desenvolvimento.

---

## 2. Padrões de Qualidade & Critérios do QA Agent
- **Nota de corte:** **$\ge 8.5 / 10.0$** para aprovação de qualquer milestone.
- **Harness:** [`Tools/qa_evaluator.py`](file:///d:/Renato/PROJETOS/06%20-%20GAME%20TESTE/Tools/qa_evaluator.py) avalia automaticamente conformidade estrutural, boas práticas e integridade do projeto.
