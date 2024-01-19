import 'package:flutter/foundation.dart';

import '../core.dart';

/// 处理器
abstract class Cpu<RegisterType extends CpuRegisters> with EmulatorMixin {
  final RegisterType registers;

  Cpu({required this.registers});

  /// 重置cpu
  @mustCallSuper
  void reset() {
    registers.reset();
  }
}
