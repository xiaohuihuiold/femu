import 'package:femu/src/ext/int_ext.dart';
import 'package:femu/src/logger/logger.dart';

import '../core/core.dart';
import 'riscv.dart';

/// 执行指令
typedef RISCVOpcodeExecutor = void Function(RISCVCpuOpcode opcode);

RISCVOpcodeExecutor _defaultExecutor = (RISCVCpuOpcode opcode) {
  throw Exception('未实现');
};

/// RISC-V处理器
class RISCVCpu extends Cpu<RISCVCpuRegisters, RISCVCpuOpcode> {
  late final _executors = _generateExecutor();

  Memory get memory => emulator.memory;

  RISCVCpu() : super(registers: RISCVCpuRegisters());

  @override
  void reset() {
    super.reset();
    registers.pc.write(emulator.resetAddress.value);
    registers.sp.write(emulator.memory.size - 1);
    logger.i('RISC-V CPU已重置');
  }

  @override
  RISCVCpuOpcode decode() {
    final pc = registers.pc.read();
    final code = memory.readU32(pc);
    final op = RISCVCpuOpcodes.getOp(code);
    if (op == null) {
      throw Exception('错误的指令: ${code.toHexString()}');
    }
    final format = op.format;
    Writer<int> rd = const NullReaderWriter();
    Reader<int> rs1 = const NullReaderWriter();
    Reader<int> rs2 = const NullReaderWriter();
    switch (format) {
      case RISCVInstructSetFormat.r:
        rd = registers.registers[(code >> 7) & 0x1f];
        rs1 = registers.registers[(code >> 15) & 0x1f];
        rs2 = registers.registers[(code >> 20) & 0x1f];
        break;
      case RISCVInstructSetFormat.i:
        rd = registers.registers[(code >> 7) & 0x1f];
        rs1 = registers.registers[(code >> 15) & 0x1f];
        break;
      case RISCVInstructSetFormat.s:
        rs1 = registers.registers[(code >> 15) & 0x1f];
        rs2 = registers.registers[(code >> 20) & 0x1f];
        break;
      case RISCVInstructSetFormat.b:
        rs1 = registers.registers[(code >> 15) & 0x1f];
        rs2 = registers.registers[(code >> 20) & 0x1f];
        break;
      case RISCVInstructSetFormat.u:
        rd = registers.registers[(code >> 7) & 0x1f];
        break;
      case RISCVInstructSetFormat.j:
        rd = registers.registers[(code >> 7) & 0x1f];
        break;
    }
    return RISCVCpuOpcode(
      code: code,
      op: op,
      rd: rd,
      rs1: rs1,
      rs2: rs2,
    );
  }

  @override
  void execute(RISCVCpuOpcode opcode) {
    _executors[opcode.op.index].call(opcode);
    registers.pc.write(registers.pc.read() + 4);
    logger.v(registers);
  }

  List<RISCVOpcodeExecutor> _generateExecutor() {
    final list = List<RISCVOpcodeExecutor>.filled(0x100, _defaultExecutor);
    list[RISCVInstructSet.add.index] = _executeAdd;
    list[RISCVInstructSet.sub.index] = _executeSub;
    list[RISCVInstructSet.xor.index] = _executeXor;
    list[RISCVInstructSet.or.index] = _executeOr;
    list[RISCVInstructSet.and.index] = _executeAnd;
    list[RISCVInstructSet.sll.index] = _executeSll;
    list[RISCVInstructSet.srl.index] = _executeSrl;
    list[RISCVInstructSet.sra.index] = _executeSra;
    list[RISCVInstructSet.slt.index] = _executeSlt;
    list[RISCVInstructSet.sltu.index] = _executeSltu;
    list[RISCVInstructSet.addi.index] = _executeAddi;
    list[RISCVInstructSet.xori.index] = _defaultExecutor;
    list[RISCVInstructSet.ori.index] = _defaultExecutor;
    list[RISCVInstructSet.andi.index] = _defaultExecutor;
    list[RISCVInstructSet.slli.index] = _defaultExecutor;
    list[RISCVInstructSet.srli.index] = _defaultExecutor;
    list[RISCVInstructSet.srai.index] = _defaultExecutor;
    list[RISCVInstructSet.slti.index] = _defaultExecutor;
    list[RISCVInstructSet.sltiu.index] = _defaultExecutor;
    list[RISCVInstructSet.lb.index] = _defaultExecutor;
    list[RISCVInstructSet.lh.index] = _defaultExecutor;
    list[RISCVInstructSet.lw.index] = _defaultExecutor;
    list[RISCVInstructSet.lbu.index] = _defaultExecutor;
    list[RISCVInstructSet.lhu.index] = _defaultExecutor;
    list[RISCVInstructSet.sb.index] = _defaultExecutor;
    list[RISCVInstructSet.sh.index] = _defaultExecutor;
    list[RISCVInstructSet.sw.index] = _defaultExecutor;
    list[RISCVInstructSet.beq.index] = _defaultExecutor;
    list[RISCVInstructSet.bne.index] = _defaultExecutor;
    list[RISCVInstructSet.blt.index] = _defaultExecutor;
    list[RISCVInstructSet.bge.index] = _defaultExecutor;
    list[RISCVInstructSet.bltu.index] = _defaultExecutor;
    list[RISCVInstructSet.bgeu.index] = _defaultExecutor;
    list[RISCVInstructSet.jal.index] = _defaultExecutor;
    list[RISCVInstructSet.jalr.index] = _defaultExecutor;
    list[RISCVInstructSet.lui.index] = _defaultExecutor;
    list[RISCVInstructSet.auipc.index] = _defaultExecutor;
    list[RISCVInstructSet.ecall.index] = _defaultExecutor;
    list[RISCVInstructSet.ebreak.index] = _defaultExecutor;
    return list;
  }

  void _executeAdd(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() + opcode.rs2.read());
  }

  void _executeSub(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() - opcode.rs2.read());
  }

  void _executeXor(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() ^ opcode.rs2.read());
  }

  void _executeOr(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() | opcode.rs2.read());
  }

  void _executeAnd(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() & opcode.rs2.read());
  }

  void _executeSll(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() << opcode.rs2.read());
  }

  void _executeSrl(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() >> opcode.rs2.read());
  }

  void _executeSra(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() >> opcode.rs2.read());
  } 

  void _executeSlt(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() < opcode.rs2.read() ? 1 : 0);
  }

  void _executeSltu(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() < opcode.rs2.read() ? 1 : 0);
  }

  void _executeAddi(RISCVCpuOpcode opcode) {
    opcode.rd.write(opcode.rs1.read() + ((opcode.code >> 20) & 0x0fff));
  }
}
