//
//  ViewController.swift
//  Converter
//
//  Created by Юлия on 09.06.2020.
//  Copyright © 2020 Юлия. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var valut: UIButton!
    @IBOutlet weak var rezultLabel: UILabel!
    @IBOutlet weak var inputValutLabel: UILabel!
    
    var rubToUsd = true
    var courses: Courses?
    var finalValut = "RUB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(path: "USD")
    }
    
    func fetchData(path: String) {
        
        dataResponce(url: "https://api.exchangeratesapi.io/latest?base=" + path) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                print(courses)
                self.inputValutLabel.text = "Исходная валюта: \(path)"
                self.getResult(count: 1)
                self.inputField.text = "1"
            }
        }
    }
    
    func getResult(count: Double) {
        
        guard let course = courses?.rates[finalValut] else {
            return
        }
        
        let result = count * course
        
        rezultLabel.text = "Результат в \(finalValut): " + String(format: "%.2f", result)
    }
    
    
    func dataResponce(url: String, completion: @escaping (_ courses: Courses)->()) {
        
        guard let url = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let courses = try decoder.decode(Courses.self, from: data)
                completion(courses)
                
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toInputSource" {
            let vc = segue.destination as? InputValutViewController
            vc?.delegate = self
            vc?.isSource = true
        } else if segue.identifier == "toInputFinal" {
            let vc = segue.destination as? InputValutViewController
            vc?.delegate = self
            vc?.isSource = false
        }
    }
    
    @IBAction func per(_ sender: Any){
        
        guard let digitStr = inputField.text, let digit = Double(digitStr) else {
            return
        }
        getResult(count: digit)
    }
    
}

extension  MainViewController: InputValutViewControllerDelegat {
    func valutSender(valut: String, isSource: Bool) {
        
        if isSource {
            fetchData(path: valut)
        } else {
            print("Получаемая валюта: \(valut)")
            finalValut = valut
            rezultLabel.text = "Результат в \(valut):"
            if let digitStr = inputField.text, let digit = Double(digitStr) {
                getResult(count: digit)
            } else {
                inputField.text = "1"
                getResult(count: 1.0)
            }
        }
    }
}

struct Courses: Codable {
    
    let base: String?
    let date: String?
    let rates: [String: Double]
}


