//
//  ViewController.swift
//  SWAPI-Species
//
//  Created by John Gallaugher on 8/13/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadAllButton: UIBarButtonItem!
    
    var species = Species()
    var activityIndicator = UIActivityIndicatorView()
    var loadAll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    func activityIndicatorSetup() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func activityIndicatorEnded() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func loadData() {
        if species.nextURL.hasPrefix("http") {
            activityIndicatorSetup()
            species.getSpecies {
                self.tableView.reloadData()
                let count = self.species.speciesArray.count
                let numberOfSpecies = self.species.numberOfSpecies
                self.navigationItem.title = "\(count) of \(numberOfSpecies) species loaded"
                self.activityIndicatorEnded()
                if self.loadAll {
                    self.loadData()
                }
            }
        } else {
            self.loadAll = false
        }
    }
    
    @IBAction func loadAllPressed(_ sender: UIBarButtonItem) {
        loadAll = true
        loadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return species.speciesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row+1). \(species.speciesArray[indexPath.row].name)"
        if indexPath.row == species.speciesArray.count-1 {
            loadData()
        }
        return cell
    }
}
