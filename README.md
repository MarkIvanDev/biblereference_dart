# biblereference
A dart library to parse text into bible references in multiple locales.

## Getting started

[Install](https://pub.dev/packages/biblereference/install) the `biblereference` package:

```yaml
dependencies:
  biblereference: ^1.0.0
```

Then you can import it in your Dart code:

```dart
import 'package:biblereference/biblereference.dart';
```

## Features

### Supported String Formats
- Book (e.g. *Genesis*)
- Book Chapter (e.g. *Genesis 1*)
- Book Chapter-Chapter (e.g. *Genesis 1-2*)
- Book Chapter:Verse (e.g. *Genesis 1:1*)
- Book Chapter:Verse-Verse (e.g. *Genesis 1:1-5*)
- Book Chapter:Verse,Verse (e.g. *Genesis 1:1,5*)
- Book Chapter:Verse-Verse,Verse-Verse (e.g. *Genesis 1:1-5,8-10*)
- Book Chapter:Verse-Verse;Chapter:Verse-Verse (e.g. *Genesis 1:1-5;2:1-3*)
- Book Chapter:Verse-Chapter:Verse (e.g. *Genesis 1:5-2:3*)
- Book Verse (for single-chapter books) (e.g. *2 John 9*)

### Supported Locales
- English: `AppLocale.en`
- Tagalog: `AppLocale.tgl`

## Usage

You can use the `BibleReferenceParser()` singleton to parse.

```dart
final reference = BibleReferenceParser().parse('Genesis 1:1-5;2:1-3');
print(reference ==
    Reference(
      BibleBook.genesis,
      segments: [
        ReferenceSegment.multipleVerses(1, 1, 5),
        ReferenceSegment.multipleVerses(2, 1, 3),
      ],
    )); // prints true
```

## Support
If you like my work and want to support me, buying me a coffee would be awesome! Thanks for your support!

<a href="https://www.buymeacoffee.com/markivandev" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

---------
**Mark Ivan Basto** &bullet; **GitHub**
**[@MarkIvanDev](https://github.com/MarkIvanDev)** &bullet; **Twitter**
**[@Rivolvan_Speaks](https://twitter.com/Rivolvan_Speaks)**