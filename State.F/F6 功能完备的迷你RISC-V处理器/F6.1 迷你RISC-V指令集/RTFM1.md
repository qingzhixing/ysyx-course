### 1. PC寄存器的位宽是多少？

**答案**：PC 寄存器位宽为 32 位。

**原文**：

> Table 2 shows the unprivileged state for the base integer ISA. For RV32I, the 32 x registers are each 32 bits wide, i.e., XLEN=32.

> There is one additional unprivileged register: the program counter pc holds the address of the current instruction.

> — **Chapter 2.1, Page 21 (PDF 页码 21)**

虽然原文未直接写明 pc 的宽度，但上下文表明 pc 的宽度等于 XLEN（32 位），因为它是地址寄存器。

---

### 2. GPR共有多少个？每个GPR的位宽是多少？

**答案**：共有 32 个通用寄存器（x0–x31），每个位宽 32 位。

**原文**：

> Table 2 shows the unprivileged state for the base integer ISA. For RV32I, the 32 x registers are each 32 bits wide, i.e., XLEN=32.

> Register x0 is hardwired with all bits equal to 0. General purpose registers x1–x31 hold values…

> — **Chapter 2.1, Page 21 (PDF 页码 21)**

---

### 3. R[0]和sISA的R[0]有什么不同之处？

**答案**：在 RV32I 中，x0（即 R[0]）是硬连线为零的寄存器，任何写入均无效，读出的值始终为零。这与某些 ISA（如 x86 或 ARM）中通用寄存器可作为普通数据寄存器不同。

**原文**：

> Register x0 is hardwired with all bits equal to 0.

> — **Chapter 2.1, Page 21 (PDF 页码 21)**

---

### 4. 指令编码的位宽是多少？指令有多少种基本格式？

**答案**：指令编码固定为 32 位宽度；有 4 种基本格式（R、I、S、U），此外还有基于立即数处理的变体格式 B 和 J。

**原文**：

> In the base RV32I ISA, there are four core instruction formats (R/1/S/U), as shown in Base instruction formats. All are a fixed 32 bits in length.

> — **Chapter 2.2, Page 23 (PDF 页码 23)**

---

### 5. 在指令的基本格式中，需要多少位来表示一个GPR？为什么？

**答案**：需要 5 位。因为 RV32I 共有 32 个通用寄存器，2⁵ = 32，5 位二进制数足以唯一标识每个寄存器。

**原文**：

> The RISC‑V ISA keeps the source (rs1 and rs2) and destination (rd) registers at the same position in all formats to simplify decoding.

> — **Chapter 2.2, Page 23 (PDF 页码 23)**

该段描述了 rs1、rs2、rd 字段在指令格式中的位置，且这些字段均为 5 位宽。

---

### 6. add指令的格式具体是什么？

**答案**：add 指令使用 R 型格式，opcode 为 `0110011`，funct3 为 `000`，funct7 为 `0000000`。

**原文**：

> ADD performs the addition of rs1 and rs2.

> **RV32I Base Integer Instruction Set** 表格中明确给出：

> | funct7 | rs2 | rs1  | funct3 | rd | opcode |

> |----------|-----|------|----------|----|-----------|

> | 0000000 | rs2 | rs1 | 000 | rd | 0110011 |

> — **Chapter 2.4.2, Page 27 (PDF 页码 27)**

---

### 7. 还有一种基础指令集称为RV32E，它和RV32I有什么不同？

**答案**：RV32E 将通用寄存器数量从 32 个减少到 16 个（x0–x15），所有使用 x16–x31 的编码均被保留（reserved），不可使用。RV32E 旨在用于资源受限的嵌入式系统。

**原文**：

> RV32E and RV64E reduce the integer register count to 16 general- purpose registers, (x0–x15)…

> — **Chapter 3.1, Page 38 (PDF 页码 38)**

> All encodings specifying the other registers x16–x31 are reserved.

> — **Chapter 3.2, Page 38 (PDF 页码 38)**
>
