import 'dart:typed_data';

import '../../ext/bytes_ext.dart';
import '../../logger/logger.dart';
import '../core.dart';

/// 内存
class Memory with EmulatorMixin {
  /// 内存大小
  final int size;

  /// 字节序
  final Endian endian;

  /// 内存
  ByteData _memory;

  Memory({
    required this.size,
    this.endian = Endian.little,
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
    return _memory.getUint16(address, endian);
  }

  /// 设置uint16类型数据
  void writeU16(int address, int value) {
    _memory.setUint16(address, value, endian);
  }

  /// 获取int16类型数据
  int read16(int address) {
    return _memory.getInt16(address, endian);
  }

  /// 设置int16类型数据
  void write16(int address, int value) {
    _memory.setInt16(address, value, endian);
  }

  /// 获取uint32类型数据
  int readU32(int address) {
    return _memory.getUint32(address, endian);
  }

  /// 设置uint32类型数据
  void writeU32(int address, int value) {
    _memory.setUint32(address, value, endian);
  }

  /// 获取int32类型数据
  int read32(int address) {
    return _memory.getInt32(address, endian);
  }

  /// 设置int32类型数据
  void write32(int address, int value) {
    _memory.setInt32(address, value, endian);
  }

  /// 获取uint64类型数据
  int readU64(int address) {
    return _memory.getUint64(address, endian);
  }

  /// 设置uint64类型数据
  void writeU64(int address, int value) {
    _memory.setUint64(address, value, endian);
  }

  /// 获取int64类型数据
  int read64(int address) {
    return _memory.getInt64(address, endian);
  }

  /// 设置int64类型数据
  void write64(int address, int value) {
    _memory.setInt64(address, value, endian);
  }

  /// 获取float32类型数据
  double readF32(int address) {
    return _memory.getFloat32(address, endian);
  }

  /// 设置float32类型数据
  void writeF32(int address, double value) {
    _memory.setFloat32(address, value, endian);
  }

  /// 获取float64类型数据
  double readF64(int address) {
    return _memory.getFloat64(address, endian);
  }

  /// 设置float64类型数据
  void writeF64(int address, double value) {
    _memory.setFloat64(address, value, endian);
  }

  /// 获取多段数据
  Uint8List readAll(int address, int length) {
    return _memory.getUint8List(address, address + length);
  }

  /// 写入多段数据
  void writeAll(int address, List<int> bytes, {int start = 0, int? end}) {
    _memory.setUint8List(address, bytes, start: start, end: end);
  }
}
