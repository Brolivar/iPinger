//
//  ViewController.swift
//  iPinger
//
//  Created by Brolivar on 21/11/20.
//

import UIKit
import PlainPing

class PingerViewController: UIViewController {

    // MARK: - Properties


    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            if let latency = timeElapsed {
                //self.pingResultLabel.text = "latency (ms): \(latency)"
                print("YES")
                print("latency (ms): \(latency)")
            }

            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        })

    }

}

