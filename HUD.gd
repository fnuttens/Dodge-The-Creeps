extends CanvasLayer

signal start_game

func show_message(text):
	$VBoxContainer/MessageLabel.text = text
	$VBoxContainer/MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$VBoxContainer/MessageLabel.text = "Dodge the\nCreeps!"
	$VBoxContainer/MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$VBoxContainer/VBoxContainer/StartButton.show()
	$VBoxContainer/VBoxContainer/HighScoresButton.show()

func update_score(score):
	$VBoxContainer/ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$VBoxContainer/VBoxContainer/StartButton.hide()
	$VBoxContainer/VBoxContainer/HighScoresButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$VBoxContainer/MessageLabel.hide()
