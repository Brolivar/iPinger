//
//  PingerModelController.swift
//  iPinger
//
//  Created by Jose Bolivar Herrera on 2/12/20.
//

import Foundation

// Sorting
enum AddressSorting {
    case address
    case reachable
}

// Reachability Status
enum ReachabilityStatus {
    case reachable
    case unreachable
}

protocol PingerModelControlerProtocol: class {
    func pingAddress(localAddress: LocalAddress, completion: @escaping () -> ())
    func pingAllAddresses(completion: @escaping (Bool, Float) -> ())
    func addressAt(_ index: Int) -> LocalAddress
    func stopUpdatingResults()
    func count() -> Int
}

class PingerModelController: ArrayViewModel {

    // MARK: - Properties
    typealias ViewModel = LocalAddress
    var viewModel: [LocalAddress] = [] //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction
    var tempViewModel: [LocalAddress] = []  //Aux copy to store all values during the address update (only gets copied if the task completes)

    static let localAddress = "192.168.0."
    static let addressNumber = 254
    private var updateCancelled: Bool = false

    // MARK: - Pinger Properties
    static let activePingers = 3         // 1. Active concurrent pingers
    static let pingAttemps = 3          // 2. Max attemps to determine if host is reachable

    // PingerQueue object, where we will be adding our operations (single address pinging)
    // .maxConcurrentOperationCount is how we achieve parallelism, establishing the max number
    // of queued operations at the same time.
    lazy var pingerQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Address Pinger Queue"
        queue.maxConcurrentOperationCount = PingerModelController.activePingers
        return queue
    }()

    // MARK: - Initialization
    // We initialize the array with the 255 addresses
    init() {
        // (from 192.168.0.1 to 192.168.1.254 inclusively)
        for n in 1...PingerModelController.addressNumber {
            let newAddress = LocalAddress(address: PingerModelController.localAddress + String(n))
            self.viewModel.append(newAddress)
        }
        for n in 1...PingerModelController.addressNumber {
            let newAddress = LocalAddress(address: PingerModelController.localAddress + String(n))
            self.tempViewModel.append(newAddress)
        }
    }
}

// MARK: - PingerModelController implementation
extension PingerModelController: PingerModelControlerProtocol {

    func addressAt(_ index: Int) -> LocalAddress {
        return self.itemAtIndex(index)
    }

    /// Function for single address pinging:
    ///
    ///  1. Given an LocalAddress object, and using the SwiftyPing library, a ping is made to the address, using the parameter "targetCount".
    ///  2. TargetCounts determine the times the address is pinged.
    ///     2.1. If the address is reachable, the function escapes directly, and the pinger is halt (in order to not waste the remaining attempts)
    ///     2.2  If the address is unreachable, the function keeps incrementing the attempts, and if not successful attepts were made, function is escaped.
    ///
    ///
    /// - Parameters:
    ///   - localAddress: Address Object, composed of address and status (reachable/not reachable)
    ///   - completion: escapes function to notify that the address pinging is finished (by being unreachable and using all attemtps OR just being rechable)
    func pingAddress(localAddress: LocalAddress, completion: @escaping () -> ()) {

        var attempts = 1
        // PingConfiguration ( time between consecutive pings, timeout interval)
        let pinger = try? SwiftyPing(host: localAddress.address, configuration: PingConfiguration(interval: 0.5, with: 3), queue: DispatchQueue.global())
        pinger?.observer = { (response) in

            if response.ipHeader == nil {
                localAddress.status = .unreachable
                //print("IpAddress:", localAddress.address, "-- status:", localAddress.status, "attempt: ", attempts)

                // Max attempt reached -> we scape function
                if attempts == PingerModelController.pingAttemps {
                    //print("Max attempt reached, escaping...")
                    pinger?.haltPinging()
                    completion()
                }
                attempts += 1

            } else {
                localAddress.status = .reachable
                //print("IpAddress:", localAddress.address, "-- status:", localAddress.status)
                pinger?.haltPinging()
                completion()
            }
        }
        pinger?.targetCount = PingerModelController.pingAttemps
        try? pinger?.startPinging()
    }



    /// Cycles and pings  all the addresses in the view model:
    ///
    /// 1. For every Address in the ViewModel, and operation for pinging that address is added to the OperationQueue.
    /// 2. Then, and using the maxConcurrentOperationCount parameter, the task will start to be made concurrently.
    /// 3. After each pinging task finishes (by being reachable or using attempts):
    ///     3.1 The local number of address pinged is increased.
    ///     3.2 A check is made to finish in case the task has being cancelled.
    ///     3.3 The progress (0.0-1.0) is calculated, and returns the  completion parameters.
    ///
    /// - Parameter completion: The closure is used to communicate the ViewControler a bool indicating if all addresses are pinged,
    ///  and a float that is used to set the progressBar
    ///
    ///
    func pingAllAddresses(completion: @escaping (Bool, Float) -> ()) {

        var pingedAddress = 0
        self.updateCancelled = false
        print("Pinging all addresses with a total of ", PingerModelController.activePingers, " pingers and ", PingerModelController.pingAttemps, " attemps.")

        for localAddress in self.tempViewModel {

            self.pingerQueue.addOperation {
                self.pingAddress(localAddress: localAddress) {
                    
                    pingedAddress += 1
                    //print("Number of pinged addresses", pingedAddress)
                    // Fetch Cancelled
                    if self.updateCancelled {
                        completion(false, 0)
                    // Fetch Completed
                    } else if pingedAddress == PingerModelController.addressNumber {
                        self.viewModel = self.tempViewModel
                        let progress = self.checkProgress(currentProgress: Float(pingedAddress))
                        completion(true, progress)
                    // Keep fetching and complete
                    } else {
                        let progress = self.checkProgress(currentProgress: Float(pingedAddress))
                        completion(false, progress)
                    }
                }
            }
        }
}
    
    // Cancels all remaining (and executing) operations on queue
    func stopUpdatingResults() {
        self.updateCancelled = true
        self.pingerQueue.cancelAllOperations()
    }

    // Calculates the current Progress (over 1.0) of the total addresses
    func checkProgress(currentProgress: Float) -> Float {
        let progress = ((currentProgress * 100) / 256) / 100
        return progress
    }
}
