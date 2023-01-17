import 'package:biblebooks/biblebooks.dart';
import 'package:biblereference/biblereference.dart';
import 'package:test/test.dart';

void main() {
  group('ReferencePoint', () {
    group('Instantiation', () {
      test('Invalid chapter', () {
        expect(() => ReferencePoint(0, 1), throwsArgumentError);
      });

      test('Invalid verse', () {
        expect(() => ReferencePoint(1, -1), throwsArgumentError);
      });
    });

    group('Operators', () {
      test('== operator', () {
        expect(ReferencePoint(1, 1) == ReferencePoint(1, 1), isTrue);
        expect(ReferencePoint(1, 1) == ReferencePoint(2, 2), isFalse);
      });

      test('!= operator', () {
        expect(ReferencePoint(1, 1) != ReferencePoint(2, 2), isTrue);
        expect(ReferencePoint(1, 1) != ReferencePoint(1, 1), isFalse);
      });

      test('> operator', () {
        expect(ReferencePoint(1, 2) > ReferencePoint(1, 1), isTrue);
        expect(ReferencePoint(2, 1) > ReferencePoint(1, 2), isTrue);

        expect(ReferencePoint(1, 1) > ReferencePoint(1, 1), isFalse);
        expect(ReferencePoint(1, 1) > ReferencePoint(1, 2), isFalse);
        expect(ReferencePoint(1, 2) > ReferencePoint(2, 1), isFalse);
      });

      test('>= operator', () {
        expect(ReferencePoint(1, 2) >= ReferencePoint(1, 1), isTrue);
        expect(ReferencePoint(2, 1) >= ReferencePoint(1, 2), isTrue);
        expect(ReferencePoint(1, 1) >= ReferencePoint(1, 1), isTrue);

        expect(ReferencePoint(1, 1) > ReferencePoint(1, 2), isFalse);
        expect(ReferencePoint(1, 2) > ReferencePoint(2, 1), isFalse);
      });

      test('< operator', () {
        expect(ReferencePoint(1, 1) < ReferencePoint(1, 2), isTrue);
        expect(ReferencePoint(1, 2) < ReferencePoint(2, 1), isTrue);

        expect(ReferencePoint(1, 1) < ReferencePoint(1, 1), isFalse);
        expect(ReferencePoint(1, 2) < ReferencePoint(1, 1), isFalse);
        expect(ReferencePoint(2, 1) < ReferencePoint(1, 2), isFalse);
      });

      test('<= operator', () {
        expect(ReferencePoint(1, 1) <= ReferencePoint(1, 2), isTrue);
        expect(ReferencePoint(1, 2) <= ReferencePoint(2, 1), isTrue);
        expect(ReferencePoint(1, 1) <= ReferencePoint(1, 1), isTrue);

        expect(ReferencePoint(1, 2) <= ReferencePoint(1, 1), isFalse);
        expect(ReferencePoint(2, 1) <= ReferencePoint(1, 2), isFalse);
      });

      test('Type mismatch', () {
        expect(() => ReferencePoint(1, 0) > 0, throwsA(anything));
        expect(() => ReferencePoint(1, 0) >= 0, throwsA(anything));
        expect(() => ReferencePoint(1, 0) < 0, throwsA(anything));
        expect(() => ReferencePoint(1, 0) <= 0, throwsA(anything));
      });
    });

    group('toString', () {
      test('Whole chapter', () {
        expect(ReferencePoint(1, 0).toString(), '1');
      });

      test('Specific verse', () {
        expect(ReferencePoint(1, 1).toString(), '1:1');
      });
    });
  });

  group('ReferenceSegment', () {
    group('Instantiation', () {
      test('Start Chapter > End Chapter', () {
        expect(
            () => ReferenceSegment.multipleChapters(2, 1), throwsArgumentError);
      });

      test('Start Verse > End Verse', () {
        expect(() => ReferenceSegment.multipleVerses(1, 2, 1),
            throwsArgumentError);
      });

      test('Start Verse == 0 && End Verse > 0', () {
        expect(() => ReferenceSegment.multipleVerses(1, 0, 1),
            throwsArgumentError);
      });

      test('Start Verse > 0 && End Verse == 0', () {
        expect(() => ReferenceSegment.multipleVerses(1, 1, 0),
            throwsArgumentError);
      });
    });

    group('Equality', () {
      test('==', () {
        expect(
            ReferenceSegment.singleVerse(1, 1) ==
                ReferenceSegment.singleVerse(1, 1),
            isTrue);
        expect(
            ReferenceSegment.singleVerse(1, 1) ==
                ReferenceSegment.singleVerse(1, 2),
            isFalse);
      });

      test('!=', () {
        expect(
            ReferenceSegment.singleVerse(1, 1) !=
                ReferenceSegment.singleVerse(1, 2),
            isTrue);
        expect(
            ReferenceSegment.singleVerse(1, 1) !=
                ReferenceSegment.singleVerse(1, 1),
            isFalse);
      });
    });

    group('toString', () {
      test('singleChapter', () {
        expect(ReferenceSegment.singleChapter(1).toString(), "1");
      });

      test('multipleChapters', () {
        expect(ReferenceSegment.multipleChapters(1, 2).toString(), "1-2");
      });

      test('singleVerse', () {
        expect(ReferenceSegment.singleVerse(1, 1).toString(), "1:1");
      });

      test('multipleVerses', () {
        expect(ReferenceSegment.multipleVerses(1, 1, 5).toString(), "1:1-5");
      });
    });
  });

  group('Reference', () {
    group('Parse', () {
      test('Book', () {
        expect(BibleReferenceParser().parse('Genesis').toString(), 'Genesis');
      });

      test('Book Chapter', () {
        expect(
            BibleReferenceParser().parse('Genesis 1').toString(), 'Genesis 1');
      });

      test('Book Chapter-Chapter', () {
        expect(BibleReferenceParser().parse('Genesis 1-2').toString(),
            'Genesis 1-2');
      });

      test('Book Chapter:Verse', () {
        expect(BibleReferenceParser().parse('Genesis 1:1').toString(),
            'Genesis 1:1');
      });

      test('Book Chapter:Verse-Verse', () {
        expect(BibleReferenceParser().parse('Genesis 1:1-5').toString(),
            'Genesis 1:1-5');
      });

      test('Book Chapter:Verse,Verse', () {
        expect(BibleReferenceParser().parse('Genesis 1:1,5').toString(),
            'Genesis 1:1,5');
      });

      test('Book Chapter:Verse-Verse,Verse-Verse', () {
        expect(BibleReferenceParser().parse('Genesis 1:1-5,8-10').toString(),
            'Genesis 1:1-5,8-10');
      });

      test('Book Chapter:Verse-Verse;Chapter:Verse-Verse', () {
        expect(BibleReferenceParser().parse('Genesis 1:1-5;2:1-3').toString(),
            'Genesis 1:1-5;2:1-3');
      });

      test('Book Chapter:Verse-Chapter:Verse', () {
        expect(BibleReferenceParser().parse('Genesis 1:5-2:3').toString(),
            'Genesis 1:5-2:3');
      });

      test('Book Verse (for single-chapter books)', () {
        expect(
            BibleReferenceParser().parse('2 John 9').toString(), '2 John 1:9');
      });
    });

    group('Parse Localized - tgl', () {
      test('Book', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa');
      });

      test('Book Chapter', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1');
      });

      test('Book Chapter-Chapter', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1-2', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1-2');
      });

      test('Book Chapter:Verse', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1:1', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1:1');
      });

      test('Book Chapter:Verse-Verse', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1:1-5', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1:1-5');
      });

      test('Book Chapter:Verse,Verse', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1:1,5', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1:1,5');
      });

      test('Book Chapter:Verse-Verse,Verse-Verse', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1:1-5,8-10', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1:1-5,8-10');
      });

      test('Book Chapter:Verse-Verse;Chapter:Verse-Verse', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1:1-5;2:1-3', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1:1-5;2:1-3');
      });

      test('Book Chapter:Verse-Chapter:Verse', () {
        expect(
            BibleReferenceParser()
                .parse('Gawa 1:5-2:3', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            'Gawa 1:5-2:3');
      });

      test('Book Verse (for single-chapter books)', () {
        expect(
            BibleReferenceParser()
                .parse('2 Juan 9', locale: AppLocale.tgl)
                .toLocalizedString(locale: AppLocale.tgl),
            '2 Juan 1:9');
      });
    });

    group('toString', () {
      test('singleChapter', () {
        expect(
            Reference(BibleBook.acts,
                segments: [ReferenceSegment.singleChapter(1)]).toString(),
            'Acts 1');
      });

      test('multipleChapters', () {
        expect(
            Reference(BibleBook.acts,
                segments: [ReferenceSegment.multipleChapters(1, 2)]).toString(),
            'Acts 1-2');
      });

      test('singleVerse', () {
        expect(
            Reference(BibleBook.acts,
                segments: [ReferenceSegment.singleVerse(1, 1)]).toString(),
            'Acts 1:1');
      });

      test('multipleVerses', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.multipleVerses(1, 1, 5)])
                .toString(),
            'Acts 1:1-5');
      });

      test('mixed', () {
        expect(
            Reference(BibleBook.genesis, segments: [
              ReferenceSegment.singleVerse(1, 1),
              ReferenceSegment.singleVerse(1, 4),
              ReferenceSegment.multipleVerses(1, 7, 9),
              ReferenceSegment.singleVerse(1, 11),
              ReferenceSegment.singleVerse(1, 13),
            ]).toString(),
            'Genesis 1:1,4,7-9,11,13');
      });
    });

    group('toLocalizedString - en', () {
      test('singleChapter', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.singleChapter(1)])
                .toLocalizedString(locale: AppLocale.en),
            "Acts 1");
      });

      test('multipleChapters', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.multipleChapters(1, 2)])
                .toLocalizedString(locale: AppLocale.en),
            "Acts 1-2");
      });

      test('singleVerse', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.singleVerse(1, 1)])
                .toLocalizedString(locale: AppLocale.en),
            "Acts 1:1");
      });

      test('multipleVerses', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.multipleVerses(1, 1, 5)])
                .toLocalizedString(locale: AppLocale.en),
            "Acts 1:1-5");
      });
    });

    group('toLocalizedString - tgl', () {
      test('singleChapter', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.singleChapter(1)])
                .toLocalizedString(locale: AppLocale.tgl),
            "Gawa 1");
      });

      test('multipleChapters', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.multipleChapters(1, 2)])
                .toLocalizedString(locale: AppLocale.tgl),
            "Gawa 1-2");
      });

      test('singleVerse', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.singleVerse(1, 1)])
                .toLocalizedString(locale: AppLocale.tgl),
            "Gawa 1:1");
      });

      test('multipleVerses', () {
        expect(
            Reference(BibleBook.acts,
                    segments: [ReferenceSegment.multipleVerses(1, 1, 5)])
                .toLocalizedString(locale: AppLocale.tgl),
            "Gawa 1:1-5");
      });
    });
  });
}
