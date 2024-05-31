import 'package:femu/src/core/core.dart';

/// GB内存操作
class GBMemory extends Memory {
  GBMemory() : super(size: 0x10000);

  @override
  int readU8(int address) {
    return super.readU8(address);
  }

  @override
  void writeU8(int address, int value) {
    super.writeU8(address, value);
  }
}
