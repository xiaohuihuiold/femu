import 'package:flutter/foundation.dart';

extension RWValueExt<T> on T {
  RWValue<T> get rw => RWValue(this);
}

abstract interface class Reader<T> {
  T read();
}

abstract interface class Writer<T> {
  void write(T value);
}

abstract interface class ReaderWriter<T> implements Reader<T>, Writer<T> {}

mixin TransformerMixin<T> on ReaderWriter<T> {
  RWTransformValue<T> transform(RWTransformer<T> transformer) {
    transformer.value = this;
    return RWTransformValue(transformer);
  }
}

class RWValue<T> extends ReaderWriter<T> with TransformerMixin<T> {
  T _value;

  RWValue(this._value);

  RWTransformValue<T> call(RWTransformer<T> transformer) =>
      transform(transformer);

  @override
  T read() => _value;

  @override
  void write(T value) => _value = value;
}

class RWTransformValue<T> extends ReaderWriter<T> with TransformerMixin<T> {
  final RWTransformer<T> transformer;

  RWTransformValue(this.transformer);

  RWTransformValue<T> call(RWTransformer<T> transformer) =>
      transform(transformer);

  @override
  T read() => transformer.read();

  @override
  void write(T value) => transformer.write(value);
}

abstract class RWTransformer<T> implements ReaderWriter<T> {
  @protected
  late ReaderWriter<T> value;

  @override
  T read();

  @override
  void write(T v);
}

class RW16Bit extends RWTransformer<int> {
  @override
  int read() => value.read() & 0xFFFF;

  @override
  void write(int v) => value.write(v & 0xFFFF);
}

class RW16BitHigh extends RWTransformer<int> {
  @override
  int read() => (value.read() & 0xFF00) >> 8;

  @override
  void write(int v) => value.write((value.read() & 0xFF) | ((v & 0xFF) << 8));
}

class RW16BitLow extends RWTransformer<int> {
  @override
  int read() => value.read() & 0xFF;

  @override
  void write(int v) => value.write((value.read() & 0xFF00) | (v & 0xFF));
}

class RWIndexBit extends RWTransformer<int> {
  final int index;

  RWIndexBit(this.index);

  @override
  int read() => (value.read() >> index) & 1;

  @override
  void write(int v) => value
      .write((value.read() & (~(1 << index))) | ((v == 0 ? 0 : 1) << index));
}
