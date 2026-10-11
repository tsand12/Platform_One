extends Node2D

## Coin Pickup State
var coin_count: int = 0
var coin_state: PickupState.States
signal coins_changed(new_amount: int)
signal coin_state_changed(new_state: PickupState.States)

## Function to store coin count in global variable [coin_count].
##
## Returns:
##	 void
func add_coins() -> void:
	coin_count += 1
	coins_changed.emit(coin_count)
	print("Game Manager Coin count: " + str(coin_count))
	
## Function to store coin count in global variable [coin_count].
##
## Returns:
##	 void
func update_coin_state(updated_state: PickupState.States) -> void:
	coin_state = updated_state
	coin_state_changed.emit(coin_state)
	print("Game Manager Coin STATE: " + PickupState.States.find_key(coin_state))
	
func get_coin_state() -> PickupState.States:
	return coin_state

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	   
