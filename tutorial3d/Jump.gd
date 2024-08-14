extends MeshInstance3D

@export var jump = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# signal utilizado para capturar e disparar a entrada de um body na area
func _on_area_3d_body_entered(body):
	# verifica se o body que entrou na area for do grupo player
	if (body as Node3D).is_in_group("player"):
		# acessando propriedade do player para forçar um jump em y
		(body as CharacterBody3D).velocity.y += jump
			
