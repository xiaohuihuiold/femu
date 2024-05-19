import 'package:femu/src/ext/int_ext.dart';

part 'gb_rom_enums.dart';

class GBRom {
  /// 4Byte
  /// 0x0100-0x0103
  /// Entry point入口
  final List<int> entry;

  /// 48Byte
  /// 0x0104-0x0133
  /// logo 校验完整性
  final List<int> logo;

  /// 16Byte
  /// 0x0134-0x0143
  /// 标题
  final String title;

  /// 2Byte
  /// 0x0144-0x0145
  /// 双字节的公司代码
  final GBNewLicenseeCode newLicCode;

  /// 1Byte
  /// 0x0146
  /// SGB SuperGameBoy
  final int sgbFlag;

  /// 1Byte
  /// 0x0147
  /// 卡带类型
  /// 0x00 ROM ONLY
  final GBCartridgeType cartridgeType;

  /// 1Byte
  /// 0x0148
  /// ROM大小 32KB << [romSize]
  final int romSize;

  /// 1Byte
  /// 0x0149
  /// RAM大小
  /// 0x00 无
  /// 0x01 2KiB
  /// 0x02 8KiB
  /// 0x03 32KiB
  /// 0x04 128KiB
  /// 0x05 64KiB
  final int ramSize;

  /// 1Byte
  /// 0x014A
  /// 区域代码
  /// 0x00 日本
  /// 0x01 海外
  final int destCode;

  /// 1Byte
  /// 0x014B
  /// 公司代码,两个为0x33则使用[newLicCode]
  final GBOldLicenseeCode licCode;

  /// 1Byte
  /// 0x014C
  /// 版本号
  final int maskRomVersion;

  /// 1Byte
  /// 0x014D
  /// 校验和,0x0134-0x014C的校验和
  final int headerChecksum;

  /// 2Byte
  /// 0x014E-0x014F
  /// 全局校验和
  final int globalChecksum;

  GBRom._create({
    required this.entry,
    required this.logo,
    required this.title,
    required this.newLicCode,
    required this.sgbFlag,
    required this.cartridgeType,
    required this.romSize,
    required this.ramSize,
    required this.destCode,
    required this.licCode,
    required this.maskRomVersion,
    required this.headerChecksum,
    required this.globalChecksum,
  });

  @override
  String toString() {
    return 'GBRom {\n'
        '\tEntry: ${entry.length}\n'
        '\tLogo: ${logo.length}\n'
        '\tTitle: $title\n'
        '\tNew Licensee Code: ${newLicCode.name}\n'
        '\tSGB Flag: ${sgbFlag.toHexString(1)}\n'
        '\tCartridge Type: ${cartridgeType.name}\n'
        '\tROM Size: $romSize\n'
        '\tRAMSize: $ramSize\n'
        '\tDestination Code: ${destCode.toHexString(1)}\n'
        '\tOld licensee Code: ${licCode.name}\n'
        '\tMask ROM Version: ${maskRomVersion.toHexString(1)}\n'
        '\tHeader Checksum: ${headerChecksum.toHexString(1)}\n'
        '\tGlobal Checksum: ${globalChecksum.toHexString(2)}\n'
        '}';
  }
}
