extends Node2D
var currentscn = null

var menu = preload("res://scenes/Menu.tscn")
var house = preload("res://scenes/LevelHouse.tscn")
var driving = preload("res://scenes/LevelDriving.tscn")
var arriving = null

var level0 = preload("res://scenes/Level0.tscn")

func _ready():
	if currentscn == null:
		add_scene(menu)
		
func add_scene(obj):
	if currentscn != null:
		currentscn.queue_free()
	
	var m = obj.instance()
	currentscn = m
	add_child(m)
	
func notify_levelend():
	if currentscn.name == "LevelHouse":
		add_scene(driving)
	elif currentscn.name == "LevelDriving":
		add_scene(arriving)
	elif currentscn.name == "LevelArriving":
		add_scene(level0)
		
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit_game"):
		if currentscn.name == "Menu":
			get_tree().quit()
		else:
			add_scene(menu)
		
	if event.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
		
	if currentscn.name == "Menu":
		if event.is_action_pressed("ui_accept"):
			add_scene(house)
