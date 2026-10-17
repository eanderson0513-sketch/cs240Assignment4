#to be played with pixel h,w at 8
#display h,w at 256
#adress on heap
.data
	prompt: .asciiz "Enter 1 to hit and 2 to stand: "
	line: .asciiz "\n"
	damn: .asciiz "You Bust"
	losex: .asciiz "You lose"
	winx: .asciiz "You won"
	tiex: .asciiz "You tie\nDealer demands another"
	no: .asciiz "1 or 2 please"
	colors:
		.word 0x000000 #black
		.word 0x0000FF #blue
		.word 0xFF0000 #red
		.word 0xFFFFFF #white
	digit:
		.byte 7,5,5,5,7
		.byte 2,6,2,2,7
		.byte 7,1,7,4,7
		.byte 7,1,7,1,7
		.byte 5,5,7,1,1
		.byte 7,4,7,1,7
		.byte 7,4,7,5,7
		.byte 7,1,1,1,1
		.byte 7,5,7,5,7
		.byte 7,5,7,1,7
.text
.globl main

main:
	li $t0, 0 #player score
	li $t1, 0 #dealer score
	li $t2, 0 #dealt score
	li $t4, 1 #player turn
	li $t5, 0 #x
	li $t6, 0 #y
	j start
	
start:
	jal random
	move $t0, $t9
	jal random
	add $t0, $t0 ,$t9
	jal random
	move $t1, $t9
	jal update
	j ask

random:
	li $a0, 0
	li $a1, 13 #upper
	li $v0, 42
	syscall
	add $a0, $a0, 2 #lower
	move $t9, $a0
	bgt $t9, 10, make10
	jr $ra
	make10:
		li $t9, 10
		jr $ra

ask:
	la $a0, line
	li $v0, 4
	syscall
	#jal tell
	la $a0, prompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t3, $v0
	la $a0, line
	li $v0, 4
	syscall
	beq $t3, 1, hit
	beq $t3, 2, stand
	la $a0, no
	li $v0, 4
	syscall
	j ask
	
hit:
	jal random
	add $t0, $t0, $t9
	jal update
	j calculate

calculate:
	bgt $t0, 21, bust
	j ask
stand:
	#li $v0, 32
	#syscall
	bgt $t1, $t0, lose
	jal random
	add $t1, $t9, $t1
	jal update
	bge $t1, 21, win
	beq $t1, $t0, tie
	j stand

tie:
	#jal tell
	la $a0, tiex
	li $v0, 4
	syscall
	li $v0, 10
	syscall

win:
	#jal tell
	la $a0, winx
	li $v0, 4
	syscall
	li $v0, 10
	syscall

lose:
	#jal tell
	la $a0, losex
	li $v0, 4
	syscall
	li $v0, 10
	syscall

bust:
	#jal tell
	la $a0, damn
	li $v0, 4
	syscall
	li $v0, 10
	syscall
tell:
	move $a0, $t0
	li $v0, 1
	syscall
	jr $ra
	
update:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)
	jal clear
	move $a0, $t0
	li $a1, 2
	li $a2, 2
	li $a3, 1
	jal drawnumber
	move $a0, $t1
	li $a1, 2
	li $a2, 10
	li $a3, 2
	jal drawnumber
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	lw $t0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra

clear:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t5, 0

clearprow:
	bge $t5, 5, cleardstart
	li $t6, 0

clearpcol:
	bge $t6, 8, clearpnext
	addi $a0, $t6, 2
	addi $a1, $t5, 2
	li $a2, 0
	jal draw
	addi $t6, $t6, 1
	j clearpcol

clearpnext:
	addi $t5, $t5, 1
	j clearprow

	cleardstart:
	li $t5, 0

cleardrow:
	bge $t5, 5, cleardone
	li $t6, 0

cleardcol:
	bge $t6, 8, cleardnext
	addi $a0, $t6, 2
	addi $a1, $t5, 10
	li $a2, 0
	jal draw
	addi $t6, $t6, 1
	j cleardcol

	cleardnext:
	addi $t5, $t5, 1
	j cleardrow

cleardone:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

drawnumber:
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
	blt $s0, 10, dnones
	bge $s0, 20, twen
	li $a0, 1
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	jal drawdigit
	addi $s1, $s1, 4
	addi $s0, $s0, -10
	j dnones

	twen:
		li $a0, 2
		move $a1, $s1
		move $a2, $s2
		move $a3, $s3
		jal drawdigit
		addi $s1, $s1, 4
		addi $s0, $s0, -20

dnones:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	jal drawdigit
	lw $s3, 0($sp)
	lw $s2, 4($sp)
	lw $s1, 8($sp)
	lw $s0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra

drawdigit:
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
	la $t7, digit
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
