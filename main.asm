	
	.include "./video.asm"
	.include "./keyboard.asm"
	.include "./map.asm"
	
	.data
VIDEO_MEMORY: .space VIDEO_MEMORY_SIZE
MAP_MEMORY:
	.byte 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
	.byte 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 0 0 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 0 0 0 0 0 0 0 8
	.byte 8 0 0 0 0 0 0 0 8 8 8 8 8 0 8 8
	.byte 8 0 8 8 0 8 8 0 0 0 0 0 0 8 8 8
	.byte 8 8 8 8 8 8 8 8 8 8 8 9 8 8 8 8
TILE_COLORS: TILE_COLORS
PLAYER:
	.word 1, 1, 0, 0 # 0: X coord, 4: Y coord, 8: Coins, 12: Points
ENEMIES_EASY:
	.word  1,  8, 0, 0
	.word  7,  4, 0, 0
	.word 14,  1, 0, 0
	.word 14, 12, 0, 0
	
ENEMIES_HARD:
	.word  1,  8, 0, 0
	.word  7,  4, 0, 0
	.word 14,  1, 0, 0
	.word 14, 12, 0, 0
	.word 7 , 10, 0, 0
	.word 12, 5, 0 , 0
GAME_WON_MSG: .asciiz "GAME WON!!!"
HEXA_POINTS: .asciiz "\nPUNTUACION HEXADECIMAL: "
BINARY_POINTS: .asciiz "\nPUNTUACION BINARIO: "
OCTAL_POINTS: .asciiz "\nPUNTUACION OCTAL: "
DECIMAL_POINTS: .asciiz "\nPUNTUACION DECIMAL: "
GAME_LOST_MSG: .asciiz "GAME OVER..."
SELECT_DIFFICULTY: .asciiz "Selecciona la dificultad: 1 Fácil 2 Difícil\n"

Octal_Result: .space 32
Binary_Result: .space 32
Hexadecimal_Result: .space 32
hex_digits:     .asciiz "0123456789ABCDEF"

	.text
	.globl main
	
main:

	    # Preguntar al usuario la dificultad
    li $v0, 4
    la $a0, SELECT_DIFFICULTY
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0  # Almacena la dificultad
    
    beq $s0, 1, main_prepare_map_easy
    beq $s0, 2, main_prepare_map_hard
    b main
    

main_prepare_map_easy:
	lw $t0, PLAYER+0
	lw $t1, PLAYER+4
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_PLAYER)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_EASY+0x00
	lw $t1, ENEMIES_EASY+0x04
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_EASY+0x10
	lw $t1, ENEMIES_EASY+0x14
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_EASY+0x20
	lw $t1, ENEMIES_EASY+0x24
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_EASY+0x30
	lw $t1, ENEMIES_EASY+0x34
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	b main_start
	
main_prepare_map_hard:
	lw $t0, PLAYER+0
	lw $t1, PLAYER+4
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_PLAYER)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_HARD+0x00
	lw $t1, ENEMIES_HARD+0x04
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_HARD+0x10
	lw $t1, ENEMIES_HARD+0x14
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_HARD+0x20
	lw $t1, ENEMIES_HARD+0x24
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_HARD+0x30
	lw $t1, ENEMIES_HARD+0x34
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_HARD+0x40
	lw $t1, ENEMIES_HARD+0x44
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES_HARD+0x50
	lw $t1, ENEMIES_HARD+0x54
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	b main_start
	
main_start:
	li $a0, 8
	jal prepare_coins
	
main_loop:
	jal paint_map
	
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
main_right:
	li $a1, 1
	b main_poll_end
main_down:
	li $a1, 2
	b main_poll_end
main_left:
	li $a1, 3
	b main_poll_end
main_poll_end:
	la $a0, PLAYER
	jal move_player
	beq $v0, 1, main_poll
	beq $v0, 2, main_save_coin
	beq $v0, 3, main_game_lost
	beq $v0, 4, main_game_won
	beq $s0, 1, main_loop_end_easy
	beq $s0, 2, main_loop_end_hard

main_loop_end_easy:
	la $a0, ENEMIES_EASY+0x00
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_EASY+0x10
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_EASY+0x20
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_EASY+0x30
	jal move_enemy
	bnez $v0, main_game_lost
	
	b main_loop
	
main_loop_end_hard:
	la $a0, ENEMIES_HARD+0x00
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_HARD+0x10
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_HARD+0x20
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_HARD+0x30
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_HARD+0x40
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES_HARD+0x50
	jal move_enemy
	bnez $v0, main_game_lost
	
	b main_loop
	
main_save_coin:
   lw $t0, PLAYER+8         
   addu $t0, $t0, 1         
   sw $t0, PLAYER+8         

   lw $t1, PLAYER+12       
   addiu $t1, $t1, 100      # Incrementar la puntuación por cada moneda (100 puntos)
   sw $t1, PLAYER+12      

   beq $s0, 1, main_loop_end_easy
   beq $s0, 2, main_loop_end_hard


main_game_lost:
	jal paint_map
	la $a0, GAME_LOST_MSG
	li $v0, 4
	syscall
	
	lw $a0, PLAYER+12
	jal print_score
	
	li $v0, 10
	syscall
	
main_game_won:
	jal paint_map
	
	lw $t1, PLAYER+12       
   	addiu $t1, $t1, 1200      # Incrementar la puntuación por Victoria (1200puntos)
    sw $t1, PLAYER+12  
	
	la $a0, GAME_WON_MSG
	li $v0, 4
	syscall
	
	move $a0, $t1
	jal print_score
	
	li $v0, 10
	syscall


# ---- PARAMS ----- #
# $a0: Coin number
# ---- VARIABLES ----- #
# $a0: Random position
# $t0: Coin number
# $t1: Tile value
#
prepare_coins:
	move $t0, $a0
prepare_coins__loop:
	subu $t0, $t0, 1
prepare_coins__loop_repeat:
	
	li $a0, 0
	li $a1, MAP_MEMORY_SIZE
	li $v0, 42
	syscall
	
	lbu $t1, MAP_MEMORY($a0)
	bnez $t1, prepare_coins__loop_repeat
	
	or $t1, $t1, T_COIN
	sb $t1, MAP_MEMORY($a0)
prepare_coins__loop_end:
	bnez $t0, prepare_coins__loop
	jr $ra

# ---- VARIABLES ----- #
# $t0: Map index
# $t1: Video index
# $t2: Tile value
#
paint_map:
	li $t0, 0
	li $t1, 0
paint_map__loop:
	lbu $t2, MAP_MEMORY($t0)
	sll $t2, $t2, 2
	lw $t2, TILE_COLORS($t2)
	sw $t2, VIDEO_MEMORY($t1)
	addu $t0, $t0, 1
	addu $t1, $t1, 4
	bltu $t0, MAP_MEMORY_SIZE, paint_map__loop
	jr $ra
	
	
# ---- PARAMS ----- #
# $a0: Score
# ---- VARIABLES ----- #
#
print_score:
	subu $sp, $sp, 8
	sw $ra, 0($sp)
	sw $a0, 4($sp)

	# Binary
	la $a0, BINARY_POINTS
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)
	jal decimal_to_binary
	move $a0, $v0
	
	li $v0, 4
	syscall
	
	# Octal
	la $a0, OCTAL_POINTS
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)
	jal decimal_to_octal
	move $a0, $v0
	
	li $v0, 4
	syscall
	
	# Hexadecimal
	la $a0, HEXA_POINTS
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)
	jal decimal_to_hexadecimal
	move $a0, $v0
	
	li $v0, 4
	syscall
	
	# Decimal
	la $a0, DECIMAL_POINTS
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)
	li $v0, 1
	syscall
	
	# Return
	lw $ra, 0($sp)
	addu $sp, $sp, 8
	jr $ra

# ---- PARAMS ----- #
# $a0: Player address
# $a1: Movement direction
#
# ---- RETURN ----- #
# 0($a0): New X coord
# 4($a0): New Y coord
# $v0: Status (0: Normal, 1: Wall, 2: Coin, 3: Enemy, 4: Goal)
#
# ---- VARIABLES ----- #
# $a0: Player address
# $t0: Initial X coord
# $t1: Initial Y coord
# $t2: New X coord
# $t3: New Y coord
#
move_player:
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	
move_player__switch:
	and $a1, $a1, 3
	beq $a1, 0, move_player__up
	beq $a1, 1, move_player__right
	beq $a1, 2, move_player__down
	beq $a1, 3, move_player__left
	
move_player__check:
	bgeu $t2, MAP_WIDTH, move_player__wall
	bgeu $t3, MAP_HEIGHT, move_player__wall
	LOAD_MAP_OFFSET($t4, $t2, $t3)
	lbu $t4, MAP_MEMORY($t4)
	beq $t4, T_WALL, move_player__wall
	
move_player__end:
	sw $t2, 0($a0)
	sw $t3, 4($a0)
	
	LOAD_MAP_OFFSET($t5, $t0, $t1)
	lbu $t1, MAP_MEMORY($t5)
	CLEAR_TILE($t1, T_PLAYER)
	sb $t1, MAP_MEMORY($t5)
	
	beq $t4, T_GOAL, move_player__goal
	
	LOAD_MAP_OFFSET($t0, $t2, $t3)
	SET_TILE($t4, T_PLAYER)
	sb $t4, MAP_MEMORY($t0)
	
	and $t5, $t4, T_ENEMY
	bnez $t5, move_player__enemy
	and $t5, $t4, T_COIN
	bnez $t5, move_player__coin
	
move_player__normal:
	li $v0, 0
	jr $ra
move_player__wall:
	li $v0, 1
	jr $ra
move_player__coin:
	CLEAR_TILE($t4, T_COIN)
	sb $t4, MAP_MEMORY($t0)
	
	li $v0, 2
	jr $ra
move_player__enemy:
	li $v0, 3
	jr $ra
move_player__goal:
	LOAD_MAP_OFFSET($t0, $t2, $t3)
	li $t4, T_PLAYER
	sb $t4, MAP_MEMORY($t0)

	li $v0, 4
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
# $v0: Set if collides with player
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
	
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t3, MAP_MEMORY($t2)
	CLEAR_TILE($t3, T_ENEMY)
	sb $t3, MAP_MEMORY($t2)
	
	li $a0, 0
	li $a1, 4
	li $v0, 42
	syscall
	
move_enemy__switch:
	addu $a0, $a0, 1
	and $a0, $a0, 3
	beq $a0, 0, move_enemy__up
	beq $a0, 1, move_enemy__right
	beq $a0, 2, move_enemy__down
	beq $a0, 3, move_enemy__left
	b move_enemy__switch
	
move_enemy__check:
	bgeu $t2, MAP_WIDTH, move_enemy__switch
	bgeu $t3, MAP_HEIGHT, move_enemy__switch
	LOAD_MAP_OFFSET($t4, $t2, $t3)
	lbu $t4, MAP_MEMORY($t4)
	beq $t4, T_WALL, move_enemy__switch
	
move_enemy__end:
	LOAD_MAP_OFFSET($t0, $t2, $t3)
	SET_TILE($t4, T_ENEMY)
	sb $t4, MAP_MEMORY($t0)
	
	and $t4, $t4, T_PLAYER
	sgtu $v0, $t4, 0

	move $a0, $t7
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
	
#-----------------Subrutina para Transformar de Decimal a Binario ---------------------------------------#
decimal_to_binary:
	move $t0, $a0
	li $t7, 2
	li $t8, 31
decimal_to_binary__loop:
    subu $t8, $t8, 1  
	div $t0, $t7    
    mfhi $t6       
    mflo $t0 
    addi $t6, $t6, '0'
    sb $t6, Binary_Result($t8) 
    bnez $t0, decimal_to_binary__loop
    la $v0, Binary_Result($t8)
    jr $ra
    
#-----------------Subrutina para Transformar de Decimal a Octal ---------------------------------------#
decimal_to_octal:
	move $t0, $a0
	li $t7, 8
	li $t8, 31
decimal_to_octal__loop: 
            subu $t8, $t8, 1  
		    div $t0, $t7
    		    mfhi $t6   
                    mflo $t0        
                    addi $t6, $t6, '0' 
                    sb $t6, Octal_Result($t8)
                    bnez $t0, decimal_to_octal__loop
                    la $v0, Octal_Result($t8)
                    jr $ra

#-----------------Subrutina para Transformar de Decimal a Hexadecimal ---------------------------------------#                 
decimal_to_hexadecimal:
	move $t0, $a0
    li $t1, 16       # Base 16
    li $t3, 31      
decimal_to_hexadecimal__loop:
    subi $t3, $t3, 1      
    divu $t0, $t1    
    mfhi $t2       
    mflo $t0
    lb $t2, hex_digits($t2)  # Obtener el car�cter correspondiente al residuo de la cadena de digitos declarada
    sb $t2, Hexadecimal_Result($t3)   
    bnez $t0, decimal_to_hexadecimal__loop  
    la $v0, Hexadecimal_Result($t3)
    jr $ra