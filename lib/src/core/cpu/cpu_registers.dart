import '../core.dart';

/// 寄存器
abstract class CpuRegisters {
  CpuRegisters();

  /// 重置寄存器
  void reset();
}
