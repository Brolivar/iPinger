//
//  LocalAddress.swift
//  iPinger
//
//  Created by Jose Bolivar Herrera on 2/12/20.
//

import Foundation


protocol LocalAddressProtocol {

}

class LocalAddress {

    var address: String         // Instead of complete address, another option would have been only last part of string(hostID)
    var status: ReachabilityStatus      // Could also be just a bool value, but I prefered this for clarity

    init(address: String) {
        self.address = address
        // All addresses are initially unreachable
        self.status = .unreachable
    }
}
