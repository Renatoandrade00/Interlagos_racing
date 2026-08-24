# Primeiros Passos: Sprint 0 (Bootstrap) & Vertical Slice (M1)

**Objetivo Imediato:** Configurar o ambiente técnico de desenvolvimento e iniciar a implementação do **Vertical Slice jogável**.

---

## Ordem de Execução Recomendada

### 1. Inicialização do Projeto Godot 4.x (Compatibility Renderer)
- **Arquivo:** `project.godot`
- **Configurações essenciais:**
  - `rendering/renderer/rendering_method="gl_compatibility"` (crucial para rodar liso na Intel UHD 620).
  - `display/window/size/viewport_width=1280` e `viewport_height=720` (com modo de esticamento `canvas_items` ou `viewport`).
  - Mapeamento inicial de inputs: `throttle`, `brake`, `steer_left`, `steer_right`, `handbrake`, `shift_up`, `shift_down`, `reset_car`.

### 2. Criação do Veículo Protótipo (M1 - CAR-001 & PHY-001)
- **Pasta:** `Vehicles/`
- **Estrutura:**
  - `VehicleBase.gd`: Lógica de gerenciamento do carro (input, câmera, telemetria).
  - `VehiclePhysics.gd`: Motor de física (Raycast suspension ou VehicleBody3D com suspensão configurada, curva de torque, frenagem e fricção de pneus).
  - Arquivo de configuração `car_prototype.tres` ou `.json` com peso, potência e relações de marcha.

### 3. Criação do Trecho de Pista do Vertical Slice (M1 - TRK-001)
- **Pasta:** `Tracks/Interlagos/`
- **Trecho:** Reta dos boxes -> *S do Senna* -> *Curva do Sol* -> *Reta Oposta*.
- **Mesh:** Superfície de asfalto com colisor, elevação com descida do S do Senna, zebras básicas com colisão suave.

### 4. Sistema de Câmeras & HUD (M1 - CAM-001 & HUD-001)
- **Chase Cam:** Câmera terceira pessoa suave que acompanha a aceleração e guinada do carro.
- **HUD:** Mostrador de velocidade (km/h), barra de RPM com redline e indicador de marcha (1..6 / R).

### 5. Configuração do Script de QA Agent & Test Harness (M0 - ARCH-006)
- **Pasta:** `Tools/QA/`
- Testes automatizados de física (aceleração 0-100 km/h, frenagem 100-0, cálculo de FPS).
