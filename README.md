Superseeder
===========

Description
-----------
Superseeder allows you to easily seed your Rails application from sheet files (.csv, .xls, .xlsx, etc.).
Superseeder supports seeding `ActiveRecord` and `Mongoid` relations.

Common Use Case
-----------
In your Rails application, create a `db/seeds/data` folder, add seed files in your favorite format.
The naming convention is `models.(csv|xls|xlsx)`.

In `db/seeds/seeds.rb`:

```ruby
include Superseeder
seed :cars
seed :parkings
```

Use `rake db:seed` as usual to see your database being seeded!

Gem dependencies
----------------
TODO

Writing seeds
-------------
Let say I want to seed the following models:

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

(`Mongoid` models are also supported.)


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

Note that the `parking` relation is set through the name. You can match any *unique* column of a model`s relation
by titling the column `relation_column`.

Also note that you can seed the relation the other way around:

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
 db/seeds/seeds.rb
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
    seed :cars, :filename => 'last_dump.csv'

 With `csv` files, you can specify the column separator:
 `seed :cars, :col_sep => ';'`

Seed formats
------------------

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

