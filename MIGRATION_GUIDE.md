# Macros Gem v2.0 Migration Guide

**Version 2.0.0** - Major refactor to remove Trailblazer dependency

## Overview

Macros gem v2.0 removes all Trailblazer and Reform dependencies and introduces a lightweight service object pattern. This guide will help you migrate from v1.x (Trailblazer-based) to v2.0 (service object-based).

## What Changed?

### Removed Dependencies
- ❌ `trailblazer`
- ❌ `trailblazer-developer`
- ❌ `trailblazer-rails`
- ❌ `reform`
- ❌ `reform-rails`
- ❌ `uber`

### New Dependencies
- ✅ `activemodel` (for form objects)
- ✅ `activesupport` (retained)

### New Base Classes

1. **`Macros::ServiceObject`** - Replaces Trailblazer operations
2. **`Macros::FormObject`** - Replaces Reform forms
3. **`Macros::Result`** - Result monad for success/failure
4. **`Macros::ValidationError`** - Custom error for validation failures

## Migration Pattern

### Before (v1.x - Trailblazer Operation)

```ruby
# app/concepts/repositories/create.rb
module Repositories
  class Create < ApplicationOperation
    contract Contracts::Create

    step Macros::Model::Build.new(Repository).call
    step :assign_organization
    step Macros::Contract::Build.new.call
    step Macros::Contract::Validate.new(key: :repository).call
    step Macros::Contract::Persist.new.call
    step :create_permissions

    def assign_organization(options, current_organization:, **)
      options['model'].organization = current_organization
    end

    def create_permissions(options, current_user:, **)
      Permissions::Create.call(user: current_user, repository: options['model'])
    end
  end
end

# app/concepts/repositories/contracts/create.rb
module Repositories::Contracts
  class Create < ApplicationContract
    property :name
    property :visibility

    validation do
      required(:name).filled
      required(:visibility).filled
    end
  end
end
```

### After (v2.0 - Service Object)

```ruby
# app/services/repositories/create.rb
module Repositories
  class Create
    include Macros::ServiceObject

    def run
      build_repository
      validate_and_save
      create_permissions

      success(repository: @repository, form: @form)
    end

    private

    def build_repository
      @repository = Repository.new
      @repository.organization = context[:current_organization]
    end

    def validate_and_save
      @form = Forms::RepositoryForm.new(@repository)

      unless @form.validate(params[:repository])
        return failure(@form.errors)
      end

      @form.save
    end

    def create_permissions
      result = Permissions::Create.call(
        params: { user: context[:current_user], repository: @repository },
        context: context
      )

      return failure(result.errors) if result.failure?
    end
  end
end

# app/forms/repositories/repository_form.rb
module Repositories
  class RepositoryForm < Macros::FormObject
    attribute :name, :string
    attribute :visibility, :string

    validates :name, presence: true
    validates :visibility, presence: true, inclusion: {
      in: %w[open_source private],
      message: 'must be open_source or private'
    }
  end
end
```

## Key Differences

### 1. Service Object Pattern

**Old (Trailblazer):**
```ruby
class MyOperation < ApplicationOperation
  step :do_something
  step :do_something_else

  def do_something(options, **)
    # ...
  end
end
```

**New (Service Object):**
```ruby
class MyService
  include Macros::ServiceObject

  def run
    do_something
    do_something_else

    success(result: @result)
  end

  private

  def do_something
    # Access params via @params
    # Access context via @context
  end
end
```

### 2. Calling Services

**Old:**
```ruby
# In controller
result = Repositories::Create.call(params: params)
```

**New:**
```ruby
# In controller
result = Repositories::Create.call(
  params: params,
  context: {
    current_user: current_user,
    current_organization: current_organization
  }
)

if result.success?
  redirect_to result[:repository]
else
  @errors = result.errors
  render :new
end
```

### 3. Forms (Reform → FormObject)

**Old (Reform):**
```ruby
class MyContract < ApplicationContract
  property :name
  property :email

  validation do
    required(:name).filled
    required(:email).filled
  end
end
```

**New (FormObject):**
```ruby
class MyForm < Macros::FormObject
  attribute :name, :string
  attribute :email, :string

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end

# Usage:
user = User.new
form = MyForm.new(user)

if form.validate(params[:user])
  form.save  # Syncs to model and saves
else
  form.errors  # Standard ActiveModel::Errors
end
```

### 4. Result Handling

**New Result API:**
```ruby
result = MyService.call(params: params, context: context)

# Check success/failure
result.success?  # => true/false
result.failure?  # => true/false

# Access data
result[:user]       # Access by key
result.data         # Full data hash
result.errors       # Errors hash

# Convert to hash
result.to_h  # Returns data if success, { errors: errors } if failure
```

### 5. Error Handling

**ValidationError:**
```ruby
class MyService
  include Macros::ServiceObject

  def run
    validate_something
    success(data: @data)
  end

  private

  def validate_something
    unless @params[:name].present?
      raise Macros::ValidationError.new(name: ['is required'])
    end
  end
end

# ValidationError is automatically caught and converted to failure result
```

**Manual failure:**
```ruby
def run
  if some_condition
    return failure(error: 'Something went wrong')
  end

  success(result: @result)
end
```

## Controller Integration

### Before (Trailblazer + concept_action)

```ruby
class RepositoriesController < ApplicationController
  include Controllers::BetterTrailblazer

  concept_action :index, :new, :create, :edit, :update, :destroy
end
```

### After (Explicit Actions)

```ruby
class RepositoriesController < ApplicationController
  def index
    result = Repositories::Index.call(
      params: params,
      context: operation_context
    )

    @repositories = result[:repositories]
  end

  def new
    result = Repositories::New.call(
      params: params,
      context: operation_context
    )

    @form = result[:form]
    @repository = result[:repository]
  end

  def create
    result = Repositories::Create.call(
      params: params,
      context: operation_context
    )

    if result.success?
      redirect_to result[:repository], notice: 'Created!'
    else
      @form = result[:form]
      @errors = result.errors
      render :new
    end
  end

  private

  def operation_context
    {
      current_user: current_user,
      current_organization: current_organization
    }
  end
end
```

## View Integration

### Form Objects with SimpleForm

**Before (Reform):**
```haml
= simple_form_for(form, url: repositories_path) do |f|
  = f.input :name
  = f.input :visibility
  = f.submit
```

**After (FormObject - same!):**
```haml
= simple_form_for(@form, url: repositories_path, as: :repository) do |f|
  = f.input :name
  = f.input :visibility
  = f.submit
```

Form objects implement the same interface as ActiveModel, so they work seamlessly with form helpers!

## Composition Pattern

### Before (Trailblazer Nested)

```ruby
class Create < ApplicationOperation
  step Nested(New)  # Reuses New operation
  step Contract::Validate()
  step Contract::Persist()
end
```

### After (Service Composition)

```ruby
class Create
  include Macros::ServiceObject

  def run
    # Call New service to set up initial state
    new_result = New.call(params: params, context: context)
    return new_result if new_result.failure?

    @repository = new_result[:repository]
    @form = new_result[:form]

    # Continue with creation logic
    validate_and_save

    success(repository: @repository, form: @form)
  end

  private

  def validate_and_save
    unless @form.validate(params[:repository])
      return failure(@form.errors)
    end

    @form.save
  end
end
```

## Migration Checklist

- [ ] Update Gemfile to use macros v2.0
  ```ruby
  gem 'macros',
      github: 'coditsu/macros',
      branch: 'refactor/remove-trailblazer-dependency'
  ```

- [ ] Create `app/services/` directory structure
  ```
  app/services/
  ├── authentication/
  ├── accounts/
  ├── organizations/
  └── ...
  ```

- [ ] Create `app/forms/` directory structure
  ```
  app/forms/
  ├── accounts/
  ├── organizations/
  └── ...
  ```

- [ ] Migrate operations domain by domain:
  1. Authentication (simplest)
  2. Accounts
  3. Organizations
  4. Permissions
  5. Repositories (most complex)

- [ ] Update controllers to use explicit actions

- [ ] Update views to use `@form` instead of `form`

- [ ] Remove Trailblazer dependencies from Gemfile

- [ ] Remove `app/concepts/` directory

- [ ] Remove `BetterTrailblazer` concern

- [ ] Test thoroughly!

## Testing

### RSpec Examples

```ruby
RSpec.describe Repositories::Create do
  describe '#call' do
    let(:params) { { repository: { name: 'test', visibility: 'open_source' } } }
    let(:context) { { current_user: user, current_organization: org } }

    context 'with valid params' do
      it 'creates repository' do
        result = described_class.call(params: params, context: context)

        expect(result).to be_success
        expect(result[:repository]).to be_persisted
        expect(result[:repository].name).to eq('test')
      end
    end

    context 'with invalid params' do
      let(:params) { { repository: { name: '' } } }

      it 'returns failure with errors' do
        result = described_class.call(params: params, context: context)

        expect(result).to be_failure
        expect(result.errors[:name]).to include("can't be blank")
      end
    end
  end
end
```

## Benefits of v2.0

1. **No Trailblazer magic** - Plain Ruby objects, easier to understand
2. **Better debugging** - Standard Ruby stack traces
3. **Less cognitive load** - Familiar ActiveModel patterns
4. **Better IDE support** - No DSL magic, better autocomplete
5. **Easier testing** - Standard RSpec patterns
6. **Smaller dependency tree** - Removed ~15 gems
7. **More Rails-idiomatic** - Uses ActiveModel, feels like Rails

## Backward Compatibility

Old Trailblazer-based macros (`Macros::Model::Build`, `Macros::Contract::Validate`, etc.) will still work if Trailblazer is installed in your application. They will be marked as deprecated in v2.x and removed in v3.0.

Check if legacy macros are loaded:
```ruby
Macros.legacy_macros_loaded?  # => true if Trailblazer is available
```

## Getting Help

- Review the test files for examples:
  - `spec/lib/macros/service_object_spec.rb`
  - `spec/lib/macros/form_object_spec.rb`
  - `spec/lib/macros/result_spec.rb`

- Check the API documentation in source files:
  - `lib/macros/service_object.rb`
  - `lib/macros/form_object.rb`

## Version History

- **v2.0.0** - Remove Trailblazer dependency, introduce service object pattern
- **v1.15.0** - Last version with Trailblazer

---

**Happy migrating! 🚀**
