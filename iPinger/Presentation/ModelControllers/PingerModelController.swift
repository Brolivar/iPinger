//
//  PingerModelController.swift
//  iPinger
//
//  Created by Jose Bolivar Herrera on 2/12/20.
//

import Foundation

enum AddressSorting {
    case address
    case reachable
}

enum ReachabilityStatus {
    case reachable
    case unreachable
}

protocol PingerModelControlerProtocol: class {
    func pingAddress(localAddress: LocalAddress, completion: @escaping () -> ())
    func pingAllAddresses(completion: @escaping () -> ())
    func addressAt(_ index: Int) -> LocalAddress
}

class PingerModelController: ArrayViewModel {

    // MARK: - Properties
    typealias ViewModel = LocalAddress
    var viewModel: [LocalAddress] = [] //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction

    static let localAddress = "192.168.0."
    static let addressNumber = 254

    // MARK: - Pinger Properties
    static let activePingers = 10       // Active concurrent pingers
    static let pingAttemps = 3          // Max attemps to determine if host is reachable

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
//            print("N: ", n)
            let newAddress = LocalAddress(address: PingerModelController.localAddress + String(n))
            viewModel.append(newAddress)
        }
    }
}

// MARK: - PingerModelController implementation
extension PingerModelController: PingerModelControlerProtocol {
    func addressAt(_ index: Int) -> LocalAddress {
        return self.itemAtIndex(index)
    }


    // Ping a single ip address
    func pingAddress(localAddress: LocalAddress, completion: @escaping () -> ()) {

        // Ping once
        // PingConfiguration ( time between consecutive pings, timeout interval)
        let pinger = try? SwiftyPing(host: localAddress.address, configuration: PingConfiguration(interval: 0.5, with: 3), queue: DispatchQueue.global())
        pinger?.observer = { (response) in

            if response.ipHeader == nil {
                localAddress.status = .unreachable
                print("IpAddress:", localAddress.address, "-- status:", localAddress.status)
                pinger?.haltPinging()
            } else {
                localAddress.status = .reachable
                print("IpAddress:", localAddress.address, "-- status:", localAddress.status)
                pinger?.haltPinging()
            }

        }
        pinger?.targetCount = 1
        try? pinger?.startPinging()
    }

    // Ping all 255 addreses contained on the modelController
    func pingAllAddresses(completion: @escaping () -> ()) {

        var pingedAddress = 0
        print("Pinging all addresses with a total of ", PingerModelController.activePingers, " pingers and ", PingerModelController.pingAttemps, " attemps.")

        // Test
        //self.pingAddress(localAddress: viewModel[1]) {}


        for localAddress in self.viewModel {
            print("On loop")
            self.pingerQueue.addOperation {
                self.pingAddress(localAddress: localAddress) {

                }
            }

        }



//
//        for localAddress in self.viewModel {
//            print("Loop iteracion: ", localAddress.address)
//
//            self.pingerQueue.addOperation {
//                print("Comenzando tarea...", localAddress.address)
//
//
//                self.pingAddress(localAddress: localAddress) {
//                    // Pingind ended - We increase the number of addresses pinged
//                    print("Ping address: ", localAddress.address, " ended!")
//                    pingedAddress += 1
//
//                    if pingedAddress == self.viewModel.count {      // Finished all pings
//                        print("All address properly pinged!")
//                        completion()
//                    }
//                }


                //print("Terminando tarea...", localAddress.address)

     //       }
      //  }


        

}
    

}
