<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

Flutter table widget: Highly customizable, performant, and easy to use.

> We're actively developing this package. Expect detailed documentation and examples in the upcoming
> releases.

----
## Features

- Fix headers to the top
- Fix columns to the left or right or both
- Pagination support available

## Getting started

### Installation
Add the following line to `pubspec.yaml`
```yaml
dependencies:
  dt_fl_table:
```

## Usage
Check example for more details.
### Basic Setup
Import the dependency.
```dart
import 'package:dt_fl_table/dt_fl_table.dart';

```
Snippet to render the table widget.
```dart
DTFLTable(
  columns: [
    DTFLTableColumn(
        key: "id",
        label: "Id",
        fixed: DTTableColumnFixedPosition.leading),
    DTFLTableColumn(key: "name", label: "Name"),
    DTFLTableColumn(key: "email", label: "Email"),
    DTFLTableColumn(key: "phone", label: "Phone"),
    DTFLTableColumn(key: "col5", label: "Column 5"),
    DTFLTableColumn(key: "col6", label: "Column 6")
  ],
  rows: List.generate(150, (index) {
    return DTFLTableRow(
      id: "$index",
      cells: [
        DTFLTableCell(
          key: "id",
          cell: Text((index).toString()),
        ),
        DTFLTableCell(
          key: "name",
          cell: Text("Full name $index"),
        ),
        DTFLTableCell(
          key: "email",
          cell: Text("email$index@ifour.io"),
        ),
        DTFLTableCell(
          key: "phone",
          cell: Text("+919999999${index + 1}"),
        ),
        DTFLTableCell(
          key: "col5",
          cell: Text("Col5 ${index + 1}"),
        ),
        DTFLTableCell(
          key: "col6",
          cell: Text("Col6 ${index + 1}"),
        ),
      ],
    );
  }).toList(),
)
```