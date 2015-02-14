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
  * [2.3 Row](#23-iteration)
* [3 Rendering](#3-rendering)
* [2.3 Multiline](#23-multiline)
* [2.4 Border](#24-border)
* [2.5 Alignment](#25-alignment)
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

###  2.3

```ruby
table[i, j]               # return element at row(i) and column(j)
table.row(i) { ... }      # return array for row(i)
table.column(j) { ... }   # return array for column(j)
table.column(name)        # return array for column(name), name of header
```

```ruby 2.4
table.row_size            # return row size
table.column_size         # return column size
table.size                # return an array of [row_size, column_size]
```

### 3 Rendering

Once you have an instance of `TTY::Table` you can print it out to the stdout like so:

```ruby
table.to_s

a1  a2  a3
b1  b2  b3
```

This will use so called `basic` renderer with default options.

However, you can include other customization options such as

```ruby
border         # hash of border properties out of :characters, :style, :separator keys
border_class   # a type of border to use
column_widths  # array of maximum columns widths
column_aligns  # array of cell alignments out of :left, :center and :right, default :left
filter         # a proc object that is applied to every field in a row
indent         # indentation applied to rendered table
multiline      # if true will wrap text at new line or column width,
               # when false will escape special characters
orientation    # either :horizontal or :vertical
padding        # array of integers to set table fields padding
renderer       # enforce display type out of :basic, :color, :unicode, :ascii
resize         # if true will expand/shrink table column sizes to match the width,
               # otherwise if false rotate table vertically
width          # constrain the table total width, otherwise dynamically
               # calculated from content and terminal size
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

### 2.5 Alignment

All columns are left aligned by default. You can enforce per column alignment by passing `column_aligns` option like so

```ruby
rows = [['a1', 'a2'], ['b1', 'b2']
table = TTY::Table.new rows: rows
table.render column_aligns: [:center, :right]
```

To align a single column do

```ruby
table.align_column(1, :right)
```

If you require a more granular alignment you can align individual fields in a row by passing `align` option

```ruby
table = TTY::Table.new do |t|
  t << ['a1', 'a2', 'a3']
  t << ['b1', {:value => 'b2', :align => :right}, 'b3']
  t << ['c1', 'c2', {:value => 'c3', :align => :center}]
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
