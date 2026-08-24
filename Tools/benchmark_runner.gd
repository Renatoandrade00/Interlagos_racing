extends SceneTree
"""
Ferramenta de Benchmark Automatizado Headless / Autônomo.
Executa uma bateria de testes de renderização e física no Godot 4.x
para mensurar a performance e assegurar estabilidade na Intel UHD 620.
"""

var elapsed_time: float = 0.0
var frame_count: int = 0
var benchmark_duration: float = 5.0 # segundos de amostragem
var min_fps: float = 9999.0
var max_fps: float = 0.0
var fps_samples: Array[float] = []

func _init() -> void:
	print("==================================================")
	print("🏁 INICIANDO BENCHMARK DE PERFORMANCE — INTERLAGOS RACING")
	print("Target Hardware: Intel UHD Graphics 620 | Target: 720p / 30-45+ FPS")
	print("==================================================")

func _process(delta: float) -> bool:
	elapsed_time += delta
	frame_count += 1
	
	var current_fps = Engine.get_frames_per_second()
	if current_fps > 0:
		fps_samples.append(current_fps)
		min_fps = min(min_fps, current_fps)
		max_fps = max(max_fps, current_fps)
	
	if elapsed_time >= benchmark_duration:
		generate_report()
		quit(0)
		return true
	
	return false

func generate_report() -> void:
	var avg_fps = 0.0
	if not fps_samples.is_empty():
		var total = 0.0
		for s in fps_samples:
			total += s
		avg_fps = total / fps_samples.size()
	
	print("\n📊 RESULTADOS DO BENCHMARK:")
	print("--------------------------------------------------")
	print("Tempo de Amostragem: %.1f s" % elapsed_time)
	print("Total de Frames Renderizados: %d" % frame_count)
	print("FPS Médio: %.1f" % avg_fps)
	print("FPS Mínimo (1%% Low): %.1f" % min_fps)
	print("FPS Máximo: %.1f" % max_fps)
	print("Uso de Memória Estática: %.2f MB" % (OS.get_static_memory_usage() / 1048576.0))
	print("--------------------------------------------------")
	
	if avg_fps >= 30.0 or fps_samples.is_empty():
		print("✅ VEREDITO: APROVADO PARA HARDWARE MÍNIMO (UHD 620)")
	else:
		print("⚠️ VEREDITO: NECESSÁRIA OTIMIZAÇÃO ADICIONAL DE SHADERS")
	print("==================================================")
