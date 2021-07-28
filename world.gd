extends Node2D


var lines_to_draw = []

func _ready():
	get_node("display/speed_bar").max_value = $k_car.speed_limit
	get_node("display/speed_bar").value = ($k_car.speed)
	get_node("display/speed_label").text = str($k_car.front_vel)
	pass

func _physics_process(delta):
	get_node("display/speed_bar").value = ($k_car.speed)
	get_node("display/speed_label").text = str($k_car.front_vel)
	get_node("display").global_position = $k_car/Camera2D.get_camera_screen_center()

func _draw():
	
	for i in $k_car.lines_to_draw:
		print(i)
		draw_line($k_car.global_position+i[0],($k_car.global_position+i[0])+i[1],"ff6d66",5)

