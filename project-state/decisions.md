# Architectural Decision Records (ADRs)

## ADR-001: Escolha da Engine Godot 4.x com Compatibility Renderer
- **Status:** Aprovado
- **Contexto:** Necessidade de suporte a hardware integrado modesto (Intel UHD 620) mantendo boa automação e baixo consumo de recursos.
- **Decisão:** Utilizar Godot 4.x com o renderizador Compatibility.
- **Consequências:** Garantia de compatibilidade com OpenGL 3 / ES 3.0 / Vulkan mobile, facilitando builds leves.
