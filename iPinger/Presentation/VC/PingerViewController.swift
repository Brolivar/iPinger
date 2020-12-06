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
    @IBOutlet private var updateLabel: UILabel!

    // MARK: - Initialization
    override func viewDidLoad() {

        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self

        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // TODO: Check if we already have store results to fetch new or not
        self.fetchNewResults()
    }

    // MARK: - Actions
    @IBAction func startButton(_ sender: Any) {
        self.fetchNewResults()
    }

    @IBAction func stopButton(_ sender: Any) {
        print("Cancelling operations.")
        self.updateLabel.text = "Cancelled"

        self.pingerProtocol.stopUpdatingResults()
        DispatchQueue.main.async {
            self.progressBar.progressTintColor = .green
            self.progressBar.progress = 0
        }
    }


    private func fetchNewResults() {
        self.progressBar.progress = 0
        self.progressBar.progressTintColor = .green

        self.updateLabel.text = "Updating..."


        self.pingerProtocol.pingAllAddresses { status, currentProgress in

            DispatchQueue.main.async {
                //print("Progress is now: ", Float(currentProgress))
                self.progressBar.setProgress(Float(currentProgress), animated: true)
            }

            if status {     // Finished Fetch
                print("Pinging finished")
                DispatchQueue.main.async {
                    self.progressBar.progressTintColor = .blue
                    self.addressTableView.reloadData()
                    self.updateLabel.text = "Completed"
                }
            }
        }
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

