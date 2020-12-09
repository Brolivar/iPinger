# Address pinger iOS App

This iOS app was made as part of an interview project. I applied a simple version of the MVVM structure for it.

## :memo: Description 

The main functionality consist on pinging all addresses given a local ip, and trace if the host is reachable or not.

The main particularity is that it is done using the full capabilities of parallelism with Swift, using queues to manage the load, and control
how many pingers we have active at the same time moment, as well as the attempts that are used to determine if an address is or not reachable.

Example of how it works:

- If max. concurrent pingers is set to 10, then at the beginning we start pinging IP addresses from x.x.x.1 to x.x.x.10 in parallel.
- When any of the pingers completes, it must start pinging the next IP address in a row which is x.x.x.11 (all 10 pingers are always busy doing their job).

### Features

:white_check_mark: Given a local ip address, all 254 addresses are pinged and displayed on a table, with its reachability status.

:white_check_mark: Using operation queues, the pinging is made concurrently, by several "pingers" at a time. This is easily changed on the Model Controller. 

:white_check_mark: Easily modifiable number of attempts to determine if an address is reachable. 

:white_check_mark: Start/Cancel button to update the pinging results, as well as a progress bar.

:white_check_mark: Address sorting by ip, or reachable.

:white_check_mark: Persistence withing the app, only loading automatically results for the first time, and then using the most recent update values.


## :books: Libraries 

- Low level ICMP ping client for Swift 5 : [Swiftyping](https://github.com/samiyr/SwiftyPing)
