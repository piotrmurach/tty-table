0.2.0 (Mar 30, 2015)

* Add UTF-8 support for operations
* Add AlignmentSet for alignments storage
* Add tests for multilne column widths

* Remove padding from wrapped operation to fully rely on Verse.wrap
* Remove color renderer
* Remove adjust_padding from Columns

* Change Table each_with_index to iterate over rows
* Change Alignment operation to use AlignmentSet
* Change Columns to directly depend on table data
* Change Indentation to stop relying on renderer
* Change Border to accept padding as argument
* Change and extract padding operation
* Change Columns to ColumnConstraint and refactor enforce

* Fix table rendering for UTF-8 content
* Fix alignment to allow for individual field alignment
* Fix bug with padding operation
* Fix table border and content coloring
* Fix bug with table rerendering to allow for multiple renders
* Fix bug with ANSI codes in table content
