extends MeshInstance3D
## Gera uma carroceria de carro esportivo GT com superfícies curvas e suaves.
## A malha é construída por lofting de perfis transversais (cross-section lofting).
## Anexe a um MeshInstance3D filho do VehicleBody3D.

@export var paint_color: Color = Color(0.08, 0.35, 0.85, 1.0)

func _ready() -> void:
	mesh = _build_body()
	_apply_paint()

func _apply_paint() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = paint_color
	mat.metallic = 0.88
	mat.metallic_specular = 0.75
	mat.roughness = 0.18
	mat.clearcoat_enabled = true
	mat.clearcoat = 0.85
	mat.clearcoat_roughness = 0.1
	material_override = mat

func _build_body() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var sections := _sections()
	var n: int = sections[0][1].size()
	
	# Gerar casca do carro conectando perfis adjacentes com quads (2 triangulos cada)
	for s in range(sections.size() - 1):
		var z0: float = sections[s][0]
		var p0: Array = sections[s][1]
		var z1: float = sections[s + 1][0]
		var p1: Array = sections[s + 1][1]
		for i in range(n):
			var j: int = (i + 1) % n
			var a := Vector3(p0[i].x, p0[i].y, z0)
			var b := Vector3(p0[j].x, p0[j].y, z0)
			var c := Vector3(p1[j].x, p1[j].y, z1)
			var d := Vector3(p1[i].x, p1[i].y, z1)
			# Winding order para normais apontando para fora
			st.add_vertex(a); st.add_vertex(d); st.add_vertex(c)
			st.add_vertex(a); st.add_vertex(c); st.add_vertex(b)
	
	# Tampar frente e traseira
	_cap(st, sections[0], true)
	_cap(st, sections[sections.size() - 1], false)
	
	st.generate_normals()
	var am := ArrayMesh.new()
	st.commit(am)
	return am

func _cap(st: SurfaceTool, sec: Array, front: bool) -> void:
	var z: float = sec[0]
	var pts: Array = sec[1]
	var cy: float = 0.0
	for p in pts:
		cy += p.y
	cy /= float(pts.size())
	var center := Vector3(0.0, cy, z)
	for i in range(pts.size()):
		var j: int = (i + 1) % pts.size()
		var a := Vector3(pts[i].x, pts[i].y, z)
		var b := Vector3(pts[j].x, pts[j].y, z)
		if front:
			st.add_vertex(center); st.add_vertex(a); st.add_vertex(b)
		else:
			st.add_vertex(center); st.add_vertex(b); st.add_vertex(a)

## Define 11 perfis transversais do carro, da frente (+Z) para a traseira (-Z).
## Cada perfil tem 8 pontos simétricos descrevendo a silhueta do carro naquela seção.
func _sections() -> Array:
	return [
		# Lip frontal - estreito e baixo (splitter dianteiro)
		[2.15,  _p(0.52, 0.58, 0.38, 0.12, 0.24, 0.38, 0.42)],
		# Para-choque dianteiro
		[1.85,  _p(0.72, 0.80, 0.62, 0.10, 0.34, 0.50, 0.54)],
		# Zona dos faróis - alargando
		[1.40,  _p(0.82, 0.88, 0.74, 0.08, 0.40, 0.58, 0.62)],
		# Capô (hood) - largura máxima, perfil baixo
		[0.70,  _p(0.86, 0.90, 0.78, 0.08, 0.44, 0.64, 0.68)],
		# Base do para-brisa
		[0.25,  _p(0.86, 0.90, 0.78, 0.08, 0.44, 0.68, 0.72)],
		# Pilar-A / início da cabine - teto sobe
		[-0.05, _p(0.82, 0.88, 0.64, 0.08, 0.44, 1.00, 1.04)],
		# Teto central
		[-0.45, _p(0.82, 0.88, 0.62, 0.08, 0.44, 1.02, 1.06)],
		# Pilar-B / teto traseiro - começa a descer
		[-0.85, _p(0.82, 0.88, 0.66, 0.08, 0.44, 0.92, 0.96)],
		# Porta-malas
		[-1.40, _p(0.80, 0.86, 0.74, 0.10, 0.40, 0.62, 0.66)],
		# Para-choque traseiro
		[-1.85, _p(0.70, 0.76, 0.62, 0.12, 0.34, 0.52, 0.54)],
		# Lip traseiro (difusor)
		[-2.10, _p(0.58, 0.64, 0.50, 0.14, 0.30, 0.44, 0.48)],
	]

## Cria um perfil simétrico de 8 pontos.
## xb=largura na base, xm=largura no meio, xt=largura no topo
## yb=altura da base, ym=altura do meio, yts=altura lateral superior, yt=altura do topo
func _p(xb: float, xm: float, xt: float,
		yb: float, ym: float, yts: float, yt: float) -> Array:
	return [
		Vector2(0, yb),        # 0: centro inferior (fundo plano)
		Vector2(xb, yb),       # 1: base direita
		Vector2(xm, ym),       # 2: lateral direita (ombro)
		Vector2(xt, yts),      # 3: topo lateral direito
		Vector2(0, yt),        # 4: centro do teto
		Vector2(-xt, yts),     # 5: topo lateral esquerdo
		Vector2(-xm, ym),      # 6: lateral esquerda
		Vector2(-xb, yb),      # 7: base esquerda
	]
