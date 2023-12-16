import '../core/core.dart';
import 'riscv.dart';

/// RISC-V处理器
class RISCVCpu extends Cpu {
  RISCVCpu() : super(registers: RISCVCpuRegisters());
}
