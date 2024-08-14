extends Node3D
# carregada na memoria do jogo assim que iniciado
const BALL = preload("res://ball.tscn")
#@onready var ball = $MovimentoBasico/Ball

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
# spawnar de acordo com um tempo estabelecido no node Timer
func _on_spawn_timer_timeout():
	# coletando node de referencia dos points da bola
	# randomizando um array
	# Node3d -> para ter acesso as propriedades de posição
	var point = get_tree().get_nodes_in_group("spawn").pick_random() as Node3D
	# criando uma instancia da bola 
	var ball = BALL.instantiate() as RigidBody3D
	# instanciado a bola ao mapa Main
	add_child(ball)
	# assosiando posição da bola aos points criados no mapa
	ball.global_position = point.global_position
	
	
# pegando a direção a partir do teclado
# Vector2 (x, y)
	#var direction = Input.get_vector("ui_left", "ui_right", "ui_page_up", "ui_down")
	
	#if direction.length() > 0:
		# utilizando vector3 pois é um elemento 3d
		# direction.y = posição x (frente)
		# direction.z  = 0.0 (não pular)
		# -direction.x posição y (lados, negativo pois direçao do input é invertido)
		# normalized = nao alterar velocidade vertical, x =1, y =1
		# multiplicando por 0.5 para reduzir a velocidade
		
		#ball.apply_impulse(Vector3(direction.y, 0.0, direction.x).normalized() * 0.5)



