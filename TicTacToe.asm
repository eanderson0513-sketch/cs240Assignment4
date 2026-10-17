# v = 1 print integer, 4 = string, 5 = recieve int
# 4 per int


# Set bitmap W and H of units to 8
# Set bitmap Width and Height of display to 256
#Set butmap base adress to heap

.data
	colors:
		.word 0x000000 #black
		.word 0x0000FF #blue
		.word 0xFF0000 #red
		.word 0xFFFFFF #white
	prompt: .asciiz "Give index 1-9 "
	player: .asciiz "Player "
	incorrect: .asciiz "0-8 please"
	bad: .asciiz "Taken "
	wins: .asciiz " WINS"
	line: "\n"
	stalemate: "TIE"
	input: .space 2
	ar: .word 0,0,0,0,0,0,0,0,0
	
.text

main:
	li $s3, 0xFFFF0000
	la $s0, ar
	move $t8, $s0
	li $t9, 1 #player turn 1
	jal initiate
	jal collect
	li $v0, 10
	syscall	

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
	
color:
	la $t4, colors
	sll $a2, $a2, 2
	add $a2, $a2, $t4
	lw $v1, 0($a2)
	jr $ra

address:
	li $v0, 0x10040000
	sll $t2, $a0, 2
	sll $t5, $a1, 7
	add $v0, $v0, $t2
	add $v0, $v0, $t5
	jr $ra
	
initiate:
	li $a3, 60
	li $a0, 0
	li $a1, 7
	li $a2, 3
	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	
	hor:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, hor
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	
	li $a3, 60
	li $a0, 0
	li $a1, 22
	li $a2, 3
	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	
	hor2:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, hor2
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	
	li $a3, 60
	li $a0, 7
	li $a1, 0
	li $a2, 3
	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	
	ver:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a1, $a1, 1
		addiu $a3, $a3, -1
		bne $a3, 0, ver
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	
	li $a3, 60
	li $a0, 22
	li $a1, 0
	li $a2, 3
	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	
	ver2:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a1, $a1, 1
		addiu $a3, $a3, -1
		bne $a3, 0, ver2
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	
	jr $ra
	
collect:
	jal stalecheck
	li $t7, 0
	li $v0, 4
	la $a0, player
	syscall
	li $v0, 1
	move $a0, $t9
	syscall
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, prompt
	syscall
	
	#li $v0, 5 #get input
	#syscall
	#move $t0, $v0
	keyloop:
		lw $t0, 0($s3)
		andi $t0, $t0, 1
		beqz $t0, keyloop
	lw $t8, 4($s3)
	andi $t8, $t8, 0xFF
	li $t7, 49
	beq $t8, $t7, one
	li $t7, 50
	beq $t8, $t7, two
	li $t7, 51
	beq $t8, $t7, three
	li $t7, 52
	beq $t8, $t7, four
	li $t7, 53
	beq $t8, $t7, five
	li $t7, 54
	beq $t8, $t7, six
	li $t7, 55
	beq $t8, $t7, seven
	li $t7, 56
	beq $t8, $t7, eight
	li $t7, 57
	beq $t8, $t7, nine
	j keyloop
	one:
		li $t0, 1
		j check
	tw:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	one:
		li $t0, 1
		j check
	#ba:
		#la $a0, incorrect
		#li $v0, 4
		#syscall
		#li $v0, 4
		#la $a0, line
		#syscall
		#j collect
	
check:
	move $t8, $s0
	mul $t1, $t0, 4 #index
	add $t8, $t8, $t1
	lw $t3, 0($t8) #value of ar[index] at $t2
	move $t8, $s0
	beq $t3, 0, save
	li $v0, 4
	la $a0, bad
	syscall
	li $v0, 4
	la $a0, line
	syscall
	j collect
	
	
save:
	add $s0, $s0, $t1
	sw $t9, 0($s0)
	mul $t1, $t1, -1
	add $s0, $s0, $t1
	li $t7, 0
	jal dot
	#jal printarr
	j repeat
	
printarr:
	li $v0, 4
	la $a0, line
	syscall
	bgt $t7, 8, repeat
	lw $t6, 0($t8)
	addi $t8, $t8, 4
	li $v0, 1
	move $a0, $t6
	syscall
	addi $t7, $t7, 1
	j printarr
repeat:
	jal wincon
	beq $t9, 1, player1
	beq $t9, 2, player2
	
player1:
	li $t9, 2
	#jal draw
	j collect
	
player2:
	li $t9, 1
	#jal draw
	j collect

dot:
	beq $t0, 0, draw1
	beq $t0, 1, draw2
	beq $t0, 2, draw3
	beq $t0, 3, draw4
	beq $t0, 4, draw5
	beq $t0, 5, draw6
	beq $t0, 6, draw7
	beq $t0, 7, draw8
	beq $t0, 8, draw9
	jr $ra
	draw1:
		li $a3, 5
		li $a0, 0
		li $a1, 3
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr1
	
	dr1:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr1
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw2:
		li $a3, 5
		li $a0, 13
		li $a1, 3
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr2
	
	dr2:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr2
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw3:
		li $a3, 5
		li $a0, 23
		li $a1, 3
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr3
	
	dr3:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr3
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw4:
		li $a3, 5
		li $a0, 0
		li $a1, 13
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr4
	
	dr4:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr4
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw5:
		li $a3, 5
		li $a0, 13
		li $a1, 13
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr5
	
	dr5:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr5
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw6:
		li $a3, 5
		li $a0, 23
		li $a1, 13
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr6
	
	dr6:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr6
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw7:
		li $a3, 5
		li $a0, 0
		li $a1, 26
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr7
	
	dr7:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr7
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw8:
		li $a3, 5
		li $a0, 13
		li $a1, 26
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr8
	
	dr8:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr8
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	draw9:
		li $a3, 5
		li $a0, 23
		li $a1, 26
		move $a2, $t9
		addiu $sp, $sp, -20
		sw $ra, 0($sp)
		j dr9
	
	dr9:
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		jal draw
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addiu $a0, $a0, 1
		addiu $a3, $a3, -1
		bne $a3, 0, dr9
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	jr $ra
	
wincon:
	check123:
		lw $t7, 0($t8)
		beqz $t7, check456
		addi $t8, $t8, 4
		lw $t6, 0($t8)
		addi $t8, $t8, -4
		beq $t7, $t6, check123x
		j check456
		check123x:
			addi $t8, $t8, 8
			lw $t7, 0($t8)
			beq $t7, $t6, win
			add $t8, $t8, -8
			j check456
	check456:
		addi $t8, $t8, 12
		lw $t7, 0($t8)
		addi $t8, $t8, -12
		beqz $t7, check789
		addi $t8, $t8, 16
		lw $t6, 0($t8)
		addi $t8, $t8, -16
		beq $t7, $t6, check456x
		j check789
		check456x:
			addi $t8, $t8, 20
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -20
			j check789
	check789:
		addi $t8, $t8, 24
		lw $t7, 0($t8)
		addi $t8, $t8, -24
		beqz $t7, check369
		addi $t8, $t8, 28
		lw $t6, 0($t8)
		addi $t8, $t8, -28
		beq $t7, $t6, check789x
		j check369
		check789x:
			addi $t8, $t8, 32
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -32
			j check369
	check369:
		addi $t8, $t8, 8
		lw $t7, 0($t8)
		addi $t8, $t8, -8
		beqz $t7, check147
		addi $t8, $t8, 20
		lw $t6, 0($t8)
		addi $t8, $t8, -20
		beq $t7, $t6, check369x
		j check147
		check369x:
			addi $t8, $t8, 32
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -32
			j check147
	check147:
		lw $t7, 0($t8)
		beqz $t7, check258
		addi $t8, $t8, 12
		lw $t6, 0($t8)
		addi $t8, $t8, -12
		beq $t7, $t6, check147x
		j check258
		check147x:
			addi $t8, $t8, 24
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -24
			j check258
	check258:
		addi $t8, $t8, 4
		lw $t7, 0($t8)
		addi $t8, $t8, -4
		beqz $t7, check159
		addi $t8, $t8, 16
		lw $t6, 0($t8)
		addi $t8, $t8, -16
		beq $t7, $t6, check258x
		j check159
		check258x:
			addi $t8, $t8, 28
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -28
			j check159
	check159:
		lw $t7, 0($t8)
		beqz $t7, check357
		addi $t8, $t8, 16
		lw $t6, 0($t8)
		addi $t8, $t8, -16
		beq $t7, $t6, check159x
		j check357
		check159x:
			addi $t8, $t8, 32
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -32
			j check357
	check357:
		addi $t8, $t8, 8
		lw $t7, 0($t8)
		addi $t8, $t8, -8
		beqz $t7, check753
		addi $t8, $t8, 16
		lw $t6, 0($t8)
		addi $t8, $t8, -16
		beq $t7, $t6, check357x
		j check753
		check357x:
			addi $t8, $t8, 24
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -24
			j check753
	check753:
		addi $t8, $t8, 24
		lw $t7, 0($t8)
		addi $t8, $t8, -24
		beqz $t7, exit
		addi $t8, $t8, 16
		lw $t6, 0($t8)
		addi $t8, $t8, -16
		beq $t7, $t6, check753x
		j exit
		check753x:
			addi $t8, $t8, 8
			lw $t7, 0($t8)
			beq $t7, $t6, win
			sub $t8, $t8, -8
			j exit
	jr $ra
win:
	la $a0, player
	li $v0, 4
	syscall
	move $a0, $t9
	li $v0, 1
	syscall
	la $a0, wins
	li $v0, 4
	syscall
	li $v0, 10
	syscall
exit:
	jr $ra
stalecheck:
	li $t7, 0
	stale:
		beq $t7, 9, stalecon
		lw $t6, 0($t8)
		addi $t8, $t8, 4
		addi $t7, $t7, 1
		bnez $t6, stale
		mul $t7, $t7, -4
		add $t8, $t8, $t7
		jr $ra
	stalecon:
		la $a0, stalemate
		li $v0, 4
		syscall
		li $v0, 10
		syscall
	
	
