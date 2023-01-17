import 'package:biblebooks/biblebooks.dart';

import 'reference.dart';

/// A class to parse bible references.
class BibleReferenceParser {
  const BibleReferenceParser._();
  static const BibleReferenceParser _instance = BibleReferenceParser._();

  factory BibleReferenceParser() => _instance;

  /// Parses the text using an [AppLocale] then returns the [Reference] or throws a [FormatException] if the parsing failed.
  Reference parse(String text, {AppLocale locale = AppLocale.en}) {
    final result = _internalParse(text, locale: locale);
    final reference = result.reference;
    if (result.isSuccessful && reference != null) {
      return reference;
    } else {
      throw FormatException(result.errorMessage ?? '');
    }
  }

  /// Parses the text using an [AppLocale] then returns the [Reference] or null if the parsing failed.
  Reference? tryParse(String text, {AppLocale locale = AppLocale.en}) {
    final result = _internalParse(text, locale: locale);
    final reference = result.reference;
    if (result.isSuccessful && reference != null) {
      return reference;
    } else {
      return null;
    }
  }

  _ReferenceResult _internalParse(String text,
      {AppLocale locale = AppLocale.en}) {
    final textTrimmed = text.trim();
    if (textTrimmed.isEmpty) return _ReferenceResult.error('String is empty');

    int splitIndex = 0;
    for (int i = 0; i < textTrimmed.length; i++) {
      if (i != 0 && textTrimmed.isDigit(i)) {
        splitIndex = i;
        break;
      }
    }
    final bookPart = textTrimmed
        .substring(0, splitIndex == 0 ? textTrimmed.length : splitIndex)
        .trim();
    final bookResult = _internalParseBook(bookPart, locale: locale);
    final book = bookResult.book;
    if (bookResult.isSuccessful && book != null) {
      if (splitIndex == 0) {
        return _ReferenceResult.success(Reference(book));
      } else {
        final maxChapter = BibleBooksHelper().getMaxChapter(book) ?? 0;
        final segmentsPart = textTrimmed.substring(splitIndex).trim();
        final segmentsResult = _internalParseSegments(segmentsPart, maxChapter);
        final segments = segmentsResult.segments;
        if (segmentsResult.isSuccessful && segments != null) {
          return _ReferenceResult.success(Reference(book, segments: segments));
        } else {
          return _ReferenceResult.error(segmentsResult.errorMessage ?? '');
        }
      }
    } else {
      return _ReferenceResult.error(bookResult.errorMessage ?? '');
    }
  }

  _ReferenceBookResult _internalParseBook(String text,
      {AppLocale locale = AppLocale.en}) {
    final potentialBook = _convertToArabicNumerals(text, locale: locale);

    var key = BibleBooksHelper().getKeyForName(potentialBook, locale: locale) ??
        BibleBooksHelper().getKeyForOsisCode(potentialBook, locale: locale) ??
        BibleBooksHelper()
            .getKeyForParatextCode(potentialBook, locale: locale) ??
        BibleBooksHelper()
            .getKeyForStandardAbbreviation(potentialBook, locale: locale) ??
        BibleBooksHelper()
            .getKeyForThompsonAbbreviation(potentialBook, locale: locale) ??
        (potentialBook.isNotEmpty
            ? BibleBooksHelper()
                .getKeyForAlternativeName(potentialBook, locale: locale)
            : null);
    if (key == null) {
      return _ReferenceBookResult.error('Unknown book name');
    } else {
      return _ReferenceBookResult.success(key);
    }
  }

  String _convertToArabicNumerals(String text,
      {AppLocale locale = AppLocale.en}) {
    // Break up on all remaining white space
    final parts = text
        .multiSplit([' ', '\r', '\n', '\t'])
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';

    // If the first part is a roman numeral, or spelled ordinal, convert it to arabic
    final number = parts[0];
    if (number.equalsIgnoreCase(
            BibleBooksHelper().getNumber(Number.first, locale: locale)) ||
        number.equalsIgnoreCase('I')) {
      parts[0] = "1";
    } else if (number.equalsIgnoreCase(
            BibleBooksHelper().getNumber(Number.second, locale: locale)) ||
        number.equalsIgnoreCase('II')) {
      parts[0] = "2";
    } else if (number.equalsIgnoreCase(
            BibleBooksHelper().getNumber(Number.third, locale: locale)) ||
        number.equalsIgnoreCase('III')) {
      parts[0] = "3";
    } else if (number.equalsIgnoreCase(
            BibleBooksHelper().getNumber(Number.fourth, locale: locale)) ||
        number.equalsIgnoreCase('IV')) {
      parts[0] = "4";
    } else if (number.equalsIgnoreCase(
            BibleBooksHelper().getNumber(Number.fifth, locale: locale)) ||
        number.equalsIgnoreCase('V')) {
      parts[0] = "5";
    }

    return parts.join(' ');
  }

  _ReferenceSegmentsResult _internalParseSegments(String text, int maxChapter) {
    try {
      final referenceSegments = <ReferenceSegment>[];
      if (text.trim().isEmpty) {
        return _ReferenceSegmentsResult.success(referenceSegments);
      }

      final citations =
          text.split(';').map((c) => c.trim()).where((c) => c.isNotEmpty);
      for (var citation in citations) {
        int? chapterNumber;

        final segments =
            citation.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
        for (var segment in segments) {
          final ranges = segment
              .split('-')
              .map((r) => r.trim())
              .where((r) => r.isNotEmpty)
              .toList();

          switch (ranges.length) {
            case 1:
              final pointResult =
                  _internalParsePoint(ranges[0], maxChapter, chapterNumber);
              final point = pointResult.point;
              if (pointResult.isSuccessful && point != null) {
                chapterNumber = pointResult.chapterOverride;
                referenceSegments.add(
                    ReferenceSegment.singleVerse(point.chapter, point.verse));
              } else {
                return _ReferenceSegmentsResult.error(
                    pointResult.errorMessage ?? '');
              }
              break;

            case 2:
              var startPointResult =
                  _internalParsePoint(ranges[0], maxChapter, chapterNumber);
              var startPoint = startPointResult.point;
              if (startPointResult.isSuccessful && startPoint != null) {
                chapterNumber = startPointResult.chapterOverride;
              } else {
                return _ReferenceSegmentsResult.error(
                    startPointResult.errorMessage ?? '');
              }
              var endPointResult =
                  _internalParsePoint(ranges[1], maxChapter, chapterNumber);
              var endPoint = endPointResult.point;
              if (endPointResult.isSuccessful && endPoint != null) {
                chapterNumber = endPointResult.chapterOverride;
              } else {
                return _ReferenceSegmentsResult.error(
                    endPointResult.errorMessage ?? '');
              }

              referenceSegments.add(ReferenceSegment(startPoint, endPoint));
              break;

            default:
              return _ReferenceSegmentsResult.error('Invalid range format');
          }
        }
      }

      return _ReferenceSegmentsResult.success(referenceSegments);
    } catch (e) {
      return _ReferenceSegmentsResult.error(e.toString());
    }
  }

  _ReferencePointResult _internalParsePoint(
      String text, int maxChapter, int? chapterOverride) {
    try {
      final colonIndex = text.indexOf(':');
      if (colonIndex != -1) {
        final parts = text.split(':');
        final chapter = int.tryParse(parts.first);

        if (chapter == null) {
          return _ReferencePointResult.error('Chapter is not a number');
        }

        if (chapter <= 0) {
          return _ReferencePointResult.error(
              'Chapter cannot be less than or equal to 0');
        }

        if (chapter > maxChapter) {
          return _ReferencePointResult.error('Chapter exceeds max chapter');
        }

        final verse = int.tryParse(parts[1]);

        if (verse == null) {
          return _ReferencePointResult.error('Verse is not a number');
        }

        return _ReferencePointResult.success(
            ReferencePoint(chapter, verse), chapter);
      } else {
        final i = int.tryParse(text);
        if (i == null) {
          return _ReferencePointResult.error('Invalid format');
        }

        if (maxChapter == 1) {
          return _ReferencePointResult.success(ReferencePoint(1, i), 1);
        } else if (chapterOverride != null) {
          return _ReferencePointResult.success(
              ReferencePoint(chapterOverride, i), chapterOverride);
        } else {
          if (i > maxChapter) {
            return _ReferencePointResult.error('Chapter exceeds max chapter');
          }

          if (i <= 0) {
            return _ReferencePointResult.error(
                'Chapter cannot be less than or equal to 0');
          }

          return _ReferencePointResult.success(
              ReferencePoint.wholeChapter(i), chapterOverride);
        }
      }
    } catch (e) {
      return _ReferencePointResult.error(e.toString());
    }
  }
}

class _ReferenceResult {
  final bool isSuccessful;
  final Reference? reference;
  final String? errorMessage;

  const _ReferenceResult._(
      this.isSuccessful, this.reference, this.errorMessage);

  factory _ReferenceResult.success(Reference reference) =>
      _ReferenceResult._(true, reference, null);
  factory _ReferenceResult.error(String errorMessage) =>
      _ReferenceResult._(false, null, errorMessage);
}

class _ReferenceBookResult {
  final bool isSuccessful;
  final BibleBook? book;
  final String? errorMessage;

  const _ReferenceBookResult._(this.isSuccessful, this.book, this.errorMessage);

  factory _ReferenceBookResult.success(BibleBook book) =>
      _ReferenceBookResult._(true, book, null);
  factory _ReferenceBookResult.error(String errorMessage) =>
      _ReferenceBookResult._(false, null, errorMessage);
}

class _ReferenceSegmentsResult {
  final bool isSuccessful;
  final List<ReferenceSegment>? segments;
  final String? errorMessage;

  const _ReferenceSegmentsResult._(
      this.isSuccessful, this.segments, this.errorMessage);

  factory _ReferenceSegmentsResult.success(List<ReferenceSegment> segments) =>
      _ReferenceSegmentsResult._(true, segments, null);
  factory _ReferenceSegmentsResult.error(String errorMessage) =>
      _ReferenceSegmentsResult._(false, null, errorMessage);
}

class _ReferencePointResult {
  final bool isSuccessful;
  final ReferencePoint? point;
  final int? chapterOverride;
  final String? errorMessage;

  const _ReferencePointResult._(
      this.isSuccessful, this.point, this.chapterOverride, this.errorMessage);

  factory _ReferencePointResult.success(
          ReferencePoint point, int? chapterOverride) =>
      _ReferencePointResult._(true, point, chapterOverride, null);
  factory _ReferencePointResult.error(String errorMessage) =>
      _ReferencePointResult._(false, null, null, errorMessage);
}

extension _StringExtensions on String {
  List<String> multiSplit(Iterable<String> delimiters) {
    return delimiters.isEmpty
        ? [this]
        : split(RegExp(delimiters.map((d) => RegExp.escape(d)).join('|')));
  }

  bool equalsIgnoreCase(String? other) {
    return toLowerCase() == other?.toLowerCase();
  }

  bool isDigit(int index) {
    return (codeUnitAt(index) ^ 0x30) <= 9;
  }
}
