#to be played with pixel h,w at 8
#display h,w at 256
#adress on heap
.data
	prompt: .asciiz "1 for Rock, 2 for Paper, 3 for Scissors: "
	line: .asciiz "\n"
	ag: .asciiz "Tie"
	wi: .asciiz "You Win"
	lo: .asciiz "You Lose"
	colors:
		.word 0x000000 #black
		.word 0x0000FF #blue
		.word 0xFF0000 #red
		.word 0xFFFFFF #white
	choices:
		.byte 0,0,0,0,0
		.byte 2,5,5,5,2 #rock
		.byte 7,7,7,7,7 #paper
		.byte 2,5,2,5,2 #scissors
.text
.globl main

main:
	li $t0, 0 #player chocie
	li $t1, 0 #comp choice
	li $t2, 0
	j ask
	
ask:
	jal random
	la $a0, line
	li $v0, 4
	syscall
	la $a0, prompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	la $a0, line
	li $v0, 4
	syscall
	bgt $t0, 3, ask
	blt $t0, 1, ask
	j calculate
	
random:
	li $a0, 0
	li $a1, 4  #upper
	li $v0, 42
	syscall
	add $a0, $a0, 0  #lower
	move $t1, $a0
	jr $ra
	
calculate:
   	jal update
	beq $t0, $t1, tie
	beq $t0, 1, prock
	j one
	prock:
		beq $t1, 2, lose
		beq $t1, 3, win
	one:
	beq $t0, 2, ppaper
	j two
	ppaper:
		beq $t1, 3, lose
		beq $t1, 1, win
	two:
	beq $t0, 3, pscissor
	pscissor:
		beq $t1, 1, lose
		beq $t1, 2, win
		
tie:
	la $a0, ag
	li $v0, 4
	syscall
	la $a0, line
	syscall
	li $v0, 10
	syscall

win:
	la $a0, wi
	li $v0, 4
	syscall
	la $a0, line
	li $v0, 10
	syscall

lose:
	la $a0, lo
	li $v0, 4
	syscall
	la $a0, line
	li $v0, 10
	syscall

update:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)
	move $a0, $t0
	li $a1, 2
	li $a2, 2
	li $a3, 1
	jal drawchoice
	move $a0, $t1
	li $a1, 20
	li $a2, 2
	li $a3, 2
	jal drawchoice
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	lw $t0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra


drawchoice:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	jal drawc
	lw $s3, 0($sp)
	lw $s2, 4($sp)
	lw $s1, 8($sp)
	lw $s0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra

drawc:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	la $t7, choices
	li $t8, 5
	mul $t8, $s0, $t8
	add $s4, $t7, $t8
	li $t5, 0

ddrow:
	bge $t5, 5, ddend
	lb $t6, 0($s4)
	li $t4, 0

ddcol:
	bge $t4, 3, ddnextr
	li $t7, 2
	sub $t7 ,$t7, $t4
	srlv $t8, $t6, $t7
	andi $t8, $t8, 1
	beqz $t8, ddskip
	move $a0, $s1
	add $a0, $a0, $t4
	move $a1, $s2
	add $a1, $a1, $t5
	move $a2, $s3
	jal draw

ddskip:
	addi $t4, $t4, 1
	j ddcol

ddnextr:
	addi $s4, $s4, 1
	addi $t5, $t5, 1
	j ddrow

ddend:
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
###########################################################################
address:
	li $v0, 0x10040000
	sll $t8, $a0, 2
	sll $t7, $a1, 7
	add $v0, $v0, $t8
	add $v0, $v0, $t7
	jr $ra
	
color:
	la $t9, colors
	sll $a2, $a2, 2
	add $a2, $a2, $t9
	lw $v1, 0($a2)
	jr $ra

draw:
	bltz $a0, done
	bltz $a1, done
	bgt $a0, 31, done
	bgt $a1, 31, done
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal address
	jal color
	sw $v1, 0($v0)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
done:
	jr $ra
