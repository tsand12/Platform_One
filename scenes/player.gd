extends CharacterBody2D

var inputDict: Dictionary = {"D":"move_right", "A":"move_left"}

const WALK_SPEED = 150.0
const RUN_SPEED = 215.0
const JUMP_VELOCITY = -300.0
const DOUBLE_PRESS_TIMEOUT := 0.5

# --- movement
var move_speed: float = 150.0
# --- event monitoring vars
var currentEvent: InputEvent = null
var lastEvent: InputEvent = null
var keyPressIter: int = 0 # TODO no longer needed. REMOVE
var elapsedKeyTime: float = 0.0
var keyDoublePressed: bool = false
var isKeyHeld: bool = false

# --- Game-Defined Actions. FIXME turn into ENUM class?
var move_left: String = "move_left";
var move_right: String = "move_right"


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := Input.get_axis(move_left, move_right)
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()

# Handles game-defined player actions.
#
#PARAMS: InputEvent, the user input
#	unused event param must remain as this is an overriden native godot method
#RETURNS: None		
func _input(event: InputEvent) -> void:
	currentEvent = event
	handleDualMovement()
	handleMovementSpeed()
	
	# sets "current" event to "last" event on key release
	if(currentEvent.is_released()):
		lastEvent = event

func _process(delta: float) -> void:
	elapsedKeyTime += delta
	
	
# Handles game-define player movements settings and default Godot-defined player movements.
#
#PARAMS: None
#RETURNS: None		
func handleDualMovement() -> void:	
	if Input.is_action_just_pressed("ui_left"):
		move_left = "ui_left"
	elif Input.is_action_just_pressed("move_left"):
		move_left = "move_left"
	elif Input.is_action_just_pressed("ui_right"):
		move_right = "ui_right"
	elif Input.is_action_just_pressed("move_right"):
		move_right = "move_right"
#
#
# TODO check this out if stuck: https://forum.godotengine.org/t/double-inputs-in-godot/119104
func handleMovementSpeed() -> void:
	if(Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left")):
		if(keyPressedTwice()):
			print(currentEvent.as_text() + " pressed TWICE!")
			if(isWithinTimeLimit(elapsedKeyTime, DOUBLE_PRESS_TIMEOUT)):				
				print("increasing movement speed!!")
				move_speed = RUN_SPEED
			else:
				print("set to walk speed!!, " + "time elapsed: " + str(elapsedKeyTime) + " , timeout: " + str(DOUBLE_PRESS_TIMEOUT))
				move_speed = WALK_SPEED
				elapsedKeyTime = 0
		else:
			move_speed = WALK_SPEED
		
		print("movement speed: " + str(move_speed))

# Detects if any key was pressed twice
# PARAMS: none
# RETURNS: bool -> returns true if a key has been pressed twice.
func keyPressedTwice() -> bool:
	#print("Last Button Pressed: " +  lastEvent.as_text() + ", Current button press: " + currentEvent.as_text())
	if(lastEvent.as_text() != currentEvent.as_text()):
		elapsedKeyTime = 0
		return false;
	else:
		return true

# checks if a Time component falls within a boundary/limit.
#PARAMS: 
#	timeElapsed (float): The delta from some native process function
#	timeout (float): The boundary/limit, can be custom 
#RETURNS: bool -> true if timeElapsed is less than or equal to the set timeout value
func isWithinTimeLimit(timeElapsed: float, timeout: float) -> bool:
	return timeElapsed <= timeout
	
	
	
# TODO get player to run on double press -- DONE
# TODO get player animation to change between "walk" and "run"
# TODO clean up "move_left" and "ui_left" option. Have both detected as left instead of check for them individually

	
