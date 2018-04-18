# TravisClient

A Travis v3 API client for Swift 4.x

[![Build Status](https://travis-ci.org/iainsmith/TravisClient.svg?branch=master)](https://travis-ci.org/iainsmith/TravisClient)

##

[Read the docs](https://iainsmith.github.io/TravisClient/index.html)

## Usage

```swift
import TravisClient

let key: String = "YOUR_TRAVIS_API_KEY"
let client = TravisClient(token: key, host: .org)

client.activeBuilds { (result: Meta<[Build]>) in
    switch result {
    case success(let builds):
        // Find the number of active builds
        builds[\.count])

        // Find the jobs associated with this build
        let jobs: [Embed<MinimalJob>] = builds[\.[0].jobs] // in prod you should typically use [\.first?.jobs]

        // Travis 
        let job: Embed<MinimalJob> = jobs[\.first]

        // The travis api client support hyper media so you can easily load the full object in a second request.
        client.follow(job) { (jobResult: Meta<Commit>) in
            print(jobResult)
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
* [x] Add User
* [x] Add Simple Query parameters
* [ ] Add Stages
* [ ] Add more typed sort parameters
* [ ] Support Type safe Eager Loading.