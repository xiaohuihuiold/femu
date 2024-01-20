import 'package:flutter/foundation.dart';

import '../core.dart';

/// 处理器
abstract class Cpu<RegisterType extends CpuRegisters,
    OpcodeType extends CpuOpcode> with EmulatorMixin {
  final RegisterType registers;

  Cpu({required this.registers});

  /// 重置cpu
  @mustCallSuper
  void reset() {
    registers.reset();
  }

  /// 解码指令
  OpcodeType decode();

  /// 执行指令
  void execute(OpcodeType opcode);
}
