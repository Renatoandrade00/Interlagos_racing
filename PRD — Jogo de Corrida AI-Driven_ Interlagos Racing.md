# PRD — Jogo de Corrida AI-Driven: Interlagos Racing

**Versão:** 1.0  
**Status:** Documento-base para desenvolvimento  
**Modelo de desenvolvimento:** AI-First / Multi-Agent  
**Plataforma inicial:** PC Windows  
**Engine preferencial:** Godot 4.x com renderer Compatibility, sujeito a benchmark inicial  
**Pista inicial:** Autódromo José Carlos Pace — Interlagos, São Paulo  
**Veículos de lançamento:** 30 veículos contemporâneos  
**Meta de hardware:** Intel UHD Graphics 620 + 12 GB RAM  
**Referência de gameplay:** Gran Turismo 4, com evolução para padrões modernos  
**Orquestração:** Google Antigravity + agentes/subagentes especializados

---

# 1. Visão do Produto

O projeto consiste no desenvolvimento de um jogo de corrida para PC, com foco em **boa qualidade visual, física convincente e baixo consumo de recursos**, desenvolvido prioritariamente por agentes de inteligência artificial coordenados por um agente orquestrador.

A experiência deverá buscar a sensação de condução de um **simcade de alta qualidade**, tendo Gran Turismo 4 como referência de design de física e comportamento dos veículos, porém utilizando implementação, assets, identidade visual, interface, código e sistemas próprios.

O objetivo não é reproduzir Gran Turismo 4, mas capturar características consideradas positivas da experiência:

- sensação de peso do veículo;
- transferência de carga durante frenagens e curvas;
- aderência progressiva dos pneus;
- diferença perceptível entre tipos de veículos;
- comportamento coerente entre tração dianteira, traseira e integral;
- perda de aderência previsível;
- sensação de velocidade;
- controles acessíveis;
- equilíbrio entre realismo e diversão.

Avaliações contemporâneas do GT4 destacam justamente sua percepção de aderência dos pneus e de transferência de peso como elementos centrais da experiência.

---

# 2. Objetivos do Projeto

## 2.1 Objetivo principal

Criar um jogo de corrida tecnicamente sólido, visualmente atraente e leve, capaz de apresentar:

**30 veículos + 1 circuito detalhado + corrida contra IA + física própria + controles modernos + sistema de progressão básico**, mantendo desempenho adequado em hardware integrado.

## 2.2 Objetivos de qualidade

O produto deverá buscar:

- jogabilidade imediatamente compreensível;
- física consistente;
- gráficos significativamente superiores aos de jogos antigos, sem depender de técnicas gráficas excessivamente pesadas;
- carregamentos rápidos;
- baixo uso de VRAM/RAM;
- estabilidade;
- arquitetura modular;
- facilidade de expansão;
- alto grau de automação do desenvolvimento por agentes.

## 2.3 Não objetivos do MVP

Não fazem parte da primeira versão:

- mundo aberto;
- multiplayer online;
- VR;
- modo carreira extremamente complexo;
- centenas de veículos;
- dezenas de circuitos;
- destruição física avançada;
- sistema completo de danos;
- clima dinâmico complexo;
- física CFD;
- simulador profissional de engenharia automotiva.

Esses elementos poderão entrar em versões futuras.

---

# 3. Público-Alvo

O jogo será direcionado principalmente a jogadores que:

- gostam de jogos de corrida;
- gostam de simcade;
- possuem PCs modestos ou intermediários;
- utilizam teclado, controle ou volante;
- procuram uma experiência mais realista que um arcade tradicional;
- valorizam sensação de direção e comportamento do veículo;
- desejam jogar em hardware sem GPU dedicada.

---

# 4. Requisito Crítico de Hardware

O projeto deverá considerar como **hardware mínimo de desenvolvimento e validação** um computador contendo aproximadamente:

- GPU: Intel UHD Graphics 620;
- RAM: 12 GB;
- CPU compatível de notebook/desktop da geração da UHD 620;
- Windows 10/11;
- armazenamento SSD recomendado.

A Intel informa que a UHD Graphics 620 possui suporte a DirectX 12 e Shader Model 5.1.

Entretanto, o suporte à API não significa que qualquer projeto 3D moderno terá bom desempenho nesse hardware. Portanto, **o projeto deverá ser orientado por métricas reais de desempenho**, e não apenas por compatibilidade técnica.

## 4.1 Meta de performance

Meta principal:

**720p / Low-Medium / 30 FPS estáveis ou superiores na UHD 620.**

Meta desejável:

**720p / Low-Medium / 45–60 FPS.**

Meta secundária:

**1080p em GPUs integradas ou dedicadas superiores.**

O jogo deverá possuir configuração gráfica automática baseada no hardware.

---

# 5. Princípio Visual

O objetivo visual será:

> “Parecer um jogo moderno de corrida simplificado, não um jogo pesado com gráficos reduzidos.”

A direção visual deverá priorizar **qualidade percebida por custo computacional**, utilizando:

- materiais PBR simplificados;
- iluminação eficiente;
- baked lighting quando possível;
- sombras seletivas;
- LOD;
- impostors quando apropriado;
- occlusion culling;
- instancing;
- texturas comprimidas;
- atlases;
- geometria otimizada;
- vegetação otimizada;
- partículas reduzidas;
- pós-processamento extremamente controlado.

Evitar como requisito obrigatório:

- ray tracing;
- path tracing;
- sombras de alta resolução em toda a cena;
- iluminação global dinâmica cara;
- volumetria pesada;
- reflexos em tempo real de alta qualidade;
- partículas excessivas.

---

# 6. Engine

## 6.1 Engine preferencial

A primeira alternativa a ser avaliada será:

**Godot 4.x + Compatibility Renderer.**

Motivos:

- código aberto;
- baixo custo de licenciamento;
- bom controle sobre o projeto;
- arquitetura relativamente simples;
- adequada para projetos independentes;
- boa capacidade de automação;
- fácil versionamento;
- facilidade para agentes modificarem arquivos;
- possibilidade de desenvolvimento headless;
- possibilidade de criação de ferramentas próprias.

A decisão definitiva deverá ser feita após um **Benchmark Gate**.

## 6.2 Benchmark Gate

Antes da implementação definitiva, o agente de arquitetura deverá criar um protótipo contendo:

- uma pista simplificada;
- 1 veículo;
- física básica;
- iluminação;
- sombras;
- partículas;
- câmera;
- HUD;
- 10 veículos simultâneos.

O benchmark deverá ser executado no hardware-alvo.

A engine somente será aprovada caso o protótipo demonstre margem suficiente de performance.

---

# 7. Pista Inicial — Interlagos

A primeira pista será o Autódromo José Carlos Pace, em Interlagos.

O circuito atual possui aproximadamente:

- 4,309 km;
- 11 curvas;
- largura de aproximadamente 12–15 metros;
- desnível aproximado de 56 metros.

Essas características deverão ser representadas de maneira suficientemente fiel no layout do circuito.

## 7.1 Elementos obrigatórios

A versão inicial deverá conter:

- reta principal;
- reta oposta;
- S do Senna;
- Curva do Sol;
- Curva do Lago;
- Laranjinha;
- Pinheirinho;
- Mergulho;
- Bico de Pato;
- boxes;
- pit lane;
- grid de largada;
- áreas de escape;
- zebras;
- guard rails;
- barreiras;
- arquibancadas;
- estruturas visíveis do autódromo;
- elementos urbanos/de fundo;
- iluminação compatível com o ambiente.

## 7.2 Fidelidade

A pista deverá priorizar:

1. fidelidade do traçado;
2. proporção;
3. elevação;
4. pontos de frenagem;
5. zebras;
6. largura;
7. referências visuais.

Detalhes cosméticos poderão ser simplificados para atender à meta de performance.

---

# 8. Veículos

A versão inicial possuirá **exatamente 30 veículos**.

## 8.1 Características

Cada veículo deverá possuir:

- modelo 3D;
- interior simplificado;
- rodas;
- pneus;
- materiais;
- iluminação;
- suspensão visual;
- animação das rodas;
- animação do volante;
- sons;
- parâmetros físicos;
- peso;
- potência;
- torque;
- distribuição de massa;
- tração;
- câmbio;
- relações de marcha;
- aerodinâmica;
- aderência;
- freios;
- dimensões.

## 8.2 Categorias

A frota deverá conter variedade suficiente para demonstrar diferenças de física:

- hatch esportivo;
- sedan esportivo;
- cupê;
- muscle car;
- esportivo;
- superesportivo;
- SUV esportivo;
- veículo de tração dianteira;
- veículo de tração traseira;
- veículo AWD.

## 8.3 Licenciamento

Os agentes deverão tratar nomes, logotipos, marcas, modelos, sons e desenhos de veículos reais como **questão de propriedade intelectual/licenciamento**.

Durante prototipagem, deverão ser utilizados:

- veículos fictícios;
- nomes provisórios;
- assets licenciados;
- assets próprios;
- ou modelos cujo uso comercial tenha sido autorizado.

Não deverá ser copiado diretamente conteúdo proprietário de Gran Turismo, Sony, Polyphony Digital ou terceiros.

---

# 9. Física dos Veículos

## 9.1 Filosofia

A física deverá ser inspirada no comportamento percebido de Gran Turismo 4, porém implementada de maneira independente.

O objetivo é obter um modelo:

**arcade → simcade → simulador hardcore**

posicionado aproximadamente em:

**65% simulação / 35% acessibilidade.**

## 9.2 Sistemas físicos

O sistema deverá contemplar:

### Corpo do veículo

- massa;
- centro de gravidade;
- momento de inércia;
- dimensões;
- distribuição de massa;
- suspensão.

### Pneus

- slip ratio;
- slip angle;
- força longitudinal;
- força lateral;
- perda de aderência;
- recuperação de aderência;
- temperatura simplificada;
- composto;
- desgaste simplificado.

### Suspensão

- mola;
- amortecedor;
- altura;
- compressão;
- extensão;
- barras estabilizadoras;
- transferência de carga.

### Freios

- força de frenagem;
- distribuição dianteira/traseira;
- ABS;
- travamento das rodas;
- fade simplificado.

### Motor

- curva de torque;
- potência;
- RPM;
- limitador;
- transmissão;
- relações de marcha.

### Diferencial

Suporte básico a:

- aberto;
- LSD;
- distribuição AWD.

### Aerodinâmica

Modelo simplificado considerando:

- downforce;
- drag;
- efeito da velocidade;
- balanceamento dianteiro/traseiro.

---

# 10. Assistências de Condução

O jogador deverá poder configurar:

- ABS;
- controle de tração;
- estabilidade;
- assistência de direção;
- assistência de frenagem;
- transmissão automática/manual.

Presets:

**Novato**

**Normal**

**Pro**

**Customizado**

---

# 11. Controles

## 11.1 Teclado

Controles padrão:

- W — acelerar;
- S — frear/ré;
- A/D — direção;
- Space — freio de mão;
- Shift — marcha;
- Ctrl — marcha anterior;
- R — reset;
- Esc — menu.

Todos deverão ser remapeáveis.

## 11.2 Gamepad

Suporte obrigatório para:

- Xbox Controller;
- controles XInput;
- controles genéricos quando possível.

Utilização:

- analógico esquerdo — direção;
- RT/R2 — aceleração;
- LT/L2 — freio;
- A/X — confirmação;
- B/Círculo — voltar;
- D-pad — menus/configuração.

## 11.3 Volante

O sistema deverá ser preparado para suporte futuro a:

- steering wheel;
- pedal;
- force feedback.

O suporte completo pode ficar fora do MVP, mas a arquitetura de input deverá não impedir sua implementação posterior.

---

# 12. Câmeras

Câmeras obrigatórias:

- terceira pessoa;
- chase cam;
- cockpit;
- hood;
- bumper;
- replay.

A câmera deverá possuir:

- suavização;
- FOV ajustável;
- vibração;
- efeito de velocidade;
- ajuste de distância.

---

# 13. Corrida

## 13.1 MVP

Uma corrida básica deverá possuir:

- grid;
- largada;
- 1 jogador;
- adversários controlados por IA;
- 3–15 carros simultâneos;
- voltas;
- checkpoints;
- posições;
- tempo de volta;
- melhor volta;
- bandeirada;
- resultado final.

## 13.2 Condições de vitória

O jogador vence ao terminar dentro da posição-alvo configurada para o evento.

---

# 14. IA dos Adversários

A IA deverá possuir arquitetura baseada em:

- racing line;
- waypoint graph;
- target speed;
- curva de frenagem;
- comportamento contextual;
- recuperação após erro;
- overtaking;
- defesa;
- dificuldade dinâmica.

Níveis:

- Easy;
- Normal;
- Hard;
- Expert.

A IA não deverá receber vantagens artificiais absurdas de velocidade somente para compensar dificuldade.

A dificuldade deverá resultar principalmente de:

- melhor linha;
- frenagem;
- aceleração;
- consistência;
- tomada de decisão.

---

# 15. Sistema de Corrida

Cada evento deverá possuir:

- nome;
- pista;
- número de voltas;
- grid;
- veículos participantes;
- regras;
- dificuldade;
- posição de largada;
- recompensa;
- condições de vitória.

---

# 16. HUD

HUD mínimo:

- posição;
- volta;
- melhor volta;
- volta atual;
- velocidade;
- RPM;
- marcha;
- minimapa simplificado;
- indicador de assistência;
- tempo de corrida.

Deverá ser configurável.

O jogador poderá ocultar o HUD.

---

# 17. Áudio

O sistema deverá incluir:

- motor;
- transmissão;
- pneus;
- vento;
- suspensão;
- colisões;
- zebras;
- ambiente;
- menu;
- música.

O motor deverá possuir camadas de áudio por RPM.

O áudio dos pneus deverá representar:

- aderência;
- deslizamento;
- frenagem;
- aceleração;
- mudança de superfície.

Isso é especialmente importante porque o som dos pneus funciona como indicação perceptível de perda de aderência, um elemento também destacado na experiência do GT4.

---

# 18. Performance

## 18.1 Budget de GPU

Todas as decisões visuais deverão considerar orçamento de GPU.

Cada novo asset visual deverá ser analisado quanto a:

- polígonos;
- número de materiais;
- draw calls;
- tamanho das texturas;
- resolução;
- sombras;
- partículas;
- custo de shader.

## 18.2 LOD

Veículos:

- LOD0;
- LOD1;
- LOD2;
- LOD3.

Pista:

- LOD por distância;
- simplificação agressiva fora da área principal;
- objetos distantes com geometria mínima.

## 18.3 Texturas

Preferência por:

- 512×512;
- 1024×1024;
- 2048×2048 apenas quando necessário.

Evitar texturas 4K na maior parte dos assets.

---

# 19. Sistema de Qualidade Visual

A equipe de agentes deverá utilizar uma regra:

> “Qualidade percebida por custo de performance.”

Qualquer efeito que custe muito desempenho deverá ser comparado com uma alternativa mais barata.

Exemplos:

**Reflexo em tempo real caro → reflection probe.**

**Objeto distante detalhado → LOD.**

**Iluminação complexa → iluminação baked.**

**Vegetação pesada → instancing + LOD.**

---

# 20. Arquitetura do Projeto

Estrutura lógica:

```text
Game
├── Core
│   ├── GameState
│   ├── SaveSystem
│   ├── Settings
│   └── Input
│
├── Vehicles
│   ├── VehicleBase
│   ├── VehiclePhysics
│   ├── VehicleController
│   ├── VehicleAudio
│   └── VehicleData
│
├── Tracks
│   ├── TrackBase
│   ├── Interlagos
│   ├── Checkpoints
│   └── PitLane
│
├── Race
│   ├── RaceManager
│   ├── Grid
│   ├── LapSystem
│   ├── Timing
│   └── Results
│
├── AI
│   ├── RacingLine
│   ├── DriverController
│   ├── Overtaking
│   └── Difficulty
│
├── UI
│   ├── HUD
│   ├── Menus
│   └── Settings
│
├── Audio
│
├── Graphics
│
└── Tools
```

---

# 21. Desenvolvimento Multi-Agent

A arquitetura de desenvolvimento será baseada em agentes especializados.

O Antigravity foi projetado como uma plataforma agent-first capaz de permitir que agentes planejem, executem e verifiquem tarefas em editor, terminal e navegador. A versão atual também possui recursos para gerenciar múltiplos agentes em paralelo, o que torna o paradigma de orquestração proposto adequado ao projeto.

---

# 22. Agente Orquestrador

Nome sugerido:

**GAME-MASTER ORCHESTRATOR**

Responsabilidades:

1. interpretar o PRD;
2. manter o estado global do projeto;
3. decompor requisitos em tarefas;
4. identificar dependências;
5. distribuir tarefas;
6. executar tarefas independentes em paralelo;
7. controlar agentes;
8. impedir conflitos de alteração;
9. acompanhar resultados;
10. chamar o agente de QA;
11. analisar notas;
12. solicitar correções;
13. repetir tarefas abaixo de 8,5;
14. controlar regressões;
15. controlar consumo de tokens.

---

# 23. Agentes Especializados

## AG-01 — Architect Agent

Responsável por:

- arquitetura;
- padrões;
- estrutura de pastas;
- interfaces;
- dependências;
- decisões tecnológicas.

## AG-02 — Vehicle Physics Agent

Responsável por:

- física;
- pneus;
- suspensão;
- transmissão;
- motor;
- freios;
- diferencial.

## AG-03 — Vehicle Asset Agent

Responsável por:

- modelos;
- LOD;
- materiais;
- otimização;
- integração de veículos.

## AG-04 — Track Agent

Responsável por:

- Interlagos;
- geometria;
- curvas;
- elevação;
- pit lane;
- boxes;
- cenário.

## AG-05 — AI Driver Agent

Responsável por:

- racing line;
- comportamento dos adversários;
- ultrapassagens;
- dificuldade.

## AG-06 — Gameplay Agent

Responsável por:

- corrida;
- voltas;
- grid;
- resultados;
- regras.

## AG-07 — UI/UX Agent

Responsável por:

- menus;
- HUD;
- configurações;
- navegação.

## AG-08 — Audio Agent

Responsável por:

- sons;
- motor;
- pneus;
- ambiente;
- mixagem.

## AG-09 — Graphics Optimization Agent

Responsável por:

- FPS;
- draw calls;
- shaders;
- LOD;
- texturas;
- GPU;
- CPU;
- memória.

## AG-10 — Build/Release Agent

Responsável por:

- builds;
- exportação;
- versionamento;
- pacotes;
- logs.

## AG-11 — QA Agent

Responsável exclusivamente por:

- testes;
- validação;
- regressão;
- performance;
- avaliação.

## AG-12 — Research Agent

Responsável por pesquisas externas necessárias para:

- dados técnicos;
- referência automotiva;
- hardware;
- engine;
- APIs;
- documentação.

---

# 24. Subagentes

Cada agente especialista poderá criar subagentes quando uma tarefa possuir componentes independentes.

Exemplo:

```text
Track Agent
   ├── Track Geometry Subagent
   ├── Elevation Subagent
   ├── Track Material Subagent
   ├── Grandstand Subagent
   └── Optimization Subagent
```

Os subagentes deverão ter escopo curto e objetivo.

---

# 25. Regra de Paralelização

O Orchestrator deverá sempre tentar maximizar paralelismo.

Exemplo:

```text
TASK-100
Criar sistema de veículo

       ├── Física
       ├── Modelo de dados
       ├── Áudio
       ├── HUD
       └── Input
```

As tarefas somente deverão ser serializadas quando houver dependência real.

Exemplo:

```text
Física Base
     ↓
Controle do Veículo
     ↓
IA
     ↓
Corrida
```

Não deverão ser serializadas tarefas que poderiam trabalhar simultaneamente em diferentes arquivos.

---

# 26. Sistema de Dependências

Cada tarefa deverá possuir:

```yaml
task_id:
title:
description:
priority:
dependencies:
agent:
files:
acceptance_criteria:
tests:
expected_output:
```

Exemplo:

```yaml
task_id: PHY-001
title: Implementar modelo básico de pneus
priority: P0
dependencies:
  - ARCH-001
agent: vehicle_physics
files:
  - /vehicles/physics/
acceptance_criteria:
  - slip angle funcionando
  - perda de aderência funcional
  - comportamento determinístico
tests:
  - tire_slip_test
  - lateral_grip_test
```

---

# 27. Sistema de Versionamento

Toda tarefa deverá trabalhar com:

- Git;
- branch dedicada;
- commits pequenos;
- mensagens padronizadas;
- logs;
- artefatos de teste.

Formato:

```text
feature/<task-id>-descricao
```

Exemplo:

```text
feature/PHY-001-tire-model
```

O agente não deverá alterar arbitrariamente arquivos pertencentes a outra tarefa ativa sem coordenação do Orchestrator.

---

# 28. Pipeline de Execução

Fluxo obrigatório:

```text
PRD
 ↓
ORCHESTRATOR
 ↓
DECOMPOSIÇÃO
 ↓
DEPENDENCY GRAPH
 ↓
PARALELIZAÇÃO
 ↓
AGENTS
 ↓
IMPLEMENTAÇÃO
 ↓
QA AGENT
 ↓
NOTA 0–10
 ↓
>= 8.5 ? ── SIM ──> APROVAR
     │
     NÃO
     ↓
ANÁLISE DA FALHA
     ↓
RETRABALHO
     ↓
NOVO QA
     ↓
LOOP
```

---

# 29. Critério de Aprovação

Nenhuma tarefa será considerada concluída apenas porque o agente informou que terminou.

A tarefa somente será considerada:

**DONE**

quando:

```text
QA SCORE >= 8.5
```

Caso contrário:

```text
STATUS = REWORK_REQUIRED
```

e o Orchestrator deverá reabrir a tarefa.

---

# 30. QA Agent — Sistema de Pontuação

Nota de 0 a 10.

## Critérios

### Funcionalidade — 0 a 2

- funciona?
- atende ao requisito?
- não quebra casos básicos?

### Qualidade técnica — 0 a 2

- arquitetura adequada?
- código sustentável?
- modularidade?

### Performance — 0 a 2

- consumo de CPU;
- GPU;
- RAM;
- FPS.

### Integração — 0 a 2

- funciona com os sistemas existentes?
- não introduz regressões?

### Qualidade/UX — 0 a 2

- experiência adequada?
- comportamento natural?
- acabamento?

Total:

**10 pontos**

---

# 31. Regras do QA

O QA Agent deverá:

1. ler a especificação da tarefa;
2. verificar acceptance criteria;
3. executar testes;
4. analisar logs;
5. executar benchmark quando aplicável;
6. verificar regressões;
7. gerar evidências;
8. atribuir nota;
9. justificar a nota;
10. informar exatamente o que precisa ser corrigido.

Não poderá simplesmente atribuir:

> “8,5 — parece funcionar.”

A avaliação deverá ser baseada em evidências.

---

# 32. Relatório do QA

Formato:

```yaml
task_id: PHY-001
score: 8.2
status: REWORK_REQUIRED

functional:
  score: 1.8
  issues:
    - comportamento instável em baixa velocidade

technical:
  score: 1.7
  issues: []

performance:
  score: 1.4
  issues:
    - custo elevado em 60 FPS

integration:
  score: 1.7
  issues: []

ux:
  score: 1.6
  issues:
    - perda de aderência muito abrupta

required_fixes:
  - suavizar curva de perda de aderência
  - otimizar cálculo
```

---

# 33. Loop de Correção

Quando:

```text
score < 8.5
```

o Orchestrator deverá:

1. preservar os testes que falharam;
2. enviar feedback ao agente responsável;
3. solicitar correção;
4. executar novamente;
5. chamar QA novamente.

O agente não deverá simplesmente apagar testes para aumentar artificialmente a nota.

---

# 34. Proteção contra “Gaming” da Nota

O sistema deverá possuir testes independentes.

O agente que implementa uma tarefa não deverá ser responsável pela aprovação da própria tarefa.

O QA deverá utilizar:

- testes automatizados;
- cenários pré-definidos;
- casos adversos;
- benchmarks;
- comparação com baseline;
- testes de regressão.

A métrica deverá medir qualidade real, não somente passagem em testes superficiais. Esse cuidado é importante em sistemas de agentes autônomos, pois pesquisas recentes sobre workflows de agentes mostram que otimizar apenas uma métrica pode incentivar comportamentos que “jogam com o teste” em vez de resolver corretamente o problema.

---

# 35. Economia de Tokens

O Orchestrator deverá possuir como prioridade:

**máxima entrega com mínimo contexto necessário.**

Regras:

### Regra 1 — Contexto mínimo

Cada agente recebe somente:

- tarefa;
- requisitos relevantes;
- arquivos necessários;
- dependências;
- critérios de aceitação.

### Regra 2 — Não enviar o PRD inteiro

O PRD completo deverá permanecer como fonte de verdade, mas agentes receberão apenas os trechos relevantes.

### Regra 3 — Preferir arquivos de estado

Criar:

```text
/project-state/
    architecture.md
    decisions.md
    tasks.yaml
    qa-history.yaml
    performance.md
```

### Regra 4 — Resumos

Depois de tarefas grandes:

```text
FULL CONTEXT
      ↓
SUMMARY
      ↓
PERSISTENT STATE
```

### Regra 5 — Evitar duplicação

Agentes não deverão repetir pesquisas já realizadas sem necessidade.

---

# 36. Memória do Projeto

O projeto deverá possuir uma memória persistente:

```text
PROJECT_MEMORY.md
```

Contendo:

- decisões arquiteturais;
- problemas conhecidos;
- soluções adotadas;
- padrões;
- limitações;
- métricas;
- decisões rejeitadas.

---

# 37. Estado das Tarefas

Estados possíveis:

```text
BACKLOG
READY
RUNNING
BLOCKED
QA_PENDING
REWORK_REQUIRED
APPROVED
REGRESSION
DONE
```

---

# 38. Prioridades

### P0 — Crítico

Bloqueia o jogo.

### P1 — Alta

Necessário para MVP.

### P2 — Média

Melhoria importante.

### P3 — Baixa

Polimento/futuro.

O Orchestrator deverá priorizar:

```text
P0 > P1 > P2 > P3
```

mas mantendo paralelismo sempre que possível.

---

# 39. Milestones

## M0 — Foundation

- repositório;
- engine;
- arquitetura;
- build;
- sistema de agentes;
- QA básico.

## M1 — Vertical Slice

Entregar:

- 1 carro;
- trecho de Interlagos;
- física;
- câmera;
- controles;
- corrida simples;
- HUD.

Objetivo:

**jogo jogável de ponta a ponta.**

## M2 — Physics

- física refinada;
- pneus;
- suspensão;
- transmissão;
- freios;
- assistências.

## M3 — Interlagos

- circuito completo;
- pit lane;
- ambiente;
- otimização.

## M4 — Vehicle Fleet

- 30 veículos;
- dados físicos;
- LOD;
- sons.

## M5 — AI Racing

- adversários;
- racing line;
- ultrapassagem;
- dificuldade.

## M6 — UX

- menus;
- configuração;
- seleção de veículos;
- seleção de corrida.

## M7 — Optimization

Benchmark:

- UHD 620;
- GPU integrada superior;
- GPU dedicada de entrada.

## M8 — Release Candidate

- regressão;
- bugs;
- performance;
- estabilidade;
- pacote final.

---

# 40. Definition of Done — Projeto

O MVP somente poderá ser considerado concluído quando:

- [ ] jogo inicia sem erro;
- [ ] menu principal funcional;
- [ ] seleção de veículo funcional;
- [ ] 30 veículos integrados;
- [ ] Interlagos funcional;
- [ ] física funcional;
- [ ] IA funcional;
- [ ] corrida funcional;
- [ ] HUD funcional;
- [ ] controles teclado funcionais;
- [ ] controles gamepad funcionais;
- [ ] áudio funcional;
- [ ] opções gráficas funcionais;
- [ ] save/configuração funcional;
- [ ] benchmark executado;
- [ ] UHD 620 validada;
- [ ] não existem bugs P0;
- [ ] não existem bugs P1 conhecidos que impeçam lançamento;
- [ ] regressão executada;
- [ ] QA final ≥ 8,5.

---

# 41. Benchmark de Performance

O QA deverá coletar:

- FPS médio;
- FPS 1% low;
- FPS 0.1% low quando disponível;
- tempo de frame;
- CPU frame time;
- GPU frame time;
- RAM;
- VRAM/shared memory;
- draw calls;
- quantidade de objetos;
- tempo de carregamento.

Resultado exemplo:

```text
Hardware:
Intel UHD 620
RAM:
12 GB

Resolution:
1280x720

Preset:
Low

Average FPS:
43

1% Low:
31

GPU:
87%

RAM:
6.8 GB

Result:
PASS
```

---

# 42. Meta de Performance

Para o MVP:

### Minimum Gate

**30 FPS estáveis.**

### Target

**45 FPS+.**

### Stretch Goal

**60 FPS.**

O requisito de 30 FPS deverá ter prioridade sobre efeitos gráficos.

---

# 43. Sistema de Configuração Gráfica

Presets:

### Ultra Low

Para hardware muito fraco.

### Low

Perfil oficial para UHD 620.

### Medium

Perfil para GPUs integradas modernas.

### High

GPU dedicada de entrada/média.

### Custom

Configuração manual.

Opções:

- resolução;
- escala de resolução;
- textura;
- sombras;
- reflexos;
- pós-processamento;
- vegetação;
- LOD;
- distância de visão;
- antialiasing;
- partículas.

---

# 44. Escalabilidade

O projeto deverá ser preparado para futuramente adicionar:

- novas pistas;
- novos carros;
- multiplayer;
- clima;
- dia/noite;
- carreira;
- tuning;
- replay avançado;
- fotografia;
- leaderboard;
- ghost racing.

Esses recursos não deverão estar fortemente acoplados ao MVP.

---

# 45. Sistema de Dados dos Veículos

Os parâmetros físicos deverão ser externos ao código sempre que possível.

Exemplo:

```yaml
vehicle:
  id: car_001

  drivetrain: RWD

  mass: 1480

  engine:
    power_kw: 180
    torque_nm: 320
    redline: 7000

  suspension:
    front:
      spring_rate: 42000
      damping: 3200
    rear:
      spring_rate: 38000
      damping: 3000

  tires:
    front_grip: 1.0
    rear_grip: 1.0

  brakes:
    bias: 0.62
```

Isso permitirá que agentes alterem parâmetros sem modificar o sistema físico central.

---

# 46. Telemetria

O jogo deverá possuir modo de desenvolvimento capaz de exibir:

- velocidade;
- RPM;
- aceleração;
- força lateral;
- força longitudinal;
- slip angle;
- slip ratio;
- temperatura;
- suspensão;
- transferência de carga;
- estado de cada roda.

Esse sistema será fundamental para os agentes de física e QA.

---

# 47. Ferramentas Internas para Agentes

Deverão existir ferramentas para:

- executar benchmark;
- iniciar corrida automaticamente;
- carregar pista;
- selecionar veículo;
- gerar screenshot;
- gravar logs;
- coletar FPS;
- executar testes;
- verificar assets;
- validar arquivos;
- detectar arquivos quebrados;
- validar referências;
- gerar build.

Quanto maior for a automatização dessas atividades, menor será a dependência de intervenção humana.

---

# 48. Autonomous Testing

O QA Agent deverá conseguir executar cenários como:

```text
LaunchGame
→ SelectVehicle
→ SelectTrack
→ StartRace
→ Drive 3 Laps
→ CollectTelemetry
→ CaptureScreenshots
→ ValidateRaceResult
→ GenerateReport
```

Também:

```text
LaunchGame
→ StartRace
→ Crash Vehicle
→ Reset
→ Continue
```

e:

```text
LaunchGame
→ Change Graphics
→ Restart
→ Verify Settings Persistence
```

---

# 49. Testes de Regressão

Toda nova alteração relevante deverá executar:

1. testes unitários;
2. testes de integração;
3. testes funcionais;
4. benchmark quando necessário;
5. smoke test.

Uma tarefa anteriormente aprovada poderá voltar para:

```text
REGRESSION
```

caso uma mudança posterior introduza problemas.

---

# 50. Critério de Aceitação do Sistema Multi-Agent

O sistema de agentes será considerado funcional quando conseguir:

1. receber uma feature;
2. decompor a feature;
3. identificar dependências;
4. criar tarefas;
5. executar tarefas paralelamente;
6. integrar alterações;
7. executar QA;
8. produzir nota;
9. corrigir tarefas abaixo de 8,5;
10. repetir até aprovação;
11. preservar histórico;
12. evitar regressões.

---

# 51. Exemplo de Execução

Usuário:

> “Adicionar sistema de freios ABS.”

Orchestrator:

```text
ABS-001 — Arquitetura
ABS-002 — Modelo físico
ABS-003 — Input/configuração
ABS-004 — HUD
ABS-005 — Testes
```

Executa em paralelo:

```text
ABS-001
ABS-003
ABS-004
```

Após arquitetura:

```text
ABS-002
```

Após implementação:

```text
ABS-005
```

QA:

```text
Score: 7.9
```

Resultado:

```text
REWORK_REQUIRED
```

Orchestrator:

```text
→ identificar falha
→ enviar feedback
→ corrigir
→ testar
```

Nova avaliação:

```text
Score: 8.8
```

Resultado:

```text
APPROVED
```

---

# 52. Segurança dos Agentes

Como agentes podem executar comandos, escrever arquivos e operar ferramentas externas, o sistema deverá aplicar princípio de menor privilégio.

Regras:

- agentes não devem possuir acesso irrestrito sem necessidade;
- comandos destrutivos deverão ser controlados;
- dependências externas deverão ser verificadas;
- alterações de configuração crítica deverão ser registradas;
- branches deverão ser utilizadas;
- builds deverão ocorrer em ambiente controlado;
- artefatos externos deverão ser tratados como não confiáveis até verificação.

Essa preocupação é particularmente relevante para ambientes agentic de desenvolvimento, nos quais pesquisas recentes identificaram riscos associados à forma como agentes podem ser induzidos a alterar arquivos/configurações que posteriormente são executados por componentes confiáveis.

---

# 53. Propriedade Intelectual

O projeto deverá possuir identidade própria.

Permitido como referência conceitual:

- estilo de gameplay;
- princípios gerais de simcade;
- sensação de condução;
- conceitos de HUD comuns ao gênero;
- mecânicas gerais de corrida.

Não permitido:

- copiar código;
- copiar modelos;
- copiar texturas;
- copiar sons;
- copiar interfaces;
- extrair assets de Gran Turismo;
- utilizar assets de GT4;
- reproduzir logos;
- reproduzir identidade visual;
- utilizar conteúdo proprietário sem autorização.

A referência ao GT4 deverá ser tratada como **benchmark de experiência**, não como fonte de assets.

---

# 54. Questões de Licenciamento

O Orchestrator deverá manter um arquivo:

```text
LEGAL_AND_LICENSE.md
```

registrando:

- origem de cada asset;
- licença;
- autor;
- permissão comercial;
- modelo utilizado;
- textura utilizada;
- áudio utilizado;
- fonte de dados;
- restrições.

Para os 30 veículos e a reprodução comercial de Interlagos, deverá existir uma avaliação jurídica/licenciamento adequada antes de distribuição comercial.

---

# 55. Primeira Sprint dos Agentes

A primeira execução do Orchestrator deverá criar:

```text
PROJECT_BOOTSTRAP
```

Tarefas:

```text
ARCH-001
Definir arquitetura

ARCH-002
Inicializar repositório

ARCH-003
Configurar engine

ARCH-004
Criar build automatizada

ARCH-005
Criar sistema de tarefas

ARCH-006
Criar QA Agent

ARCH-007
Criar benchmark

ARCH-008
Criar protótipo de veículo

ARCH-009
Criar pista de benchmark

ARCH-010
Criar sistema de telemetria
```

As tarefas independentes deverão ser executadas simultaneamente.

---

# 56. Primeiro Vertical Slice

Antes de produzir os 30 veículos, o projeto deverá produzir somente:

**1 veículo + 1 trecho de Interlagos + corrida simples.**

O objetivo é validar a experiência completa.

Pipeline:

```text
CAR
+
TRACK
+
PHYSICS
+
CAMERA
+
INPUT
+
AI
+
RACE
+
HUD
+
AUDIO
=
PLAYABLE VERTICAL SLICE
```

Somente após a aprovação desse Vertical Slice deverão ser escalados os sistemas para os 30 veículos.

---

# 57. Gate de Qualidade do Vertical Slice

Nota mínima:

**8,5/10**

Critérios especiais:

- sensação de direção;
- qualidade da física;
- sensação de velocidade;
- estabilidade;
- visual;
- performance;
- controles;
- qualidade da pista.

Se obtiver:

```text
< 8.5
```

o projeto deverá entrar em ciclo de melhoria antes de expandir o conteúdo.

---

# 58. Métricas de Sucesso do Produto

## Técnico

- 30 veículos funcionando;
- 1 circuito completo;
- 30 FPS na UHD 620;
- estabilidade;
- carregamento aceitável.

## Gameplay

- física consistente;
- IA competitiva;
- controles responsivos;
- corrida divertida.

## Desenvolvimento

- alta taxa de tarefas automatizadas;
- paralelismo;
- baixo retrabalho;
- QA automatizado;
- histórico de decisões.

## IA

O sistema deverá medir:

- tokens utilizados por tarefa;
- número de iterações;
- tempo de execução;
- taxa de aprovação;
- número de regressões;
- quantidade de tarefas executadas em paralelo;
- custo aproximado por feature.

---

# 59. KPI do Orchestrator

O Orchestrator não deverá buscar somente “terminar tarefas”.

Ele deverá otimizar:

```text
Qualidade
    ×
Velocidade
    ×
Paralelismo
    ÷
Custo de tokens
```

Uma tarefa que leva menos tokens mas produz código ruim será considerada fracasso.

Uma tarefa extremamente detalhada que consome quantidade desnecessária de contexto também deverá ser otimizada.

---

# 60. Princípio Central do Desenvolvimento

O projeto deverá seguir a seguinte regra:

> **“Nenhum agente é autoridade absoluta sobre a qualidade do próprio trabalho.”**

O agente implementador produz.

O agente QA verifica.

O Orchestrator decide o próximo passo.

O sistema de testes fornece evidências.

O score determina aprovação.

---

# 61. Arquitetura Final do Sistema de Desenvolvimento

```text
                         ┌──────────────────────┐
                         │      PRODUCT OWNER    │
                         │        / USUÁRIO      │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │  GAME-MASTER         │
                         │  ORCHESTRATOR        │
                         └──────────┬───────────┘
                                    │
                ┌───────────────────┼───────────────────┐
                │                   │                   │
                ▼                   ▼                   ▼
          ARCHITECT             RESEARCH             PLANNER
                │                   │                   │
                └───────────────────┼───────────────────┘
                                    ▼
                         ┌──────────────────────┐
                         │    TASK GRAPH        │
                         └──────────┬───────────┘
                                    │
                  ┌─────────────────┼──────────────────┐
                  │                 │                  │
                  ▼                 ▼                  ▼
              PHYSICS             TRACK              VEHICLE
                  │                 │                  │
                  ▼                 ▼                  ▼
                AI                AUDIO                UI
                  │                 │                  │
                  └─────────────────┼──────────────────┘
                                    ▼
                         ┌──────────────────────┐
                         │      INTEGRATOR      │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │      QA AGENT        │
                         └──────────┬───────────┘
                                    │
                           ┌────────┴────────┐
                           │                 │
                       SCORE >= 8.5      SCORE < 8.5
                           │                 │
                           ▼                 ▼
                       APPROVED          REWORK
                                             │
                                             └──────► ORCHESTRATOR
```

---

# 62. Requisitos P0

Os seguintes requisitos são considerados obrigatórios:

**P0-001** — jogo executável no PC.

**P0-002** — Interlagos funcional.

**P0-003** — física funcional.

**P0-004** — pelo menos 1 veículo plenamente funcional no Vertical Slice.

**P0-005** — sistema de corrida funcional.

**P0-006** — controles teclado.

**P0-007** — controles gamepad.

**P0-008** — IA adversária.

**P0-009** — 30 veículos no MVP.

**P0-010** — benchmark na UHD 620.

**P0-011** — 30 FPS como mínimo de performance.

**P0-012** — sistema multi-agent.

**P0-013** — Orchestrator.

**P0-014** — QA Agent.

**P0-015** — score de QA de 0–10.

**P0-016** — loop obrigatório abaixo de 8,5.

**P0-017** — execução paralela quando possível.

**P0-018** — controle de consumo de tokens.

**P0-019** — testes automatizados.

**P0-020** — controle de versão.

---

# 63. Resultado Esperado

Ao término do MVP, o resultado deverá ser um jogo de corrida independente contendo:

**30 veículos contemporâneos**

+

**Autódromo de Interlagos**

+

**física simcade inspirada na experiência de GT4**

+

**IA de corrida**

+

**controles modernos**

+

**gráficos otimizados**

+

**baixo consumo de hardware**

+

**sistema de progressão inicial**

+

**arquitetura expansível**

+

**pipeline de desenvolvimento autônomo por agentes**

+

**QA automatizado com aprovação ≥8,5**

O diferencial técnico do projeto não será apenas o jogo, mas também o **sistema de desenvolvimento AI-First capaz de decompor, paralelizar, implementar, testar, avaliar e corrigir o próprio produto continuamente**.

---

# 64. Próximo Documento Técnico Recomendado

A partir deste PRD, o próximo artefato deverá ser o:

**AI DEVELOPMENT SPECIFICATION (ADS)**

Esse documento deverá transformar o PRD em instruções operacionais para o Antigravity, definindo:

- `AGENTS.md`;
- arquitetura de agentes;
- prompts de cada agente;
- estrutura de diretórios;
- protocolo de comunicação;
- formato de tarefas;
- formato de QA;
- score automático;
- regras de paralelização;
- memória persistente;
- política de tokens;
- integração Git;
- comandos autorizados;
- gates de qualidade;
- workflow completo do Orchestrator;
- prompts iniciais para criação do projeto.

Isso permitirá passar do **“PRD do jogo”** para o **“sistema operacional de IA que irá construir o jogo”**.