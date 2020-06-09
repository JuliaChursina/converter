//
//  InputValutViewController.swift
//  Converter
//
//  Created by Юлия on 09.06.2020.
//  Copyright © 2020 Юлия. All rights reserved.
//

import UIKit

class InputValutViewController: UIViewController {
    
    let mValute = ["USD", "EUR", "NZD", "ZAR", "IDR", "RON", "CNY", "JPY", "SEK", "TRY", "KRW", "HKD", "GBP", "PLN", "CZK", "MXN", "SGD", "ISK", "AUD", "ILS", "NOK", "THB", "BGN", "MYR", "HUF", "PHP", "CHF", "RUB", "HRK", "CAD", "DKK", "INR"]
    
    var isSource = true
    
    weak var delegate: InputValutViewControllerDelegat?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}


extension InputValutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mValute.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath)
        cell.textLabel?.text =  mValute[indexPath.row]
        return cell
    }
}

extension InputValutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.valutSender(valut: mValute[indexPath.row], isSource: isSource)
        dismiss(animated: true, completion: nil)
    }
    
}

protocol InputValutViewControllerDelegat: class {
    func valutSender(valut: String, isSource: Bool)
}
