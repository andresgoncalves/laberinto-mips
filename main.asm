	
	.include "./video.asm"
	.include "./keyboard.asm"
	.include "./map.asm"
	
	.data
VIDEO_MEMORY: .space VIDEO_MEMORY_SIZE
MAP_MEMORY:
	.byte 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
	.byte 8 0 0 0 0 0 0 0 0 1 0 0 0 0 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 0 0 0 0 0 0 0 0 0 0 0 1 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 1 0 0 1 0 0 0 0 0 0 0 0 1 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 0 0 0 8 8 0 8 0 8 8 0 8 0 8
	.byte 8 0 8 8 0 8 8 0 0 0 0 0 0 0 0 8
	.byte 8 0 0 0 0 0 0 1 8 8 8 8 8 1 8 8
	.byte 8 1 8 8 0 8 8 0 0 0 0 0 1 8 8 8
	.byte 8 8 8 8 8 8 8 8 8 8 8 9 8 8 8 8
TILE_COLORS: TILE_COLORS
PLAYER:
	.word 1, 1, 0, 0 # 0: X coord, 4: Y coord, 8: Coins
ENEMIES:
	.word  1,  8, 0, 0
	.word  7,  4, 0, 0
	.word 14,  1, 0, 0
	.word 14, 12, 0, 0
GAME_WON_MSG: .asciiz "GAME WON\nCoins: "
GAME_LOST_MSG: .asciiz "GAME OVER"

Octal_Result: .space 20

.macro DecimalToOctal(%decimal)
	li $t7 8 #Base 8 por la que vamos a dividir
	li $t8 0 #Este sera el resultado
	deciOctal_loop: 
		    div %decimal, $t7    # Dividir el n�mero por 8
    		    mfhi $t6        
                    addi $t6, $t6, '0' # Convertir el residuo a car�cter para poder ser guardado
                    sb $t6, Octal_Result($t8) # Almacenar 
                    addi $t8, $t8, 1  # Incrementar la posici�n del space del resultado en donde estamos guardando
                    mflo %decimal        # Actualizar el n�mero ingresado
                    bnez %decimal, deciOctal_loop
          .end_macro 
                    
#-------------------------------Macro para Transformar de Decimal a Binario-------------------------------------------------#
#------------------------Macro Para Transformar de Decimal a Octal ----------------------------------------------------------------#
	.macro DecimalToBinary(%decimal)
	li $t7 2 #Base 2 por la que vamos a dividir
	li $t8 0 #Este sera el resultado
	deciOctal_loop: 
		    div %decimal, $t7    # Dividir el n�mero por 2
    		    mfhi $t6        
                    addi $t6, $t6, '0' # Convertir el residuo a car�cter para poder ser guardado
                    sb $t6, Octal_Result($t8) # Almacenar 
                    addi $t8, $t8, 1  # Incrementar la posici�n del space del resultado en donde estamos guardando
                    mflo %decimal        # Actualizar el n�mero ingresado
                    bnez %decimal, deciOctal_loop
           .end_macro 
      
	.text
	.globl main
	
main:

main_prepare_map:
	lw $t0, PLAYER+0
	lw $t1, PLAYER+4
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_PLAYER)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES+0x00
	lw $t1, ENEMIES+0x04
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES+0x10
	lw $t1, ENEMIES+0x14
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES+0x20
	lw $t1, ENEMIES+0x24
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
	lw $t0, ENEMIES+0x30
	lw $t1, ENEMIES+0x34
	LOAD_MAP_OFFSET($t2, $t0, $t1)
	lbu $t0, MAP_MEMORY($t2)
	SET_TILE($t0, T_ENEMY)
	sb $t0, MAP_MEMORY($t2)
	
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

main_loop_end:
	la $a0, ENEMIES+0x00
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES+0x10
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES+0x20
	jal move_enemy
	bnez $v0, main_game_lost
	la $a0, ENEMIES+0x30
	jal move_enemy
	bnez $v0, main_game_lost
	
	b main_loop
	
main_save_coin:
	lw $t0, PLAYER+8
	addu $t0, $t0, 1
	sw $t0, PLAYER+8
	b main_loop_end

main_game_lost:
	jal paint_map
	la $a0, GAME_LOST_MSG
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
main_game_won:
	jal paint_map
	
	la $a0, GAME_WON_MSG
	li $v0, 4
	syscall
	
	lw $a0, PLAYER+8
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall


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
