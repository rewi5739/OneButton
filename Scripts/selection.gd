extends Sprite2D

func select(element : CharacterBody2D):
	position = element.global_position + Vector2(0, -30)
