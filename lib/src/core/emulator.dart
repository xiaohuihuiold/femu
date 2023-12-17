import 'package:flutter/foundation.dart';

import '../logger/logger.dart';

import 'core.dart';

/// 模拟器状态
enum EmulatorState {
  idle,
  running,
  paused,
  stopped,
}

/// 模拟器
class Emulator {
  /// cpu实例
  final Cpu cpu;

  /// 内存实例
  final Memory memory;

  /// 模拟器状态
  final _stateValue = ValueNotifier<EmulatorState>(EmulatorState.idle);

  ValueListenable<EmulatorState> get state => _stateValue;

  /// CPU循环是否开启中
  bool _cpuRunning = false;

  Emulator({
    required this.cpu,
    required this.memory,
  }) {
    memory._emulator = this;
    cpu._emulator = this;
    reset();
  }

  /// 运行模拟器
  void run() {
    if (state.value != EmulatorState.idle) {
      logger.w('模拟器正在运行中');
      return;
    }
    reset();
    _stateValue.value = EmulatorState.running;
    logger.i('模拟器开始运行...');
    _startCPULoop();
  }

  /// 恢复
  void resume() {
    if (state.value != EmulatorState.paused) {
      logger.w('模拟器不在暂停中');
      return;
    }
    _stateValue.value = EmulatorState.running;
    logger.i('模拟器已恢复');
    _startCPULoop();
  }

  /// 暂停
  void pause() {
    if (state.value != EmulatorState.running) {
      logger.w('模拟器不在运行中');
      return;
    }
    _stateValue.value = EmulatorState.paused;
    logger.i('模拟器已暂停');
  }

  /// 停止
  void stop() {
    _stateValue.value = EmulatorState.stopped;
    logger.i('模拟器已停止');
  }

  void reset() {
    cpu.reset();
    memory.reset();
    logger.i('模拟器已重置');
  }

  /// 开始CPU循环
  Future<void> _startCPULoop() async {
    if (_cpuRunning) {
      return;
    }
    _cpuRunning = true;
    try {
      while (state.value == EmulatorState.running) {
        await Future.value();
      }
    } catch (e) {
      logger.e('指令执行出错', error: e);
      stop();
    }
    _cpuRunning = false;
  }
}

/// 模拟器实例混合
mixin EmulatorMixin {
  Emulator? _emulator;

  Emulator get emulator => _emulator!;
}
