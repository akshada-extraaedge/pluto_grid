import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../helper/column_helper.dart';
import '../../../helper/row_helper.dart';
import '../../../mock/mock_pluto_scroll_controller.dart';

void main() {
  group('currentRowIdx', () {
    testWidgets('currentCell 이 선택되지 않는 경우 null 을 리턴해야 한다.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('left',
            count: 3, fixed: PlutoColumnFixed.Left),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, fixed: PlutoColumnFixed.Right),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      int currentRowIdx = stateManager.currentRowIdx;

      // when
      expect(currentRowIdx, null);
    });

    testWidgets('currentCell 이 선택 된 경우 선택 된 셀의 rowIdx 를 리턴해야 한다.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('left',
            count: 3, fixed: PlutoColumnFixed.Left),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, fixed: PlutoColumnFixed.Right),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      stateManager.setLayout(BoxConstraints());

      // when
      String selectColumnField = 'right1';
      stateManager.setCurrentCell(rows[7].cells[selectColumnField], 7);

      int currentRowIdx = stateManager.currentRowIdx;

      // when
      expect(currentRowIdx, 7);
    });
  });

  group('currentRow', () {
    testWidgets('currentCell 이 선택되지 않는 경우 null 을 리턴해야 한다.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('left',
            count: 3, fixed: PlutoColumnFixed.Left),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, fixed: PlutoColumnFixed.Right),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      PlutoRow currentRow = stateManager.currentRow;

      // when
      expect(currentRow, null);
    });

    testWidgets('currentCell 이 선택 된 경우 선택 된 row 를 리턴해야 한다.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('left',
            count: 3, fixed: PlutoColumnFixed.Left),
        ...ColumnHelper.textColumn('body', count: 3, width: 150),
        ...ColumnHelper.textColumn('right',
            count: 3, fixed: PlutoColumnFixed.Right),
      ];

      List<PlutoRow> rows = RowHelper.count(10, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      stateManager.setLayout(BoxConstraints());

      // when
      String selectColumnField = 'left1';
      stateManager.setCurrentCell(rows[3].cells[selectColumnField], 3);

      PlutoRow currentRow = stateManager.currentRow;

      // when
      expect(currentRow, isNot(null));
      expect(currentRow.key, rows[3].key);
    });
  });

  group('setSortIdxOfRows', () {
    testWidgets(
        'The sortIdx value of rows should be increased from 0 and filled.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      final rowsFilledSortIdx = stateManager.setSortIdxOfRows(rows);

      // then
      expect(rowsFilledSortIdx[0].sortIdx, 0);
      expect(rowsFilledSortIdx[1].sortIdx, 1);
      expect(rowsFilledSortIdx[2].sortIdx, 2);
      expect(rowsFilledSortIdx[3].sortIdx, 3);
      expect(rowsFilledSortIdx[4].sortIdx, 4);
    });

    testWidgets(
        'The sortIdx value of rows should be decrease from 4 and filled.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      final rowsFilledSortIdx = stateManager.setSortIdxOfRows(
        rows,
        increase: false,
        start: 4,
      );

      // then
      expect(rowsFilledSortIdx[0].sortIdx, 4);
      expect(rowsFilledSortIdx[1].sortIdx, 3);
      expect(rowsFilledSortIdx[2].sortIdx, 2);
      expect(rowsFilledSortIdx[3].sortIdx, 1);
      expect(rowsFilledSortIdx[4].sortIdx, 0);
    });
  });

  group('prependNewRows', () {
    testWidgets(
      'count 기본값 1 만큼 rows 앞쪽에 추가 되어야 한다.',
      (WidgetTester tester) async {
        // given
        List<PlutoColumn> columns = [
          ...ColumnHelper.textColumn('text', count: 3, width: 150),
        ];

        List<PlutoRow> rows = RowHelper.count(5, columns);

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );

        // when
        stateManager.prependNewRows();

        // then
        expect(stateManager.rows.length, 6);
        // 원래 있던 첫번 째 Row 의 셀이 두번 째로 이동
        expect(stateManager.rows[1].cells['text0'].value, 'text0 value 0');
      },
    );

    testWidgets(
      'count 5 만큼 rows 앞쪽에 추가 되어야 한다.',
      (WidgetTester tester) async {
        // given
        List<PlutoColumn> columns = [
          ...ColumnHelper.textColumn('text', count: 3, width: 150),
        ];

        List<PlutoRow> rows = RowHelper.count(5, columns);

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );

        // when
        stateManager.prependNewRows(count: 5);

        // then
        expect(stateManager.rows.length, 10);
        // 원래 있던 첫번 째 Row 의 셀이 6번 째로 이동
        expect(stateManager.rows[5].cells['text0'].value, 'text0 value 0');
      },
    );
  });

  group('prependRows', () {
    testWidgets('A new row must be added before the existing row.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      PlutoRow newRow = RowHelper.count(1, columns).first;

      // when
      stateManager.prependRows([newRow]);

      // then
      expect(stateManager.rows[0].key, newRow.key);
      expect(stateManager.rows.length, 6);
    });

    testWidgets('Row is not added when passing an empty array.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      stateManager.prependRows([]);

      // then
      expect(stateManager.rows.length, 5);
    });

    testWidgets(
        'WHEN currentCell 이 있는 상태에서 '
        'THEN '
        'currentRowIdx 와 currentCellPosition 이 '
        'rows 가 추가 된 만큼에 따라 업데이트 되어야 한다.', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: MockPlutoScrollController(),
      );

      stateManager.setLayout(BoxConstraints());

      final int rowIdxBeforePrependRows = 0;

      stateManager.setCurrentCell(
          rows.first.cells['text1'], rowIdxBeforePrependRows);

      expect(stateManager.currentRowIdx, rowIdxBeforePrependRows);

      List<PlutoRow> newRows = RowHelper.count(5, columns);

      // when
      stateManager.prependRows(newRows);

      // then
      // 앞에 새로운 Row 가 추가 되면 현재 idx 에 추가 된 row 수량 만큼 더해 포커스를 유지.
      final rowIdxAfterPrependRows = newRows.length + rowIdxBeforePrependRows;

      expect(stateManager.currentRowIdx, rowIdxAfterPrependRows);

      expect(stateManager.currentCellPosition.columnIdx, 1);

      expect(stateManager.currentCellPosition.rowIdx, rowIdxAfterPrependRows);
    });

    testWidgets(
        'WHEN _currentSelectingPosition 이 있는 상태에서 '
        'THEN currentSelectingPosition 이 업데이트 되어야 한다.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: MockPlutoScrollController(),
      );

      final int rowIdxBeforePrependRows = 3;

      stateManager.setCurrentSelectingPosition(
        columnIdx: 2,
        rowIdx: rowIdxBeforePrependRows,
      );

      expect(
        stateManager.currentSelectingPosition.rowIdx,
        rowIdxBeforePrependRows,
      );

      List<PlutoRow> newRows = RowHelper.count(7, columns);

      // when
      stateManager.prependRows(newRows);

      // then
      expect(stateManager.currentSelectingPosition.columnIdx, 2);

      expect(
        stateManager.currentSelectingPosition.rowIdx,
        newRows.length + rowIdxBeforePrependRows,
      );
    });
  });

  group('appendNewRows', () {
    testWidgets(
      'count 기본값 1 만큼 rows 뒤쪽에 추가 되어야 한다.',
      (WidgetTester tester) async {
        // given
        List<PlutoColumn> columns = [
          ...ColumnHelper.textColumn('text', count: 3, width: 150),
        ];

        List<PlutoRow> rows = RowHelper.count(5, columns);

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );

        // when
        stateManager.appendNewRows();

        // then
        expect(stateManager.rows.length, 6);
        // 마지막 Row 에 추가 됨
        expect(
          stateManager.rows[5].cells['text0'].value,
          columns[0].type.defaultValue,
        );
      },
    );

    testWidgets(
      'count 5 만큼 rows 뒤쪽에 추가 되어야 한다.',
      (WidgetTester tester) async {
        // given
        List<PlutoColumn> columns = [
          ...ColumnHelper.textColumn('text', count: 3, width: 150),
        ];

        List<PlutoRow> rows = RowHelper.count(5, columns);

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );

        // when
        stateManager.appendNewRows(count: 5);

        // then
        expect(stateManager.rows.length, 10);
        // 추가 된 5~9 번 셀의 기본 값
        expect(
          stateManager.rows[5].cells['text0'].value,
          columns[0].type.defaultValue,
        );
        expect(
          stateManager.rows[9].cells['text0'].value,
          columns[0].type.defaultValue,
        );
      },
    );
  });

  group('appendRows', () {
    testWidgets('New rows must be added after the existing row.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      List<PlutoRow> newRows = RowHelper.count(2, columns);

      // when
      stateManager.appendRows(newRows);

      // then
      expect(stateManager.rows[5].key, newRows[0].key);
      expect(stateManager.rows[6].key, newRows[1].key);
      expect(stateManager.rows.length, 7);
    });

    testWidgets('Row is not added when passing an empty array.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      stateManager.appendRows([]);

      // then
      expect(stateManager.rows.length, 5);
    });
  });

  group('getNewRow', () {
    testWidgets(
      'Should be returned a row including cells filled with defaultValue of the column',
      (WidgetTester tester) async {
        // given
        List<PlutoColumn> columns = [
          PlutoColumn(
            title: 'text',
            field: 'text',
            type: PlutoColumnType.text(defaultValue: 'default text'),
          ),
          PlutoColumn(
            title: 'number',
            field: 'number',
            type: PlutoColumnType.number(defaultValue: 123),
          ),
          PlutoColumn(
            title: 'select',
            field: 'select',
            type: PlutoColumnType.select(['One', 'Two'], defaultValue: 'Two'),
          ),
          PlutoColumn(
            title: 'date',
            field: 'date',
            type: PlutoColumnType.date(
                defaultValue: DateTime.parse('2020-09-01')),
          ),
          PlutoColumn(
            title: 'time',
            field: 'time',
            type: PlutoColumnType.time(defaultValue: '23:59'),
          ),
        ];

        List<PlutoRow> rows = [];

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );

        // when
        PlutoRow newRow = stateManager.getNewRow();

        // then
        expect(newRow.cells['text'].value, 'default text');
        expect(newRow.cells['number'].value, 123);
        expect(newRow.cells['select'].value, 'Two');
        expect(newRow.cells['date'].value, DateTime.parse('2020-09-01'));
        expect(newRow.cells['time'].value, '23:59');
      },
    );
  });

  group('getNewRows', () {
    testWidgets(
      'count 기본값 1 만큼 생성 되어야 한다.',
      (WidgetTester tester) async {
        // given
        // given
        List<PlutoColumn> columns = [
          ...ColumnHelper.textColumn('text', count: 2),
        ];

        List<PlutoRow> rows = [];

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );
        // when
        List<PlutoRow> newRows = stateManager.getNewRows();

        // then
        expect(newRows.length, 1);
      },
    );

    testWidgets(
      'count 3 만큼 생성 되어야 한다.',
      (WidgetTester tester) async {
        // given
        // given
        List<PlutoColumn> columns = [
          ...ColumnHelper.textColumn('text', count: 2),
        ];

        List<PlutoRow> rows = [];

        PlutoStateManager stateManager = PlutoStateManager(
          columns: columns,
          rows: rows,
          gridFocusNode: null,
          scroll: null,
        );
        // when
        List<PlutoRow> newRows = stateManager.getNewRows(count: 3);

        // then
        expect(newRows.length, 3);
      },
    );
  });

  group('removeCurrentRow', () {
    testWidgets('Should not be removed rows, when currentRow is null.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      stateManager.removeCurrentRow();

      // then
      expect(stateManager.rows.length, 5);
    });

    testWidgets('Should be removed currentRow, when currentRow is not null.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      stateManager.setLayout(BoxConstraints());

      // when
      final currentRowKey = rows[3].key;

      stateManager.setCurrentCell(rows[3].cells['text1'], 3);

      stateManager.removeCurrentRow();

      // then
      expect(stateManager.rows.length, 4);
      expect(stateManager.rows[0].key, isNot(currentRowKey));
      expect(stateManager.rows[1].key, isNot(currentRowKey));
      expect(stateManager.rows[2].key, isNot(currentRowKey));
      expect(stateManager.rows[3].key, isNot(currentRowKey));
    });
  });

  group('removeRows', () {
    testWidgets('Should not be removed rows, when rows parameter is null.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      stateManager.removeRows(null);

      // then
      expect(stateManager.rows.length, 5);
    });

    testWidgets('Should be removed rows, when rows parameter is not null.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      final deleteRows = [rows[0], rows[1]];

      stateManager.removeRows(deleteRows);

      // then
      final deleteRowKeys =
          deleteRows.map((e) => e.key).toList(growable: false);

      expect(stateManager.rows.length, 3);
      expect(deleteRowKeys.contains(stateManager.rows[0].key), false);
      expect(deleteRowKeys.contains(stateManager.rows[1].key), false);
      expect(deleteRowKeys.contains(stateManager.rows[2].key), false);
    });

    testWidgets('Should be removed all rows', (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      // when
      final deleteRows = [...rows];

      stateManager.removeRows(deleteRows);

      // then
      expect(stateManager.rows.length, 0);
    });
  });

  group('updateCurrentRowIdx', () {
    testWidgets('When setCurrentCell, the _currentRowIdx value must be set.',
        (WidgetTester tester) async {
      // given
      List<PlutoColumn> columns = [
        ...ColumnHelper.textColumn('text', count: 3, width: 150),
      ];

      List<PlutoRow> rows = RowHelper.count(5, columns);

      PlutoStateManager stateManager = PlutoStateManager(
        columns: columns,
        rows: rows,
        gridFocusNode: null,
        scroll: null,
      );

      stateManager.setLayout(BoxConstraints());

      stateManager.setCurrentCell(rows[3].cells['text1'], 3);

      // when
      stateManager.updateCurrentRowIdx();

      // then
      expect(stateManager.currentRowIdx, 3);
    });
  });
}
