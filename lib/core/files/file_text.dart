import 'dart:convert';

import 'package:cross_file/cross_file.dart';

/// Reads a picked file as UTF-8 text.
///
/// Not [XFile.readAsString], which was a trap until cross_file 0.3.5+5: it
/// took an `encoding` parameter, defaulted it to UTF-8, and then — when the
/// XFile held bytes rather than a path — ignored it and ran
/// `String.fromCharCodes`, which is Latin-1. Android's document picker hands
/// back bytes, so every imported file came through with its diacritics
/// mangled: "svjećica" arriving as "svjeÄica". Nothing threw. The text was
/// simply wrong, which is worse: a Fuelio reminder whose name no longer
/// matched any known service imported as nothing at all, and the user was
/// told three of their intervals were "not recognised" over names they could
/// see were spelled correctly.
///
/// It decodes properly now, and strictly: it still keeps a byte-order mark
/// and throws on a byte that is not UTF-8, which this does neither of.
Future<String> readTextFile(XFile file) async {
  final bytes = await file.readAsBytes();
  // Malformed input is replaced rather than thrown: a file in some other
  // encoding should import as much of itself as it can, instead of failing
  // whole over one byte.
  final text = utf8.decode(bytes, allowMalformed: true);
  // A spreadsheet on Windows writes a byte-order mark, which would otherwise
  // become an invisible first character of the first header — which is how a
  // column stops being found.
  return text.startsWith('﻿') ? text.substring(1) : text;
}

/// The same file, a line at a time.
///
/// A Car Scanner recording is telemetry: tens of thousands of rows for a
/// half-hour drive and eighty megabytes for a long one. [readTextFile] would
/// hold all of it, and the decoded string again, on a phone that has neither
/// to spare. Nothing about a recording needs two lines at once.
///
/// The same UTF-8 care as above — malformed bytes replaced, not thrown — and
/// the byte-order mark is dropped from the first line rather than the file.
Stream<String> readTextLines(XFile file) async* {
  var first = true;
  // Malformed input is replaced rather than thrown, for the same reason as
  // above and with more at stake: this runs over every picked file, so a
  // strict decode here would refuse a Latin-1 spreadsheet before the lenient
  // reader below ever saw it.
  final lines = const Utf8Decoder(
    allowMalformed: true,
  ).bind(file.openRead()).transform(const LineSplitter());
  await for (final line in lines) {
    if (first) {
      first = false;
      yield line.startsWith('﻿') ? line.substring(1) : line;
      continue;
    }
    yield line;
  }
}
