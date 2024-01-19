import 'package:femu/src/logger/logger.dart';

import '../core/core.dart';
import 'riscv.dart';

/// RISC-V处理器
class RISCVCpu extends Cpu<RISCVCpuRegisters> {
  RISCVCpu() : super(registers: RISCVCpuRegisters());

  @override
  void reset() {
    super.reset();
    registers.pc.write(emulator.resetAddress.value);
    logger.i('RISC-V CPU已重置');
  }
}
