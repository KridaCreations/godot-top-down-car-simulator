extends RigidBody2D


func _ready():
	pass
#	apply_torque_impulse(20)
#	apply_impulse(Vector2(20,20),Vector2(1,1))
	apply_impulse(Vector2(0,-30),Vector2(5000,0))
