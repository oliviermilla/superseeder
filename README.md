Superseeder
===========

Description
-----------
Easily seed your Rails models (and their relations) from sheet files.
Currently supported formats are .csv, .xls, .xlsx, .ods, .tsv., .yml. Support for other formats can easily be added and contributed back here. :)

The gem was written for Mongoid models (https://github.com/mongoid/mongoid). ActiveRecord support is on its way.

Use Case
-----------
Create a `db/seeds/data` folder. Add seed files in your favorite format.

In `db/seeds/seeds.rb`:

```ruby
include Superseeder
seed :cars
seed :parkings
```

Use `rake db:seed` as usual to see your database being seeded!

Writing seeds
-------------
Let's say you want to seed the following models with their relations:

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

Your seeds are expected to look like:

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

Note that the `parking` relations are set through `name`. You can match any column of a model\`s relation
by titling the column **`relation_column`**. Matching multiple columns is also possible.

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
You can allow a model to seed itself:

```ruby
model Car
  extend Superseeder::Seedable
end
Car.seed
```

Single Table Inheritance
------------------------
You can seed a model and its inherited models from a single file provided you add a '_type' column containing the subclass name.

```ruby
model Car
end

model RentedCar < Car
end
```
name|_type
----|-----
Mustang|
Corvette|RentedCar
BMW|

will seed
```ruby
Car.new :name => 'Mustang'
RentedCar.new :name => 'Corvette'
Car.new :name => 'BMW'
```

Options
------------------------
`seed` takes a number of options:
 * `:filename` to specify a file name not matching a model name

```ruby
   seed :cars, :filename => 'last_dump.csv'
```

 * `:many_sep` to specify the separator in array relations

 name|cars_name
 ----|----
 south|Mustang@BMW
 east|
 west|
 north|Corvette

```ruby
   seed :parkings, :many_sep => '@'
```

You can also pass any option supported by the Roo gem (https://github.com/roo-rb/roo) to read files, such as encoding, CSV column separator, etc. Check their documentation for more information.

Contributing / Seed formats
------------------
I appreciate any help to make this gem more robust and flexible.

If you want to add support for other formats, here's how to do it:

Add a module in the superseeder format namespace that look like:

 ```ruby
 # my_format.rb
 module Superseeder
   module Formats
     module MyFormat

       def self.extensions
       # list of supported extensions, ex: %w(.mft .x4t)
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

