extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var mouse_sensitivy = 0.01

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
		pivot.rotate_y(-(event as InputEventMouseMotion).relative.x * mouse_sensitivy)
		# adicionando rotação vertical
		camera.rotate_x(-(event as InputEventMouseMotion).relative.y * mouse_sensitivy)
		# limitando rotação vertical
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	# adicionado pivot para player se mover na direção em que a camera esta apontando
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# capturando oque atingir a area do player
func _on_area_3d_body_entered(body):
	# se body for uma bola
	if (body as Node3D).is_in_group("ball"):
		# se atingido sair do game
		get_tree().quit()
