import 'dart:typed_data';

import 'package:femu/src/logger/logger.dart';

import '../core.dart';

/// 内存
class Memory with EmulatorMixin {
  /// 内存大小
  final int size;

  /// 内存
  ByteData _memory;

  Memory({
    required this.size,
  }) : _memory = ByteData(size);

  /// 重置内存
  void reset() {
    _memory = ByteData(size);
    logger.i('内存已重置: ${size}Byte');
  }

  /// 获取uint8类型数据
  int readU8(int address) {
    return _memory.getUint8(address);
  }

  /// 设置uint8类型数据
  void writeU8(int address, int value) {
    _memory.setUint8(address, value);
  }

  /// 获取int8类型数据
  int read8(int address) {
    return _memory.getInt8(address);
  }

  /// 设置int8类型数据
  void write8(int address, int value) {
    _memory.setInt8(address, value);
  }

  /// 获取uint16类型数据
  int readU16(int address) {
    return _memory.getUint16(address, Endian.little);
  }

  /// 设置uint16类型数据
  void writeU16(int address, int value) {
    _memory.setUint16(address, value, Endian.little);
  }

  /// 获取int16类型数据
  int read16(int address) {
    return _memory.getInt16(address, Endian.little);
  }

  /// 设置int16类型数据
  void write16(int address, int value) {
    _memory.setInt16(address, value, Endian.little);
  }
}
