extends Node3D
class_name PPMovement3d


# variavel privada, fazendo herança dessa classe para herdar de um CharacterBody3D
@onready var _parent : CharacterBody3D = get_parent() as CharacterBody3D
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivy = 0.003

var _pivot = SpringArm3D
var _camera = Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#func _ready():
	#_pivot = SpringArm3D.new()
	#add_child(_pivot)
	#_pivot.rotation_degrees.x = 80
	#_camera = Camera3D.new()
	#_pivot.add_child(_camera)
	


# Capturar o mouse
func _input(event):
	if event is InputEventMouseButton: # se clicar com o botão na tela
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # capture o mouse
	elif  Input.is_action_just_pressed("ui_cancel"): # se pressionado ESC
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # o mouse fica visivel
	
	# se acontecer movimento do mouse e o mouse for capturado
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# adicionando rotação ao node pivot
		# .rotate_y -> o quanto o mouse se moveu
		# .rotate_y( convertendo pixel em  radianos, para a sensibilidade ser aceitavel)
		# (event is InputEventMouseMotion) -> para poder acessar as propriedades
		# relative -> retorna o quanto que ele se moveu dese a ultima posição
		
		# _pivot -> tudo que for relativo ao player precisa herdar dele
		_parent.rotate_y(-(event as InputEventMouseMotion).relative.x * mouse_sensitivy)
		
		# adicionando rotação vertical
		_parent.rotate_x(-(event as InputEventMouseMotion).relative.y * mouse_sensitivy)
		
		# limitando rotação vertical
		_camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
	

func _physics_process(delta):
	# Add the gravity.
	if not _parent.is_on_floor():
		_parent.velocity.y -= _gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and _parent.is_on_floor():
		_parent.velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	# adicionado _parent. para player se mover na direção em que a camera esta apontando
	var direction = (_parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		_parent.velocity.x = direction.x * speed
		_parent.velocity.z = direction.z * speed
	else:
		_parent.velocity.x = move_toward(_parent.velocity.x, 0, speed)
		_parent.velocity.z = move_toward(_parent.velocity.z, 0, speed)

	_parent.move_and_slide()

# capturando oque atingir a area do player
func _on_area_3d_body_entered(body):
	# se body for uma bola
	if (body as Node3D).is_in_group("ball"):
		# se atingido sair do game
		get_tree().quit()

