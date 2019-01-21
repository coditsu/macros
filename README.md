# Trailblazer Coditsu Macros Engine

[![CircleCI](https://circleci.com/gh/coditsu/macros/tree/master.svg?style=svg)](https://circleci.com/gh/coditsu/macros/tree/master)

Set of macros for nicer composition of Traiblazer operations.

Example:

```ruby
module Repositories
  class Destroy < ApplicationOperation
    step Macros::Model::Find(Repository, :find_by)
    step Macros::Model::Destroy()
  end
end
```

## Note on contributions

First, thank you for considering contributing to Coditsu ecosystem! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs and meet our quality requirements.

To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combines multiple linters and code analyzers for both code and documentation. Once you're done with your changes, submit a pull request.

Coditsu will automatically check your work against our quality standards. You can find your commit check results on the [builds page](https://app.coditsu.io/coditsu/commit_builds) of Coditsu organization.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/coditsu/commit_builds)
