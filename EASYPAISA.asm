.data
strinput1 : .space 16
strinput2 : .space 16
stringinput3 : .space 16
giveorder: .asciiz "please enter what u want to order:\n"
username : .asciiz "HAMZA"
password : .asciiz "BUKC123"
balance  : .word  0

login_prompt: .asciiz "\nProvide the username : \n"
paswd_prompt: .asciiz "\nProvide the password :\n "
loginerror_prompt: .asciiz "\nInvalid crendentials. Please retry."
login_label:"LOGIN PAGE"
welcome_prompt: .asciiz "\n\n WELCOME TO EASYPAISA MIPS APPLICATION\n "
action_prompt: .asciiz "\n  1. Check your balance\n  2. Deposit Money\n  3. Withdraw Money\n  4. Electric Bill Payment\n  5. Ticket Payment\n  6. Sui Gas Payment\n  7. Internet Bill Payment\n  8. Order Food Payment\n 9. Exit\nSelect menu option : "
menu: .asciiz "\n  1. Chicken Roll RS-100\n  2. chicken burger RS-120\n  3. White karahi RS-800per-kg\n  4. California-pizza RS-1200\n  5. Fresh bread RS-100\n  6. California Fries RS-150/bucket\n"
tickets: .asciiz "\n  1. super service RS-1000\n  2. Super Deluxe Service RS-1500\n  3. Youtang Service RS-1800\n  4. Vip A/C Service RS-2000\n  5. Luxury Business Class Service RS-2200\n"
balance_prompt: .asciiz "\nYour current balance is $ \n"
withdraw_prompt: .asciiz "\nEnter the amount to withdraw :\n "
insufficient_prompt: .asciiz "\nYou dont have suffucient balance.\n"
deposit_prompt: .asciiz "\nEnter the amount to deposit :\n "
logout_prompt: .asciiz "\nSuccessfully logged out."
action_invalid: .asciiz "\nUnknown input provided. Valid inputs are 1-5."
pay: .asciiz "do you wanted to ELECTRIC BILL pay\n1.yes\n2.no\n"
Spay: .asciiz "do you wanted to SUI GAS pay\n1.yes\n2.no\n"
Ipay: .asciiz "do you wanted to SUI GAS pay\n1.yes\n2.no\n"
BUYTICKETS: .asciiz "do you wanted to buy tickets\n1.yes\n2.no\n"
ORDERFOOD: .asciiz "do you wanted to order food\n1.yes\n2.no\n"
en: .asciiz "enter amount: "
Sn: .asciiz "enter amount: "
In: .asciiz "enter amount: "
OF: .asciiz "enter amount OF food which u want to buy: "
BT: .asciiz "enter tickket package amount you want to avail: "
no: .asciiz "You have zero balance"
p: .asciiz "\nBill paid successfully"
O: .asciiz "\n ORDER FOOD successfully"
T: .asciiz "\n TICKET PURCHASED successfully"

more: .asciiz "do you want to withdraw again:\n1.yes\n2.no\n "
.text
main:
login:

	la   $a0, login_label     	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall   	
	
	la   $a0, login_prompt     	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	la   $a0, strinput1     	# load address of input buffer for syscall
	li   $a1, 16          		# Maximum number of the length of read string service
	li   $v0, 8           		# specify read string service
	syscall               		# Read the string.
	la   $a0, paswd_prompt     	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	la   $a0, strinput2     	# load address of input buffer for syscall
	li   $a1, 16          		# Maximum number of the length of read string service
	li   $v0, 8           		# specify read string service
	syscall   					# Read the string.
	
	la   $a0, username     		# load address of the username
	la   $a1, strinput1    		# load address of input buffer for username 
	jal StringCompare
	bne  $v0, 0 , login_incorrect
	
	la   $a0, password     		# load address of the password
	la   $a1, strinput2  		# load address of input buffer for password 
	jal StringCompare
	bne  $v0, 0 , login_incorrect
	
	j account
	
	login_incorrect:	
		la   $a0, loginerror_prompt # load address of prompt for syscall
		li   $v0, 4           		# specify Print String service
		syscall               		# print the prompt string
		j login

account:
	
	la   $a0, welcome_prompt    # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	
	
	la   $a0, username     		# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	
	la   $a0, action_prompt     # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	
	li   $v0, 5           		# specify Read Integer service
	syscall               		# Read the number. After this instruction, the number read is in $v0.
	
	beq  $v0, 1 , account_balance
	beq  $v0, 2 , account_deposit
	beq  $v0, 3 , account_withdraw
	beq  $v0, 4 , EBILL
	
	beq  $v0, 5 , Buy
	beq  $v0, 6 , SBILL
	beq  $v0, 7 , IBILL
	beq  $v0, 8 , order
	
	beq  $v0, 9 , exit
	
	
	la   $a0, action_invalid    # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	j account
	
account_balance:
	la   $a0, balance_prompt    # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	la   $t0, balance
	lw   $a0, ($t0)       # load the integer to be printed 
	li   $v0, 1           # specify Print Integer service
	syscall               # print the balance number
	j account
	
account_withdraw:
	la   $a0, withdraw_prompt   # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	li   $v0, 5           		# specify Read Integer service
	syscall               		# Read the number. After this instruction, the number read is in $v0.
	la   $t0, balance
	lw   $t1, ($t0)
	sub  $t1, $t1, $v0
	blt $t1, 0, withdraw_insufficient
	sw   $t1, ($t0)	
	la $a0,more
	li $v0,4
	syscall
	li $v0,5
	syscall
	beq $v0,1,account_withdraw
	
	j account_balance
	withdraw_insufficient:
		la   $a0, insufficient_prompt   # load address of prompt for syscall
		li   $v0, 4           			# specify Print String service
		syscall               			# print the prompt string
		j account_balance
		
	
account_deposit:
	la   $a0, deposit_prompt   # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	li   $v0, 5           		# specify Read Integer service
	syscall               		# Read the number. After this instruction, the number read is in $v0.
	la   $t0, balance
	lw   $t1, ($t0)
	add  $t1, $t1, $v0
	sw   $t1, ($t0)	
	j account_balance
	
EBILL:
	la   $a0, pay   	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall 
	li $v0,5
	syscall
	
	beq $v0,1,yesh
	beq $v0,2,nooo
	
	              		
	yesh:
	la $a0,en
	li $v0,4
	syscall
	li $v0,5
	syscall
	la   $t0, balance
	lw   $t1, ($t0)
	sub  $t1, $t1, $v0
	blt $t1, 0, withdra_insufficient
	sw   $t1, ($t0)	
	la $a0,p
	li $v0,4
	syscall
	j account_balance
	withdra_insufficient:
		la   $a0, no   # load address of prompt for syscall
		li   $v0, 4           			# specify Print String service
		syscall               			# print the prompt string
	j account   	
	
nooo:
j account	# print the prompt string
	
	Buy:
	la   $a0, BUYTICKETS  	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall 
	li $v0,5
	syscall
	
	 la   $a0, tickets     # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	
	
	beq $v0,1,yes1
	beq $v0,2,no1
	
	              		
	yes1:
	la $a0,en
	li $v0,4
	syscall
	li $v0,5
	syscall
	la   $t0, balance
	lw   $t1, ($t0)
	sub  $t1, $t1, $v0
	blt $t1, 0, withdraw1_insufficient
	sw   $t1, ($t0)	
	la $a0,T
	li $v0,4
	syscall
	j account_balance
	withdraw1_insufficient:
		la   $a0, no   # load address of prompt for syscall
		li   $v0, 4           			# specify Print String service
		syscall               			# print the prompt string
	j account   	
	
no1:
j account	# print the prompt string
	
	


exit:
	# The program is finished. Exit.
	li   $v0, 10          # system call for exit
	syscall               # Exit!
		
SBILL:
	la   $a0, Spay   	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall 
	li $v0,5
	syscall
	
	beq $v0,1,yes2
	beq $v0,2,no2
	
	              		
	yes2:
	la $a0,Sn
	li $v0,4
	syscall
	li $v0,5
	syscall
	la   $t0, balance
	lw   $t1, ($t0)
	sub  $t1, $t1, $v0
	blt $t1, 0, withdraw2_insufficient
	sw   $t1, ($t0)	
	la $a0,p
	li $v0,4
	syscall
	j account_balance
	withdraw2_insufficient:
		la   $a0, no   # load address of prompt for syscall
		li   $v0, 4           			# specify Print String service
		syscall               			# print the prompt string
	j account   	
	
no2:
j account	# print the prompt string
	
	IBILL:
	la   $a0, Ipay   	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall 
	li $v0,5
	syscall
	
	beq $v0,1,yes3
	beq $v0,2,no3
	
	              		
	yes3:
	la $a0,In
	li $v0,4
	syscall
	li $v0,5
	syscall
	la   $t0, balance
	lw   $t1, ($t0)
	sub  $t1, $t1, $v0
	blt $t1, 0, withdraw3_insufficient
	sw   $t1, ($t0)	
	la $a0,p
	li $v0,4
	syscall
	j account_balance
	withdraw3_insufficient:
		la   $a0, no   # load address of prompt for syscall
		li   $v0, 4           			# specify Print String service
		syscall               			# print the prompt string
	j account   	
	
no3:
j account	# print the prompt string

order:

	
	la   $a0, ORDERFOOD  	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall
	
	
	 
	li $v0,5
	syscall
	
	 la   $a0, menu     # load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall               		# print the prompt string
	
	la   $a0, giveorder    	# load address of prompt for syscall
	li   $v0, 4           		# specify Print String service
	syscall  

	la   $a0, stringinput3     	# load address of input buffer for syscall
	li   $a1, 16          		# Maximum number of the length of read string service
	li   $v0, 8           		# specify read string service
	syscall   
	
	beq $v0,1,yes4
	beq $v0,2,no4
	
	              		
	yes4:
	la $a0,OF
	li $v0,4
	syscall
	li $v0,5
	syscall
	la   $t0, balance
	lw   $t1, ($t0)
	sub  $t1, $t1, $v0
	blt $t1, 0, withdraw4_insufficient
	sw   $t1, ($t0)	
	la $a0,O
	li $v0,4
	syscall
	j account_balance
	withdraw4_insufficient:
		la   $a0, no   # load address of prompt for syscall
		li   $v0, 4           			# specify Print String service
		syscall               			# print the prompt string
	j account   	
	
no4:
j account	# print the prompt string
# Subroutines

StringCompare: 
	#a0 is the stored string address
	#a1 is the constant string address
	#return : $v0=0 means equal, nonzero unequal
	compareloop: 
		lb $t0, ($a0) 						# $t0 = ASCII of the character of first string
		lb $t1, ($a1) 						# $t1 = ASCII of the character of second string
		beq  $t0, 0, compareloop_done 	#If character is '\0'
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		beq  $t0, $t1, compareloop 		#If character is  equal
	compareloop_exit:
		li $v0,1				 		# return 1
		jr   $ra              	 		# return from subroutine
	compareloop_done:		
		bne  $t1, 10, compareloop_exit 	#If character is not '\n'
		li $v0,0	             		# return 0
		jr   $ra              	 		# return from subroutine
