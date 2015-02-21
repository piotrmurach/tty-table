# TTY::Table

[![Gem Version](https://badge.fury.io/rb/tty-table.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty-table.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty-table.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/tty-table/badge.png)][coverage]

[gem]: http://badge.fury.io/rb/tty-table
[travis]: http://travis-ci.org/peter-murach/tty-table
[codeclimate]: https://codeclimate.com/github/peter-murach/tty-table
[coverage]: https://coveralls.io/r/peter-murach/tty-table

> A flexible and intuitive table generator.

**TTY::Table** provides independent table formatting component for [TTY](https://github.com/peter-murach/tty) toolkit.

## Features

* Create table once and render using custom view renderers [see]()
* Supports multibyte character encodings
* Table behaves like an array with familiar API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tty-table'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty-table

## Contents

* [1. Usage](#1-usage)
* [2. Interface](#2-interface)
  * [2.1 Initialization](#21-initialization)
  * [2.2 Iteration](#22-iteration)
  * [2.3 Access](#23-access)
  * [2.4 Size](#24-size)
* [3 Rendering](#3-rendering)
  * [3.1 Render](#31-render)
  * [3.2 Renderer](#32-renderer)
    * [3.1.1 Basic renderer](#311-basic)
    * [3.1.2 ASCII renderer](#312-ascii-renderer)
    * [3.1.3 Unicode renderer](#313-unicode-renderer)
  * [3.3 Options](#33-options)
  * [3.4 Alignment](#34-alignment)

* [2.3 Multiline](#23-multiline)
* [2.4 Border](#24-border)
* [2.6 Padding](#26-padding)
* [2.7 Filter](#27-filter)
* [2.8 Width](#28-width)

## 1. Usage

First, provide **TTY::Table** with headers and data:

```ruby
table = TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]
```

Then simply call `render` or `to_s` on the instance:

```ruby
table.render
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |a2     |
  +-------+-------+
  |b1     |b2     |
  +-------+-------+
```

## 2. Interface

### 2.1 Initialization

**TTY::Table** can be created in variety of ways. The easiest way is to pass 2-dimensional array:

```ruby
table = TTY::Table[['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new [['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new rows: [['a1', 'a2'], ['b1', 'b2']]
```

Alternatively you can specify rows one by one inside block:

```ruby
table = TTY::Table.new do |t|
  t << ['a1', 'a2']
  t << ['b1', 'b2']
end
```

You can add rows of data after initialization:

```ruby
table = TTY::Table.new
table << ['a1','a2']
table << ['b1','b2']
```

In addition to rows you can specify table header:

```ruby
table = TTY::Table.new ['h1', 'h2'], [['a1', 'a2'], ['b1', 'b2']]
table = TTY::Table.new header: ['h1', 'h2'], rows: [['a1', 'a2'], ['b1', 'b2']]
```

or cross header with rows inside a hash like so

```ruby
table = TTY::Table.new [{'h1' => ['a1', 'a2'], 'h2' => ['b1', 'b2']}]
```

### 2.2 Iteration

Table behaves like an Array so `<<`, `each` and familiar methods can be used:

```ruby
table << ['a1', 'a2', 'a3']
table << ['b1', 'b2', 'b3']
table << ['a1', 'a2'] << ['b1', 'b2']  # chain rows assignment
```

In order to iterate over table rows including headers do:

```ruby
table.each { |row| ... }                       # iterate over rows
table.each_with_index  { |row, index| ... }    # iterate over rows with an index
```

### 2.3 Access

In order to referene the row at `index` do:

```ruby
table = TTY::Table.new [['a1','a2'], ['b1','b2']]
table[0]                    # => ['a1','a2']
table.row(0)                # => ['a1','a2']
table.row(i) { |row| ... }  # return array for row(i)
```

Negative indices count backwards from the end of table data (`-1` is the last element):

```ruby
table[-1]   # => ['b1','b2']
```

To reference element at given row(i) and column(j) do:

```ruby
table[i, j]   # return element at row(i) and column(j)
table[0,0]    # => 'a1'
```

To specifically reference column(j) do:

```ruby
table.column(j) { ... }   # return array for column(j)
table.column(0)           # => ['a1','b1']
table.column(name)        # return array for column(name), name of header
```

An `IndexError` is raised for indexes outside of data range.

### 2.4 Size

In order to query the number of rows, columns or size do:

```ruby
table.rows_size        # return row size
table.columns_size     # return column size
table.size             # return an array of [row_size, column_size]
```

### 2.5 Orientation

## 3 Rendering

**TTY-Table** rendering process means you can create tabular data once and then create different renderers to match your needs for formatting the data.

### 3.1 Render

Given a table:

```ruby
table = TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]
```

Once you have an instance of `TTY::Table` you can decorate the content using the `render` method. In order to display a basic whitespace delimited view do:

```ruby
table.render(:basic)
# =>
  header1 header2
  a1      a2
  b1      b2
```

This will use so called `:basic` renderer with default options. The other renderers are `:ascii` and `:unicode`.

### 3.2 Renderer

**TTY::Table** has a definition of `TTY::Table::Renderer` which allows you to provide different view for your tabular data. It comes with few initial renderers built in such as `TTY::Table::Renderer::Basic`, `TTY::Table::Rendere::ASCII` and `TTY::Table::Renderer:Unicode`.

Given a table of data:

```ruby
table = TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]
```

You can create a special renderer for it:

```ruby
multi_renderer = TTY::Table::Renderer::Basic.new(table, multiline: true)
```

and then call `render`

```ruby
multi_renderer.render
```

This way, you create tabular data once and then create different renderers to match your needs for formatting the data.

#### 3.2.1 Basic Renderer

The basic render allows for formatting table with whitespace without any border:

```ruby
renderer = TTY::Table::Renderer::Basic.new(table)
```

```ruby
renderer.render
# =>
  header1 header2
  a1      a2
  b1      b2
```

This is the same as calling `render` directly on table:

```ruby
table.render
```

#### 3.2.2 ASCII Renderer

The ascii renderer allows for formatting table with ASCII type border.

Create an instance of ASCII renderer:

```ruby
renderer = TTY::Table::Renderer::ASCII.new(table)
```

and then call `render` to get the formatted data:

```ruby
renderer.render
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |a2     |
  |b1     |b2     |
  +-------+-------+
```

This is the same as calling `render` directly on table instance with `:ascii` as the first argument:

```ruby
table.render(:ascii)
```

#### 3.2.3 Unicode Renderer

The uniocde renderer allows for formatting table with Unicode type border.

Create an instance of Unicode renderer:

```ruby
renderer = TTY::Table::Renderer::Unicode.new(table)
```

and then call `render` to get the formatted data:

```ruby
renderer.render
# =>
  ┌───────┬───────┐
  │header1│header2│
  ├───────┼───────┤
  │a1     │a2     │
  │b1     │b2     │
  └───────┴───────┘
```

This is the same as calling `render` directly on table instance with `:unicode` as the first argument:

```ruby
table.render(:unicode)
```

### 3.3 Options

Rendering of **TTY-Table** includes numerous customization options:

```ruby
alignments     # array of cell alignments out of :left, :center and :right,
               # default :left
border         # hash of border options - :characters, :style and :separator
border_class   # a type of border to use such as TTY::Table::Border::Null,
               # TTY::Table::Border::ASCII, TTY::Table::Border::Unicode
column_widths  # array of maximum column widths
filter         # a proc object that is applied to every field in a row
indent         # indentation applied to rendered table, by default 0
multiline      # if true will wrap text at new line or column width,
               # when false will escape special characters
padding        # array of integers to set table fields padding,
               # by default [0,0,0,0]
resize         # if true will expand/shrink table column sizes to match
               # the terminal width, otherwise if false will rotate
               # table vertically. By default set to false
width          # constrain the table total width, by default dynamically
               # calculated based on content and terminal size
```

### 3.4 Alignment

By default all columns are `:left` aligned.

You can align each column by passing `alignments` option to table renderer:

```ruby
table.render :ascii, alignments: [:center, :right]
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |  a1   |     a2|
  |  b1   |     b2|
  +-------+-------+
```

If you require a more granular alignment you can align individual fields in a row by passing `:alignment` option like so:

```ruby
table = TTY::Table.new header: ['header1', 'header2']
table << [{value: 'a1', alignment: :right}, 'a2']
table << ['b1', {value: 'b2', alignment: :center}]
```

and then simply render:

```ruby
table.render(:ascii)
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |     a1|a2     |
  |b1     |  b2   |
  +-------+-------+
```



### 2.3 Multiline

Renderer options may include `multiline` parameter. The `true` value will cause the table fields wrap at their natural line breaks or in case when the column widths are set the content will wrap.

```ruby
table = TTY::Table.new [ ["First", '1'], ["Multi\nLine\nContent", '2'], ["Third", '3']]
table.render :ascii, multiline: true
# =>
  +-------+-+
  |First  |1|
  |Multi  |2|
  |Line   | |
  |Content| |
  |Third  |3|
  +-------+-+
```

When the `false` option is specified all the special characters will be escaped and if the column widths are set the content will be truncated like so

```ruby
table = TTY::Table.new [ ["First", '1'], ["Multiline\nContent", '2'], ["Third", '3']]
table.render :ascii, multiline: false
# =>
  +------------------+-+
  |First             |1|
  |Multiline\nContent|2|
  |Third             |3|
  +------------------+-+
```

### 2.4 Border

To print border around data table you need to specify `renderer` type out of `basic`, `ascii`, `unicode`. By default `basic` is used. For instance, to output unicode border:

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render :unicode
# =>
  ┌───────┬───────┐
  │header1│header2│
  ├───────┼───────┤
  │a1     │a2     │
  │b1     │b2     │
  └───────┴───────┘
```

You can also create your own custom border by subclassing `TTY::Table::Border` and implementing the `def_border` method using internal DSL methods like so:

```ruby
class MyBorder < TTY::Table::Border
  def_border do
    left         '$'
    center       '$'
    right        '$'
    bottom       ' '
    bottom_mid   '*'
    bottom_left  '*'
    bottom_right '*'
  end
end
```

Next pass the border class to your table instance `render_with` method

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render_with MyBorder
# =>
  $header1$header2$
  $a1     $a2     $
  *       *       *
```

Finally, if you want to introduce slight modifications to the predefined border types, you can use table `border` helper like so

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render do |renderer|
  renderer.border do
    mid          '='
    mid_mid      ' '
  end
end
# =>
  header1 header2
  ======= =======
  a1      a2
  b1      b2
```

In addition to specifying border characters you can force table to render separator line on each row like:

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']]
table.render do |renderer|
  renderer.border.separator = :each_row
end
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |a2     |
  +-------+-------+
  |b1     |b2     |
  +-------+-------+
```

Also to change the display color of your border do:

```ruby
table.render do |renderer|
  renderer.border.style = :red
end
```


#### 2.6 Padding

By default padding is not applied. You can add `padding` to table fields like so

```ruby
header = ['Field', 'Type', 'Null', 'Key', 'Default', 'Extra']
rows  = [['id', 'int(11)', 'YES', 'nil', 'NULL', '']]
table = TTY::Table.new(header, rows)
table.render { |renderer| renderer.padding= [0,1,0,1] }
# =>
  +-------+---------+------+-----+---------+-------+
  | Field | Type    | Null | Key | Default | Extra |
  +-------+---------+------+-----+---------+-------+
  | id    | int(11) | YES  | nil | NULL    |       |
  +-------+---------+------+-----+---------+-------+
```

or you can set specific padding using `right`, `left`, `top`, `bottom` helpers. However, when adding top or bottom padding a `multiline` option needs to be set to `true` to allow for rows to span multiple lines. For example

```ruby
table.render { |renderer|
  renderer.multiline = true
  renderer.padding.top = 1
}
# =>
  +-----+-------+----+---+-------+-----+
  |     |       |    |   |       |     |
  |Field|Type   |Null|Key|Default|Extra|
  +-----+-------+----+---+-------+-----+
  |     |       |    |   |       |     |
  |id   |int(11)|YES |nil|NULL   |     |
  +-----+-------+----+---+-------+-----+
```

### 2.7 Filter

You can define filters that will modify individual table fields value before they are rendered. A filter can be a callable such as proc. Here's an example that formats

```ruby
table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
table.render do |renderer|
  renderer.filter = Proc.new do |val, row_index, col_index|
    if col_index == 1 and !(row_index == 0)
      val.capitalize
    else
      val
    end
  end
end
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |A2     |
  +-------+-------+
  |b1     |B2     |
  +-------+-------+
```

To color even fields red on green background add filter like so

```ruby
table.render do |renderer|
  renderer.filter = proc do |val, row_index, col_index|
    col_index % 2 == 1 ? TTY.color.set(val, :red, :on_green) : val
  end
end
```

### 2.8 Width

To control table's column sizes pass `width`, `resize` options. By default table's natural column widths are calculated from the content. If the total table width does not fit in terminal window then the table is rotated vertically to preserve content.

The `resize` property will force the table to expand/shrink to match the terminal width or custom `width`. On its own the `width` property will not resize table but only enforce table vertical rotation if content overspills.

```ruby
header = ['h1', 'h2', 'h3']
rows   = [['aaa1', 'aa2', 'aaaaaaa3'], ['b1', 'b2', 'b3']]
table = TTY::Table.new header, rows
table.render width: 80, resize: true
# =>
  +---------+-------+------------+
  |h1       |h2     |h3          |
  +---------+-------+------------+
  |aaa1     |aa2    |aaaaaaa3    |
  |b1       |b2     |b3          |
  +---------+-------+------------+
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tty-table/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2015 Piotr Murach. See LICENSE for further details.
