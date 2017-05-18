# Prestashop

[![Build Status](https://travis-ci.org/mikolfaro/prestashop.svg)](https://travis-ci.org/mikolfaro/prestashop) 
[![Code Climate](https://codeclimate.com/github/mikolfaro/prestashop/badges/gpa.svg)](https://codeclimate.com/github/mikolfaro/prestashop)
[![Test coverage](https://codeclimate.com/github/mikolfaro/prestashop/badges/coverage.svg)](https://codeclimate.com/github/mikolfaro/prestashop)
[![Dependencies](https://gemnasium.com/mikolfaro/prestashop.svg)](https://gemnasium.com/mikolfaro/prestashop)

Prestashop API for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prestashop', github: 'werein/prestashop'
```

Use `branch: 'master'` for local repository in case of bundler global config

## Usage

Create new client for connect to your Prestashop WebService

```ruby
Prestashop::Client::Implementation.create 'api_key', 'api_url'
```

Now you are able to communicate with Prestashop WebService

### Low-level API

To call API request directly you can use this class.

##### Head / Check

Call HEAD on WebService API, returns +true+ if was request successfull or raise error, when request failed.

``` ruby
Prestashop::Client.head :customer, 2 # => true
Prestashop::Client.check :customer, 3 # => true
```

##### Get / Read

Call GET on WebService API, returns parsed Prestashop response or raise error, when request failed.

```ruby
Prestashop::Client.get :customer, 1       # => {id: 1 ...}
Prestashop::Client.read :customer, [1,2]  # => [{id: 1}, {id: 2}]
```

When you are using get, you can also filter, sort or limit response. In case, when you need to get all users you need to set user id as `nil`

**Available options:**

* filter
* display
* sort
* limit
* schema
* date

##### Post / Create
Call POST on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.

```ruby
Prestashop::Client.post :customer, { name: 'Steve' } # => true
```

##### Put / Update

Call PUT on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.

```ruby
Prestashop::Client.put :customer, 1, {surname: 'Jobs'} # => true
Prestashop::Client.update :customer, 1, {nope: 'Jobs'} # => false
```

##### Delete / Destroy

Call DELETE on WebService API, returns +true+ if was request successfull or raise error, when request failed.

```ruby
Prestashop::Client.delete :customer, 1 # => true
```

### Mapper

Please read inline docs inside `lib/prestashop/mapper/extension.rb`, available models are defined in `lib/prestashop/mapper/models`

After reading that you can do something like this

```ruby
id_lang = Prestashop::Mapper::Language.find_by_iso_code('cs')
id_supplier = Prestashop::Mapper::Supplier.new(name: 'apple').find_or_create

product = Prestashop::Mapper::Product.new(id_lang: id_lang, id_supplier: id_supplier, reference: 'apple-macbook')

if product.find?
  product.update price: '1299'
else
  product.description = 'My description'
  product.price = '1299'
  product.create
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
