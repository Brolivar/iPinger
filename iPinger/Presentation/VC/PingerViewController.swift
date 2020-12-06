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


    @IBOutlet private var addressTableView: UITableView!
    @IBOutlet private var progressBar: UIProgressView!
    @IBOutlet private var sortButton: UIButton!

    // MARK: - Initialization
    override func viewDidLoad() {

        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self

        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.pingerProtocol.pingAllAddresses {
            self.addressTableView.reloadData()
        }
    }

    // MARK: - Actions
    @IBAction func startButton(_ sender: Any) {
    }

    @IBAction func stopButton(_ sender: Any) {
    }

    

}

// MARK: - UITableViewDelegate Extension
extension PingerViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource Extension
extension PingerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pingerProtocol.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIDs.AddressTableViewCell, for: indexPath) as? AddressTableViewCell
            else { return UITableViewCell() }

        let index = indexPath.row
        cell.configure(from: self.pingerProtocol.addressAt(index))
        return cell
    }


}

