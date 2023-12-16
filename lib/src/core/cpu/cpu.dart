import '../core.dart';

/// 处理器
abstract class Cpu with EmulatorMixin {
  final CpuRegisters registers;

  Cpu({required this.registers});
}
