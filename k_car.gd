extends KinematicBody2D

export var mass = 1
export var kf:float = 1
export var orf:float = 0.1
export var steer_speed = 0.5
export var e_force = -5
export var speed_limit = 300
export var max_steer = 45
#2420 asquare + bsqare

onready var front = $front
onready var back = $back
onready var moi = (mass*(2420/12))
onready var prev_f_pos = $front.global_position
onready var prev_b_pos = $back.global_position
onready var prev_pos = global_position
onready var prev_angle = rotation

var target_rotation = 0
var angle = 0
var speed = 0
var lines_to_draw = []
var front_vel = Vector2.ZERO
var back_vel = Vector2.ZERO
var angular_velcity = 0
var velocity = Vector2.ZERO

func _ready():
	Engine.time_scale = 1#0.01
	
	pass

func _physics_process(delta):
	lines_to_draw = []
	var rf = orf
	
	var f = 1
	velocity = ((global_position - prev_pos))/delta
	speed = velocity.length()
	prev_pos = global_position
	if speed > speed_limit:
		f = 0
	
	angular_velcity = (rotation - prev_angle)/delta
	prev_angle = rotation
	
	var f_vec = ($front.global_position - global_position).normalized()
	f_vec = round_vec(f_vec,10000)
	var back_pos = round_vec((back.global_position-global_position),1000)
	var front_pos = round_vec((front.global_position-global_position),1000)
	target_rotation = 0
	if Input.is_action_pressed("ui_up"):
		$Timer.start()
		impulse(back_pos,f_vec * -e_force * f)
	elif Input.is_action_pressed("ui_down"):
		$Timer.start()
		impulse(back_pos,f_vec * (e_force) )
	elif $Timer.is_stopped():
		if speed < 8:
			print("vel")
			front_vel = Vector2.ZERO
			back_vel = Vector2.ZERO
			angular_velcity = 0
			velocity = Vector2.ZERO
		if (front_vel.length() < 3):
			print("f_vel")
			front_vel = Vector2.ZERO
			back_vel = Vector2.ZERO
			angular_velcity = 0
			velocity = Vector2.ZERO
		elif (back_vel.length() < 3):
			print("b_vel")
			front_vel = Vector2.ZERO
			back_vel = Vector2.ZERO
			angular_velcity = 0
			velocity = Vector2.ZERO
	print(speed)
	if Input.is_action_pressed("ui_select"):
		rf = kf
	
	if Input.is_action_pressed("ui_right"):
		target_rotation += max_steer
	if Input.is_action_pressed("ui_left"):
		target_rotation -= max_steer
	
	angle = lerp(angle,target_rotation,steer_speed)
	
	var x = 0.3	
	#front wheel friction///////////////////////////////////////////////
	var f_wheel_d_vec = f_vec.rotated(deg2rad(angle))
	var front_vel_r = front_vel.dot(f_wheel_d_vec) * f_wheel_d_vec
	front_vel_r = round_vec(front_vel_r,1000)
	var front_vel_k = front_vel - front_vel_r
	impulse(front_pos,(front_vel_k.normalized() * kf * e_force))
#	lines_to_draw.append([front_pos,(front_vel_k.normalized() * kf * e_force)])
	impulse(front_pos,(front_vel_r.normalized() * rf * e_force))
	
	
	#back wheel friction/////////////////////////////////////////////////
	var b_wheel_d_vec = f_vec.rotated(deg2rad(0))
	var back_vel_r = back_vel.dot(b_wheel_d_vec) * b_wheel_d_vec
	back_vel_r = round_vec(back_vel_r,1000)
	var back_vel_k = back_vel - back_vel_r
	impulse(back_pos,(back_vel_k.normalized() * kf * e_force))
#	lines_to_draw.append([back_pos,(back_vel_k.normalized() * kf * e_force)])
	impulse(back_pos,(back_vel_r.normalized() * rf * e_force))
	
	move_and_slide(velocity)
	rotate((angular_velcity * delta))
	front_vel = round_vec(($front.global_position - prev_f_pos)/delta,1000)
	back_vel = round_vec(($back.global_position - prev_b_pos)/delta,1000)
	prev_f_pos = $front.global_position
	prev_b_pos = $back.global_position
	get_parent().get_node("Node2D").update()
	
func draw_lines():
	pass
	


func round_vec(vec:Vector2,factor):
	vec *= factor
	vec.x = round(vec.x)
	vec.y = round(vec.y)
	vec /= factor
	return vec
	
func impulse(pos:Vector2,impulse:Vector2):
	var d_angular_velocity = impulse.cross(-pos)/(moi+(mass*(pos.length_squared())))
	
	angular_velcity += d_angular_velocity
	
	var d_velocity = impulse/mass
	velocity += d_velocity

func limiting_impulse(pos:Vector2,impulse:Vector2):
	var d_angular_velocity = impulse.cross(-pos)/(moi+(mass*(pos.length_squared())))
	var n_a_vel = angular_velcity + d_angular_velocity
	if (n_a_vel * angular_velcity <0):# or (angular_velcity == 0):
		angular_velcity = 0
	else:
		angular_velcity = n_a_vel
	
	var d_velocity = impulse/mass
	var nv_x = velocity.x + d_velocity.x
	if (nv_x * velocity.x < 0):# or (velocity.x == 0):
		velocity.x = 0
	else:
		velocity.x += d_velocity.x
	var nv_y = velocity.y + d_velocity.y
	if (nv_y * velocity.y < 0):# or (velocity.y == 0):
		velocity.y = 0
	else:
		velocity.y += d_velocity.y





func _on_Timer_timeout():
	if speed < 16:
		print("vel")
		front_vel = Vector2.ZERO
		back_vel = Vector2.ZERO
		angular_velcity = 0
		velocity = Vector2.ZERO
	if (front_vel.length() < 3):
		print("f_vel")
		front_vel = Vector2.ZERO
		back_vel = Vector2.ZERO
		angular_velcity = 0
		velocity = Vector2.ZERO
	elif (back_vel.length() < 3):
		print("b_vel")
		front_vel = Vector2.ZERO
		back_vel = Vector2.ZERO
		angular_velcity = 0
		velocity = Vector2.ZERO

