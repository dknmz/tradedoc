# Tradedoc

A Ruby library for reading and writing business trade documents such as invoices,
credit notes, remittance advice, etc.

## Formats

There are multiple formats for business documents in current use around the world
and this library aims to be able to support them natively or easily add support for more.

Currently supported:

* **UN/CEFACT** also known as *CII* (Cross-Industry Invoice)
* **UBL**, Universal Business Language

## Installation

Add it to your Gemfile

```ruby
gem "tradedoc"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Style

This project uses [Standard](https://github.com/standardrb/standard) as the code style
and all pull requests must be linted using `standardrb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dknmz/tradedoc.

## Resources

### UBL

* XSD and sample XML files: https://docs.oasis-open.org/ubl/os-UBL-2.4/

### UN/CEFACT / CII

* XSD: https://unece.org/trade/uncefact/mainstandards

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
