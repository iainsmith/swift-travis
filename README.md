# TravisClient

A Swift interface to the travis-ci v3 API. Supports [travis-ci.org](https://travis-ci.org), [travis-ci.com](https://travis-ci.com) & on premise deployments.

[![Build Status](https://travis-ci.org/iainsmith/TravisClient.svg?branch=master)](https://travis-ci.org/iainsmith/TravisClient) | [Read the docs](https://iainsmith.github.io/TravisClient/index.html)

## Installation

* Install with SPM `.package(url: "https://github.com/iainsmith/swift-travis", from: "0.3.0"),`
* The swift-travis package has the following 3 libraries you can use in your application. 

| Usecase | interface | target |
|---|---|---|
| iOS & Mac apps | URLSession |  `.product(name: "TravisClient", package: "swift-travis")`|
| CLI & Server APPs | EventLoopFuture |  `.product(name: "TravisClientNIO", package: "swift-travis")` |
| Build your own package | Codable structs |  `.product(name: "TravisV3Core", package: "swift-travis")` |

### Quick example

```swift
import TravisClient

let key: String = ProcessInfo().environment["TRAVIS_TOKEN]"!
let client = TravisClient(token: key, host: .org)

client.userBuilds(query: query) { result in
  switch result {
    case let .success(builds):
      builds.count
      builds.first?.pullRequestTitle
    case let .failure(error):
      // error handling
  }
}
```

### Swift NIO examples

```swift
import TravisClientNIO

let key: String = ProcessInfo().environment["TRAVIS_TOKEN]"!
let client = TravisClient(token: key, host: .org) // You can also pass an `EventLoopGroup`

let builds = try client.builds(forRepository: repo).wait()
print(builds.count)
print(builds.first?.pullRequestTitle)
```

## Travis API Concepts.

The api mirrors the names & concepts from the official [Travis API documentation](https://developer.travis-ci.com/gettingstarted). 

#### Minimal vs Standard Representation.

Each model object has two representations. A standard representation that includes all the attributes and a minimal representation that includes some attributes.

```swift
public struct MinimalJob: Codable, Minimal {
  public typealias Full = Job
  public let id: Int
}

public struct Job: Codable {
  public let id: Int
  public let number: String
  public let state: String
  // 10 other properties
}
```

[Minimal vs Standard Job Example Travis documentation](https://developer.travis-ci.com/resource/job#Job)

If you need more information you can load a standard representation using the `client.follow(embed:completion:)` method

```swift
let build: Meta<Build>
let minimalJob: Embed<MinimalJob> = build.jobs.first! // don't do this in production code

client.follow(embed: minimalJob) { fullJob in
    print(fullJob.state)
}
```

##### Modelling the hypermedia API

The Travis v3 API uses a custom hypermedia API spec, that is [described on their website](https://developer.travis-ci.com/hypermedia#hypermedia). In The `TravisV3Core` we model the standard responses using 
the `Metadata<Object>` type which contains the `Pagination` data and the object `<Object>` which is a travis resource such as `[Build]` / `Job` etc.

```swift
@dynamicMemberLookup
public struct Metadata<Object: Codable>: Codable {
  public let type: String
  public let path: String
  public let pagination: Pagination<Object>?
  public let object: Object
}
```

Full API objects such as `Build` embed multiple minimal representations of other resources which is modelled with the `Embed<Object>` struct which typically contains a Minimal representation of another resource

```swift
@dynamicMemberLookup
public struct Embed<Object: Codable>: Codable {
  public let type: String
  public let path: String?
  public let object: Object
}
```

You can call `client.follow(page:)` or `client.follow(embed:)` to either load a paginated API or to load a full representation.  


```swift
import TravisClient

client.activeBuilds { (result: Result<MetaData<[Build]>, TravisError>) in

    /// You can also switch over the result
    switch result {
    case success(let builds: MetaData<[Build]>)
        // Find the number of active builds
        builds.count

        // Find the jobs associated with this build
        guard let job: Embed<MinimalJob> = jobs.first else { return }

        // Each API call returns one resource that has a 'standard representation' full object in this case supports hyper media so you can easily load the full object in a second request.
        client.follow(embed: job) { (jobResult: Result<MetaData<Job>>) in
            print(jobResult)
        }

        // Or follow a paginated request
        client.follow(page: builds.pagination.next) { nextPage in
            print(nextPage)
        }

    case error(let error):
        // handle error
        print(error)
    }
}
```

## Running the tests

```sh
# JSON parsing tests
> swift test

# Hit the travis.org API  
> TRAVIS_TOKEN=YOUR_TOKEN_HERE swift test
```

The Integration tests only run if you have a `TRAVIS_TOKEN` environment variable set. This uses `XCTSkipIf` which requires Xcode 11.

## Supported swift versions

If you are using Swift 5.1 or newer you can use the latest release
If you need support for Swift 4.2 or older use version `0.2.0`

## TODO

* [x] Support paginated requests
* [x] Add User Model
* [x] Add Simple Query parameters
* [ ] Add Stages Model
* [ ] Add more typed sort parameters
* [ ] Support Type safe Eager Loading.
