//
//  AddressTableViewCell.swift
//  iPinger
//
//  Created by Jose Bolivar on 6/12/20.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet private var ipAddress: UILabel!
    @IBOutlet private var statusImage: UIImageView!


    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(from address: LocalAddress) {

        self.ipAddress.text = address.address
        if address.status == .reachable {
            self.statusImage.image = UIImage(systemName: "wifi")
            self.statusImage.tintColor = UIColor.appColor(.greenColor)
        } else {
            self.statusImage.image = UIImage(systemName: "wifi.slash")
            self.statusImage.tintColor = UIColor.appColor(.redColor)
        }
    }
}
