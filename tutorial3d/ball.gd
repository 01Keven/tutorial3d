extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# adicnionando um impulso apenas ao eixo z
	apply_impulse(Vector3(0,0,-30))



