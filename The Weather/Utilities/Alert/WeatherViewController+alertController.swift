//
//  WeatherViewController+alertController.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import UIKit

extension WeatherViewController{
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping(String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField { textField in
            let cities = ["Moscow", "Tomsk", "Sochi", "Ufa"]
            textField.placeholder = cities.randomElement()
        }
        
        let search = UIAlertAction( title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else {
                return
            }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(search)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

