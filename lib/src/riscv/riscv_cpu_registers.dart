import 'package:femu/src/logger/logger.dart';

import '../core/core.dart';

/// RISC-V寄存器
class RISCVCpuRegisters extends CpuRegisters {
  final pc = 0.rw;
  final zero = 0.rw;
  final ra = 0.rw;
  final sp = 0.rw;
  final gp = 0.rw;
  final tp = 0.rw;
  final t0 = 0.rw;
  final t1 = 0.rw;
  final t2 = 0.rw;
  final s0 = 0.rw;
  final s1 = 0.rw;
  final a0 = 0.rw;
  final a1 = 0.rw;
  final a2 = 0.rw;
  final a3 = 0.rw;
  final a4 = 0.rw;
  final a5 = 0.rw;
  final a6 = 0.rw;
  final a7 = 0.rw;
  final s2 = 0.rw;
  final s3 = 0.rw;
  final s4 = 0.rw;
  final s5 = 0.rw;
  final s6 = 0.rw;
  final s7 = 0.rw;
  final s8 = 0.rw;
  final s9 = 0.rw;
  final s10 = 0.rw;
  final s11 = 0.rw;
  final t3 = 0.rw;
  final t4 = 0.rw;
  final t5 = 0.rw;
  final t6 = 0.rw;

  // x0-x31
  late final registers = [
    zero,
    ra,
    sp,
    gp,
    tp,
    t0,
    t1,
    t2,
    s0,
    s1,
    a0,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    a7,
    s2,
    s3,
    s4,
    s5,
    s6,
    s7,
    s8,
    s9,
    s10,
    s11,
    t3,
    t4,
    t5,
    t6,
  ];

  @override
  void reset() {
    registers.forEach(_writeZero);
    logger.i('RISC-V寄存器已重置');
  }

  void _writeZero(RWValue<int> rw) {
    rw.write(0);
  }
}
