# frozen_string_literal: true

require_relative "lib/tradedoc/version"

Gem::Specification.new do |spec|
  spec.name = "tradedoc"
  spec.version = Tradedoc::VERSION
  spec.authors = ["mroach"]
  spec.email = ["mroach@mazepay.com"]

  spec.summary = "Trade document parser and generator"
  spec.description = ""
  spec.homepage = "https://github.com/dknmz/tradedoc.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/dknmz"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dknmz/mastercard_api"
  spec.metadata["github_repo"] = "ssh://github.com/dknmz/mastercard_api"
  spec.metadata["changelog_uri"] = "https://github.com/dknmz/mastercard_api/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "bigdecimal", ">= 3.0.0"
  spec.add_dependency "money", ">= 6.0"
  spec.add_dependency "nokogiri", ">= 1.0"
end
