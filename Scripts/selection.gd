extends Sprite2D

func select(element : CharacterBody2D):
	position = element.position + Vector2(0, -30)
