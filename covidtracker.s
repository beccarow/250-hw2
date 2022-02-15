.text
.align 2

main:
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    li $a0, 38 #allocate space for ROOT
    li $v0, 9 #dynamically allocate memory
    syscall

    move $s7, $v0 # s7 = ROOT
    move $a0, $s7
    la $a1, blueDevil
    jal strcpy # blueDevil = head of tree


while:
     #print prompt for patient
    li $v0, 4 
    la $a0, patientPrompt
    syscall

    #read patient name
    li $v0, 8
    la $a0, buffer
    la $a1, 31
    syscall

    move $s0, $a0 # s0 = patient name

    la $a0, buffer
    la $a1, done  #load done
    jal compare
    beq $v0, $zero, next

    #print prompt for source
    li $v0, 4
    la $a0, sourcePrompt
    syscall 

    #read source name
    li $v0, 8
    la $a0, buffer
    la $a1, 31
    syscall

    move $s1, $a0 # s1 = source name
    #CREATE NODE
    li $a0, 38 #allocate space for 30 char
    li $v0, 9 #dynamically allocate memory
    syscall
    move $a0, $v0 #a0 = node
    move $a1, $s0 #a1 = patient name
    jal strcpy

    move $s2, $v0 # moves node to s2
    li $t1, 0
    #sw $t1, 30($s2) # set left node to null
    #sw $t1, 34($s2) # set right node to null -> not storing name, storing address of name

    move $a0, $s7 #root
    move $a1, $s2 #address of node with patient name
    move $a2, $s1 #source name
    jal insertSort
    

    j while

next:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

compare:
    add $t1, $a0, $zero #buffer -> t1
    add $t2, $a1, $zero #done -> t2

loop:
    lb $t3, ($t1) #buffer
    lb $t4, ($t2) #done
    beqz $t3, checkt4
    beqz $t4, mismatch
    bne $t3, $t4, mismatch
    addi $t1, $t1, 1 # move 1 letter forward in buffer
    addi $t2, $t2, 1 # move 1 letter forward in done
    j loop

mismatch:
    addi $v0, $zero, 1
    j end

checkt4:
    bnez $t4, mismatch # not done
    add $v0, $zero, $zero # yes done

end:
    jr $ra

strcpy:
	lb $t0, 0($a1)
	beq $t0, $zero, done_copying
	sb $t0, 0($a0)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j strcpy

done_copying:
	jr $ra

insertSort: # a0 = root, a1= patient name address, a2 = source name
    subu $sp, $sp, 20 #want addresses of nodes to know where to add new nodes
    sw $a0, 0($sp) #load tree root address
    sw $a1, 4($sp)
    sw $ra, 8($sp) #loads return address
    
    #lw $t1, 30($a0) #left child
    #sw $t1, 12($sp)

    #lw $t2, 34($a0) #right child
    #sw $t2, 16($sp)

    move $a1, $a2 # move a2 to a1 because compare takes arguments a0 and a1, a2 is actually the source
    jal compare
    bnez $v0, notFound
    
    lw $a1, 4($sp) # patient name add.
    lw $a0, 0($sp) # root
    lw $t1, 30($a0) # left child
    lw $t2, 34($a0) #right child

    bnez $t1, leftFull
    sw $a1, 30($a0) # set empty left to patient name -> store a1 in 30(a0)
    lw $ra, 8($sp)
    addi $sp, $sp, 20
    jr $ra


notFound: #checks if child is empty, going down left side of tree
    lw $a0, 30($a0)
    beqz $a0, childNull
    jal insertSort
    lw $a0, 34($a0)
    beqz $a0, childNull
    jal insertSort

childNull:
    lw $ra, 8($sp)
    addi $sp, $sp, 20
    jr $ra

leftFull:
    sw $a1, 34($a0)
    move $a0, $a1 # move in order to call compare
    move $a1, $a2
    jal strcmp

    bgtz $v0, switch

    lw $a1, 4($sp)
    lw $a0, 0($sp) # load root
    lw $a0, 34($a0) # right child
    jal insertSort
    # set found->right = $v0

    lw $ra, 8($sp)
    addi $sp, $sp, 20
    jr $ra

switch:
    li $a0, 38 #allocate space for 30 char
    li $v0, 9 #dynamically allocate memory
    syscall
    move $a0, $v0 #a0 = node

    lw $t1, 12($sp) # left child
    lw $t2, 16($sp) #right child

    move $a0, $t1 # swap = found->left : temp variables
    move $t2, $a0 # found->right = swap
    move $t1, $a1 # found->left = patient name

    move $a1, $s0 #a1 = patient name
    jal strcpy

    add $s2, $zero, $v0 # moves node to s2
    sw $zero, 30($s2) # set left node to null
    sw $zero, 34($s2) # set right node to null -> not storing name, storing address of name

strcmp:
	lb $t0, 0($a0)
	lb $t1, 0($a1)

	bne $t0, $t1, done_with_strcmp_loop
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	bnez $t0, strcmp
	li $v0, 0
	jr $ra
		

done_with_strcmp_loop:
	sub $v0, $t0, $t1
	jr $ra

print:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    beq $a0, $zero, exitPrint # if root is null

printLoop:
    li $v0, 4
    syscall

    la $a0, space
    li $v0, 4
    syscall

    lw $a0, 4($sp) # reload root
    li $v0, 4
    la $a0, 30($a0) # left
    syscall

    la $a0, space
    li $v0, 4
    syscall

    lw $a0, 4($sp) # reload root
    li $v0, 4
    la $a0, 34($a0)
    syscall

    lw $a0, 4($sp)
    la $a0, 30($a0) # call again on left
    jal print

    lw $a0, 4($sp)
    la $a0, 34($a0) # call again on right
    jal print

exitPrint:
    lw $a0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

printTree: # root of tree and head of linked list, recursive
    subu $sp, $sp, 12
    sw $ra, 0($sp)
    sw $s0, 4($sp) # root (a0)
    sw $s1, 8($sp) # head of linked list (a1)
    move $s0, $a0
    move $s1, $a1
    beqz $a0, rootNull
    # check if left child is null --> if so print just root
    move $t1, 30($s0)
    move $a0, $s0
    move $a1, $s1
    beqz $t1, leftNull

    move $t1, 34($s0)
    move $a0, $s0
    move $a1, $s1
    beqz $t1, rightNull

    j familyFull


leftNull: # malloc space for new node and add to linked list
    move $t1, $a0 #save a0
    move $t2, $a1
    li $a0, 100 #allocate space for 3 max 30 char names
    li $v0, 9 #dynamically allocate memory
    syscall
    move $a0, $v0 # moving nodes to be called by listSort
    move $a1, $t1
    jal strcpy
    move $a0, $v0
    move $a1, $t2
    jal listSort
    # close stack ?

    j printTreeCont

rightNull:
    move $t0, $a0 # root
    move $t1, 30($a0) # left child
    move $t3, $a1

    la $a0, family #buffer for copying
    move $a1, $t0 #root
    jal strcpy

    # TO DO: copy both names together
    li $a0, 100 #allocate space for 3 max 30 char names
    li $v0, 9 #dynamically allocate memory
    syscall
    move $a0, $v0 # allocated space/node
    move $a1, $t4 # t4 should be family string
    jal strcpy
    
    move $a0, $v0
    move $a1, $t3
    jal listSort

    j printTreeCont

familyFull:
    # TO DO: copy both names together
    li $a0, 100 #allocate space for 3 max 30 char names
    li $v0, 9 #dynamically allocate memory
    syscall
    move $a0, $v0 # allocated space/node
    move $a1, $t4 # t4 should be family string
    jal strcpy
    
    move $a0, $v0
    move $a1, $s1
    jal listSort

printTreeCont:
    move $a0, 30($s0) # get address of left child
    move $a1, $s1 # head of linked list -> a1
    jal printTree

    move $a1, $v0 # returned from printTree
    move $a0, 34($s0) # address of right child - might need to save more stuff
    jal printTree # printing right child subtree

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    move $v0, $a1 # might have to change a1 to s1
    jr $ra # return head of linked list

rootNull:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    move $v0, $a1
    jr $ra

# TO DO: flag of when to print

listSort: # takes head of list (a1) and new node (a0)
    move $t1, $a1 # head
    move $t0, $a0 # new node
    beqz $t1, headNull
    move $a0, $t1
    move $a1, $t0
    jal strcmp
    bgez $v0, headNull
    move $t3, $t1 # move head to t3

loopListSort:
    move $t4, 100($t3)
    beqz $t4, exitLoop
    move $a0, 100($t4) # current->next
    move $a1, $t0 # new node being compared
    jal strcmp
    bltz $v0, exitLoop
    move $t3, 100($t3)
    j loopListSort

exitLoop:
    move $t7, 100($t0) # new node->next
    move $t4, 100($t3) # current->next
    move $t7, $t4 # new node->next = current->next
    move $t0, $t4 # current->next = new node
    jr $ra

headNull: # make new node head
    move $t6, $a1 # moves head to temp
    move $t5, 100($a0) # moves new node->next to head
    move $t5, $t6 # new node->next = head
    move $a1, $a0
    jr $ra
    


.data
patientPrompt: .asciiz "Enter patient name: "
sourcePrompt: .asciiz "Enter source name: "
buffer: .space 31
done: .asciiz "DONE\n"
blueDevil: .asciiz "bluedevil\n"
space: .asciiz " "
family: .space 90