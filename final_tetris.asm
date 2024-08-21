#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Anuj Sarvate, 1009284347, sarvate1, anuj.sarvate@mail.utoronto.ca
# Student2: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed) 
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 64 (update this as needed)
# - Display height in pixels: 128 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. Game over screen and Restart if "retry" option (e) is chosen
# 2. keyboard press p displays "Paused" message on screen, second p will resume game
# 3. Sound effects for different conditions like rotating and dropping tetrominoes and for game over.
# 4. Different colour for every tetrominoe
# Hard Features:
# 1. Full set of tetrominoes
# 2. Animation to lines when they are completed

# How to play:
# A,S,D to move piece, R to rotate 90 degrees, E to restart, Q to quit
# Link to video demonstration for final submission:
# - https://youtu.be/JRO5g0ttalc
#
# Are you OK with us sharing the video with people outside course staff?
# - yes 
#
# Any additional information that the TA needs to know:
# - Worked on alone.
#
#####################################################################

##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

piece_info:	.space 24
    
grid:           .space 2048 

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    # Initialize the game
    la $s0, piece_info	
    li $s1, 1
    lw $s2, ADDR_DSPL
    la $s3, grid
    li $s4, 0x808080
    li $s5, 1
    
    
    jal draw_checker
    jal left_and_right
    jal bottom_wall
    jal left_and_right_grid
    jal bottom_grid
    jal game_loop

reset_grid:
    la $t0, grid
    li $t1, 2048
reset_grid_loop:
    beqz $t1, end_reset_loop
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    subi $t1, $t1, 4
    j reset_grid_loop
end_reset_loop:
jr $ra

cycle_pieces:
    beq $s1, 1, draw_line_piece_1
    beq $s1, 2, draw_o_piece_1
    beq $s1, 3, draw_L_piece_1
    beq $s1, 4, draw_T_piece_1
    beq $s1, 5, draw_J_piece_1
    beq $s1, 6, draw_S_piece_1
    beq $s1, 7, draw_Z_piece_1
    jr $ra
    
reset_counter:
    li $s1, 0
    jr $ra
     
   
draw_grid:
    la $t0, grid
    lw $t1, ADDR_DSPL
    li $t2, 512
    
draw_grid_loop:
    beq $t2, $zero, done_grid
    
    lw $t5, 0($t0)
    beq $t5, 2, draw_red
    beq $t5, 3, draw_green
    beq $t5, 4, draw_blue
    beq $t5, 5, draw_orange
    beq $t5, 6, draw_pink
    beq $t5, 7, draw_purple
    beq $t5, 8, draw_yellow
        
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop
        
draw_red:
    li $t4, 0xff0000
    sw $t4, 0($t1)
                
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop
    
draw_green:
    li $t4, 0x00ff00
    sw $t4, 0($t1)
                
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop

draw_blue:
    li $t4, 0x0000ff
    sw $t4, 0($t1)
                
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop
    
draw_orange:
    li $t4, 0xffA500
    sw $t4, 0($t1)
                
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop

draw_pink:
    li $t4, 0xFFC0CB
    sw $t4, 0($t1)
                
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop

draw_purple:
    li $t4, 0xA020F0
    sw $t4, 0($t1)
                
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop
    
draw_yellow:
    li $t4, 0xFFFF00
    sw $t4, 0($t1)
    
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    subi $t2, $t2, 1
    j draw_grid_loop
    
done_grid:
    jr $ra
    
left_and_right_grid:
    li $t1, 1        
    la $t0, grid
    li $t2, 0
left_and_right_grid_loop:
    beq $t2, 128, end_left_and_right_grid
    sw $t1, 0($t0)
    sw $t1, 60($t0)
    addi $t0, $t0, 64
    addi $t2, $t2, 4
    j left_and_right_grid_loop
end_left_and_right_grid:
    jr $ra

bottom_grid:
    li $t1, 1      
    la $t0, grid
    addi $t0, $t0, 1984
    li $t2, 0
bottom_grid_loop:
    beq $t2, 64, end_bottom_grid
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 4
    j bottom_grid_loop
end_bottom_grid:
    jr $ra
        
draw_checker:
    lw $t0, ADDR_DSPL
    li $t2, 0
    li $t3, 0
checker_loop:
    beq $t2, 128, end_checker
    li $t3, 0
row_loop:
    beq $t3, 64, next_row
    andi $t6, $t2, 1
    andi $t7, $t3, 1
    xor $t8, $t6, $t7
    
    beqz $t8, colour_one
    li $t4, 0x1b1b1b
    j draw_loop
    
colour_one:
    li $t4, 0x17161A 


draw_loop:
    sw $t4, 0($t0)
    addi $t0, $t0, 4
    addi $t3, $t3, 1
    j row_loop
    
next_row:
    addi $t2, $t2, 1
    j checker_loop

end_checker:
    jr $ra
 
left_and_right:
    li $t1, 0x808080      
    lw $t0, ADDR_DSPL
    li $t2, 0
left_and_right_loop:
    beq $t2, 128, end_left_and_right
    sw $t1, 0($t0)
    sw $t1, 60($t0)
    addi $t0, $t0, 64
    addi $t2, $t2, 4
    j left_and_right_loop
end_left_and_right:
    jr $ra

bottom_wall:
    li $t1, 0x808080      
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1984
    li $t2, 0
bottom_loop:
    beq $t2, 64, end_bottom
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 4
    j bottom_loop
end_bottom:
    jr $ra
    
    
exit:
    li $v0, 10
    syscall

draw_line_piece_1:
    li $t1, 0xFF0000        
    lw $t0, ADDR_DSPL       
    addi $t0, $t0, 20                    
    addi $t3, $t0, 0
    addi $t4, $t3, 4
    addi $t5, $t4, 4
    addi $t6, $t5, 4
    li $t7, 1
    sw $t7, 0($s0)
    sw $t7, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)      
    sw $t1, 0($t3)  
    sw $t1, 0($t4)        
    sw $t1, 0($t5)                
    sw $t1, 0($t6)                 
    jr $ra     
    
rotate:
    li $v0, 31
    li $a0, 40
    li $a1, 400
    li $a2, 10
    li $a3, 70
    syscall
    lw $t2, 0($s0)
    lw $t7, 4($s0)
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)   
    beq $t7, 1, line_rotate
    beq $t7, 2, o_rotate
    beq $t7, 3, L_rotate
    beq $t7, 4, T_rotate
    beq $t7, 5, J_rotate
    beq $t7, 6, S_rotate
    beq $t7, 7, Z_rotate
    
        
line_rotate:
    li $t1, 0xFF0000            
    beq $t2, 1, first_line_rotate
    beq $t2, 2, second_line_rotate
    
L_rotate:
    li $t1, 0x0000FF
    beq $t2, 1, first_L_rotate
    beq $t2, 2, second_L_rotate
    beq $t2, 3, third_L_rotate
    beq $t2, 4, fourth_L_rotate

o_rotate:
    li $t6, 0x00FF00
    lw $t1, 8($s0)          
    lw $t2, 12($s0)        
    lw $t3, 16($s0)         
    lw $t4, 20($s0) 
    
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    jr $ra                 

T_rotate:
    li $t1, 0xffA500
    beq $t2, 1, first_T_rotate
    beq $t2, 2, second_T_rotate
    beq $t2, 3, third_T_rotate
    beq $t2, 4, fourth_T_rotate
    
J_rotate:
    li $t1, 0xFFC0CB
    beq $t2, 1, first_J_rotate
    beq $t2, 2, second_J_rotate
    beq $t2, 3, third_J_rotate
    beq $t2, 4, fourth_J_rotate
    
S_rotate:
    li $t1, 0xA020F0
    beq $t2, 1, first_S_rotate
    beq $t2, 2, second_S_rotate
    
Z_rotate:
    li $t1, 0xFFFF00
    beq $t2, 1, first_Z_rotate
    beq $t2, 2, second_Z_rotate
    
first_line_rotate:
    addi $t3, $t3, -120
    addi $t4, $t4, -60
    addi $t6, $t6, 60
    li $t2, 2
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra

second_line_rotate:
    addi $t3, $t3, 120
    addi $t4, $t4, 60
    addi $t6, $t6, -60
    li $t2, 1
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra

first_L_rotate:
    addi $t3, $t3, 136
    addi $t4, $t4, 68
    addi $t6, $t6, 60
    li $t2, 2
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
second_L_rotate:
    addi $t3, $t3, 120
    addi $t4, $t4, 60
    addi $t6, $t6, -68
    li $t2, 3
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
third_L_rotate:
    addi $t3, $t3, -136
    addi $t4, $t4, -68
    addi $t6, $t6, -60
    li $t2, 4
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
fourth_L_rotate:
    addi $t3, $t3, -120
    addi $t4, $t4, -60
    addi $t6, $t6, 68
    li $t2, 1
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

first_T_rotate:
    addi $t3, $t3, -60
    addi $t5, $t5, 60
    addi $t6, $t6, -68
    li $t2, 2
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
second_T_rotate:
    addi $t3, $t3, 68
    addi $t5, $t5, -68
    addi $t6, $t6, -60
    li $t2, 3
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

third_T_rotate:
    addi $t3, $t3, 60
    addi $t5, $t5, -60
    addi $t6, $t6, 68
    li $t2, 4
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
fourth_T_rotate:
    addi $t3, $t3, -68
    addi $t5, $t5, 68
    addi $t6, $t6, 60
    li $t2, 1
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

first_J_rotate:
    addi $t3, $t3, 136
    addi $t4, $t4, 68
    addi $t6, $t6, -60
    li $t2, 2
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

second_J_rotate:
    addi $t3, $t3, 120
    addi $t4, $t4, 60
    addi $t6, $t6, 68
    li $t2, 3
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

third_J_rotate:
    addi $t3, $t3, -136
    addi $t4, $t4, -68
    addi $t6, $t6, 60
    li $t2, 4
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
fourth_J_rotate:
    addi $t3, $t3, -120
    addi $t4, $t4, -60
    addi $t6, $t6, -68
    li $t2, 1
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

first_S_rotate:
    addi $t3, $t3, 68
    addi $t4, $t4, 128
    addi $t5, $t5, -60
    li $t2, 2
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
second_S_rotate:
    addi $t3, $t3, -68
    addi $t4, $t4, -128
    addi $t5, $t5, 60
    li $t2, 1
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

first_Z_rotate:
    addi $t3, $t3, 8
    addi $t4, $t4, 68
    addi $t6, $t6, 60
    li $t2, 2
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 

second_Z_rotate:
    addi $t3, $t3, -8
    addi $t4, $t4, -68
    addi $t6, $t6, -60
    li $t2, 1
    sw $t2, 0($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra 
    
    
    
draw_o_piece_1:
    li $t1, 0x00FF00
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    addi $t3, $t0, 0
    addi $t4, $t3, 4
    addi $t5, $t4, 60
    addi $t6, $t5, 4
    li $t7, 1
    li $t8, 2
    sw $t7, 0($s0)
    sw $t8, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)   
    sw $t1, 0($t6) 
    jr $ra

draw_L_piece_1:
    li $t1, 0x0000FF
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    addi $t3, $t0, 0
    addi $t4, $t3, 64
    addi $t5, $t4, 64
    addi $t6, $t5, 4
    li $t7, 1
    li $t8, 3
    sw $t7, 0($s0)
    sw $t8, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra

draw_T_piece_1:
    li $t1, 0xffA500
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    addi $t3, $t0, 0
    addi $t4, $t3, 4
    addi $t5, $t4, 4
    addi $t6, $t4, 64
    li $t7, 1
    li $t8, 4
    sw $t7, 0($s0)
    sw $t8, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra

draw_J_piece_1:
    li $t1, 0xFFC0CB
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    addi $t3, $t0, 0
    addi $t4, $t3, 64
    addi $t5, $t4, 64
    addi $t6, $t5, -4
    li $t7, 1
    li $t8, 5
    sw $t7, 0($s0)
    sw $t8, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra
    
draw_S_piece_1:
    li $t1, 0xA020F0
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    addi $t3, $t0, 0
    addi $t4, $t3, 4
    addi $t5, $t3, 60
    addi $t6, $t5, 4
    li $t7, 1
    li $t8, 6
    sw $t7, 0($s0)
    sw $t8, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra

draw_Z_piece_1:
    li $t1, 0xFFFF00
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    addi $t3, $t0, 0
    addi $t4, $t3, 4
    addi $t5, $t4, 64
    addi $t6, $t5, 4
    li $t7, 1
    li $t8, 7
    sw $t7, 0($s0)
    sw $t8, 4($s0)
    sw $t3, 8($s0)
    sw $t4, 12($s0)
    sw $t5, 16($s0)
    sw $t6, 20($s0)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    sw $t1, 0($t6)
    jr $ra
    
move_down:
    lw $t1, 8($s0)          
    lw $t2, 12($s0)        
    lw $t3, 16($s0)         
    lw $t4, 20($s0)      
    lw $t5, 4($s0)   

    addi $t1, $t1, 64      
    addi $t2, $t2, 64      
    addi $t3, $t3, 64     
    addi $t4, $t4, 64      

    sw $t1, 8($s0)         
    sw $t2, 12($s0)        
    sw $t3, 16($s0)         
    sw $t4, 20($s0)   
    
    beq $t5, 1, red1
    beq $t5, 2, green1
    beq $t5, 3, blue1
    beq $t5, 4, orange1
    beq $t5, 5, pink1
    beq $t5, 6, purple1
    beq $t5, 7, yellow1
    
    
    
red1:
    li $t6, 0xFF0000     
    j draw_new
    
green1:
    li $t6, 0x00FF00
    j draw_new
    
blue1:
    li $t6, 0x0000FF
    j draw_new
   
orange1:
    li $t6, 0xffA500
    j draw_new
    
pink1:
    li $t6, 0xFFC0CB
    j draw_new
   
purple1:
    li $t6, 0xA020F0
    j draw_new
   
yellow1:
    li $t6, 0xFFFF00
    j draw_new
   
    
draw_new:
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    jr $ra                 

keyboard_check:
    lw $t9, ADDR_KBRD
wait_for_key:
    lw $t8, 0($t9)       
    beq $t8, $zero, wait_for_key  
    
    lw $a0, 4($t9)       
    beq $a0, 115, respond_to_S   
    beq $a0, 97, respond_to_A
    beq $a0, 100, respond_to_D
    beq $a0, 114, respond_to_R
    beq $a0, 113, respond_to_Q
    beq $a0, 112, respond_to_P
    beq $a0, 101, respond_to_E
    
    j wait_for_key
    
respond_to_S:
    jal collision_bottom
    jal draw_checker
    jal left_and_right
    jal bottom_wall
    jal draw_grid
    jal move_down
    j wait_for_key
    
respond_to_A:
    jal collision_left
    jal draw_checker
    jal left_and_right
    jal bottom_wall
    jal draw_grid
    jal move_left
    j wait_for_key                          

respond_to_D:
    jal collision_right
    jal draw_checker
    jal left_and_right
    jal bottom_wall   
    jal draw_grid
    jal move_right
    j wait_for_key

respond_to_R:
    jal collision_rotation
    jal draw_checker
    jal left_and_right
    jal bottom_wall
    jal draw_grid
    jal rotate
    j wait_for_key
    
respond_to_E:
    jal reset_grid
    j main
    
    
respond_to_P:
    beq $s5, 1, pause
    beq $s5, 2, unpause
    
pause:
    li $s5, 2
    jal draw_checker
    
    lw $t0, ADDR_DSPL
    li $t1, 0xFFFFFF
    addi $t0, $t0, 196
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 64($t0)
    sw $t1, 68($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 68($t0)
    sw $t1, 128($t0)
    sw $t1, 132($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 64($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    sw $t1, 200($t0)
    sw $t1, 136($t0)
    sw $t1, 72($t0)
    sw $t1, 8($t0)
    
    addi $t0, $t0, 288
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 64($t0)
    sw $t1, 128($t0)
    sw $t1, 132($t0)
    sw $t1, 136($t0)
    sw $t1, 200($t0)
    sw $t1, 264($t0)
    sw $t1, 256($t0)
    sw $t1, 260($t0)
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 64($t0)
    sw $t1, 68($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 256($t0)
    sw $t1, 260($t0) 
    
    addi $t0, $t0, 16
   
    sw $t1, 4($t0)
    sw $t1, 68($t0)
    sw $t1, 132($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    sw $t1, 260($t0)
    sw $t1, 256($t0)
    
    j wait_for_key
    
unpause:
    li $s5, 1
    jal draw_checker
    jal left_and_right
    jal bottom_wall
    jal draw_grid
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    lw $t5, 4($s0)
    beq $t5, 1, unpause_red
    beq $t5, 2, unpause_green
    beq $t5, 3, unpause_blue
    beq $t5, 4, unpause_orange
    beq $t5, 5, unpause_pink
    beq $t5, 6, unpause_purple
    beq $t5, 7, unpause_yellow

unpause_red:
    li $t6, 0xFF0000
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key     

unpause_green:
    li $t6, 0x00FF00
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key    
    
unpause_blue:
    li $t6, 0x0000FF
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key    
    
unpause_orange:
    li $t6, 0xffA500
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key    
    
unpause_pink:
    li $t6, 0xFFC0CB
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key    

unpause_purple:
    li $t6, 0xA020F0
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key    
    
unpause_yellow:
    li $t6, 0xFFFF00
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)
    
    j wait_for_key    
    

respond_to_Q:
    j exit
    
    
move_left:
    lw $t1, 8($s0)          
    lw $t2, 12($s0)        
    lw $t3, 16($s0)         
    lw $t4, 20($s0)         
    lw $t5, 4($s0)   
    
    addi $t1, $t1, -4      
    addi $t2, $t2, -4      
    addi $t3, $t3, -4     
    addi $t4, $t4, -4      

    sw $t1, 8($s0)         
    sw $t2, 12($s0)        
    sw $t3, 16($s0)         
    sw $t4, 20($s0)        
    
    beq $t5, 1, red2
    beq $t5, 2, green2
    beq $t5, 3, blue2
    beq $t5, 4, orange2
    beq $t5, 5, pink2
    beq $t5, 6, purple2
    beq $t5, 7, yellow2
    
red2:
    li $t6, 0xFF0000     
    j draw_new
green2:
    li $t6, 0x00FF00
    j draw_new
blue2:
    li $t6, 0x0000FF
    j draw_new
orange2:
    li $t6, 0xffA500
    j draw_new
pink2:
    li $t6, 0xFFC0CB
    j draw_new
purple2:
    li $t6, 0xA020F0
    j draw_new
yellow2:
    li $t6, 0xFFFF00
    j draw_new
    
move_right:
    lw $t1, 8($s0)          
    lw $t2, 12($s0)        
    lw $t3, 16($s0)         
    lw $t4, 20($s0)    
    lw $t5, 4($s0)     

    addi $t1, $t1, 4   
    addi $t2, $t2, 4      
    addi $t3, $t3, 4     
    addi $t4, $t4, 4      

    sw $t1, 8($s0)         
    sw $t2, 12($s0)        
    sw $t3, 16($s0)         
    sw $t4, 20($s0)        
    
    beq $t5, 1, red3
    beq $t5, 2, green3
    beq $t5, 3, blue3
    beq $t5, 4, orange3
    beq $t5, 5, pink3
    beq $t5, 6, purple3
    beq $t5, 7, yellow3
                  
red3:
    li $t6, 0xFF0000     
    j draw_new
green3:
    li $t6, 0x00FF00
    j draw_new
blue3:
    li $t6, 0x0000FF
    j draw_new
orange3:
    li $t6, 0xffA500
    j draw_new
pink3:
    li $t6, 0xFFC0CB
    j draw_new
purple3:
    li $t6, 0xA020F0
    j draw_new
yellow3: 
    li $t6, 0xFFFF00
    j draw_new
    
game_loop:
    jal game_over_check
    jal break_line
    jal left_and_right_grid
    jal bottom_grid
    jal cycle_pieces
    addi $s1, $s1, 1
    beq $s1, 8, reset_counter
    jal keyboard_check
    j game_loop

collision_right:
    lw $t0, 4($s0)
    beq $t0, 1, line_collision_right
    beq $t0, 2, o_collision_right
    beq $t0, 3, line_collision_right
    beq $t0, 4, line_collision_right
    beq $t0, 5, line_collision_right
    beq $t0, 6 line_collision_right
    beq $t0, 7, line_collision_right


collision_left: 
    lw $t0, 4($s0)
    beq $t0, 1, line_collision_left
    beq $t0, 2, o_collision_left
    beq $t0, 3, line_collision_left
    beq $t0, 4, line_collision_left
    beq $t0, 5, line_collision_left
    beq $t0, 6, line_collision_left
    beq $t0, 7, line_collision_left

collision_bottom:
    lw $t0, 4($s0)
    beq $t0, 1, line_collision_bottom
    beq $t0, 2, o_collision_bottom
    beq $t0, 3, line_collision_bottom
    beq $t0, 4, line_collision_bottom
    beq $t0, 5, line_collision_bottom
    beq $t0, 6, line_collision_bottom
    beq $t0, 7, line_collision_bottom
    
collision_rotation:
    lw $t0, 4($s0)
    beq $t0, 1, line_collision_rotation
    beq $t0, 3, L_collision_rotation
    beq $t0, 4, T_collision_rotation
    beq $t0, 5, J_collision_rotation
    beq $t0, 6, S_collision_rotation
    beq $t0, 7, Z_collision_rotation
    jr $ra
    
line_collision_rotation:
    lw $t1, 0($s0)
    beq $t1, 1, horizontal_line_rotate
    beq $t1, 2, vertical_line_rotate
    
L_collision_rotation:
    lw $t1, 0($s0)
    beq $t1, 1, L_position_1_rotate
    beq $t1, 2, L_position_2_rotate
    beq $t1, 3, L_position_3_rotate
    beq $t1, 4, L_position_4_rotate
    
T_collision_rotation:
    lw $t1, 0($s0)
    beq $t1, 1, T_position_1_rotate
    beq $t1, 2, T_position_2_rotate
    beq $t1, 3, T_position_3_rotate
    beq $t1, 4, T_position_4_rotate

J_collision_rotation:
    lw $t1, 0($s0)
    beq $t1, 1, J_position_1_rotate
    beq $t1, 2, J_position_2_rotate
    beq $t1, 3, J_position_3_rotate
    beq $t1, 4, J_position_4_rotate

S_collision_rotation:
    lw $t1, 0($s0)
    beq $t1, 1, S_position_1_rotate
    beq $t1, 2, S_position_2_rotate
    
Z_collision_rotation:
    lw $t1, 0($s0)
    beq $t1, 1, Z_position_1_rotate
    beq $t1, 2, Z_position_2_rotate
    
S_position_1_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 68($t3)
    lw $t4, 128($t4)
    lw $t5, -60($t5)
    
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t5, wait_for_key
    jr $ra
    
S_position_2_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -68($t3)
    lw $t4, -128($t4)
    lw $t5, 60($t5)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t5, wait_for_key
    jr $ra

Z_position_1_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 8($t3)
    lw $t4, 68($t4)
    lw $t6, 60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
Z_position_2_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -8($t3)
    lw $t4, -68($t4)
    lw $t6, -60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

J_position_1_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 136($t3)
    lw $t4, 68($t4)
    lw $t6, -60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

J_position_2_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 120($t3)
    lw $t4, 60($t4)
    lw $t6, 68($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
J_position_3_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -136($t3)
    lw $t4, -68($t4)
    lw $t6, 60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
J_position_4_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -120($t3)
    lw $t4, -60($t4)
    lw $t6, -68($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
T_position_1_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -60($t3)
    lw $t4, 60($t4)
    lw $t6, -68($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

T_position_2_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 68($t3)
    lw $t4, -68($t4)
    lw $t6, -60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

T_position_3_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 60($t3)
    lw $t4, -60($t4)
    lw $t6, 68($t6)
   
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
T_position_4_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -68($t3)
    lw $t4, 68($t4)
    lw $t6, 60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
    
L_position_1_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 136($t3)
    lw $t4, 68($t4)
    lw $t6, 60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

 L_position_2_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 120($t3)
    lw $t4, 60($t4)
    lw $t6, -68($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

L_position_3_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -136($t3)
    lw $t4, -68($t4)
    lw $t6, -60($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
L_position_4_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -120($t3)
    lw $t4, -60($t4)
    lw $t6, 68($t6)
    
    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
    
horizontal_line_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, -120($t3)
    lw $t4, -60($t4)
    lw $t6, 60($t6)

    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra
    
vertical_line_rotate:
    lw $t2, ADDR_DSPL
    lw $t3, 8($s0)
    lw $t4, 12($s0)
    lw $t5, 16($s0)
    lw $t6, 20($s0)
    
    sub $t3, $t3, $t2
    sub $t4, $t4, $t2
    sub $t5, $t5, $t2
    sub $t6, $t6, $t2
    
    la $t7, grid
    
    add $t3, $t3, $t7
    add $t4, $t4, $t7
    add $t5, $t5, $t7
    add $t6, $t6, $t7
    
    lw $t3, 120($t3)
    lw $t4, 60($t4)
    lw $t6, -60($t6)

    bnez $t3, wait_for_key
    bnez $t4, wait_for_key
    bnez $t6, wait_for_key
    jr $ra

o_collision_right:
    lw $t0, ADDR_DSPL
    lw $t7, 12($s0)
    lw $t1, 20($s0)
    
    sub $t7, $t7, $t0
    sub $t2, $t1, $t0
    
    la $t3, grid
    
    add $t7, $t3, $t7
    add $t4, $t3, $t2
    
    lw $t7, 4($t7)
    lw $t5, 4($t4)
    
    bnez $t5, wait_for_key
    bnez $t7, wait_for_key

    jr $ra

o_collision_left:
    lw $t0, ADDR_DSPL
    lw $t1, 8($s0)
    lw $t7, 16($s0)
    
    sub $t7, $t7, $t0
    sub $t2, $t1, $t0
    
    la $t3, grid
    
    add $t4, $t3, $t2
    add $t7, $t7, $t3
    
    lw $t7, -4($t7)
    lw $t5, -4($t4)
    
    bnez $t5, wait_for_key
    bnez $t7, wait_for_key
    jr $ra
    
o_collision_bottom:
    lw $t0, ADDR_DSPL
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sub $t3, $t3, $t0
    sub $t4, $t4, $t0
    la $t5, grid
    add $t3, $t5, $t3
    add $t4, $t5, $t4
 
    lw $t6, 64($t3)
    bnez $t6, save_block
    
    lw $t6, 64($t4)
    bnez $t6, save_block
   
    jr $ra
line_collision_right:
    lw $t0, ADDR_DSPL
    lw $t6, 8($s0)
    lw $t7, 12($s0)
    lw $t8, 16($s0)
    lw $t1, 20($s0)
    
    sub $t6, $t6, $t0
    sub $t7, $t7, $t0
    sub $t8, $t8, $t0
    sub $t2, $t1, $t0
    
    la $t3, grid
    
    add $t6, $t3, $t6
    add $t7, $t3, $t7
    add $t8, $t3, $t8
    add $t4, $t3, $t2
    
    lw $t6, 4($t6)
    lw $t7, 4($t7)
    lw $t8, 4($t8)
    lw $t5, 4($t4)
    
    bnez $t5, wait_for_key
    bnez $t6, wait_for_key
    bnez $t7, wait_for_key
    bnez $t8, wait_for_key
    jr $ra

line_collision_left:
    lw $t0, ADDR_DSPL
    lw $t1, 8($s0)
    lw $t6, 12($s0)
    lw $t7, 16($s0)
    lw $t8, 20($s0)
    
    sub $t6, $t6, $t0
    sub $t7, $t7, $t0
    sub $t8, $t8, $t0
    sub $t2, $t1, $t0
    
    la $t3, grid
    
    add $t4, $t3, $t2
    add $t6, $t6, $t3
    add $t7, $t7, $t3
    add $t8, $t8, $t3
    
    lw $t6, -4($t6)
    lw $t7, -4($t7)
    lw $t8, -4($t8)
    lw $t5, -4($t4)
    
    bnez $t5, wait_for_key
    bnez $t6, wait_for_key
    bnez $t7, wait_for_key
    bnez $t8, wait_for_key
    jr $ra

line_collision_bottom:
    lw $t0, ADDR_DSPL
    lw $t1, 8($s0)
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    sub $t1, $t1, $t0
    sub $t2, $t2, $t0
    sub $t3, $t3, $t0
    sub $t4, $t4, $t0
    la $t5, grid
    add $t1, $t5, $t1
    add $t2, $t5, $t2
    add $t3, $t5, $t3
    add $t4, $t5, $t4
 
    lw $t6, 64($t1)
    bnez $t6, save_block
    
    lw $t6, 64($t2)
    bnez $t6, save_block
    
    lw $t6, 64($t3)
    bnez $t6, save_block
    
    lw $t6, 64($t4)
    bnez $t6, save_block
   
    jr $ra

game_over_check:
    la $t0, grid
    addi $t0, $t0, 20 
    lw $t1, 0($t0)
    bnez $t1, game_over_screen
    jr $ra

game_over_screen:
    jal draw_checker
    lw $t0, ADDR_DSPL
    li $t1, 0xFF0000
    addi $t0, $t0, 192
    sw $t1, 0($t0)
    sw $t1, 64($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    sw $t1, 200($t0)
    sw $t1, 136($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
 
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 68($t0)
    sw $t1, 128($t0)
    sw $t1, 132($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    
    addi $t0, $t0, 12
    sw $t1, 0($t0)
    sw $t1, 64($t0)    
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 68($t0)
    sw $t1, 8($t0)
    sw $t1, 72($t0)
    sw $t1, 136($t0)
    sw $t1, 200($t0)
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 64($t0)
    sw $t1, 68($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    
    addi $t0, $t0, 276
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 64($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    sw $t1, 200($t0)
    sw $t1, 72($t0)
    sw $t1, 136($t0)
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 64($t0)
    sw $t1, 128($t0)  
    sw $t1, 8($t0)  
    sw $t1, 72($t0)
    sw $t1, 136($t0)
    sw $t1, 196($t0)
    
    addi $t0, $t0, 16
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 64($t0)
    sw $t1, 68($t0)
    sw $t1, 128($t0)
    sw $t1, 192($t0)
    sw $t1, 196($t0)
    
    addi $t0, $t0, 12
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 64($t0)
    sw $t1, 128($t0)        
    sw $t1, 192($t0)  
    j keyboard_check
 
    
save_block: 
    li $v0, 31
    li $a0, 60
    li $a1, 400
    li $a2, 10
    li $a3, 70
    syscall
    lw $t0, ADDR_DSPL
    lw $t1, 8($s0)           
    lw $t2, 12($s0)
    lw $t3, 16($s0)
    lw $t4, 20($s0)
    la $t5, grid        
    lw $t7, 4($s0)
    
    beq $t7, 1, save_red
    beq $t7, 2, save_green
    beq $t7, 3, save_blue
    beq $t7, 4, save_orange
    beq $t7, 5, save_pink
    beq $t7, 6, save_purple
    beq $t7, 7, save_yellow
    
save_red:    
    li $t6, 2                
    j save
save_green:
    li $t6, 3
    j save
save_blue:
    li $t6, 4
    j save
save_orange:
    li $t6, 5
    j save
save_pink:
    li $t6, 6
    j save
save_purple:
    li $t6, 7
    j save
save_yellow:
    li $t6, 8
    j save
 
    
    
save:
    sub $t1, $t1, $t0
    sub $t2, $t2, $t0
    sub $t3, $t3, $t0
    sub $t4, $t4, $t0
    
    add $t1, $t5, $t1
    add $t2, $t5, $t2
    add $t3, $t5, $t3
    add $t4, $t5, $t4
    
    sw $t6, 0($t1)
    sw $t6, 0($t2)
    sw $t6, 0($t3)
    sw $t6, 0($t4)

    j game_loop
    

break_line:
    la $t0, grid      
    li $t1, 0         

rows:
    bge $t1, 31, end_row_loop  
    move $t2, $t0     
    li $t3, 0        
    li $t4, 0        
columns_loop:
    bge $t4, 16, end_columns_loop
    lw $t5, 0($t0)    
    beqz $t5, skip    
    addi $t3, $t3, 1  

skip:
    addi $t0, $t0, 4 
    addi $t4, $t4, 1  
    j columns_loop  

end_columns_loop:
    li $t6, 16        
    bne $t3, $t6, skip_delete 
    j delete_row       

skip_delete:
    addi $t0, $t2, 64
    addi $t1, $t1, 1 
    j rows   

end_row_loop:
    jr $ra
delete_row:
    li $t7, 16  
delete_row_loop:
    beqz $t7, end_delete_row  
    sub $t8, $t2, $s3
    add $t9, $s2, $t8
    sw $s4, 0($t9)
    sw $zero, 0($t2)  
    addi $t2, $t2, 4  
    subi $t7, $t7, 1  
    j delete_row_loop    

end_delete_row:
    j shift_down
    
    
shift_down:
    subi $t9, $t2, 68
shift_down_loop:      
    blt $t9, $s3, end_shift_down  
    lw $t4, 0($t9)         
    sw $t4, 64($t9)       
    addi $t9, $t9, -4      
    j shift_down_loop     

end_shift_down:
    j skip_delete                 
    


    

    

    
