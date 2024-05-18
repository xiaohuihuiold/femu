import 'package:femu/riscv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'RISC-V test',
    () async {
      final emulator = Emulator(
        cpu: RISCVCpu(),
        // 128MiB
        memory: Memory(size: 128 * 1024 * 1024),
      );
      await emulator.load(0, './demos/riscv/add-addi.bin');
      await Future.delayed(const Duration(milliseconds: 400));
      emulator.run();
    },
    timeout: const Timeout(Duration(days: 1)),
  );
}
