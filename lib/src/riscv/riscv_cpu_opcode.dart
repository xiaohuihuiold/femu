import '../core/core.dart';

/// RISC-V指令码
class RISCVCpuOpcode extends CpuOpcode {}

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
  _0('0', RISCVInstructSetFormat.r, -1, 0, 0);

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
