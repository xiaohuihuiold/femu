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
    memory.readU32(pc);
  }

  @override
  void execute(RISCVCpuOpcode opcode) {}
}
