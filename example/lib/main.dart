import 'package:dt_fl_table/dt_fl_table.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DTFL Table Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DTFL Table Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: DTFLTable(
                columns: [
                  DTFLTableColumn(
                    key: "id",
                    label: "Id",
                    fixed: DTFLTableColumnFixedPosition.leading,
                  ),
                  DTFLTableColumn(key: "name", label: "Name"),
                  DTFLTableColumn(key: "email", label: "Email"),
                  DTFLTableColumn(key: "phone", label: "Phone"),
                  DTFLTableColumn(key: "col5", label: "Column 5"),
                  DTFLTableColumn(key: "col6", label: "Column 6")
                ],
                rows: List.generate(150, (index) {
                  return DTFLTableRow(
                    id: "0",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
