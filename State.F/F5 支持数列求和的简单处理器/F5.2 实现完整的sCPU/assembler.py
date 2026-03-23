#!/usr/bin/env python3
import sys
import re
import os

reg_map = {"r0": "00", "r1": "01", "r2": "10", "r3": "11"}


def encode_li(rd, imm):
    imm_val = int(imm)
    if not 0 <= imm_val <= 15:
        raise ValueError(f"立即数 {imm_val} 超出范围 0-15")
    return "10" + reg_map[rd] + f"{imm_val:04b}"


def encode_add(rd, rs1, rs2):
    return "00" + reg_map[rd] + reg_map[rs1] + reg_map[rs2]


def encode_bner0(rs2, addr):
    addr_val = int(addr)
    if not 0 <= addr_val <= 15:
        raise ValueError(f"地址 {addr_val} 超出范围 0-15")
    return "11" + f"{addr_val:04b}" + reg_map[rs2]


def assemble_line(line):
    line = line.split("#")[0].strip()
    if not line:
        return None
    if ":" in line:
        _, line = line.split(":", 1)
        line = line.strip()
    parts = re.split(r"[ ,]+", line)
    if not parts:
        return None
    op = parts[0].lower()
    if op == "li":
        if len(parts) != 3:
            raise SyntaxError("li 需要 2 个操作数")
        return encode_li(parts[1], parts[2])
    elif op == "add":
        if len(parts) != 4:
            raise SyntaxError("add 需要 3 个操作数")
        return encode_add(parts[1], parts[2], parts[3])
    elif op == "bner0":
        if len(parts) != 3:
            raise SyntaxError("bner0 需要 2 个操作数")
        return encode_bner0(parts[1], parts[2])
    else:
        raise SyntaxError(f"未知指令: {op}")


def to_hex(bin_str):
    return f"{int(bin_str, 2):02x}"


def to_raw_format(hex_vals, line_width=16):
    """生成 raw 格式文本行列表，支持游程编码"""
    encoded = []
    i = 0
    n = len(hex_vals)
    while i < n:
        j = i
        while j < n and hex_vals[j] == hex_vals[i]:
            j += 1
        cnt = j - i
        if cnt >= 4:
            encoded.append(f"{hex_vals[i]}*{cnt}")
        else:
            encoded.extend([hex_vals[i]] * cnt)
        i = j
    lines = []
    for k in range(0, len(encoded), line_width):
        lines.append(" ".join(encoded[k : k + line_width]))
    return lines


def main():
    # 简单参数解析：支持 -o output.hex 或直接指定输出文件
    infile = None
    outfile = None
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == "-o":
            if i + 1 < len(args):
                outfile = args[i + 1]
                i += 2
            else:
                print("错误：-o 选项需要指定输出文件", file=sys.stderr)
                sys.exit(1)
        else:
            if infile is None:
                infile = args[i]
            else:
                # 如果已有输入文件，则多余参数视为输出文件（兼容旧用法）
                if outfile is None:
                    outfile = args[i]
                else:
                    print(f"警告：忽略多余参数 '{args[i]}'", file=sys.stderr)
            i += 1

    if not infile:
        print("用法: python asm.py input.asm [-o output.hex]", file=sys.stderr)
        sys.exit(1)

    # 读取输入
    try:
        with open(infile, "r") as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"错误：输入文件 '{infile}' 不存在。", file=sys.stderr)
        sys.exit(1)

    # 汇编
    bin_lines = []
    for idx, line in enumerate(lines):
        try:
            b = assemble_line(line)
            if b:
                bin_lines.append(b)
        except Exception as e:
            print(f"错误 (行 {idx + 1}): {e}", file=sys.stderr)

    # 转换为十六进制
    hex_vals = [to_hex(b) for b in bin_lines]

    # 生成 raw 格式文本
    raw_lines = ["v2.0 raw"] + to_raw_format(hex_vals)

    # 确定输出文件
    if not outfile:
        base = os.path.splitext(infile)[0]
        outfile = base + ".hex"

    # 写入输出
    try:
        with open(outfile, "w") as f:
            f.write("\n".join(raw_lines) + "\n")
    except IOError as e:
        print(f"错误：无法写入输出文件 '{outfile}': {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
