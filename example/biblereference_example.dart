import 'package:biblebooks/biblebooks.dart';
import 'package:biblereference/biblereference.dart';

void main() {
  // Parse using the default locale: AppLocale.en

  // Book
  var reference = BibleReferenceParser().parse('Genesis');
  print(reference == Reference(BibleBook.genesis)); // prints true

  // Book Chapter
  reference = BibleReferenceParser().parse('Genesis 1');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [ReferenceSegment.singleChapter(1)],
      )); // prints true

  // Book Chapter-Chapter
  reference = BibleReferenceParser().parse('Genesis 1-2');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [ReferenceSegment.multipleChapters(1, 2)],
      )); // prints true

  // Book Chapter:Verse
  reference = BibleReferenceParser().parse('Genesis 1:1');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [ReferenceSegment.singleVerse(1, 1)],
      )); // prints true

  // Book Chapter:Verse-Verse
  reference = BibleReferenceParser().parse('Genesis 1:1-5');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [ReferenceSegment.multipleVerses(1, 1, 5)],
      )); // prints true

  // Book Chapter:Verse,Verse
  reference = BibleReferenceParser().parse('Genesis 1:1,5');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [
          ReferenceSegment.singleVerse(1, 1),
          ReferenceSegment.singleVerse(1, 5),
        ],
      )); // prints true

  // Book Chapter:Verse-Verse,Verse-Verse
  reference = BibleReferenceParser().parse('Genesis 1:1-5,8-10');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [
          ReferenceSegment.multipleVerses(1, 1, 5),
          ReferenceSegment.multipleVerses(1, 8, 10),
        ],
      )); // prints true

  // Book Chapter:Verse-Verse;Chapter:Verse-Verse
  reference = BibleReferenceParser().parse('Genesis 1:1-5;2:1-3');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [
          ReferenceSegment.multipleVerses(1, 1, 5),
          ReferenceSegment.multipleVerses(2, 1, 3),
        ],
      )); // prints true

  // Book Chapter:Verse-Chapter:Verse
  reference = BibleReferenceParser().parse('Genesis 1:5-2:3');
  print(reference ==
      Reference(
        BibleBook.genesis,
        segments: [
          ReferenceSegment(ReferencePoint(1, 5), ReferencePoint(2, 3)),
        ],
      )); // prints true

  // Book Verse (for single-chapter books)
  reference = BibleReferenceParser().parse('2 John 9');
  print(reference ==
      Reference(
        BibleBook.john2,
        segments: [
          ReferenceSegment.singleVerse(1, 9),
        ],
      )); // prints true

  // Parse using the default locale: AppLocale.tgl

  // Book
  reference = BibleReferenceParser().parse('Gawa', locale: AppLocale.tgl);
  print(reference == Reference(BibleBook.acts)); // prints true

  // Book Chapter
  reference = BibleReferenceParser().parse('Gawa 1', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [ReferenceSegment.singleChapter(1)],
      )); // prints true

  // Book Chapter-Chapter
  reference = BibleReferenceParser().parse('Gawa 1-2', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [ReferenceSegment.multipleChapters(1, 2)],
      )); // prints true

  // Book Chapter:Verse
  reference = BibleReferenceParser().parse('Gawa 1:1', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [ReferenceSegment.singleVerse(1, 1)],
      )); // prints true

  // Book Chapter:Verse-Verse
  reference = BibleReferenceParser().parse('Gawa 1:1-5', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [ReferenceSegment.multipleVerses(1, 1, 5)],
      )); // prints true

  // Book Chapter:Verse,Verse
  reference = BibleReferenceParser().parse('Gawa 1:1,5', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [
          ReferenceSegment.singleVerse(1, 1),
          ReferenceSegment.singleVerse(1, 5),
        ],
      )); // prints true

  // Book Chapter:Verse-Verse,Verse-Verse
  reference =
      BibleReferenceParser().parse('Gawa 1:1-5,8-10', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [
          ReferenceSegment.multipleVerses(1, 1, 5),
          ReferenceSegment.multipleVerses(1, 8, 10),
        ],
      )); // prints true

  // Book Chapter:Verse-Verse;Chapter:Verse-Verse
  reference =
      BibleReferenceParser().parse('Gawa 1:1-5;2:1-3', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [
          ReferenceSegment.multipleVerses(1, 1, 5),
          ReferenceSegment.multipleVerses(2, 1, 3),
        ],
      )); // prints true

  // Book Chapter:Verse-Chapter:Verse
  reference =
      BibleReferenceParser().parse('Gawa 1:5-2:3', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.acts,
        segments: [
          ReferenceSegment(ReferencePoint(1, 5), ReferencePoint(2, 3)),
        ],
      )); // prints true

  // Book Verse (for single-chapter books)
  reference = BibleReferenceParser().parse('2 Juan 9', locale: AppLocale.tgl);
  print(reference ==
      Reference(
        BibleBook.john2,
        segments: [
          ReferenceSegment.singleVerse(1, 9),
        ],
      )); // prints true
}
