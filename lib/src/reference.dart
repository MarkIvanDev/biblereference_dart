import 'package:biblebooks/biblebooks.dart';

/// A bible reference.
class Reference {
  /// The book of this reference.
  final BibleBook book;

  /// The verse segments of this reference.
  final List<ReferenceSegment> segments;

  Reference(this.book, {Iterable<ReferenceSegment>? segments})
      : segments = List.unmodifiable(segments ?? const <ReferenceSegment>[]);

  @override
  int get hashCode => Object.hashAll([book, ...segments]);

  @override
  bool operator ==(other) =>
      other is Reference &&
      book == other.book &&
      _segmentListEqual(segments, other.segments);

  @override
  String toString() {
    return toLocalizedString();
  }

  /// A localized string representation of this reference using a locale.
  String toLocalizedString({AppLocale locale = AppLocale.en}) {
    final buffer = StringBuffer();
    buffer.write(BibleBooksHelper().getName(book, locale: locale));
    if (segments.isNotEmpty) {
      buffer.write(' ');
    }
    for (var i = 0; i < segments.length; i++) {
      if (i == 0) {
        buffer.write(segments[i].toString());
      } else {
        if (segments[i - 1].start.chapter == segments[i - 1].end.chapter &&
            segments[i].start.chapter == segments[i].end.chapter &&
            segments[i - 1].start.chapter == segments[i].start.chapter &&
            segments[i - 1].start.verse != 0 &&
            segments[i].start.verse != 0) {
          if (segments[i].start.verse == segments[i].end.verse) {
            buffer.write(',${segments[i].start.verse}');
          } else {
            buffer
                .write(',${segments[i].start.verse}-${segments[i].end.verse}');
          }
        } else {
          buffer.write(';${segments[i].toString()}');
        }
      }
    }
    return buffer.toString();
  }
}

/// A bible reference verse segment.
class ReferenceSegment {
  /// Starting point of this verse segment.
  final ReferencePoint start;

  /// End point of this verse segment.
  final ReferencePoint end;

  const ReferenceSegment._(this.start, this.end);

  /// A factory constructor that returns a new [ReferenceSegment] with the specified start and end points.
  factory ReferenceSegment(ReferencePoint start, ReferencePoint end) =>
      _create(start, end);

  /// A factory constructor that returns a new [ReferenceSegment] representing a single chapter.
  factory ReferenceSegment.singleChapter(int chapter) => _create(
      ReferencePoint.wholeChapter(chapter),
      ReferencePoint.wholeChapter(chapter));

  /// A factory constructor that returns a new [ReferenceSegment] representing multiple chapters.
  factory ReferenceSegment.multipleChapters(int start, int end) => _create(
      ReferencePoint.wholeChapter(start), ReferencePoint.wholeChapter(end));

  /// A factory constructor that returns a new [ReferenceSegment] representing a single verse.
  factory ReferenceSegment.singleVerse(int chapter, int verse) =>
      _create(ReferencePoint(chapter, verse), ReferencePoint(chapter, verse));

  /// A factory constructor that returns a new [ReferenceSegment] representing multiple verses.
  factory ReferenceSegment.multipleVerses(
          int chapter, int startVerse, int endVerse) =>
      _create(ReferencePoint(chapter, startVerse),
          ReferencePoint(chapter, endVerse));

  static ReferenceSegment _create(ReferencePoint start, ReferencePoint end) {
    if (start > end) {
      throw ArgumentError.value(start);
    }
    if ((start.verse == 0) ^ (end.verse == 0)) {
      throw ArgumentError(
          "Start and end verses are only valid when both are 0 or both are greater than 0");
    }
    return ReferenceSegment._(start, end);
  }

  @override
  String toString() {
    var buffer = StringBuffer();
    buffer.write(start.toString());
    if (start != end) {
      if (start.chapter == end.chapter) {
        buffer.write('-${end.verse}');
      } else {
        buffer.write('-${end.toString()}');
      }
    }
    return buffer.toString();
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  bool operator ==(other) =>
      other is ReferenceSegment && start == other.start && end == other.end;
}

/// A point of a [ReferenceSegment].
class ReferencePoint implements Comparable<ReferencePoint> {
  /// The chapter of this reference point.
  final int chapter;

  /// The verse of this reference point.
  final int verse;

  const ReferencePoint._(this.chapter, this.verse);

  /// A factory constructor that returns a new [ReferencePoint] with the specified chapter and verse values.
  factory ReferencePoint(int chapter, int verse) => _create(chapter, verse);

  /// A factory constructor that returns a new [ReferencePoint] representing a whole chapter.
  factory ReferencePoint.wholeChapter(int chapter) => _create(chapter, 0);

  static ReferencePoint _create(int chapter, int verse) {
    if (chapter <= 0) {
      throw ArgumentError.value(chapter);
    }
    if (verse < 0) {
      throw ArgumentError.value(verse);
    }
    return ReferencePoint._(chapter, verse);
  }

  @override
  String toString() => '$chapter${verse != 0 ? ":$verse" : ""}';

  @override
  int compareTo(ReferencePoint other) {
    int chapterDifference = chapter - other.chapter;
    return chapterDifference != 0 ? chapterDifference : verse - other.verse;
  }

  @override
  int get hashCode => Object.hash(chapter, verse);

  @override
  bool operator ==(other) =>
      other is ReferencePoint &&
      other.chapter == chapter &&
      other.verse == verse;

  /// Compares this reference point to another, returning true if this point comes before the other.
  bool operator <(other) => compareTo(other) < 0;

  /// Compares this reference point to another, returning true if this point comes before or is the same as the other.
  bool operator <=(other) => compareTo(other) <= 0;

  /// Compares this reference point to another, returning true if this point comes after the other.
  bool operator >(other) => compareTo(other) > 0;

  /// Compares this reference point to another, returning true if this point comes after or is the same as the other.
  bool operator >=(other) => compareTo(other) >= 0;
}

bool _segmentListEqual(
    List<ReferenceSegment> list1, List<ReferenceSegment> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  for (var i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }

  return true;
}
