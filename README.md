# ClearsaleClean

Gem based on the https://github.com/Baby-com-br/clearsale gem, my thanks to Daniel Konishi.

Gem for send and checking orders at ClearSale.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clearsale_clean'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install clearsale_clean

## Usage

```bash
Declare environment variables.
CLEARSALE_ENTITYCODE
CLEARSALE_ENV

# Entitycode access code provided by ClearSale.
CLEARSALE_ENTITYCODE: 00000000-0000-0000-0000-000000000000

# Option to access the ClearSale test or production environment.
The default is homolog, but it is possible to pass production to access the ClearSale production environment.
CLEARSALE_ENV: homolog
```

```ruby
order = {
	"user": {
		"id": 8888,
		"email": "petergriffin@abc.com",
		"cpf": "248.783.463-37",
		"full_name": "Peter Löwenbräu Griffin",
		"birthdate": "2007-11-19T08:37:48",
		"phone": "11 8001 1002",
		"gender": "m",
		"last_sign_in_ip": "127.0.0.1"
	},
	"payment": {
		"payment_type": "creditcard",
		"card_holder": "Petter L Griffin",
		"card_number": "1234432111112222",
		"card_expiration": "05/2012",
		"card_security_code": "123",
		"acquirer": "visa",
		"amount": 50
	},
	"order": {
		"id": 1234,
		"finger_print": "aaaa1111",
		"total_shipping": 18,
		"total_items": 20,
		"total_order": 38,
		"installments": 3,
		"shipping_type": "correio",
		"status": "new",
		"created_at": "2007-11-19T08:37:48",
		"paid_at": "2020-05-20T08:37:46",
		"delivery_time": 2,
		"billing_address": {
			"street_name": "Bla St",
			"number": "123",
			"complement": "",
			"neighborhood": "Rhode Island",
			"city": "Mayland",
			"state": "Maryland",
			"country": "Brasil",
			"postal_code": "00100-011"
		},
		"shipping_address": {
			"street_name": "Bla St",
			"number": "123",
			"complement": "",
			"neighborhood": "Rhode Island",
			"city": "Mayland",
			"state": "Maryland",
			"country": "Brasil",
			"postal_code": "00100-011"
		},
		"order_items": [
			{
				"product": {
					"id": 5555,
					"name": "Pogobol",
					"category": {
						"id": 7777,
						"name": "Disney"
					}
				},
				"price": 5,
				"quantity": 2
			},
			{
				"product": {
					"id": 5555,
					"name": "Pogobol",
					"category": {
						"id": 7777,
						"name": "Disney"
					}
				},
				"price": 5,
				"quantity": 2
			}
		]
	}
}
```

Requesting analysis
```ruby
  response = ClearsaleClean::Analysis::SendOrder.new(order).send_order
  response
  # => {:order_id=>1235, :score=>0.0, :status=>:waiting}
  # => {:status=>:order_not_accepted, :message=>"Pedido 1234 já existe e não está como reanalise."}
```
Consulting the analysis
```ruby
  order_id = '1234'
  response = ClearsaleClean::Analysis::GetOrder.new(order_id).order_status

  response
  # {:order_id=>1234, :score=>0.0, :status=>:manual_analysis}
  response[:order_id]
  # => 1234

  response[:score]
  # => (0.01..21.11)

  response[:status]
  # => :automatic_approval
  # => :manual_approval
  # => :rejected_without_suspicion
  # => :manual_analysis
  # => :error
  # => :waiting
  # => :manual_rejection
  # => :cancelled
  # => :fraud
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` or `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/repassa/clearsale_clean. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/repassa/clearsale_clean/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the ClearsaleClean project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/repassa/clearsale_clean/blob/master/CODE_OF_CONDUCT.md).
