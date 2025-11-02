# Coditsu Macros - Service Object Framework

[![Build Status](https://github.com/coditsu/macros/actions/workflows/ci.yml/badge.svg)](https://github.com/coditsu/macros/actions/workflows/ci.yml)

A lightweight service object framework for Ruby applications with form objects and result monads.

## Version 2.0 - Trailblazer-Free

Version 2.0 removes the Trailblazer dependency and provides a clean, simple service object pattern using plain Ruby and ActiveModel.

### Quick Example

```ruby
class Users::Create
  include Macros::ServiceObject

  def run
    form = UserForm.new(User.new)
    return failure(form.errors) unless form.validate(params)
    return failure(form.model.errors) unless form.save

    success(user: form.model)
  end
end

# Usage
result = Users::Create.call(params: { name: 'John' }, context: { current_user: admin })

if result.success?
  puts "Created user: #{result[:user].name}"
else
  puts "Errors: #{result.errors}"
end
```

## Table of Contents

* [Installation](#installation)
* [Core Components](#core-components)
  * [Service Objects](#service-objects)
  * [Form Objects](#form-objects)
  * [Result Monad](#result-monad)
  * [Validation Errors](#validation-errors)
* [Usage Examples](#usage-examples)
* [Testing](#testing)
* [Migration from v1.x](#migration-from-v1x)
* [Contributing](#contributing)

## Installation

Add to your Gemfile:

```ruby
gem 'macros', '~> 2.0'
```

Then run:

```bash
bundle install
```

## Core Components

### Service Objects

Service objects encapsulate business logic into reusable, testable units.

```ruby
class Organizations::Create
  include Macros::ServiceObject

  def run
    # Access params and context
    organization = Organization.new(params[:organization])

    # Return success or failure
    return failure(organization.errors) unless organization.save

    success(organization: organization)
  end
end
```

**Features:**
- Simple `.call` class method interface
- Access to `params` and `context` hashes
- `success(data)` and `failure(errors)` result builders
- Automatic result wrapping

### Form Objects

Form objects handle validation and persistence separately from models.

```ruby
class UserForm < Macros::FormObject
  attribute :name, :string
  attribute :email, :string
  attribute :age, :integer

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { greater_than: 0 }

  private

  def sync_to_model
    model.name = name
    model.email = email
    model.age = age
  end
end

# Usage
form = UserForm.new(User.new)
if form.validate(name: 'John', email: 'john@example.com', age: 30)
  form.save
end
```

**Features:**
- Based on `ActiveModel::Model`
- Full ActiveModel validation support
- Automatic model population and syncing
- Wraps model save operations

### Result Monad

Results represent success or failure states with data or errors.

```ruby
result = MyService.call(params: { name: 'test' })

if result.success?
  user = result[:user]
  puts "Success: #{user.name}"
else
  puts "Errors: #{result.errors}"
end

# Access result data
result.data      # => { user: #<User> }
result.errors    # => {}
result[:user]    # => #<User>

# Convert to hash
result.to_h      # => { user: #<User> } or { errors: { ... } }
```

### Validation Errors

Custom exception for validation failures.

```ruby
class MyService
  include Macros::ServiceObject

  def run
    raise Macros::ValidationError.new(base: ['Invalid input'])
  end
end

# Rescue and handle
begin
  MyService.call(params: {})
rescue Macros::ValidationError => e
  puts e.errors  # => { base: ['Invalid input'] }
end
```

## Usage Examples

### Simple Service Object

```ruby
class Repositories::Destroy
  include Macros::ServiceObject

  def run
    repository = Repository.find_by(id: params[:id])
    return failure(base: ['Repository not found']) unless repository

    return failure(repository.errors) unless repository.destroy

    success(repository: repository)
  end
end
```

### Service with Form Object

```ruby
class Organizations::Update
  include Macros::ServiceObject

  def run
    organization = Organization.find(params[:id])
    form = OrganizationForm.new(organization)

    return failure(form.errors) unless form.validate(params[:organization])
    return failure(form.errors) unless form.save

    success(organization: form.model)
  end
end
```

### Service with Authorization

```ruby
class Repositories::Create
  include Macros::ServiceObject

  def run
    return failure(base: ['Unauthorized']) unless can_create?

    repository = Repository.new(params[:repository])
    return failure(repository.errors) unless repository.save

    success(repository: repository)
  end

  private

  def can_create?
    context[:current_user]&.admin?
  end
end
```

## Testing

See [TESTING.md](TESTING.md) for comprehensive testing guide.

**Quick test example:**

```ruby
RSpec.describe Users::Create do
  describe '.call' do
    let(:params) { { name: 'John', email: 'john@example.com' } }

    it 'creates user successfully' do
      result = described_class.call(params: params)

      expect(result).to be_success
      expect(result[:user]).to be_persisted
    end

    it 'returns failure for invalid params' do
      result = described_class.call(params: {})

      expect(result).to be_failure
      expect(result.errors).to be_present
    end
  end
end
```

**Test Coverage:** 87.66% (135/154 lines)

## Migration from v1.x

Version 2.0 is a breaking change from v1.x. See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed migration instructions.

**Key changes:**
- Removed Trailblazer dependency
- Replaced operation step DSL with simple `run` method
- Replaced Reform with ActiveModel-based forms
- Simplified architecture - no operation pipeline

**Before (v1.x):**
```ruby
class Users::Create < Trailblazer::Operation
  step :model_build
  step Contract::Build(constant: UserContract)
  step Contract::Validate()
  step Contract::Persist()
end
```

**After (v2.0):**
```ruby
class Users::Create
  include Macros::ServiceObject

  def run
    form = UserForm.new(User.new)
    return failure(form.errors) unless form.validate(params)
    return failure(form.errors) unless form.save
    success(user: form.model)
  end
end
```

## Contributing

First, thank you for considering contributing to the Coditsu ecosystem! It's people like you that make the open source community such a great community!

Each pull request must:
- Pass all RSpec specs (run `bundle exec rspec`)
- Maintain or improve code coverage (currently 87.66%)
- Follow the existing code style
- Include tests for new functionality

To check your changes, we use [Coditsu](https://coditsu.io) that combines multiple linters and code analyzers. Once you're done with your changes, submit a pull request.

Coditsu will automatically check your work against our quality standards. You can find your commit check results on the [builds page](https://app.coditsu.io/coditsu/commit_builds) of Coditsu organization.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/coditsu/commit_builds)

## License

See LICENSE file for details.
