import 'core.dart';

/// 模拟器
class Emulator {
  /// cpu实例
  final Cpu cpu;

  /// 内存实例
  final Memory memory;

  Emulator({
    required this.cpu,
    required this.memory,
  }) {
    memory._emulator = this;
    cpu._emulator = this;
  }
}

/// 模拟器实例混合
mixin EmulatorMixin {
  Emulator? _emulator;

  Emulator get emulator => _emulator!;
}
