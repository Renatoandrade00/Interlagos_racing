# 🏁 Interlagos Racing (AI-Driven Simcade)

![Godot 4.x](https://img.shields.io/badge/Engine-Godot%204.x-blue?logo=godotengine)
![Renderer](https://img.shields.io/badge/Renderer-GL%20Compatibility-green)
![Target Hardware](https://img.shields.io/badge/Target-Intel%20UHD%20620%20%7C%20720p-orange)
![Architecture](https://img.shields.io/badge/Workflow-AI--Driven%20%2F%20Multi--Agent-purple)
![QA Gate](https://img.shields.io/badge/QA%20Score-%E2%89%A5%208.5%2F10-brightgreen)

Um jogo de corrida **simcade** desenvolvido no **Godot Engine 4.x**, inspirado na física e sensação de condução clássica de *Gran Turismo 4* (transferência de peso, aderência progressiva dos pneus e sensação de velocidade), otimizado especificamente para rodar com alta performance e baixo consumo de recursos em hardwares de entrada (com validação prioritária em GPUs integradas como a **Intel UHD Graphics 620** a 720p / 30–45+ FPS).

O projeto é desenvolvido através de um modelo **AI-First / Multi-Agent**, onde agentes e subagentes especializados cuidam da física, pistas, IA adversária e otimização gráfica, com verificação contínua e pontuação automatizada por um **QA Agent**.

---

## ✨ Destaques do Projeto

- **🏎️ Física Simcade Desacoplada (65% Simulação / 35% Acessibilidade):** Parâmetros de suspensão, curva de torque, freios e pneus totalmente desacoplados em arquivos de dados.
- **🇧🇷 Autódromo José Carlos Pace (Interlagos):** Representação do traçado clássico de 4,309 km com suas 11 curvas e desnível de ~56 metros (S do Senna, Curva do Sol, Laranjinha, Bico de Pato, etc.).
- **⚡ Ultraleve & Otimizado:** Construído com o renderer `GL Compatibility`, materiais PBR simplificados e foco em custo-benefício computacional.
- **🎮 Controles Responsivos:** Suporte integrado a Teclado (WASD) e Controles XInput/Gamepad com direção progressiva sensível à velocidade.
- **🤖 Desenvolvimento Multi-Agente:** Pipeline de tarefas com critério rigoroso de aprovação (QA Score $\ge 8.5/10$).

---

## 🛠️ Tecnologias & Requisitos

- **Engine:** [Godot Engine 4.x](https://godotengine.org/)
- **Renderer:** Compatibility / OpenGL
- **Resolução Alvo:** 1280x720 (com escalonamento suave)
- **Hardware Mínimo Testado:** Intel Core i3/i5 com Intel UHD Graphics 620 + 8-12 GB RAM

---

## 🚀 Como Executar

1. Clone o repositório:
   ```bash
   git clone https://github.com/Renatoandrade00/Interlagos_racing.git
   ```
2. Abra o **Godot Engine 4.x**.
3. Importe o arquivo `project.godot`.
4. Pressione **F5** para rodar o projeto ou selecione a cena `res://Tracks/Interlagos/InterlagosVerticalSlice.tscn`.

---

## 🎮 Controles Padrão

| Ação | Teclado | Gamepad (Xbox / XInput) |
| :--- | :--- | :--- |
| **Acelerar** | `W` / Seta Cima | Gatilho Direito (`RT / R2`) |
| **Frear / Ré** | `S` / Seta Baixo | Gatilho Esquerdo (`LT / L2`) |
| **Virar Esquerda / Direita** | `A` / `D` | Analógico Esquerdo (`LS`) |
| **Freio de Mão** | `Espaço` | Botão `B` / Círculo |
| **Reset do Veículo** | `R` | Botão `Y` / Triângulo |
