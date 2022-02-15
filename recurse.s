.data
question:	.asciiz    "Enter a value for n: "
result:	.asciiz    " \n"

.text
.globl main

main:
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    li $v0, 4	# print string command
    la $a0, question
    syscall		# print the question

    li $v0, 5	# read int command
    syscall	
    move $a0, $v0	# move the user input value, n, to $t0
    jal recurse

    add $s2, $zero, $v0
    move $a0, $v0
    li $v0, 1
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

recurse:
    subu $sp, $sp, 12
    sw $ra, 0($sp)
    sw $s5, 4($sp) # storing n
    sw $s6, 8($sp) # save 3n -2

    move $s5, $a0 # a0 into s5 (n)
    beq $a0, $zero, baseCase

    li $t2, 3
    li $t3, 2
    add $t4, $zero, -2

    mul $s6, $s5, $t2 # 3n
    sub $s6, $s6, $t3 # -2

    move $s5, $a0
    addi $a0, -1

    jal recurse


    mul $v0, $v0, $t3 # multiply by 2
    add $v0, $v0, $s6

    lw $ra, 0($sp)
    lw $s5, 4($sp)
    lw $s6, 8($sp)
    addi $sp, $sp, 12

    jr $ra

baseCase:
    add $v0, $zero, $t4
    lw $ra, 0($sp)
    lw $s5, 4($sp)
    lw $s6, 8($sp)
    addi $sp, $sp, 12

    jr $ra
    
