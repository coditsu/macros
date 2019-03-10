# Trailblazer Coditsu Macros Engine

[![CircleCI](https://circleci.com/gh/coditsu/macros/tree/master.svg?style=svg)](https://circleci.com/gh/coditsu/macros/tree/master)

Set of macros for nicer composition of Trailblazer operations.

Example:

```ruby
module Repositories
  class Destroy < ApplicationOperation
    step Macros::Model::Find(Repository, :find_by)
    step Macros::Model::Destroy()
  end
end
```

## Table of Contents

* [Trailblazer Coditsu Macros Engine](#trailblazer-coditsu-macros-engine)
   * [Table of contents](#table-of-contents)
   * [Macros types](#macros-types)
      * [Contract macros](#contract-macros)
      * [Context macros](#context-macros)
      * [Error macros](#error-macros)
      * [Karafka macros](#karafka-macros)
      * [Model macros](#model-macros)
      * [Params macros](#params-macros)
   * [Note on contributions](#note-on-contributions)

## Macros types

There are several types of macros organized in namespaces that can be used to do various things with predefined steps.

### Contract macros

- `Macros::Contract::Build` - Step for setting contract class and building a new contract
- `Macros::Contract::Persist` - Step for contract persistance
- `Macros::Contract::Validate` - Step for contract validation

```ruby
module Organizations
  class New < ApplicationOperation
    contract Contracts::Create

    step Macros::Model::Build(Organization)
    step Macros::Contract::Build()
    step Macros::Contract::Validate(key: :organization)
    step Macros::Contract::Persist()
  end
end
```

### Context macros

- `Macros::Ctx::Assign` - Assigns a given class to a ctx key for further usage

```ruby
class Sources < ApplicationOperation
  # Now under the 'model' within context you'll have the Source class
  step Macros::Ctx::Assign(Source)
  step Macros::Model::Fetch(:eligible_for_gc)
end
```

### Error macros

- `Macros::Error::Raise` - If we switched to the left track it will raise with some details for debugging

```ruby
class Vacuum < ApplicationOperation
  step :setup_tables_names
  step :delete_orphaned_offenses

  # Raise an error if anything goes wrong
  failure Macros::Error::Raise(Errors::OperationFailure)
end
```

### Karafka macros

- `Macros::Karafka::Broadcast` - Broadcasts a given context field using a given responder

```ruby
class Create < ApplicationOperation
  step :model_build
  step :model_persist
  step Macros::Karafka::Broadcast(::Users::CreatedResponder)
end
```

### Model macros

- `Macros::Model::Build` - Build step for creating new objects from a class/scope
- `Macros::Model::Destroy` - Destroy step for removing object assigned in `ctx['model']`
- `Macros::Model::Fetch` - Extracts from a given object from a ctx hash a given attribute/method and assigns it under diferrent key
- `Macros::Model::Find` - Searches on a given scope and assigns result to a ctx hash
- `Macros::Model::Import` - Import step for mass data import
- `Macros::Model::Paginate` - Runs a pagination for a model and reassigns it under the same name
- `Macros::Model::Persist` - Persist step for saving object assigned in `ctx['model']`
- `Macros::Model::Search` -  Searches based on current_search data and overwrites our model/resource

```ruby
module Repositories
  class Destroy < ApplicationOperation
    step Macros::Model::Find(Repository)
    step Macros::Model::Destroy()
  end
end
```

### Params macros

- `Macros::Params::Fetch` - Fetches a given param key into the ctx hash for further usage

```ruby
class ScheduleSync < ApplicationOperation
  step Macros::Params::Fetch(from: :build_token)
  step :find_most_recent_status_for_commit_build
  step :schedule_delayed_job
end
```

## Note on contributions

First, thank you for considering contributing to Coditsu ecosystem! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs and meet our quality requirements.

To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combines multiple linters and code analyzers for both code and documentation. Once you're done with your changes, submit a pull request.

Coditsu will automatically check your work against our quality standards. You can find your commit check results on the [builds page](https://app.coditsu.io/coditsu/commit_builds) of Coditsu organization.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/coditsu/commit_builds)
