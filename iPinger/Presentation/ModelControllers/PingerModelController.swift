//
//  PingerModelController.swift
//  iPinger
//
//  Created by Jose Bolivar Herrera on 2/12/20.
//

import Foundation
import PlainPing


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

}

class PingerModelController: ArrayViewModel {

    // MARK: - Properties
    typealias ViewModel = LocalAddress
    var viewModel: [LocalAddress] = [] //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction

    static let localAddress = "192.168.0."
    static let addressNumber = 254

    // MARK: - Initialization
    // We initialize the array with the 255 addresses
    init() {
        // (from 192.168.0.1 to 192.168.1.254 inclusively)
        for n in 1...PingerModelController.addressNumber {
            print("N: ", n)
            let newAddress = LocalAddress(address: PingerModelController.localAddress + String(n))
            viewModel.append(newAddress)
        }
    }
}

// MARK: - PingerModelController implementation
extension PingerModelController: PingerModelControlerProtocol {

    // Ping a single ip address
    func pingAddress(localAddress: LocalAddress, completion: @escaping () -> ()) {

        PlainPing.ping(localAddress.address, withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            print("Pinged Address: ", localAddress.address)
            if let latency = timeElapsed {
                //self.pingResultLabel.text = "latency (ms): \(latency)"
                print("Reachable")
                localAddress.status = .reachable
                completion()
            } else {
                print("Not reachable")
                localAddress.status = .unreachable
                completion()
            }

            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        })
    }

    // Ping all 255 addreses contained on the modelController
    func pingAllAddresses(completion: @escaping () -> ()) {

        var addressPinged = 0

        // Test
        self.pingAddress(localAddress: self.viewModel[0]) {}
        self.pingAddress(localAddress: self.viewModel[1]) {}
        self.pingAddress(localAddress: self.viewModel[2]) {}
        self.pingAddress(localAddress: self.viewModel[3]) {}
        self.pingAddress(localAddress: self.viewModel[4]) {}
        self.pingAddress(localAddress: self.viewModel[5]) {}
        self.pingAddress(localAddress: self.viewModel[6]) {}

//        for address in self.viewModel {
//            print("ADDRESS:", address.address)
//            self.pingAddress(localAddress: address) { () in
//                addressPinged += 1
//            }
//        }
    }
    

}
