.data
passstring:     .asciiz "all tests passed!\n"
fail1string:    .asciiz "test #"
fail2string:    .asciiz " failed!\n"

num0xABCDEFFF:	.word 0xABCDEFFF
num0x12345678:	.word 0x12345678

.text

# _start is the entry point into any program.
.global _start
.ent    _start 
_start:

#
#  The header ends here, and code goes below
#

        # test #1: sll
        li	$30, 1
        
        li	$t0, 0x00000001
        sll	$t0, $t0, 16

        li	$t1, 0x00010000
        bne	$t0, $t1, fail
        
        # test #2: srl
        li	$30, 2
        
        li	$t0, 0xf0000000
        srl	$t0, $t0, 2

        li	$t1, 0x3c000000
        bne	$t0, $t1, fail
        
        # test #3: sra
        li	$30, 3
        
        li	$t0, 0xf0000000
        sra	$t0, $t0, 2

        li	$t1, 0xfc000000
        bne	$t0, $t1, fail
        
        # test #4: jr
        li	$30, 4
        
        la	$t0, jr_test
        li	$t1, 0x00000101
        jr	$t0
        
        ori	$t1, $t1, 0x1010	# should be skipped
        
	jr_test:
	li	$t2, 0x00000101
        bne	$t1, $t2, fail
        
        # test #5: jalr
        li	$30, 5
        
        la	$t0, jalr_test
        li	$t1, 0x000ABCDE
        jalr	$ra, $t0
        
	jalr_skipped:
        ori	$t1, $t1, 0xFFFF	# should be skipped
        
        jalr_test:        
        li	$t2, 0x000ABCDE
        bne	$t1, $t2, fail
        la	$t2, jalr_skipped
        bne	$ra, $t2, fail
        
        # test #6: mult, mflo
        li	$30, 6
        
        li	$t0, 0x12345
        li	$t1, 0x67890
        mult	$t0, $t1
        
        li	$t2, 0x5CCA2ED0
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #7: mult, mfhi
        li	$30, 7
        
        li	$t0, 0x12345
        li	$t1, 0x67890
        mult	$t0, $t1
        
        li	$t2, 0x00000007
        mfhi	$t3
        bne	$t2, $t3, fail
        
        # test #8: mult, negative x positive
        li	$30, 8
        
        li	$t0, 8
        li	$t1, -2
        mult	$t0, $t1
        
        li	$t2, 0xFFFFFFF0
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #9: mult, positive x negative
        li	$30, 9
        
        li	$t0, -8
        li	$t1, 1
        mult	$t0, $t1
        
        li	$t2, 0xFFFFFFF8
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #10: mult, negative x negative
        li	$30, 10
        
        li	$t0, -8
        li	$t1, -2
        mult	$t0, $t1
        
        li	$t2, 0x00000010
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #11: multu, positive x positive
        li	$30, 11
        
        li	$t0, 8
        li	$t1, 2
        multu	$t0, $t1
        
        li	$t2, 0x00000010
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #12: multu, negative x positive
        li	$30, 12
        
        li	$t0, -16
        li	$t1, 5
        multu	$t0, $t1
        
        li	$t2, 0xFFFFFFB0
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #13: multu, positive x negative
        li	$30, 13
        
        li	$t0, 5
        li	$t1, -16
        multu	$t0, $t1
        
        li	$t2, 0xFFFFFFB0
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #14: multu, negative x negative
        li	$30, 14
        
        li	$t0, -5
        li	$t1, -5
        multu	$t0, $t1
        
        li	$t2, 0x00000019
        mflo	$t3
        bne	$t2, $t3, fail
        
        # test #15: addu without overflow
        li	$30, 15
        
        li	$t0, 5
        li	$t1, 10
        addu	$t0, $t0, $t1
        
        li	$t1, 15
        bne	$t0, $t1, fail
        
        # test #16: addu with overflow
        li	$30, 16
        
        li	$t0, 0x7FFFFFFF
        li	$t1, 1
        addu	$t0, $t0, $t1
        
        li	$t1, 0x80000000
        bne	$t0, $t1, fail
        
        # test #17: subu without overflow
        li	$30, 17
        
        li	$t0, 25
        li	$t1, 10
        subu	$t0, $t0, $t1
        
        li	$t1, 15
        bne	$t0, $t1, fail
        
        # test #18: subu with overflow
        li	$30, 18
        
        li	$t0, 0x80000000
        li	$t1, 1
        subu	$t0, $t0, $t1
        
        li	$t1, 0x7FFFFFFF
        bne	$t0, $t1, fail
        
        # test #19: and
        li	$30, 19
        
        li	$t0, 0x000F0000
        and	$t0, $t0, 0x00050000
        
        li	$t1, 0x00050000
        bne	$t0, $t1, fail
        
        # test #20: or
        li	$30, 20
        
        li	$t0, 0x000F00F0
        or	$t0, $t0, 0x0000ABCD
        
        li	$t1, 0x000FABFD
        bne	$t0, $t1, fail
        
        # test #21: xor
        li	$30, 21
        
        li	$t0, 0x00010101
        xor	$t0, $t0, 0x00011111
        
        li	$t1, 0x00001010
        bne	$t0, $t1, fail
        
        # test #22: nor
        li	$30, 22
        
        li	$t0, 0x00010101
        nor	$t0, $t0, 0x00011111
        
        li	$t1, 0xFFFEEEEE
        bne	$t0, $t1, fail
        
        # test #23: slt, positive < positive
        li	$30, 23
        
        li	$t0, 2
        li	$t1, 4
        slt	$t2, $t0, $t1
        
        li	$t3, 1
        bne	$t2, $t3, fail
        
        # test #24: slt, positive < positive
        li	$30, 24
        
        li	$t0, 4
        li	$t1, 2
        slt	$t2, $t0, $t1
        
        li	$t3, 0
        bne	$t2, $t3, fail
        
        # test #25: slt, negative < positive
        li	$30, 25
        
        li	$t0, -8
        li	$t1, 4
        slt	$t2, $t0, $t1
        
        li	$t3, 1
        bne	$t2, $t3, fail
        
        # test #26: slt, negative < positive
        li	$30, 26
        
        li	$t0, 1
        li	$t1, -1234567
        slt	$t2, $t0, $t1
        
        li	$t3, 0
        bne	$t2, $t3, fail
        
        # test #27: slt, negative < negative
        li	$30, 27
        
        li	$t0, -8
        li	$t1, -4
        slt	$t2, $t0, $t1
        
        li	$t3, 1
        bne	$t2, $t3, fail
        
        # test #28: slt, negative < negative
        li	$30, 28
        
        li	$t0, -2
        li	$t1, -1234567
        slt	$t2, $t0, $t1
        
        li	$t3, 0
        bne	$t2, $t3, fail
        
        # test #29: sltu, normal
        li	$30, 29
        
        li	$t0, 0
        li	$t1, 1
        sltu	$t2, $t0, $t1
        
        li	$t3, 1
        bne	$t2, $t3, fail
        
        # test #30: sltu, normal
        li	$30, 30
        
        li	$t0, 100
        li	$t1, 1
        sltu	$t2, $t0, $t1
        
        li	$t3, 0
        bne	$t2, $t3, fail
        
        # test #31: sltu, "negative" and normal
        li	$30, 31
        
        li	$t0, 10
        li	$t1, -10
        sltu	$t2, $t0, $t1
        
        li	$t3, 1
        bne	$t2, $t3, fail
        
        # test #32: sltu, "negative" and normal
        li	$30, 32
        
        li	$t0, -10
        li	$t1, 10
        sltu	$t2, $t0, $t1
        
        li	$t3, 0
        bne	$t2, $t3, fail
        
        # test #33: sltu, both "negative" 
        li	$30, 33
        
        li	$t0, -10
        li	$t1, -1
        sltu	$t2, $t0, $t1
        
        li	$t3, 1
        bne	$t2, $t3, fail
        
        # test #34: sltu, both "negative" 
        li	$30, 34
        
        li	$t0, -1
        li	$t1, -10
        sltu	$t2, $t0, $t1
        
        li	$t3, 0
        bne	$t2, $t3, fail
        
        # test #35: jal
        li	$30, 35
        
        li	$t0, 0x00010000
        jal	jal_test
        
        jal_skipped:
        ori	$t0, $t0, 0x0000ABCD
        
        jal_test:
        li	$t1, 0x00010000
        bne	$t0, $t1, fail
        la	$t1, jal_skipped
        bne	$ra, $t1, fail
        
        # test #36: beq, satisfied
        li	$30, 36
        
        li	$t0, 10
        li	$t1, 10
        beq	$t0, $t1, beq_1
        j	fail
        
        beq_1:
        
        # test #37: beq, not satisfied
        li	$30, 37
        
        li	$t0, 10
        li	$t1, 89
        beq	$t0, $t1, beq_2
        addu	$t0, $t0, $t1
        
        beq_2:
        li	$t2, 99
        bne	$t0, $t2, fail
        
        # test #38: addiu without overflow
        li	$30, 38
        
        li	$t0, 10
        addiu	$t1, $t0, 15
        
        li	$t2, 25
        bne	$t1, $t2, fail
        
        # test #39: addiu with overflow
        li	$30, 39
        
        li	$t0, 0x7FFFFFFF
        addiu	$t1, $t0, 1
        
        li	$t2, 0x80000000
        bne	$t1, $t2, fail
        
        # test #40: slti, positive < positive
        li	$30, 40
        
        li	$t0, 10
        slti	$t1, $t0, 20
        
        li	$t2, 1
        bne	$t1, $t2, fail
        
        # test #41: slti, positive < positive
        li	$30, 41
        
        li	$t0, 10
        slti	$t1, $t0, 1
        
        li	$t2, 0
        bne	$t1, $t2, fail
        
        # test #42: slti, negative < positive
        li	$30, 42
        
        li	$t0, -30
        slti	$t1, $t0, 20
        
        li	$t2, 1
        bne	$t1, $t2, fail
        
        # test #43: slti, negative < positive
        li	$30, 43
        
        li	$t0, 10
        slti	$t1, $t0, -999
        
        li	$t2, 0
        bne	$t1, $t2, fail
        
        # test #44: slti, negative < negative
        li	$30, 44
        
        li	$t0, -30
        slti	$t1, $t0, -20
        
        li	$t2, 1
        bne	$t1, $t2, fail
        
        # test #45: slti, negative < negative
        li	$30, 45
        
        li	$t0, -20
        slti	$t1, $t0, -999
        
        li	$t2, 0
        bne	$t1, $t2, fail
        
         # test #46: sltiu, positive < positive
        li	$30, 46
        
        li	$t0, 10
        sltiu	$t1, $t0, 20
        
        li	$t2, 1
        bne	$t1, $t2, fail
        
        # test #47: sltiu, positive < positive
        li	$30, 47
        
        li	$t0, 10
        sltiu	$t1, $t0, 1
        
        li	$t2, 0
        bne	$t1, $t2, fail
        
        # test #48: sltiu, positive < negative
        li	$30, 48
        
        li	$t0, 20
        sltiu	$t1, $t0, -1
        
        li	$t2, 1
        bne	$t1, $t2, fail
        
        # test #49: sltiu, positive < negative
        li	$30, 49
        
        li	$t0, -1
        sltiu	$t1, $t0, 2
        
        li	$t2, 0
        bne	$t1, $t2, fail
        
        # test #50: sltiu, negative < negative
        li	$30, 50
        
        li	$t0, -30
        sltiu	$t1, $t0, -20
        
        li	$t2, 1
        bne	$t1, $t2, fail
        
        # test #51: sltiu, negative < negative
        li	$30, 51
        
        li	$t0, -20
        sltiu	$t1, $t0, -999
        
        li	$t2, 0
        bne	$t1, $t2, fail
        
        # test #52: andi
        li	$30, 52
        
        li	$t0, 0x0000FFFF
        andi	$t0, $t0, 0xFDAD
        
        li	$t1, 0xFDAD
        bne	$t0, $t1, fail
        
        # test #53: xori
        li	$30, 53
        
        li	$t0, 0x0000AAAA
        xori	$t0, $t0, 0xFFFF
        
        li	$t1, 0x00005555
        bne	$t0, $t1, fail
        
        # test #54: lui
        li	$30, 54
        
        lui	$t0, 0xABCD
        
        li	$t1, 0xABCD0000
        bne	$t0, $t1, fail
        
        # test #55: lb, no offset
        li	$30, 55
        
        la	$t0, num0xABCDEFFF
        lb	$t1, 0($t0)
        
        li	$t2, 0xFFFFFFFF
        bne	$t1, $t2, fail
        
        # test #56: lb, positive offset
        li	$30, 56
        
        la	$t0, num0xABCDEFFF
        lb	$t1, 3($t0)
        
        li	$t2, 0xFFFFFFAB
        bne	$t1, $t2, fail
        
        # test #57: lb, negative offset
        li	$30, 57
        
        la	$t0, num0x12345678
        lb	$t1, -2($t0)
        
        li	$t2, 0xFFFFFFCD
        bne	$t1, $t2, fail
        
        # test #58: lh, no offset
        li	$30, 58
        
        la	$t0, num0xABCDEFFF
        lh	$t1, 0($t0)
        
        li	$t2, 0xFFFFEFFF
        bne	$t1, $t2, fail
        
        # test #59: lh, positive offset
        li	$30, 59
        
        la	$t0, num0xABCDEFFF
        lh	$t1, 2($t0)
        
        li	$t2, 0xFFFFABCD
        bne	$t1, $t2, fail
        
        # test #60: lh, negative offset
        li	$30, 60
        
        la	$t0, num0x12345678
        lh	$t1, -2($t0)
        
        li	$t2, 0xFFFFABCD
        bne	$t1, $t2, fail
        
        # test #61: lw, no offset
        li	$30, 61
        
        la	$t0, num0xABCDEFFF
        lw	$t1, 0($t0)
        
        li	$t2, 0xABCDEFFF
        bne	$t1, $t2, fail
        
        # test #62: lw, positive offset
        li	$30, 62
        
        la	$t0, num0xABCDEFFF
        lw	$t1, 4($t0)
        
        li	$t2, 0x12345678
        bne	$t1, $t2, fail
        
        # test #63: lw, negative offset
        li	$30, 63
        
        la	$t0, num0x12345678
        lw	$t1, -4($t0)
        
        li	$t2, 0xABCDEFFF
        bne	$t1, $t2, fail
        
        # test #64: lbu, normal
        li	$30, 64
        
        la	$t0, num0x12345678
        lbu	$t1, 0($t0)
        
        li	$t2, 0x78
        bne	$t1, $t2, fail
        
        # test #65: lbu, zero extension
        li	$30, 65
        
        la	$t0, num0xABCDEFFF
        lbu	$t1, 0($t0)
        
        li	$t2, 0xFF
        bne	$t1, $t2, fail
        
        # test #66: lhu, normal
        li	$30, 66
        
        la	$t0, num0x12345678
        lhu	$t1, 0($t0)
        
        li	$t2, 0x5678
        bne	$t1, $t2, fail
        
        # test #67: lhu, zero extension
        li	$30, 67
        
        la	$t0, num0xABCDEFFF
        lhu	$t1, 2($t0)
        
        li	$t2, 0xABCD
        bne	$t1, $t2, fail
        
        # test #68: sb, no offset
        li	$30, 68
        
        la	$t0, num0xABCDEFFF
        li	$t1, 0x55
        sb	$t1, 0($t0)
        
        lw	$t2, 0($t0)
        li	$t3, 0xABCDEF55
        bne	$t2, $t3, fail
        
        li	$t1, 0xFF	# restoration
        sb	$t1, 0($t0)
        
        # test #69: sb, positive offset
        li	$30, 69
        
        la	$t0, num0xABCDEFFF
        li	$t1, 0x55
        sb	$t1, 2($t0)
        
        lw	$t2, 0($t0)
        li	$t3, 0xAB55EFFF
        bne	$t2, $t3, fail
        
        li	$t1, 0xCD	# restoration
        sb	$t1, 2($t0)
        
        # test #69: sb, negative offset
        li	$30, 69
        
        la	$t0, num0x12345678
        li	$t1, 0x55
        sb	$t1, -1($t0)
        
        lw	$t2, -4($t0)
        li	$t3, 0x55CDEFFF
        bne	$t2, $t3, fail
        
        li	$t1, 0xAB	# restoration
        sb	$t1, -1($t0)
        
        # test #70: sh, no offset
        li	$30, 70
        
        la	$t0, num0xABCDEFFF
        li	$t1, 0x3355
        sh	$t1, 0($t0)
        
        lw	$t2, 0($t0)
        li	$t3, 0xABCD3355
        bne	$t2, $t3, fail
        
        li	$t1, 0xEFFF	# restoration
        sh	$t1, 0($t0)
        
        # test #71: sh, positive offset
        li	$30, 71
        
        la	$t0, num0xABCDEFFF
        li	$t1, 0x3355
        sh	$t1, 2($t0)
        
        lw	$t2, 0($t0)
        li	$t3, 0x3355EFFF
        bne	$t2, $t3, fail
        
        li	$t1, 0xABCD	# restoration
        sh	$t1, 2($t0)
        
        # test #72: sh, negative offset
        li	$30, 72
        
        la	$t0, num0x12345678
        li	$t1, 0x3355
        sh	$t1, -4($t0)
        
        lw	$t2, -4($t0)
        li	$t3, 0xABCD3355
        bne	$t2, $t3, fail
        
        li	$t1, 0xEFFF	# restoration
        sh	$t1, -4($t0)
        
        # test #73: sw, no offset
        li	$30, 73
        
        la	$t0, num0xABCDEFFF
        li	$t1, 0xFAFAFAFA
        sw	$t1, 0($t0)
        
        lw	$t2, 0($t0)
        li	$t3, 0xFAFAFAFA
        bne	$t2, $t3, fail
        
        li	$t1, 0xABCDEFFF	# restoration
        sw	$t1, 0($t0)
        
        # test #74: sw, positive offset
        li	$30, 74
        
        la	$t0, num0xABCDEFFF
        li	$t1, 0xEAAAEAAA
        sw	$t1, 4($t0)
        
        lw	$t2, 4($t0)
        li	$t3, 0xEAAAEAAA
        bne	$t2, $t3, fail
        
        li	$t1, 0x12345678	# restoration
        sw	$t1, 4($t0)
        
        # test #75: sw, negative offset
        li	$30, 75
        
        la	$t0, num0x12345678
        li	$t1, 0xDADADADA
        sw	$t1, -4($t0)
        
        lw	$t2, -4($t0)
        li	$t3, 0xDADADADA
        bne	$t2, $t3, fail
        
        li	$t1, 0xABCDEFFF	# restoration
        sw	$t1, -4($t0)

pass:
        la $a0, passstring
        li $v0, 4
        syscall
        b done

fail:
        ori $a0, $0, %lo(fail1string)
        ori $v0, $0, 4
        syscall

        ori  $a0, $30, 0
        ori  $v0, $0, 1
        syscall

        ori $a0, $0, %lo(fail2string)
        ori $v0, $0, 4
        syscall

done:
        ori $v0, $zero, 10
        syscall

.end _start

