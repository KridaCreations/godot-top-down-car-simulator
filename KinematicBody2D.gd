extends RigidBody2D

export var factor = 2
export var e_force = -10
export var steering_angle = 25
export var rf = 0.05
export var kf = 1

var front_vel = Vector2.ZERO
var back_vel = Vector2.ZERO
onready var prev_pos_front = $front.global_position
onready var prev_pos_back = $back.global_position
func _ready():
	prev_pos_front = $front.global_position
	prev_pos_back = $back.global_position
	apply_impulse($back.global_position,transform.y *10* e_force)
	force_update_transform()
	pass

func round_vec(vec:Vector2,factor):
	vec = vec * factor
	vec.round()
	print((vec/factor).y)
	return vec/factor
	
func _physics_process(delta):
	front_vel = ($front.global_position - prev_pos_front)/delta
	back_vel = ($back.global_position - prev_pos_back)/delta
	var back_pos = round_vec(($back.global_position-global_position),1000)
	var front_pos = round_vec(($front.global_position-global_position),1000)
	prev_pos_front = $front.global_position
	prev_pos_back = $back.global_position
	var rotation = deg2rad(0)
	if Input.is_action_pressed("ui_up"):
		apply_impulse(back_pos,transform.y * e_force)
	elif Input.is_action_pressed("ui_down"):
		apply_impulse(back_pos,transform.y * -e_force)
	
	if Input.is_action_pressed("ui_right"):
		rotation = PI/3
	elif Input.is_action_pressed("ui_left"):
		rotation = -PI/3
		
	var x = 0.3
	var f_wheel_d_vec = transform.y.rotated(rotation)
	f_wheel_d_vec = f_wheel_d_vec.round() #round_vec(f_wheel_d_vec,1000)
#	print(f_wheel_d_vec)
#	var f_wheel_d_vec = rotate_vec(transform.y,(rotation))
	f_wheel_d_vec = f_wheel_d_vec.normalized()
#	print(f_wheel_d_vec)
	var front_vel_r = front_vel.dot(f_wheel_d_vec) * f_wheel_d_vec
	
	var front_vel_k = front_vel - front_vel_r
	apply_impulse(front_pos,-(front_vel_k * kf * x))
	apply_impulse(front_pos,-(front_vel_r * rf * x))
	
	print(front_vel)
	
	var b_wheel_d_vec = transform.y.rotated(deg2rad(0))
	b_wheel_d_vec = b_wheel_d_vec.round()
#	print(b_wheel_d_vec)
#	b_wheel_d_vec = b_wheel_d_vec.round()
	b_wheel_d_vec = b_wheel_d_vec.normalized()
	var back_vel_r = back_vel.dot(b_wheel_d_vec) * b_wheel_d_vec
	var back_vel_k = back_vel - back_vel_r
	apply_impulse(back_pos,-(back_vel_k * kf * x))
	apply_impulse(back_pos,-(back_vel_r * rf * x))
	
func rotate_vec(vec,angle):
	var x = (cos((angle))*vec.x) - (sin((angle))*vec.y)
	var y = (sin((angle))*vec.x) + (cos((angle))*vec.y)
	return Vector2(x,y)
