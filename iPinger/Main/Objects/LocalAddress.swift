//
//  LocalAddress.swift
//  iPinger
//
//  Created by Jose Bolivar Herrera on 2/12/20.
//

import Foundation

class LocalAddress: NSObject, NSCoding, NSSecureCoding  {

    static var supportsSecureCoding: Bool = true

    var address: String         // Instead of complete address, another option would have been only last part of string(hostID)
    var status: ReachabilityStatus      // Could also be just a bool value, but I prefered this for clarity

    init(address: String) {
        self.address = address
        // All addresses are initially unreachable
        self.status = .unreachable
    }

    // MARK: - NSCoding

    required init?(coder: NSCoder) {
        
        self.address = coder.decodeObject(forKey: "address") as? String ?? ""

        let decodedStatus = coder.decodeObject(forKey: "status") as? String

        if decodedStatus == "Reachable" {
            self.status = .reachable
        } else {
            self.status = .unreachable
        }

    }

    func encode(with coder: NSCoder) {
        coder.encode(self.address, forKey: "address")
        if self.status == .reachable {
            coder.encode("Reachable", forKey: "status")
        } else {
            coder.encode("Unreachable", forKey: "status")
        }
    }

}

