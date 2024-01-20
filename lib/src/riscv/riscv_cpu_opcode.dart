import 'package:collection/collection.dart';

import '../core/core.dart';

/// OPCode工具
class RISCVCpuOpcodes {
  /// 指令映射
  static final _mapping = _generateMapping();

  static List<dynamic> _generateMapping() {
    final list = List<dynamic>.filled(0x7f + 1, null);
    final instructSet = RISCVInstructSet.values
        .whereNot((element) => element.name == '_')
        .toList();
    for (final instruct in instructSet) {
      final opcode = instruct.opcode;
      final func3 = instruct.func3;
      final func7 = instruct.func7;
      if (func3 < 0) {
        // 由opcode直接确定指令码
        list[opcode] = instruct;
      } else {
        if (list[opcode] == null) {
          list[opcode] = List<dynamic>.filled(0x07 + 1, null);
        }
        final sub = list[opcode];
        if (func7 < 0) {
          // 由opcode+func3确定指令码
          sub[func3] = instruct;
        } else {
          // 由opcode+func3+func7确定指令码
          if (sub[func3] == null) {
            sub[func3] = <int, dynamic>{};
          }
          final sub1 = sub[func3];
          sub1[func7] = instruct;
        }
      }
    }
    return list;
  }

  /// 获取指令
  static RISCVInstructSet? getOp(int code) {
    final opcode = code & 0x7f;
    final func3 = (code >> 12) & 0x07;
    final func7 = (code >> 25) & 0x7f;
    final value = _mapping[opcode];
    if (value is RISCVInstructSet) {
      return value;
    } else if (value is List) {
      if (func3 < 0) {
        return null;
      }
      final sub = value[func3];
      if (sub is RISCVInstructSet) {
        return sub;
      } else if (sub is Map) {
        if (func7 < 0) {
          return null;
        }
        final sub1 = sub[func7];
        if (sub1 is RISCVInstructSet) {
          return sub1;
        }
      }
    }
    return null;
  }
}

/// 空的访问对象
class NullReaderWriter implements ReaderWriter<int> {
  const NullReaderWriter();

  @override
  int read() {
    throw Exception('NullReader');
  }

  @override
  void write(int value) {
    throw Exception('NullWriter');
  }
}

/// RISC-V指令码
class RISCVCpuOpcode extends CpuOpcode {
  final RISCVInstructSet op;
  final Writer<int> rd;
  final Reader<int> rs1;
  final Reader<int> rs2;

  const RISCVCpuOpcode({
    required this.op,
    this.rd = const NullReaderWriter(),
    this.rs1 = const NullReaderWriter(),
    this.rs2 = const NullReaderWriter(),
  });
}

/// 指令类型
enum RISCVInstructSetFormat {
  r('R'),
  i('I'),
  s('S'),
  b('B'),
  u('U'),
  j('J');

  final String format;

  const RISCVInstructSetFormat(this.format);
}

/// 指令集
enum RISCVInstructSet {
  // RV32I
  add('add', RISCVInstructSetFormat.r, 0x33, 0x00, 0x00),
  sub('sub', RISCVInstructSetFormat.r, 0x33, 0x00, 0x20),
  xor('xor', RISCVInstructSetFormat.r, 0x33, 0x4, 0x00),
  or('or', RISCVInstructSetFormat.r, 0x33, 0x06, 0x00),
  and('and', RISCVInstructSetFormat.r, 0x33, 0x07, 0x00),
  sll('sll', RISCVInstructSetFormat.r, 0x33, 0x01, 0x00),
  srl('srl', RISCVInstructSetFormat.r, 0x33, 0x05, 0x00),
  sra('sra', RISCVInstructSetFormat.r, 0x33, 0x05, 0x20),
  slt('slt', RISCVInstructSetFormat.r, 0x33, 0x02, 0x00),
  sltu('sltu', RISCVInstructSetFormat.r, 0x33, 0x03, 0x00),
  // --------
  addi('addi', RISCVInstructSetFormat.i, 0x13, 0x00, -1),
  xori('xori', RISCVInstructSetFormat.i, 0x13, 0x04, -1),
  ori('ori', RISCVInstructSetFormat.i, 0x13, 0x06, -1),
  andi('andi', RISCVInstructSetFormat.i, 0x13, 0x07, -1),
  slli('slli', RISCVInstructSetFormat.i, 0x13, 0x01, 0x00),
  srli('srli', RISCVInstructSetFormat.i, 0x13, 0x05, 0x00),
  srai('srai', RISCVInstructSetFormat.i, 0x13, 0x05, 0x20),
  slti('slti', RISCVInstructSetFormat.i, 0x13, 0x02, -1),
  sltiu('sltiu', RISCVInstructSetFormat.i, 0x13, 0x03, -1),
  // --------
  lb('lb', RISCVInstructSetFormat.i, 0x03, 0x00, -1),
  lh('lh', RISCVInstructSetFormat.i, 0x03, 0x01, -1),
  lw('lw', RISCVInstructSetFormat.i, 0x03, 0x02, -1),
  lbu('lbu', RISCVInstructSetFormat.i, 0x03, 0x04, -1),
  lhu('lhu', RISCVInstructSetFormat.i, 0x03, 0x05, -1),
  // --------
  sb('sb', RISCVInstructSetFormat.s, 0x23, 0x00, -1),
  sh('sh', RISCVInstructSetFormat.s, 0x23, 0x01, -1),
  sw('sw', RISCVInstructSetFormat.s, 0x23, 0x02, -1),
  // --------
  beq('beq', RISCVInstructSetFormat.b, 0x63, 0x00, -1),
  bne('bne', RISCVInstructSetFormat.b, 0x63, 0x01, -1),
  blt('blt', RISCVInstructSetFormat.b, 0x63, 0x04, -1),
  bge('bge', RISCVInstructSetFormat.b, 0x63, 0x05, -1),
  bltu('bltu', RISCVInstructSetFormat.b, 0x63, 0x06, -1),
  bgeu('bgeu', RISCVInstructSetFormat.b, 0x63, 0x07, -1),
  // --------
  jal('jal', RISCVInstructSetFormat.j, 0x6f, -1, -1),
  jalr('jalr', RISCVInstructSetFormat.i, 0x67, 0x00, -1),
  // --------
  lui('lui', RISCVInstructSetFormat.u, 0x37, -1, -1),
  auipc('auipc', RISCVInstructSetFormat.u, 0x17, -1, -1),
  // --------
  ecall('ecall', RISCVInstructSetFormat.i, 0x73, 0x00, 0x00),
  // --------
  ebreak('ebreak', RISCVInstructSetFormat.i, 0x73, 0x00, 0x01),
  _0('_', RISCVInstructSetFormat.r, -1, 0, 0);

  final String name;
  final RISCVInstructSetFormat format;
  final int opcode;
  final int func3;
  final int func7;

  const RISCVInstructSet(
    this.name,
    this.format,
    this.opcode,
    this.func3,
    this.func7,
  );
}
