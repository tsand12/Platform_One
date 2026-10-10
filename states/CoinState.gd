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
var coins
var state_current
@onready var timer: Timer = $Timer

func _ready() -> void:
	super._ready()
	#timer_init() 
	print("Initial coin state: " + get_current_pickup_state_name())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins = GameManager.coin_count
		
func updateCoinBar(action: CoinAction) -> void:
	match(action):
		CoinAction.RESET:
			coins = COIN_BAR_RESET
			print("Ran out of energy blasts. Resetting coin count...")
		CoinAction.ADD:
			GameManager.add_coins()

	
	print("Coin Bar: " + str(get_coin_count()) + "/" + str(COIN_BAR_SIZE   ))



func _on_body_entered(body: Node2D) -> void:
	# remove coin from screen on pickup	
	print("Coin collected. Current coin state: " + str(get_current_pickup_state_name()))
	handle_coin_state()

## Handles logic for each pickup state for coins.
##
## PARAMS:
##	- [code]delta[\code]: the elapsed time since the previous frame (type: float)
##RETURNS: None
func handle_coin_state() -> void:	
	state_current = GameManager.get_coin_state()
	match state_current:
		PickupState.States.PICKUP_AVAILABLE:
			# TODO this just means the pickup is still available to be collected in the level
			# there should be a "fill-up" bar. Once the bar fills up, the player can shoot
				# projectiles for a period of time (10 seconds?)
			# can collect  coins
			if(get_coin_count() >= COIN_BAR_SIZE):
				print("Coin bar is full...")
				update_pickup_state(PickupState.States.PICKUP_EQUIPPED)
			else:
				updateCoinBar(CoinAction.ADD)
				queue_free()  
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

## Retrieves the current global coin count value.
## 
## Returns:
##     int: The total number of coins sstored in [GameManager].
func get_coin_count() -> int:
	if(GameManager.coin_count > 0):
		coins = GameManager.coin_count
	return coins
	
func timer_init() -> void:
	timer.timeout.connect(tmp_timer_func)
	timer.wait_time = 3

func tmp_timer_func() -> void:
	print("You need to do something here!!!")
