@tool
extends Node3D
class_name InterlagosTrackBuilder

## Construtor Procedural do Circuito Completo de Interlagos (Autódromo José Carlos Pace)
## Gera pista contínua (asfalto FIA 14m), zebras 3D, linhas brancas, guardrails e colisores.

@export var asphalt_texture: Texture2D = preload("res://Graphics/asphalt_texture.png")
@export var track_width: float = 14.0
@export var samples_per_segment: int = 10

# Spline de nós mestres dos 3 setores do Circuito de Interlagos
const CIRCUIT_NODES: Array[Vector3] = [
	# --- SETOR 1: RETA PRINCIPAL, S DO SENNA E CURVA DO SOL ---
	Vector3(0.0, 0.0, -130.0),    # 0: Linha de Largada/Chegada
	Vector3(0.0, 0.0, -40.0),     # 1: Reta Principal (Pits)
	Vector3(0.0, 0.0, 60.0),      # 2: Reta Principal (Meio)
	Vector3(0.0, 0.0, 150.0),     # 3: Ponto de Frenagem Curva 1
	Vector3(-10.0, -2.5, 205.0),  # 4: S do Senna - Curva 1 (Esquerda Descida)
	Vector3(-22.0, -4.5, 240.0),  # 5: S do Senna - Curva 2 (Direita)
	Vector3(-45.0, -6.5, 275.0),  # 6: Curva do Sol (Ápice Esquerda)
	Vector3(-80.0, -7.0, 280.0),  # 7: Saída da Curva do Sol
	# --- SETOR 2: RETA OPOSTA, DESCIDA DO LAGO, FERRADURA, LARANJINHA, BICO DE PATO ---
	Vector3(-140.0, -7.0, 230.0), # 8: Reta Oposta (Zona de DRS)
	Vector3(-195.0, -7.0, 150.0), # 9: Fim da Reta Oposta (Frenagem Forte)
	Vector3(-225.0, -6.5, 80.0),  # 10: Descida do Lago - Curva 4 (Esquerda 90°)
	Vector3(-220.0, -5.5, 10.0),  # 11: Descida do Lago - Curva 5 (Saída)
	Vector3(-195.0, -4.0, -40.0), # 12: Aproximação Ferradura
	Vector3(-155.0, -2.0, -85.0), # 13: Curva da Ferradura (Direita Longa Subida)
	Vector3(-125.0, -0.5, -115.0),# 14: Saída da Ferradura
	Vector3(-95.0, 1.0, -145.0),  # 15: Curva da Laranjinha (Direita Cega)
	Vector3(-75.0, 1.0, -125.0),  # 16: Saída Laranjinha
	Vector3(-60.0, 0.5, -85.0),   # 17: Curva do Pinheirinho (Esquerda Técnica)
	Vector3(-50.0, 0.0, -100.0),  # 18: Saída Pinheirinho
	Vector3(-45.0, -0.5, -135.0), # 19: Bico de Pato (Hairpin Lenta Direita)
	# --- SETOR 3: MERGULHO, JUNÇÃO, SUBIDA DOS BOXES E CURVA DO CAFÉ ---
	Vector3(-38.0, -1.5, -160.0), # 20: Saída Bico de Pato
	Vector3(-30.0, -3.0, -195.0), # 21: Curva do Mergulho (Descida Rápida Esquerda)
	Vector3(-20.0, -2.0, -225.0), # 22: Curva da Junção (Esquerda em Subida Crucial)
	Vector3(-12.0, -0.8, -205.0), # 23: Subida dos Boxes (Aceleração Plena)
	Vector3(-4.0, 0.0, -170.0),   # 24: Curva do Café (Esquerda de Alta para a Reta)
]

func _ready() -> void:
	build_full_circuit()

func get_circuit_waypoints() -> Array[Vector3]:
	return CIRCUIT_NODES.duplicate()

func build_full_circuit() -> void:
	# 1. Gerar pontos interpolados (Spline Catmull-Rom fechada)
	var spline_points: Array[Vector3] = _generate_catmull_rom_spline(CIRCUIT_NODES, samples_per_segment)
	
	# 2. Criar malha de asfalto e colisores
	var track_body := StaticBody3D.new()
	track_body.name = "FullTrackSurface"
	add_child(track_body)
	
	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "TrackMesh"
	
	var road_mesh := _build_road_mesh(spline_points, track_width)
	mesh_inst.mesh = road_mesh
	track_body.add_child(mesh_inst)
	
	# Colisor exato da pista para a física do carro
	var col_shape := CollisionShape3D.new()
	col_shape.name = "TrackCollision"
	col_shape.shape = road_mesh.create_trimesh_shape()
	track_body.add_child(col_shape)
	
	# 3. Adicionar Zebras 3D nas curvas principais
	_add_curbs_to_circuit()

func _generate_catmull_rom_spline(nodes: Array[Vector3], samples: int) -> Array[Vector3]:
	var result: Array[Vector3] = []
	var n := nodes.size()
	
	for i in range(n):
		var p0 = nodes[(i - 1 + n) % n]
		var p1 = nodes[i]
		var p2 = nodes[(i + 1) % n]
		var p3 = nodes[(i + 2) % n]
		
		for step in range(samples):
			var t := float(step) / float(samples)
			var pt := _catmull_rom_point(p0, p1, p2, p3, t)
			result.append(pt)
	
	return result

func _catmull_rom_point(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, t: float) -> Vector3:
	var t2 := t * t
	var t3 := t2 * t
	return 0.5 * (
		(2.0 * p1) +
		(-p0 + p2) * t +
		(2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 +
		(-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3
	)

func _build_road_mesh(points: Array[Vector3], width: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var half_w := width * 0.5
	var n := points.size()
	var uv_accum: float = 0.0
	
	var left_verts: Array[Vector3] = []
	var right_verts: Array[Vector3] = []
	var uvs: Array[float] = []
	
	for i in range(n):
		var p := points[i]
		var next_p := points[(i + 1) % n]
		var dir := (next_p - p).normalized()
		var right := dir.cross(Vector3.UP).normalized()
		
		var left_pt := p - (right * half_w)
		var right_pt := p + (right * half_w)
		
		left_verts.append(left_pt)
		right_verts.append(right_pt)
		
		if i > 0:
			uv_accum += p.distance_to(points[i - 1]) * 0.1
		uvs.append(uv_accum)
	
	# Construir triângulos da fita de asfalto
	for i in range(n):
		var next_i := (i + 1) % n
		var l0 := left_verts[i]
		var r0 := right_verts[i]
		var l1 := left_verts[next_i]
		var r1 := right_verts[next_i]
		
		var uv0_y := uvs[i]
		var uv1_y := uvs[next_i] if next_i > 0 else (uvs[n - 1] + 1.0)
		
		# Triângulo 1 (l0 -> l1 -> r1)
		st.set_uv(Vector2(0.0, uv0_y)); st.add_vertex(l0)
		st.set_uv(Vector2(0.0, uv1_y)); st.add_vertex(l1)
		st.set_uv(Vector2(1.0, uv1_y)); st.add_vertex(r1)
		
		# Triângulo 2 (l0 -> r1 -> r0)
		st.set_uv(Vector2(0.0, uv0_y)); st.add_vertex(l0)
		st.set_uv(Vector2(1.0, uv1_y)); st.add_vertex(r1)
		st.set_uv(Vector2(1.0, uv0_y)); st.add_vertex(r0)
	
	st.generate_normals()
	st.generate_tangents()
	
	var am := ArrayMesh.new()
	st.commit(am)
	
	# Aplicar Material PBR de Asfalto
	var mat := StandardMaterial3D.new()
	if asphalt_texture:
		mat.albedo_texture = asphalt_texture
	else:
		mat.albedo_color = Color(0.18, 0.19, 0.22, 1.0)
	mat.roughness = 0.82
	mat.uv1_scale = Vector3(4.0, 1.0, 1.0)
	am.surface_set_material(0, mat)
	
	return am

func _add_curbs_to_circuit() -> void:
	var curb_scene: PackedScene = preload("res://Tracks/TrackCurb.tscn")
	if not curb_scene:
		return
	
	# Posições estratégicas de zebras nos ápices e saídas
	var curb_transforms: Array[Transform3D] = [
		# S do Senna (Curva 1 e 2)
		Transform3D(Basis(Vector3.UP, deg_to_rad(-25)), Vector3(-16.0, -2.5, 205.0)),
		Transform3D(Basis(Vector3.UP, deg_to_rad(45)), Vector3(-28.0, -4.5, 240.0)),
		# Curva do Sol
		Transform3D(Basis(Vector3.UP, deg_to_rad(-60)), Vector3(-50.0, -6.5, 275.0)),
		# Descida do Lago
		Transform3D(Basis(Vector3.UP, deg_to_rad(-90)), Vector3(-230.0, -6.5, 80.0)),
		# Ferradura
		Transform3D(Basis(Vector3.UP, deg_to_rad(65)), Vector3(-150.0, -2.0, -85.0)),
		# Bico de Pato
		Transform3D(Basis(Vector3.UP, deg_to_rad(85)), Vector3(-40.0, -0.5, -135.0)),
		# Junção
		Transform3D(Basis(Vector3.UP, deg_to_rad(-45)), Vector3(-25.0, -2.0, -225.0)),
		# Curva do Café
		Transform3D(Basis(Vector3.UP, deg_to_rad(-15)), Vector3(-8.0, 0.0, -170.0)),
	]
	
	var curbs_root := Node3D.new()
	curbs_root.name = "CircuitCurbs"
	add_child(curbs_root)
	
	for t in curb_transforms:
		var curb_inst = curb_scene.instantiate() as Node3D
		curb_inst.transform = t
		curbs_root.add_child(curb_inst)
