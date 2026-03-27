.text
	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.file	"a.c"
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	# 函数序言：分配栈空间，保存返回地址和帧指针
	addi	sp, sp, -48
	.cfi_def_cfa_offset 48
	sd	ra, 40(sp)                      # 8-byte Folded Spill
	sd	s0, 32(sp)                      # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	addi	s0, sp, 48
	.cfi_def_cfa s0, 0

	# 对应 return 0; 的提前准备，将返回值0存入栈中
	li	a0, 0
	sd	a0, -40(s0)                     # 8-byte Folded Spill
	sw	a0, -20(s0)                     # 未使用的冗余存储

	# int x = 10; (volatile)
	li	a0, 10
	sw	a0, -24(s0)

	# int y = 20; (volatile)
	li	a0, 20
	sw	a0, -28(s0)

	# int z = x + y;
	lw	a0, -24(s0)      # 加载 x
	lw	a1, -28(s0)      # 加载 y
	addw	a0, a0, a1       # 相加
	sw	a0, -32(s0)      # 存储结果到 z

	# printf("z = %d\n", z);
	lw	a1, -32(s0)      # 第二个参数: z
.Lpcrel_hi0:
	auipc	a0, %pcrel_hi(.L.str)           # 第一个参数: 格式字符串地址
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi0)
	call	printf

	# return 0;
	ld	a0, -40(s0)                     # 8-byte Folded Reload (加载返回值0)
	ld	ra, 40(sp)                      # 8-byte Folded Reload
	ld	s0, 32(sp)                      # 8-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"z = %d\n"
	.size	.L.str, 8

	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf