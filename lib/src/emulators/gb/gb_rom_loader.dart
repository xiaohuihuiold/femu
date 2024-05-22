import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:femu/src/constants.dart';
import 'package:femu/src/emulators/riscv/riscv_cpu_opcode.dart';
import 'package:femu/src/ext/bytes_ext.dart';
import 'package:flutter/services.dart';

import 'gb_rom.dart';

/// GB ROM加载器
class GBRomLoader {
  static const tag = 'GBRomLoader';

  final _builder = GBRomBuilder();

  final ByteData _byteData;

  GBRomLoader._create(this._byteData);

  static GBRom loadFromMemory(Uint8List bytes) {
    final byteData = bytes.buffer.asByteData();
    final loader = GBRomLoader._create(byteData);
    return loader.load();
  }

  static Future<GBRom> loadFromPath(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('文件不存在');
    }
    return loadFromMemory(await file.readAsBytes());
  }

  static Future<GBRom> loadFromAsset(
    String key, {
    AssetBundle? bundle,
  }) async {
    final byteData = await (bundle ?? rootBundle).load(key);
    return loadFromMemory(byteData.buffer.asUint8List());
  }

  GBRom load() {
    int offset = 0x100;
    offset = _loadHeader(offset);
    return _builder.build();
  }

  int _loadHeader(int offset) {
    _builder.entry = _byteData.getUint8List(offset, offset + 4);
    offset += 4;

    _builder.logo = _byteData.getUint8List(offset, offset + 48);
    offset += 48;

    _builder.title = _byteData.getString(offset, offset + 16);
    offset += 16;

    offset = _loadNewLicenseeCode(offset);

    _builder.sgbFlag = _byteData.getUint8(offset);
    offset += 1;

    offset = _loadCartridgeType(offset);

    _builder.romSize = Constants.byte32KiB * (1 << _byteData.getUint8(offset));
    offset += 1;

    _builder.ramSize = switch (_byteData.getUint8(offset)) {
      0x02 => Constants.byte8KiB,
      0x03 => Constants.byte32KiB,
      0x04 => Constants.byte128KiB,
      0x05 => Constants.byte64KiB,
      int() => 0,
    };
    offset += 1;

    _builder.destCode = _byteData.getUint8(offset);
    offset += 1;

    offset = _loadOldLicenseeCode(offset);

    _builder.maskRomVersion = _byteData.getUint8(offset);
    offset += 1;

    _builder.headerChecksum = _byteData.getUint8(offset);
    offset += 1;

    _builder.globalChecksum = _byteData.getUint16(offset);
    offset += 2;

    return offset;
  }

  int _loadOldLicenseeCode(int offset) {
    final code = _byteData.getUint8(offset);
    _builder.licCode = GBOldLicenseeCode.values.firstWhere(
        (e) => e.code == code,
        orElse: () => GBOldLicenseeCode.None);
    return offset + 1;
  }

  int _loadCartridgeType(int offset) {
    final code = _byteData.getUint8(offset);
    _builder.cartridgeType = GBCartridgeType.values.firstWhere(
        (e) => e.code == code,
        orElse: () => GBCartridgeType.RomOnly);
    return offset + 1;
  }

  int _loadNewLicenseeCode(int offset) {
    final code =
        String.fromCharCodes(_byteData.getUint8List(offset, offset + 2));
    _builder.newLicCode = GBNewLicenseeCode.values.firstWhere(
        (e) => e.code == code,
        orElse: () => GBNewLicenseeCode.None);
    return offset + 2;
  }
}
