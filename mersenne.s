.data
question:	.asciiz    "Enter a value for n: "
result:	.asciiz    " \n"

.text
.globl main

main:
    
    li $v0, 4	# print string command
    la $a0, question
    syscall		# print the question

    li $v0, 5	# read int command
    syscall	
    move $t0, $v0	# move the user input value, n, to $t0

    li $t1, 1	# x = 1 if n == 0
    li $t2, 0	# Loop counter
    li $t4, 1	# use to incrment loop counter and also final sub

top_of_loop:        # compute power of 2
    add $t2, $t2, $t4	# Increment until counter == n
    bgt $t2, $t0, end_of_loop
    sll $t1, $t1, 1		# x = x * 2
    move $v0, $t1
    j top_of_loop

end_of_loop:
    
    move $a0, $v0
    sub $t1, $t1, $t4 	# -1

    move $a0, $t1
    li $v0, 1	# print int command
    syscall

    li $v0, 4	# print string command
    la $a0, result	# carriage return
    syscall

    li $v0, 10	# terminate program
    syscall

