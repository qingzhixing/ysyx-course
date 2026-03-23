
RISC-V 手册第 1.4 节第一段对存储器在 ISA 层面的规格做出了如下定义：

> A RISC‑V hart has a single byte‑addressable address space of \(2^{\mathrm{xLER}}\) bytes for all memory accesses. A word of memory is defined as 32 bits (4 bytes). Correspondingly, a halfword is 16 bits (2 bytes), a doubleword is 64 bits (8 bytes), and a quadword is 128 bits (16 bytes).
> — **Chapter 1.4, Page 15 (PDF 页码 15)**

### 关键约定

- **地址空间**：每个 hart 拥有一个统一的、按字节寻址的地址空间，大小为 \(2^{\text{XLEN}}\) 字节。
- **字（word）**：32 位（4 字节）。
- **半字（halfword）**：16 位（2 字节）。
- **双字（doubleword）**：64 位（8 字节）。
- **四字（quadword）**：128 位（16 字节）。

这些宽度定义是 ISA 层面的抽象，独立于底层电路实现。电路层次需要通过译码、数据通路和存储阵列等具体方式来实现这些宽度与寻址约束，从而满足 ISA 对存储器的规格要求。
