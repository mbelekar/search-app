## Search Application
This application is a simple command line app that searches data and prints it to stdout in tabular format. Supported data types for search are `Users` and `Tickets`

- Where the data exists, values from any related entities are returned in the search results. Example: Searching for a user also gets the tickets assigned to the user. Similarly, searching for a ticket will also get the user assigned to that ticket.
- Search can be performed on any field
- Search can be performed for missing values
- Search will look for exact terms in the provided data.

### Set up

Docker is a pre-requisite for running this application. Please refer to instructions [here](https://docs.docker.com/get-docker/) to install docker on local machine. Application is written in Ruby (version 3.0). All the required dependencies are installed using docker

Data files location is configured in `config/data-files.json` file. Provided data files for this exercise have been added to this repository and can be found at the location specified in the config file.

You will need to build docker images before you can run tests or run the application.

#### To build docker images for this application, run the following in your terminal:

```
$ ./auto/build
```

Running above script will build local docker images for development and production environment.


### How to run this application

Tests have been written using rspec.

#### To run all the tests:

Run build script prior to running tests:

```
$ ./auto/build
```

Run tests:

```
$ ./auto/test
```

#### Run Application:

Run build script before running application:

```
$ ./auto/build
```

To search for users:

```
$ ./auto/run search users [OPTIONS]
```

To see a list of available options, you can run `./auto/run search users` or `./auto/run search users --help` or `./auto/run search users -h`
[OPTIONS] can be a single option or multiple options in the format `--key=value`. You will need to specify at least one option to be able to search.

To search for tickets

```
$ ./auto/run search tickets [OPTIONS]
```

To see a list of available options, you can run `./auto/run search tickets` or `./auto/run search tickets --help` or `./auto/run search tickets -h`
[OPTIONS] can be a single option or multiple options in the format `--key=value`. You will need to specify at least one option to be able to search.


#### Multi-valued Options
When help information for an option says `(Can be specified multiple times)` it means we can search for multiple terms using that particular option. By default any option can be specified only once for the sub-command unless the help message says otherwise.
Example:
`bundle exec ./bin/search tickets --tags="Fédératéd Statés Of Micronésia"  --tags="Wisconsin"` will search for tickets that have both tags "Fédératéd Statés Of Micronésia" and "Wisconsin"
But `bundle exec ./bin/search users --_id=1 --_id=2` will return records for _id=2 since this option is not meant to be multi-valued.

#### Alternate way of running application without Docker

In case you do not wish to use docker you can run this application with ruby-3.0 installed on your machine. In the application root directory run the following commands in the terminal:

```
$ bundle install
$ bundle exec ./bin/search users -h
```

To run tests, in the application root directory run:

```
$ bundle install
$ bundle exec rspec -fd
```

### Assumptions
To keep it simple and meet all the requirements, I have made following assumptions:

- The application will search data from static files.
- Source data will always be valid json
- Source data will not have any duplicates
- Search is performed using exact term match
- All source data can fit into memory for searching

### Technical Design choices:
#### Domain model:
- `Models::User` models a single user record from the data file
- `Models::Ticket` models a single ticket record from the data file
#### Validation:
- `Validations::UserContract` enforces the data contract for `User` model.
- `Validations::TicketContract` enforces the data contract `Ticket` model.
#### Data Load:
- `Loader` reads passed config, iterates over the directory specified in the config and sends each file to the parser class returned by `ParserFactory` class.
- `JsonParser` is responsible for parsing file passed to it by the loader

#### Data Transformation:
- `Transformer` gets raw data array generated by the `Loader` as  its input. It invokes correct validation and model class(using `ModelFactory` and `ValidationFactory`) to transform each record to a model.

#### Data Builder
- `DataBuilder` ties together `Loader` and `Transformer` classes to generate the final data structure that is to be searched.

#### CLI Interface
- `MainCommand` is the entrypoint. When user runs search command in the cli, this class is invoked.
- `UserCommand` represents the `users` subcommand.
- `TicketCommand` represents `tickets` subcommand.
Both the subcommand classes enforce type validation on the end user's cli input. These classes pass users inputs to the `Application` class to invoke data load/transform and search
#### Application
- `Application` ties together cli, search and data load/transform functionality. It passes data config to `DataBuilder`. Once it gets back loaded/transformed data, it passes this along with the user selected search options from `CLI::UserCommand`/ `CLI::TicketCommand` class to the correct search class(returned by `SearchFactory`). The search results are then displayed using `DataDisplay` module (mixed-in with `Application`)

Application flow:![search-app](https://user-images.githubusercontent.com/1658005/123136945-d47bd400-d496-11eb-98c6-10752fb2030d.png)

#### Tests:
- Unit tests and feature tests cover the functionality.
- Fixtures, helper test classes and custom matchers are used to keep the code DRY

### Trade-offs
- Some coupling with classes that are deemed to be safe. Eg: `DataBuilder` is coupled with `Loader` as the the latter is meant to just glob files from directory and send to `Parser`. This responsibility is less likely to change if the source data always going to be in file format

### Improvements
- The data is loaded every time a search command is run. Design can be changed to load once and search multiple times.
- Some of the tests have mocks which can be reduced by further refactoring of the code.
