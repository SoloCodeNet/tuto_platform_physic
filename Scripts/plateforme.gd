extends KinematicBody2D
onready var tw = $Tween

export(Vector2) var end = Vector2.ZERO
export(float) var time_revolution= 2.0

var invert:bool = false
var pos_start: Vector2
var pos_end: Vector2

func _ready() -> void:
	pos_start = self.position
	pos_end   = self.position + end 
	move(invert)
	
func move(value):
	var a = pos_start if value else pos_end
	var b = pos_end if value else pos_start
	tw.interpolate_property(self, "position", a, b, time_revolution/2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tw.start()

func _on_Tween_tween_all_completed():
	invert= !invert
	move(invert)