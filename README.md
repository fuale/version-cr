# version

Simple app for generating changelog and bumping semver commit history

_How It Works:_

1. Follow the Conventional Commits Specification in your repository.
2. When you're ready to release, run `version bump`.

`version` will then do the following:

1. Retrieve the current version of your repository by looking at the last git tag.
2. Generates a changelog based on your commits.
3. Creates a new commit including your files and updated CHANGELOG.
4. Creates a new tag with the new version number.

## Usage

### Building from Source

To build the app from source, run the following command:

```
# using shards
shards build

# using crystal
crystal build src/main.cr
```

This will create an executable named version in the `bin`.

### Running

```
version -h      # show help
version changes # generate changelog in current directory
version bump    # create git tag and generate new changelog
```

## Development

To run the tests, run the following command:

```
crystal spec
```

## Contributing

1. Fork it (<https://github.com/your-github-user/version/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Akhmedov Farid](https://github.com/your-github-user) - creator and maintainer
