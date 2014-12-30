Superseeder
===========

Description
-----------
Easily seed your Rails models from worksheet, including relations.

Use Case
-----------
Add seed files in your favorite format in `db/seeds/data`.

In `db/seeds/seeds.rb`, just

```ruby
include Superseeder
seed :cars
seed :parkings
```

and use `rake db:seed` as usual to see your database filling up!

Gem dependencies
----------------
You do not need any gem dependency for `csv` files.
For other formats, you **must** add the gem dependencies yourself in your application's `Gemfile`.

format|gem|version
------|---|-------
xls|roo-xls|
xlsx|roo|>=1.13.2
OpenOffice/LibreOffice|roo|>=1.13.2
Google Sheet|roo-google|

Relations
-------------
Let say you want to seed the models with the following relations:

```ruby
model Car < ActiveRecord::Base
  belongs_to :parking
  validates :name, :presence => true
end

model Parking < ActiveRecord::Base
  has_many :cars
  validates :name, :presence => true, :uniqueness => true
end
```

**`Mongoid` models are also supported!**

Your seed file are expected to look like:

 `db/seeds/data/cars.csv`

 name|parking_name
 ----|------------
 Mustang|south
 Corvette|north
 BMW|south

 `db/seeds/parkings.csv`

 name|
 ----|-
 south|
 east|
 west|
 north|

```ruby
 # db/seeds/seeds.rb
 include Superseeder
 seed :parkings
 seed :cars
```

Note that the `parking` relations are set through `name`. You can match any **unique** column of a model\`s relation
by titling the column **`relation_column`**.

You can of course seed relations the other way around:

 `db/seeds/data/cars.csv`

 name|
 ----|-
 Mustang|
 Corvette|
 BMW|

 `db/seeds/parkings.csv`

 name|cars_name
 ----|----
 south|Mustang,BMW
 east|
 west|
 north|Corvette

```ruby
 # db/seeds/seeds.rb
 include Superseeder
 seed :cars
 seed :parkings
```

Handling things yourself
------------------------

If you want to apply special logic for a seed, just pass a block to seed:
```ruby
seed :cars do |row|
  #Do it your way
end
```
each row of the seed file will be passed as a hash.

Seeding from models
------------------------
You can allow a model to seed itself from a file:

```ruby
model Car
  extend Superseeder::Seedable
end
Car.seed
```

Options
------------------------
`seed` takes a number of options:
 * `:filename` to specify a file name not matching a model name

```ruby
   seed :cars, :filename => 'last_dump.csv'
```

 * `:many_sep` to specify what separate references to array relations (`has_many`, `has_and_belongs_to_many`, `embeds_many`).

With `csv` files, you can specify the column separator:
 ```ruby
 seed :cars, :col_sep => ';'
 ```

Contributing / Seeds from other file formats
------------------
I appreciate any help to make this gem more robust and flexible, please pull! :)

If you want to add support for other formats, here's how to do it:

Add a module in the superseeder format namespace that look like:

 ```ruby
 # my_format.rb
 module Superseeder
   module Formats
     module MyFormat

       def self.extensions
       # list of supported extensions
       end

       def __process(path, *args)
         # Add code for parsing your format.
       end
     end
   end
 end
```

LICENSE
-------

(The MIT License)

Copyright © 2014 Olivier Milla

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the ‘Software’), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

