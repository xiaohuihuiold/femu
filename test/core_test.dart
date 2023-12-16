import 'package:flutter_test/flutter_test.dart';

import 'package:femu/femu.dart';

void main() {
  group('rw test', () {
    final int16 = 0xF00F.rw;
    final int16High = int16(RW16BitHigh());
    final int16Low = int16(RW16BitLow());
    final int16Index = int16(RWIndexBit(5));

    test('read', () {
      Reader<int> r = int16;
      expect(r.read(), 0xF00F);
    });

    test('write', () {
      int16.write(0);
      Writer<int> w = int16(RW16Bit());
      Reader<int> r = int16(RW16Bit());
      final input = [0x00FF, 0xFF00, 0xFFFF, 0xFF00FF, 0xFFFF00, 0xFFFFFF];
      final output = [0x00FF, 0xFF00, 0xFFFF, 0x00FF, 0xFF00, 0xFFFF];
      for (int i = 0; i < input.length; i++) {
        w.write(input[i]);
        expect(r.read(), output[i], reason: '读写不一致: [$i]');
      }
    });

    test('transformer', () {
      int16.write(0);
      final input = [0x00FF, 0x00FF, 0x0000, 0x0000, 0x0000, 0x00FF];
      final output = [0xFF00, 0xFFFF, 0x00FF, 0x0000, 0x0000, 0x00FF];
      for (int i = 0; i < input.length; i++) {
        if (i.isEven) {
          int16High.write(input[i]);
        } else {
          int16Low.write(input[i]);
        }
        expect(int16.read(), output[i], reason: '读写不一致: [$i]');
      }
    });

    test('index bit', () {
      int16.write(0);
      final input = [0xFF, 0xFE, 0, 0, 0, 1];
      final output = [1, 1, 0, 0, 0, 1];
      final output2 = [0xFF, 0xFF, 0, 0, 0, 0x20];
      for (int i = 0; i < input.length; i++) {
        if (i.isEven) {
          int16.write(input[i]);
        } else {
          int16Index.write(input[i]);
        }
        expect(int16Index.read(), output[i], reason: '读写不一致: [$i]');
        expect(int16.read(), output2[i], reason: '读写不一致: [$i]');
      }
    });
  });
}
