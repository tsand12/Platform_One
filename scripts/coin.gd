extends Area2D
var currentState
## This seems like this script might not be necessary. The CoinState script is already handling the state of the coin pickup.
@onready var coin_state: CoinState = $CoinData


# this should update the COIN_STATE
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_body_entered(body: Node2D) -> void:
	# remove coin from screen on pickup	
	print("Coin collected. Current coin state: " + str(coin_state.get_current_pickup_state_name()))
	queue_free()
	#if(player.coinState.is_available()):
		#player.coins += 1
		#queue_free()
	#else:
		#pass # Replace with function body.
