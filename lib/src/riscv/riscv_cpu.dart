import 'package:femu/src/ext/int_ext.dart';
import 'package:femu/src/logger/logger.dart';

import '../core/core.dart';
import 'riscv.dart';

/// RISC-V处理器
class RISCVCpu extends Cpu<RISCVCpuRegisters, RISCVCpuOpcode> {
  Memory get memory => emulator.memory;

  RISCVCpu() : super(registers: RISCVCpuRegisters());

  @override
  void reset() {
    super.reset();
    registers.pc.write(emulator.resetAddress.value);
    registers.sp.write(emulator.memory.size - 1);
    logger.i('RISC-V CPU已重置');
  }

  @override
  RISCVCpuOpcode decode() {
    final pc = registers.pc.read();
    final code = memory.readU32(pc);
    final op = RISCVCpuOpcodes.getOp(code);
    if (op == null) {
      throw Exception('错误的指令: ${code.toHexString()}');
    }
    final format = op.format;
    Writer<int> rd = const NullReaderWriter();
    Reader<int> rs1 = const NullReaderWriter();
    Reader<int> rs2 = const NullReaderWriter();
    switch (format) {
      case RISCVInstructSetFormat.r:
        rd = registers.registers[(code >> 7) & 0x1f];
        rs1 = registers.registers[(code >> 15) & 0x1f];
        rs2 = registers.registers[(code >> 20) & 0x1f];
        break;
      case RISCVInstructSetFormat.i:
        rd = registers.registers[(code >> 7) & 0x1f];
        rs1 = registers.registers[(code >> 15) & 0x1f];
        break;
      case RISCVInstructSetFormat.s:
        rs1 = registers.registers[(code >> 15) & 0x1f];
        rs2 = registers.registers[(code >> 20) & 0x1f];
        break;
      case RISCVInstructSetFormat.b:
        rs1 = registers.registers[(code >> 15) & 0x1f];
        rs2 = registers.registers[(code >> 20) & 0x1f];
        break;
      case RISCVInstructSetFormat.u:
        rd = registers.registers[(code >> 7) & 0x1f];
        break;
      case RISCVInstructSetFormat.j:
        rd = registers.registers[(code >> 7) & 0x1f];
        break;
    }
    return RISCVCpuOpcode(op: op, rd: rd, rs1: rs1, rs2: rs2);
  }

  @override
  void execute(RISCVCpuOpcode opcode) {
    logger.v(opcode.op.name);
    registers.pc.write(registers.pc.read() + 4);
  }
}
