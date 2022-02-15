
.data 

patientprompt: .asciiz " Enter a patient name:"
infectorprompt: .asciiz " Enter the infecor name:"
respoint: .asciiz "res line \n"
string: .asciiz "%s"
space: .asciiz " "
newline: .asciiz "\n"
empty: .asciiz "File is empty"
done1: .asciiz "DONE\n"
done2: .asciiz "DONE"
done3: .asciiz "DON"
buffer: .space 31
buffer2: .space 31

.text
.align 2
main:
        addiu   $sp,$sp,-208
        sw      $31,204($sp)
        sw      $fp,200($sp)
        move    $fp,$sp
        sw      $4,208($fp)
        sw      $5,212($fp)
        li      $v0, 4 
        la      $a0, patientprompt
        syscall
        nop

        addiu   $2,$fp,56
        move    $5,$2
        li      $v0, 8
        la      $a0, buffer
        la      $a1, 31
        syscall

        nop
        #sw      $0,24($fp)
        #sw      $0,28($fp)

while_loop:
        addiu   $3,$fp,56
        move    $4,$3
        la $a0, buffer
        la $a1, done1  #load done
        jal strcmp
        beq $v0, $zero, exitdone #exit code if patient = DONE
        nop

        li      $v0, 4 
        la      $a0, infectorprompt
        syscall

        addiu   $2,$fp,128
        move    $5,$2
        li      $v0, 8
        la      $a0, buffer2
        la      $a1, 31
        syscall
        nop

        li      $a0, 38 #allocate space for patient
        li      $v0, 9 #dynamically allocate memory
        syscall

        sw      $2,40($fp)

        li      $a0, 38 #allocate space for source
        li      $v0, 9 #dynamically allocate memory
        syscall

        sw      $2,44($fp)
        sw      $0,32($fp)
    copy_patient: #copy patient name into  nodes
        lw      $2,32($fp)
        addiu   $3,$fp,56
        addu    $2,$3,$2
        lb      $2,0($2)
        nop
        beq     $2,$0, donecopying #if patient charachter is empty, finish copying
        nop

        lw      $2,32($fp)
        addiu   $3,$fp,56
        addu    $2,$3,$2
        lb      $3,0($2)
        li      $2,10                 # 0xa
        beq     $3,$2,donecopying 
        nop

        lw      $3,40($fp)
        lw      $2,32($fp)
        nop
        addu    $2,$3,$2
        lw      $3,32($fp)
        addiu   $4,$fp,56
        addu    $3,$4,$3
        lb      $3,0($3)
        nop
        sb      $3,0($2)
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
        b       copy_patient
        nop

donecopying :
        lw      $3,40($fp)
        lw      $2,32($fp)
        nop
        addu    $2,$3,$2
        sb      $0,0($2)
        sw      $0,36($fp)
copy_source:
        lw      $2,36($fp)
        addiu   $3,$fp,128
        addu    $2,$3,$2
        lb      $2,0($2)
        nop
        beq     $2,$0,donecopy2
        nop

        lw      $2,36($fp)
        addiu   $3,$fp,128
        addu    $2,$3,$2
        lb      $3,0($2)
        li      $2,10                 # 0xa
        beq     $3,$2,donecopy2
        nop

        lw      $3,44($fp)
        lw      $2,36($fp)
        nop
        addu    $2,$3,$2
        lw      $3,36($fp)
        addiu   $4,$fp,128
        addu    $3,$4,$3
        lb      $3,0($3)
        nop
        sb      $3,0($2)
        lw      $2,36($fp)
        nop
        addiu   $2,$2,1
        sw      $2,36($fp)
        b       copy_source
        nop

donecopy2:
        lw      $3,44($fp)
        lw      $2,36($fp)
        nop
        addu    $2,$3,$2
        sb      $0,0($2)
        li      $v0, 4 
        la      $a0, patientprompt
        syscall
        nop

        addiu   $2,$fp,56
        move    $5,$2
        li      $v0, 8
        la      $a0, buffer
        la      $a1, 31
        syscall
        nop

        lw      $2,28($fp)
        nop
        bne     $2,$0,insertnode 
        nop

        lw      $2,44($fp)
        nop
        sw      $2,28($fp)
        lw      $6,44($fp)
        lw      $5,40($fp)
        lw      $4,28($fp)
        jal     insertSort
        nop

        sw      $2,28($fp)
        b       jumploop
        nop

insertnode :
        lw      $6,44($fp)
        lw      $5,40($fp)
        lw      $4,28($fp)
        jal     insertSort

        nop

        sw      $2,28($fp)
jumploop:
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
        b       while_loop
        nop

exitdone:
        sw      $0,48($fp)
        li      $2,1                        
        sw      $2,52($fp)
        lw      $6,52($fp)
        lw      $5,48($fp)
        lw      $4,28($fp)
        jal     printTree
        nop

        sw      $2,48($fp)
        move    $2,$0
return_done:
        move    $sp,$fp
        lw      $31,204($sp)
        lw      $fp,200($sp)
        addiu   $sp,$sp,208
        j       $31
        nop

printTree:
        addiu   $sp,$sp,-144
        sw      $31,140($sp)
        sw      $fp,136($sp)
        move    $fp,$sp
        sw      $4,144($fp)
        sw      $5,148($fp)
        sw      $6,152($fp)
        lw      $2,144($fp)
        nop
        bne     $2,$0,$L16
        nop

        lw      $2,148($fp)
        b       $L17
        nop

$L16: #case where root has no right of left children 
        lw      $2,144($fp)
        nop
        lw      $2,32($2)
        nop
        bne     $2,$0,$L18
        nop

        lw      $2,144($fp) 
        nop
        move    $4,$2 #we take the root string

        jal     newNode #we create a new node ( it also copies the string to the node) 
        nop

        sw      $2,24($fp)
        addiu   $2,$fp,148
        lw      $5,24($fp)
        move    $4,$2   



        jal     LLsort #insert new node to the linked list alphabetically 
        nop

        b       $L19
        nop

$L18: #case where root has only a left child
        lw      $2,144($fp)
        nop
        lw      $2,36($2)
        nop
        bne     $2,$0,$L20
        nop

        lw      $3,144($fp)
        addiu   $2,$fp,36
        move    $5,$3
        move    $4,$2    
        jal     strcpy   #we take the root string
        nop

        addiu   $2,$fp,36
        move    $4,$2
        jal     strlen
        nop

        move    $3,$2
        addiu   $2,$fp,36
        addu    $2,$2,$3
        li      $3,32                #we take the left child string
        sb      $3,0($2)
        sb      $0,1($2)
        lw      $2,144($fp)
        nop
        lw      $2,32($2)
        nop
        move    $3,$2
        addiu   $2,$fp,36
        move    $5,$3
        move    $4,$2

        jal     strcat             # put root and left child name together in one line (example :"BlueuDevil Badger")
        nop

        addiu   $2,$fp,36
        move    $4,$2

        jal     newNode             #creat new node
        nop

        sw      $2,28($fp)
        addiu   $2,$fp,148
        lw      $5,28($fp)
        move    $4,$2

        jal     LLsort              #insert and sort 
        nop

        b       $L19
        nop

$L20: #case where root has a left child  and right child
        lw      $3,144($fp)
        addiu   $2,$fp,36
        move    $5,$3
        move    $4,$2
        jal     strcpy
        nop

        addiu   $2,$fp,36
        move    $4,$2
        jal     strlen
        nop

        move    $3,$2
        addiu   $2,$fp,36
        addu    $2,$2,$3
        li      $3,32                
        sb      $3,0($2)
        sb      $0,1($2)
        lw      $2,144($fp)
        nop
        lw      $2,32($2)
        nop
        move    $3,$2
        addiu   $2,$fp,36
        move    $5,$3
        move    $4,$2
        jal     strcat
        nop

        addiu   $2,$fp,36
        move    $4,$2
        jal     strlen
        nop

        move    $3,$2
        addiu   $2,$fp,36
        addu    $2,$2,$3
        li      $3,32                 # 0x20
        sb      $3,0($2)
        sb      $0,1($2)
        lw      $2,144($fp)
        nop
        lw      $2,36($2)
        nop
        move    $3,$2
        addiu   $2,$fp,36
        move    $5,$3
        move    $4,$2
        jal     strcat
        nop

        addiu   $2,$fp,36
        move    $4,$2
        jal     newNode
        nop

        sw      $2,32($fp)
        addiu   $2,$fp,148
        lw      $5,32($fp)
        move    $4,$2

        jal     LLsort
        nop

$L19:
        lw      $2,144($fp)
        nop
        lw      $2,32($2)
        lw      $3,148($fp)
        move    $6,$0
        move    $5,$3
        move    $4,$2
        jal     printTree        #call print tree for left child 
        nop

        sw      $2,148($fp)
        lw      $2,144($fp)
        nop
        lw      $2,36($2)
        lw      $3,148($fp)
        move    $6,$0
        move    $5,$3
        move    $4,$2
        jal     printTree     #call print tree for right child 
        nop

        sw      $2,148($fp)
        lw      $3,152($fp)
        li      $2,1                        #
        bne     $3,$2,$L21
        nop

        lw      $2,148($fp)
        nop
        move    $4,$2
        jal     printList       #if at the end, print the linked list alphabetically 
        nop

$L21:
        lw      $2,148($fp)
$L17:
        move    $sp,$fp         #go back to return address
        lw      $31,140($sp)
        lw      $fp,136($sp)
        addiu   $sp,$sp,144
        j       $31
        nop

#---------------------END of PRINT TREE --------------------------------------------


#---------------------START of LLsort --------------------------------------------
LLsort:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        sw      $5,44($fp)
        lw      $2,40($fp)
        nop
        lw      $2,0($2)
        nop
        beq     $2,$0,$L23
        nop

        lw      $2,40($fp)
        nop
        lw      $2,0($2)
        nop
        move    $3,$2
        lw      $2,44($fp)
        nop
        move    $5,$2
        move    $4,$3
        jal     strcmp
        nop

        bltz    $2,$L24
        nop

$L23:
        lw      $2,40($fp)          #check #if new node is alphabetically smaller
        nop
        lw      $3,0($2)
        lw      $2,44($fp)
        nop
        sw      $3,100($2)
        lw      $2,40($fp)
        lw      $3,44($fp)
        nop
        sw      $3,0($2)
        b       $L25 #jump to insert before root
        nop

$L24:
        lw      $2,40($fp)    
        nop
        lw      $2,0($2)
        nop
        sw      $2,24($fp)
$L27: #loop to check where to put new node on the right side of the linked list (bigger alphabetically) 
        lw      $2,24($fp)   
        nop
        lw      $2,100($2)
        nop
        beq     $2,$0,$L26
        nop

        lw      $2,24($fp)
        nop
        lw      $2,100($2)
        nop
        move    $3,$2
        lw      $2,44($fp)
        nop
        move    $5,$2
        move    $4,$3
        jal     strcmp
        nop

        bgez    $2,$L26 #if new node is smaller than next node, insert here
        nop

        lw      $2,24($fp)
        nop
        lw      $2,100($2)
        nop
        sw      $2,24($fp)
        b       $L27   #jump back to the loop if not right spot ( new node still too big) 
        nop

$L26: #if new node is smaller than next node, insert here
        lw      $2,24($fp)
        nop
        lw      $3,100($2)
        lw      $2,44($fp)
        nop
        sw      $3,100($2)
        lw      $2,24($fp)
        lw      $3,44($fp)
        nop
        sw      $3,100($2)
$L25: #insert before root
        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        j       $31
        nop
#---------------------END of LL sort --------------------------------------------

printList:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        lw      $2,40($fp)
        nop
        sw      $2,24($fp)
$L30: #loop to print each line 
        lw      $2,24($fp)
        nop
        beq     $2,$0,$L31 #if new line == zero, break
        nop
        lw      $2,24($fp) #this right now returns empty string ERROR
        la      $a0, 24($fp)
        li      $v0, 4     #print the linked list line 
        syscall
        nop
        move    $5,$2
        li      $v0, 4  #print new line 
        la      $a0, newline
        syscall
        nop
        lw      $2,24($fp)
        nop
        lw      $2,100($2)
        nop
        sw      $2,24($fp)
        b       $L30 #jump back to loop 
        nop

$L31: #exit print list 
        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        j       $31 #jr ra
        nop

#---------------------END of Print List --------------------------------------------

#---------------------start for InsertSort --------------------------------------------
insertSort:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        sw      $5,52($fp)
        sw      $6,56($fp)
        lw      $5,56($fp)
        lw      $4,48($fp)
        jal     finder    #jump to find the right source or whether it is in the tree already 
        nop

        sw      $2,24($fp)
        lw      $2,24($fp)
        nop
        bne     $2,$0,$L33
        nop

        lw      $2,52($fp)
        nop
        sw      $2,48($fp)
        lw      $2,48($fp)
        b       $L34
        nop

$L33: # call insert Sort on left child if child is null (add left)
        lw      $2,24($fp)
        nop
        lw      $2,32($2)
        nop
        bne     $2,$0,$L35
        nop

        lw      $2,24($fp)
        nop
        lw      $2,32($2)
        lw      $6,56($fp)
        lw      $5,52($fp)
        move    $4,$2
        jal     insertSort
        nop

        move    $3,$2
        lw      $2,24($fp)
        nop
        sw      $3,32($2)
        b       $L36
        nop

$L35: # if left child is full, compare to new node
        lw      $2,24($fp)
        nop
        lw      $2,32($2)
        nop
        move    $3,$2
        lw      $2,52($fp)
        nop
        move    $5,$2
        move    $4,$3
        jal     strcmp
        nop

        sw      $2,28($fp)
        lw      $2,28($fp)
        nop
        bgez    $2,$L37 # if new node is smaller than left, insert in left (switch)
        nop

        lw      $2,24($fp)
        nop
        lw      $2,36($2)
        lw      $6,56($fp)
        lw      $5,52($fp)
        move    $4,$2
        jal     insertSort # insert in right (bigger)
        nop

        move    $3,$2
        lw      $2,24($fp)
        nop
        sw      $3,36($2)
$L37: # if new node is smaller than left, insert in left (switch)
        lw      $2,28($fp)
        nop
        blez    $2,$L36
        nop

        sw      $0,32($fp)
        lw      $2,24($fp)
        nop
        lw      $2,32($2)
        nop
        sw      $2,32($fp)
        lw      $2,24($fp)
        lw      $3,32($fp)
        nop
        sw      $3,36($2)
        lw      $2,24($fp)
        lw      $3,52($fp)
        nop
        sw      $3,32($2)
$L36:
        lw      $2,48($fp)
$L34: # return
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        j       $31
        nop

finder: #locating in tree
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        sw      $5,44($fp)
        sw      $0,24($fp)
        lw      $2,40($fp)
        nop
        bne     $2,$0,$L39
        nop

        move    $2,$0
        b       $L40
        nop

$L39:
        lw      $2,40($fp)
        lw      $3,44($fp)
        nop
        move    $5,$3
        move    $4,$2
        jal     strcmp # compares name of root and source
        nop

        bne     $2,$0,$L41 # if not equal, jump to finder on children
        nop

        lw      $2,40($fp) # return root
        b       $L40
        nop

$L41: # calling finder on children of root
        lw      $2,40($fp)
        nop
        lw      $2,32($2)
        lw      $5,44($fp)
        move    $4,$2
        jal     finder # calls on left
        nop

        sw      $2,24($fp)
        lw      $2,24($fp)
        nop
        beq     $2,$0,$L42
        nop

        lw      $2,24($fp)
        b       $L40
        nop

$L42:
        lw      $2,40($fp)
        nop
        lw      $2,36($2)
        lw      $5,44($fp)
        move    $4,$2
        jal     finder # calls finder on right
        nop

        sw      $2,24($fp)
        lw      $2,24($fp)
        nop
        beq     $2,$0,$L43
        nop

        lw      $2,24($fp)
        b       $L40
        nop

$L43:
        move    $2,$0
$L40:
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        j       $31
        nop




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


    strcpy:
	lb $t0, 0($a1)
	sb $t0, 0($a0)
        beq $t0, $zero, done_copying
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j strcpy

	done_copying:
	jr $ra


    strlen:
        li      $v0, 0                  # len = 0

    while:  lb      $t0, ($a0)              # get char
        beqz    $t0, wh_end 
        subu $t1, $t0, 10
        beqz $t1, wh_end            # if(char == '\0') --> end while
        addi    $v0, $v0, 1             # len++
        addiu   $a0, $a0, 1             # *s++
        j       while
    wh_end:
        jr      $ra

# Advance #a0 until it contains address of \0 byte
strcat:
    or $t0, $a0, $zero # Source
    or $t1, $a1, $zero # Destination

loop:
    lb $t2, 0($t0)
    beq $t2, $zero, end
    addiu $t0, $t0, 1
    sb $t2, 0($t1)
    addiu $t1, $t1, 1
    b loop
    nop

end:
    or $v0, $t1, $zero # Return last position on result buffer
    jr $ra
    nop


newNode:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        li      $4,104                  # 0x68
        li      $a0, 104 #allocate space for ROOT
        li      $v0, 9 #dynamically allocate memory
        syscall
        nop

        sw      $2,24($fp)
        lw      $2,24($fp)
        lw      $5,40($fp)
        move    $4,$2
        jal     strcpy
        nop

        lw      $2,24($fp)
        nop
        sw      $0,100($2) #new node next == null
        lw      $2,24($fp)
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        j       $31
        nop
