//
//  PingerViewController.swift
//  iPinger
//
//  Created by Jose Bolivar on 21/11/20.
//

import UIKit

class PingerViewController: UIViewController {

    // MARK: - Properties

    //Ideally this should be injected by a third party entity (i.e navigator, segue manager, etc...)
    var pingerProtocol: PingerModelControlerProtocol! = PingerModelController()


    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.pingerProtocol.pingAllAddresses {
            print("Pinging finished")
        }
    }

}

