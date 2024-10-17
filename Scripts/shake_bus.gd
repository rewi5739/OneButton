extends Node

signal shake_triggered(strength: float, fade: float)

func trigger_shake(strength: float = 30, fade: float = 5):
	shake_triggered.emit(strength, fade)
