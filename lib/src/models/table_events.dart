
import 'table_pagination.dart';

sealed class DTFLTableEvents {}

class DTFLTableOnSelection extends DTFLTableEvents {
  Set<String> selected;

  DTFLTableOnSelection({required this.selected});
}

class DTFLTableOnGoOnePageForward extends DTFLTableEvents {
  DTFLTablePagination pagination;

  DTFLTableOnGoOnePageForward({required this.pagination});
}

class DTFLTableOnGoOnePageBackward extends DTFLTableEvents {
  DTFLTablePagination pagination;

  DTFLTableOnGoOnePageBackward({required this.pagination});
}

class DTFLTableOnGoToLastPage extends DTFLTableEvents {
  DTFLTablePagination pagination;

  DTFLTableOnGoToLastPage({required this.pagination});
}

class DTFLTableOnGoToFirstPage extends DTFLTableEvents {
  DTFLTablePagination pagination;

  DTFLTableOnGoToFirstPage({required this.pagination});
}

class DTFLTableOnPageSizeChange extends DTFLTableEvents {
  DTFLTablePagination pagination;
  int selectedPageSize;

  DTFLTableOnPageSizeChange({
    required this.pagination,
    required this.selectedPageSize,
  });
}
