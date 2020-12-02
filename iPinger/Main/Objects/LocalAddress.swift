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

    var address: String
    var status: ReachabilityStatus

    init(address: String) {
        self.address = address
        // All addresses are initially unreachable
        self.status = .unreachable
    }
}
