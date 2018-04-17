# TravisClient

A Travis v3 API client for Swift 4.x

## Browse the docs



## Usage

```swift
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

[ ] Support paginated requests
[ ] Add Stage
[ ] Add Owner
[ ] Add Query parameters
[ ] Support Type safe Eager Loading.