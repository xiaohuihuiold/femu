import 'dart:convert';
import 'dart:typed_data';

/// ByteData扩展
extension ByteDataExt on ByteData {
  String getString(int offset, [int? end]) {
    final bytes = getUint8List(offset, end);
    return utf8.decode(bytes.sublist(0, bytes.indexOf(0)));
  }

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
