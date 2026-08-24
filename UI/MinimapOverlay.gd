extends Control
class_name MinimapOverlay

@export var player_node: Node3D
@export var ai_nodes: Array[Node3D] = []

# Dimensões da área da pista em metros para mapeamento 2D do circuito completo
@export var world_min: Vector2 = Vector2(-250.0, -250.0) # X, Z
@export var world_max: Vector2 = Vector2(30.0, 310.0)

@onready var track_line: Line2D = $Panel/MapArea/TrackLine
@onready var player_dot: ColorRect = $Panel/MapArea/PlayerDot
@onready var map_area: Control = $Panel/MapArea

var ai_dots: Array[ColorRect] = []

func _ready() -> void:
	setup_minimap_track()
	setup_ai_dots()

func setup_minimap_track() -> void:
	track_line.clear_points()
	
	# Usar nós mestres do circuito completo de Interlagos
	var nodes = InterlagosTrackBuilder.CIRCUIT_NODES
	for pt in nodes:
		var pt2d := Vector2(pt.x, pt.z)
		track_line.add_point(world_to_minimap(pt2d))
	
	# Fechar o traçado no ponto inicial
	if not nodes.is_empty():
		var first_pt := Vector2(nodes[0].x, nodes[0].z)
		track_line.add_point(world_to_minimap(first_pt))

func setup_ai_dots() -> void:
	for i in range(ai_nodes.size()):
		var dot = ColorRect.new()
		dot.size = Vector2(6, 6)
		dot.color = Color(0.95, 0.2, 0.2, 1) # Ponto vermelho para os rivais
		map_area.add_child(dot)
		ai_dots.append(dot)

func _process(_delta: float) -> void:
	if not map_area:
		return
	
	# Posição do Player no minimapa
	if player_node and is_instance_valid(player_node):
		var p_pos2d = Vector2(player_node.global_transform.origin.x, player_node.global_transform.origin.z)
		var p_map_pos = world_to_minimap(p_pos2d)
		player_dot.position = p_map_pos - (player_dot.size * 0.5)
	
	# Posição dos oponentes IA
	for i in range(ai_nodes.size()):
		var ai = ai_nodes[i]
		if i < ai_dots.size() and is_instance_valid(ai):
			var ai_pos2d = Vector2(ai.global_transform.origin.x, ai.global_transform.origin.z)
			var ai_map_pos = world_to_minimap(ai_pos2d)
			ai_dots[i].position = ai_map_pos - (ai_dots[i].size * 0.5)

func world_to_minimap(world_pos: Vector2) -> Vector2:
	var area_size = map_area.size
	var norm_x = inverse_lerp(world_min.x, world_max.x, world_pos.x)
	var norm_y = inverse_lerp(world_min.y, world_max.y, world_pos.y)
	
	return Vector2(norm_x * area_size.x, norm_y * area_size.y)
