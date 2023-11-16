	
	.include "./video.asm"
	.include "./keyboard.asm"
	.include "./map.asm"
	
	.data
VIDEO_MEMORY: .space VIDEO_MEMORY_SIZE
MAP_MEMORY: .space MAP_MEMORY_SIZE
PLAYER:  .space 8
ENEMIES: .space 32

Octal_Result: .space 20
	
	.text
#------------------------Macro Para Transformar de Decimal a Octal ----------------------------------------------------------------#
	.macro DecimalToOctal(%decimal)
	li $t7 8 #Base 8 por la que vamos a dividir
	li $t8 0 #Este sera el resultado
	deciOctal_loop: 
		    div %decimal, $t7    # Dividir el número por 8
    		    mfhi $t6        
                    addi $t6, $t6, '0' # Convertir el residuo a carácter para poder ser guardado
                    sb $t6, Octal_Result($t8) # Almacenar 
                    addi $t8, $t8, 1  # Incrementar la posición del space del resultado en donde estamos guardando
                    mflo %decimal        # Actualizar el número ingresado
                    bnez %decimal, loop   
		
	.globl main
	
main:
	li $s5, C_CYAN
	li $s6, C_BLACK
	li $s7, C_RED
main_loop:

	# Move enemy
	la $a0, ENEMIES
	jal move_enemy
	
	LOAD_VIDEO_OFFSET($t0, $s0, $s1)
	sw $s6, VIDEO_MEMORY($t0)

	lw $s0, 0($a0)
	lw $s1, 4($a0)
	
	LOAD_VIDEO_OFFSET($t0, $s0, $s1)
	sw $s7, VIDEO_MEMORY($t0)
	
	
	# Wait for key press and move player
main_poll:
	READ_KEYSTROKE($t0)
	beq $t0, 'w', main_up
	beq $t0, 'a', main_left
	beq $t0, 's', main_down
	beq $t0, 'd', main_right
	b main_poll
main_up:
	li $a1, 0
	b main_poll_end
main_down:
	li $a1, 1
	b main_poll_end
main_left:
	li $a1, 2
	b main_poll_end
main_right:
	li $a1, 3
	b main_poll_end
	
main_poll_end:
	la $a0, PLAYER
	jal move_player
	
	LOAD_VIDEO_OFFSET($t0, $s2, $s3)
	sw $s6, VIDEO_MEMORY($t0)

	lw $s2, 0($a0)
	lw $s3, 4($a0)
	
	LOAD_VIDEO_OFFSET($t0, $s2, $s3)
	sw $s5, VIDEO_MEMORY($t0)
	
	b main_loop

	li $v0, 10
	syscall

# ---- PARAMS ----- #
# $a0: Player address
# $a1: Movement direction
#
# ---- RETURN ----- #
# 0($a0): New X coord
# 4($a0): New Y coord
# $v0: Current tile at position
# $v1: Set if couldn't move
#
# ---- VARIABLES ----- #
# $a0: Player address
# $t0: Initial X coord
# $t1: Initial Y coord
# $t2: New X coord
# $t3: New Y coord
# $t4: Tile offset
#
move_player:
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	
move_player__switch:
	and $a1, $a1, 3
	beq $a1, 0, move_player__up
	beq $a1, 1, move_player__down
	beq $a1, 2, move_player__left
	beq $a1, 3, move_player__right
	
move_player__check:
	bgeu $t2, MAP_WIDTH, move_player__fail
	bgeu $t3, MAP_HEIGHT, move_player__fail
	LOAD_MAP_OFFSET($t4, $t2, $t3)
	lbu $t4, MAP_MEMORY($t4)
	beq $t4, T_WALL, move_player__fail
	
move_player__end:
	move $v0, $t4
	sw $t2, 0($a0)
	sw $t3, 4($a0)
	jr $ra

move_player__fail:
	move $v0, $t4
	li $v1, 1
	jr $ra
	
move_player__up:
	move $t2, $t0
	subu $t3, $t1, 1
	b move_player__check
	
move_player__down:
	move $t2, $t0
	addu $t3, $t1, 1
	b move_player__check
	
move_player__left:
	subu $t2, $t0, 1
	move $t3, $t1
	b move_player__check
	
move_player__right:
	addu $t2, $t0, 1
	move $t3, $t1
	b move_player__check

# ---- PARAMS ----- #
# $a0: Enemy address
#
# ---- RETURN ----- #
# 0($a0): New X coord
# 4($a0): New Y coord
# $v0: Current tile at position
#
# ---- VARIABLES ----- #
# $a0: Random integer
# $t0: Initial X coord
# $t1: Initial Y coord
# $t2: New X coord
# $t3: New Y coord
# $t4: Tile offset
# $t7: Enemy address
#
move_enemy:
	move $t7, $a0

	lw $t0, 0($a0)
	lw $t1, 4($a0)
	
	li $a0, 0
	li $a1, 4
	li $v0, 42
	syscall
	
move_enemy__switch:
	addu $a0, $a0, 1
	and $a0, $a0, 3
	beq $a0, 0, move_enemy__up
	beq $a0, 1, move_enemy__down
	beq $a0, 2, move_enemy__left
	beq $a0, 3, move_enemy__right
	b move_enemy__switch
	
move_enemy__check:
	bgeu $t2, MAP_WIDTH, move_enemy__switch
	bgeu $t3, MAP_HEIGHT, move_enemy__switch
	LOAD_MAP_OFFSET($t4, $t2, $t3)
	lbu $t4, MAP_MEMORY($t4)
	beq $t4, T_WALL, move_enemy__switch
	
move_enemy__end:
	move $a0, $t7
	move $v0, $t4
	sw $t2, 0($a0)
	sw $t3, 4($a0)
	jr $ra
	
move_enemy__up:
	move $t2, $t0
	subu $t3, $t1, 1
	b move_enemy__check
	
move_enemy__down:
	move $t2, $t0
	addu $t3, $t1, 1
	b move_enemy__check
	
move_enemy__left:
	subu $t2, $t0, 1
	move $t3, $t1
	b move_enemy__check
	
move_enemy__right:
	addu $t2, $t0, 1
	move $t3, $t1
	b move_enemy__check
