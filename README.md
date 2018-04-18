# TravisClient

A Travis v3 API client for Swift 4.x

[![Build Status](https://travis-ci.org/iainsmith/TravisClient.svg?branch=master)](https://travis-ci.org/iainsmith/TravisClient) | [Read the docs](https://iainsmith.github.io/TravisClient/index.html)

## Installation

* Install with cocoapods: `pod 'TravisClient'`
* Install with SPM `.package(url: "https://github.com/IainSmith/TravisClient", from: "0.2.0"),`

### Quick Usage

```swift
import TravisClient

let key: String = "YOUR_TRAVIS_API_KEY"
let client = TravisClient(token: key, host: .org)

client.activeBuilds { (result: Result<Meta<[Build]>, TravisError>) in
    /// In swift 4.1 you can subscript directly into the Result
    let activeBuildCount: Int? = result[\[Build].count]
    let firstBuildPRTitle: String? = result[\.first?.pullRequestTitle]
}
```

## Travis API Concepts.

[Read the Travis API documentation](https://developer.travis-ci.com/gettingstarted) for much more detail. TravisClient follows the same naming conventions & concepts from the official api documentation.

#### Minimal vs Standard Representation.

Each model object has two representations. A standard representation that includes all the attributes and a minimal representation that includes some attributes.

```swift
public struct MinimalJob: Codable, Minimal {
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
    print(fullJob[\.state])
}
```

## Usage

```swift
import TravisClient

let key: String = "YOUR_TRAVIS_API_KEY"
let client = TravisClient(token: key, host: .org)

client.activeBuilds { (result: Result<Meta<[Build]>, TravisError>) in

    #if swift(>=4.1)
    /// In swift 4.1 you can subscript directly into the Result
    let activeBuildCount: Int? = result[\Build.id]
    #else
    /// In swift 4.0 you need to subscript into the optional value of a result.
    let resultBuildNumber: Int? = result.value?[\.id]
    #endif


    /// You can also switch over the result
    switch result {
    case success(let builds: Meta<[Build]>):
        // Find the number of active builds
        builds[\.count])

        // Find the jobs associated with this build
        guard let job: Embed<MinimalJob> = jobs[\.first] else { return }

        // Each API call returns one resource that has a 'standard representation' full object in this case  supports hyper media so you can easily load the full object in a second request.
        client.follow(job) { (jobResult: Meta<Job>) in
            print(jobResult)
        }

        // Or follow a paginated request
        client.follow(builds.pagination?.next) { nextPage in
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
> swift test --filter TravisClientTests.JSONTests

# Hit the travis.org API  
> TRAVIS_TOKEN=YOUR_TOKEN_HERE swift test
```

## TODO

* [x] Support paginated requests
* [x] Add User Model
* [x] Add Simple Query parameters
* [ ] Add Stages Model
* [ ] Add more typed sort parameters
* [ ] Support Type safe Eager Loading.