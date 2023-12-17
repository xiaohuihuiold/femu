import 'dart:typed_data';

/// ByteData扩展
extension ByteDataExt on ByteData {
  Uint8List getUint8List(int offset, [int? end]) {
    return buffer.asUint8List(offset, end == null ? null : end - offset);
  }

  void setUint8List(int offset, List<int> bytes, {int start = 0, int? end}) {
    final length = end == null ? null : end - start;
    for (int i = offset; i < offset + (length ?? bytes.length); i++) {
      setUint8(i, bytes[i - offset + start]);
    }
  }
}
