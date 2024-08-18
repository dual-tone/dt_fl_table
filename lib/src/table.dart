import 'dart:async';

import 'package:flutter/material.dart';

import 'table_view.dart';
import 'models/table_column.dart';
import 'models/table_events.dart';
import 'models/table_pagination.dart';
import 'models/table_row.dart';
import 'models/table_style.dart';

class DTFLTable extends StatefulWidget {
  final List<DTFLTableColumn> columns;
  final List<DTFLTableRow> rows;
  final List<Widget>? tableLeadingActions;
  final List<Widget>? tableTrailingActions;
  final DTFLTablePagination? pagination;
  final Set<String>? initialSelection;
  final DTFLTableStyle? tableStyle;
  final bool? selectable;
  final Widget? showLoader;
  final Function(DTFLTableEvents)? onEvent;

  const DTFLTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pagination,
    this.selectable,
    this.tableLeadingActions,
    this.tableTrailingActions,
    this.tableStyle,
    this.onEvent,
    this.showLoader,
    this.initialSelection,
  });

  @override
  State<DTFLTable> createState() => DTFLTableView();
}

abstract class DTFLTableState extends State<DTFLTable> {
  ScrollController tableHeaderScrollController = ScrollController();
  ScrollController tableBodyHorizontalScrollController = ScrollController();
  ScrollController tableBodyVerticalScrollController = ScrollController();
  ScrollController tableFixedColScrollController = ScrollController();

  final double checkboxColumnWidth = 53;
  double rowHeight = 45;
  double headerHeight = 45;
  EdgeInsets cellPadding = const EdgeInsets.symmetric(
    horizontal: 13,
  );
  Color borderColor = Colors.black38;
  Color? alternateRowColor;

  List<DTFLTableRow> _totalRows = [];
  List<DTFLTableRow> rows = [];
  StreamController<Set<String>> selectedStream =
      StreamController<Set<String>>.broadcast();
  StreamController<DTFLTablePagination> paginationStream =
      StreamController<DTFLTablePagination>.broadcast();

  Function(DTFLTableEvents)? onEvent;

  @override
  void initState() {
    super.initState();

    // Synchronise the header and body scroll movement
    tableBodyHorizontalScrollController.addListener(() {
      tableHeaderScrollController.animateTo(
        tableBodyHorizontalScrollController.offset,
        duration: const Duration(milliseconds: 5),
        curve: Curves.linear,
      );
    });
    tableBodyVerticalScrollController.addListener(() {
      tableFixedColScrollController.animateTo(
        tableBodyVerticalScrollController.offset,
        duration: const Duration(milliseconds: 5),
        curve: Curves.linear,
      );
    });
  }

  configureTableDefaults() {
    rowHeight = widget.tableStyle?.rowHeight ?? rowHeight;
    cellPadding = widget.tableStyle?.cellPadding ?? cellPadding;
    borderColor = widget.tableStyle?.borderColor ?? borderColor;
    alternateRowColor = widget.tableStyle?.showAlternateRowColor == true
        ? (widget.tableStyle?.alternateRowColor ?? Colors.black12)
        : null;

    DTFLTablePagination p =
        (widget.pagination ?? DTFLTablePagination(enabled: false)).copyWith(
      position: widget.pagination?.position ?? MainAxisAlignment.end,
      pageSizes: widget.pagination?.pageSizes ?? [5, 25, 50],
      selectedPageSize: widget.pagination?.selectedPageSize ??
          widget.pagination?.pageSizes?.first ??
          5,
      rowsPerPage: widget.pagination?.rowsPerPage ?? 25,
      currentPage: 1,
      totalRows: widget.rows.length,
    );
    _totalRows = widget.rows;
    rows = widget.rows;

    if (p.enabled == true && p.asynchronous != true) {
      rows = _totalRows.take(p.selectedPageSize!).toList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedStream.sink.add(widget.initialSelection ?? {});
      paginationStream.sink.add(p);
    });

    onEvent = widget.onEvent;
  }

  onSelectAll(bool val) {
    switch (val) {
      case true:
        Set<String> newSelection = rows.map((r) => r.id).toSet();
        selectedStream.sink.add(newSelection);

        if (onEvent != null) {
          onEvent!(DTFLTableOnSelection(selected: newSelection));
        }
        break;
      case false:
        selectedStream.sink.add({});
        if (onEvent != null) {
          onEvent!(DTFLTableOnSelection(selected: {}));
        }
        break;
    }
  }

  onSelection(Set<String> selection, String key, bool val) async {
    switch (val) {
      case true:
        selection.add(key);
        selectedStream.sink.add(selection);
        if (onEvent != null) {
          onEvent!(DTFLTableOnSelection(selected: selection));
        }
        break;
      case false:
        selection.remove(key);
        selectedStream.sink.add(selection);
        if (onEvent != null) {
          onEvent!(DTFLTableOnSelection(selected: selection));
        }
        break;
    }
  }

  onPaginationEvent(DTFLTableEvents event) {

    if (event is DTFLTableOnGoOnePageBackward &&
        event.pagination.asynchronous == true) {
      emitPaginationEvent(event);
      return;
    }
    if (event is DTFLTableOnGoOnePageForward &&
        event.pagination.asynchronous == true) {
      emitPaginationEvent(event);
      return;
    }
    if (event is DTFLTableOnGoToFirstPage &&
        event.pagination.asynchronous == true) {
      emitPaginationEvent(event);
      return;
    }
    if (event is DTFLTableOnGoToLastPage &&
        event.pagination.asynchronous == true) {
      emitPaginationEvent(event);
      return;
    }
    if (event is DTFLTableOnPageSizeChange &&
        event.pagination.asynchronous == true) {
      emitPaginationEvent(event);
      return;
    }

    if (event is DTFLTableOnGoOnePageForward) {
      List<DTFLTableRow> r = _totalRows
          .skip(event.pagination.currentPage! *
              event.pagination.selectedPageSize!)
          .take(event.pagination.selectedPageSize!)
          .toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: event.pagination.currentPage! + 1,
      ));
    }
    if (event is DTFLTableOnGoOnePageBackward) {
      List<DTFLTableRow> r = _totalRows
          .skip(((event.pagination.currentPage! - 1) *
                  event.pagination.selectedPageSize!) -
              event.pagination.selectedPageSize!)
          .take(event.pagination.selectedPageSize!)
          .toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: event.pagination.currentPage! - 1,
      ));
    }
    if (event is DTFLTableOnGoToLastPage) {
      List<DTFLTableRow> r = _totalRows
          .skip((event.pagination.totalPages! - 1) *
              event.pagination.selectedPageSize!)
          .take(event.pagination.selectedPageSize!)
          .toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: event.pagination.totalPages!,
      ));
    }
    if (event is DTFLTableOnGoToFirstPage) {
      List<DTFLTableRow> r =
          _totalRows.take(event.pagination.selectedPageSize!).toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: 1,
      ));
    }
    if (event is DTFLTableOnPageSizeChange) {
      List<DTFLTableRow> r = _totalRows.take(event.selectedPageSize).toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: 1,
        selectedPageSize: event.selectedPageSize,
      ));
    }
  }

  emitPaginationEvent(DTFLTableEvents event) {
    if (onEvent != null) {
      onEvent!(event);
      return;
    }

    debugPrint("Pagination event fired. No handler registered.");
  }

  calculateColumnWidth(DTFLTableColumn col, double availableWidth) =>
      col.widthInPercentage != null
          ? switch (col.widthInPercentage ?? 0) {
              > 0 => col.widthInPercentage! * (availableWidth / 100),
              _ => null,
            }
          : col.width != null
              ? switch (col.width ?? 0) {
                  > 0 => col.width!,
                  _ => null,
                }
              : null;
}
