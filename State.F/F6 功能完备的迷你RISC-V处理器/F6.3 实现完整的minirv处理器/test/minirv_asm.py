import sys
import re

# 通用立即数匹配模式：十进制、十六进制（0x...）、二进制（0b...），可选负号
IMM_PAT = r"(-?0x[0-9a-f]+|-?0b[01]+|-?\d+)"

# 寄存器映射
reg_map = {
    "zero": 0,
    "x0": 0,
    "ra": 1,
    "x1": 1,
    "sp": 2,
    "x2": 2,
    "gp": 3,
    "x3": 3,
    "tp": 4,
    "x4": 4,
    "t0": 5,
    "x5": 5,
    "t1": 6,
    "x6": 6,
    "t2": 7,
    "x7": 7,
    "s0": 8,
    "fp": 8,
    "x8": 8,
    "s1": 9,
    "x9": 9,
    "a0": 10,
    "x10": 10,
    "a1": 11,
    "x11": 11,
    "a2": 12,
    "x12": 12,
    "a3": 13,
    "x13": 13,
    "a4": 14,
    "x14": 14,
    "a5": 15,
    "x15": 15,
}


def parse_reg(s):
    s = s.strip().lower()
    if s in reg_map:
        return reg_map[s]
    raise ValueError(f"非法寄存器: {s}")


def parse_imm(s):
    s = s.strip().lower()
    if s.startswith("0x"):
        return int(s, 16)
    if s.startswith("0b"):
        return int(s, 2)
    return int(s)


def assemble_line(line, pc):
    # 去除注释
    line = line.split("#")[0].strip()
    if not line:
        return None, 4
    if line.endswith(":"):
        return None, 4

    parts = re.split(r"[ ,]+", line)
    op = parts[0].lower()

    # add rd, rs1, rs2
    if op == "add":
        rd = parse_reg(parts[1])
        rs1 = parse_reg(parts[2])
        rs2 = parse_reg(parts[3])
        code = (
            (0b0000000 << 25)
            | (rs2 << 20)
            | (rs1 << 15)
            | (0b000 << 12)
            | (rd << 7)
            | 0b0110011
        )
        return code, 4

    # addi rd, rs1, imm
    if op == "addi":
        rd = parse_reg(parts[1])
        rs1 = parse_reg(parts[2])
        imm = parse_imm(parts[3])
        imm12 = imm & 0xFFF
        code = (imm12 << 20) | (rs1 << 15) | (0b000 << 12) | (rd << 7) | 0b0010011
        return code, 4

    # lui rd, imm
    if op == "lui":
        rd = parse_reg(parts[1])
        imm = parse_imm(parts[2])
        imm20 = (imm >> 12) & 0xFFFFF
        code = (imm20 << 12) | (rd << 7) | 0b0110111
        return code, 4

    # lw rd, imm(rs1)
    if op == "lw":
        rd = parse_reg(parts[1])
        match = re.match(IMM_PAT + r"\((\w+)\)$", parts[2].strip(), re.IGNORECASE)
        if not match:
            raise ValueError(f"非法寻址模式: {parts[2]}")
        imm = parse_imm(match.group(1))
        rs1 = parse_reg(match.group(2))
        imm12 = imm & 0xFFF
        code = (imm12 << 20) | (rs1 << 15) | (0b010 << 12) | (rd << 7) | 0b0000011
        return code, 4

    # lbu rd, imm(rs1)
    if op == "lbu":
        rd = parse_reg(parts[1])
        match = re.match(IMM_PAT + r"\((\w+)\)$", parts[2].strip(), re.IGNORECASE)
        if not match:
            raise ValueError(f"非法寻址模式: {parts[2]}")
        imm = parse_imm(match.group(1))
        rs1 = parse_reg(match.group(2))
        imm12 = imm & 0xFFF
        code = (imm12 << 20) | (rs1 << 15) | (0b100 << 12) | (rd << 7) | 0b0000011
        return code, 4

    # sw rs2, imm(rs1)
    if op == "sw":
        rs2 = parse_reg(parts[1])
        match = re.match(IMM_PAT + r"\((\w+)\)$", parts[2].strip(), re.IGNORECASE)
        if not match:
            raise ValueError(f"非法寻址模式: {parts[2]}")
        imm = parse_imm(match.group(1))
        rs1 = parse_reg(match.group(2))
        imm12 = imm & 0xFFF
        imm11_5 = (imm12 >> 5) & 0x7F
        imm4_0 = imm12 & 0x1F
        code = (
            (imm11_5 << 25)
            | (rs2 << 20)
            | (rs1 << 15)
            | (0b010 << 12)
            | (imm4_0 << 7)
            | 0b0100011
        )
        return code, 4

    # sb rs2, imm(rs1)
    if op == "sb":
        rs2 = parse_reg(parts[1])
        match = re.match(IMM_PAT + r"\((\w+)\)$", parts[2].strip(), re.IGNORECASE)
        if not match:
            raise ValueError(f"非法寻址模式: {parts[2]}")
        imm = parse_imm(match.group(1))
        rs1 = parse_reg(match.group(2))
        imm12 = imm & 0xFFF
        imm11_5 = (imm12 >> 5) & 0x7F
        imm4_0 = imm12 & 0x1F
        code = (
            (imm11_5 << 25)
            | (rs2 << 20)
            | (rs1 << 15)
            | (0b000 << 12)
            | (imm4_0 << 7)
            | 0b0100011
        )
        return code, 4

    # jalr rd, imm(rs1)
    if op == "jalr":
        rd = parse_reg(parts[1])
        match = re.match(IMM_PAT + r"\((\w+)\)$", parts[2].strip(), re.IGNORECASE)
        if not match:
            raise ValueError(f"非法寻址模式: {parts[2]}")
        imm = parse_imm(match.group(1))
        rs1 = parse_reg(match.group(2))
        imm12 = imm & 0xFFF
        code = (imm12 << 20) | (rs1 << 15) | (0b000 << 12) | (rd << 7) | 0b1100111
        return code, 4

    raise ValueError(f"未知指令: {op}")


def assemble_file(input_file, output_file):
    with open(input_file, "r") as f:
        lines = f.readlines()

    # 第一遍：收集标签地址（仅记录，不自动替换）
    labels = {}
    pc = 0
    for line in lines:
        line = line.split("#")[0].strip()
        if not line:
            continue
        if line.endswith(":"):
            label = line[:-1].strip()
            if label in labels:
                raise ValueError(f"重复标签: {label}")
            labels[label] = pc
            continue
        pc += 4

    # 第二遍：生成机器码
    pc = 0
    codes = []
    for line in lines:
        line = line.split("#")[0].strip()
        if not line or line.endswith(":"):
            continue
        code, size = assemble_line(line, pc)
        if code is not None:
            codes.append(code)
        pc += size

    with open(output_file, "w") as f:
        f.write("v2.0 raw\n")
        for code in codes:
            f.write(f"{code:08X}\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("用法: python minirv_asm.py input.asm output.hex")
        sys.exit(1)
    assemble_file(sys.argv[1], sys.argv[2])
