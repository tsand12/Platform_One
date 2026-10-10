extends PickupState

## This should really be named something like "EnergyState", 
## but we'll keep calling it CoinState since we're literally picking up coins
class_name CoinState
# number of coins it takes for bar to be "full"
const COIN_BAR_SIZE : int = 5 
const COIN_BAR_RESET : int = 0
const PICKUP_ELAPSED_RESET : int = 0
var elapsedTime = 0; #implement a real timer
enum CoinAction {ADD, RESET}
var coins : int = 0
var state_current
@onready var timer: Timer = $Timer


func _ready() -> void:
	super._ready()
	#timer_init()
	print("Initial coin state: " + str(PickupState.States.find_key(super.get_current_pickup_state())) )
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state_current = get_current_pickup_state()
		
func updateCoinBar(action: CoinAction) -> void:
	match(action):
		CoinAction.RESET:
			coins = COIN_BAR_RESET
			print("Ran out of energy blasts. Resetting coin count...")
		CoinAction.ADD:
			coins += 1
	
	print("Coin Bar: " + str(coins) + "/" + str(COIN_BAR_SIZE))



func _on_body_entered(body: Node2D) -> void:
	# remove coin from screen on pickup	
	print("Coin collected. Current coin state: " + str(get_current_pickup_state_name()))
	handle_coin_state()
	queue_free()
	
func handle_coin_state() -> void:
	
	match state_current:
		PickupState.States.PICKUP_AVAILABLE:
			# TODO this just means the pickup is still available to be collected in the level
			# there should be a "fill-up" bar. Once the bar fills up, the player can shoot
				# projectiles for a period of time (10 seconds?)
			# can collect  coins
			
			if(coins >= COIN_BAR_SIZE):
				update_pickup_state(PickupState.States.PICKUP_EQUIPPED)
			else:
				updateCoinBar(CoinAction.ADD)
		PickupState.States.PICKUP_EQUIPPED:
			# TODO indicate powerup is ready to be used (print statement for now). aka the bar is full
			# cannot collect additional coins
			pass
		PickupState.States.PICKUP_ACTIVE:			
			#elapsedTime += delta
			# TODO indicates player has activated power up. Count down should start (if applicable)
			# cannot collect additional coins
			pass
		PickupState.States.PICKUP_EXPIRED:
			# TODO disable powerup (if applicable)
			# set state to AVAILABLE
			pass
			
func timer_init() -> void:
	timer.timeout.connect(tmp_timer_func)
	timer.wait_time = 3
	
	


func tmp_timer_func() -> void:
	print("You need to do something here!!!")
