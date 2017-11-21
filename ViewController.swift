//
//  ViewController.swift
//  17 App Whats The Weather
//
//  Created by Jack Stone on 21/11/2017.
//  Copyright © 2017 Jack Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    
    @IBAction func getWeatherButton(_ sender: Any) {
        
        var hasFoundCity: Bool = false
        
        // get contents of weather-forecast.com API //
        if let url = URL(string: "https://www.weather-forecast.com/locations/\(cityTextField.text!.replacingOccurrences(of: " ", with: "-"))/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            
            // Task is a closure - doing task off the main thread //
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                // message to user //
                var message = ""
                
                // code for task //
                if let error = error {
                    print(error)
                } else {
                    // if we can create unwrapped Data //
                    if let unwrappedData = data {
                        // create String of data using utf-8 encoding //
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        // print(dataString!)
                        
                        // process data //
                        // grab start of content we want //
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            // print(contentArray)
                            if contentArray.count > 1 {
                                
                                // update stringSeparator to filter out everything after the content we want //
                                stringSeparator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                
                                if newContentArray.count > 1 {
                                    
                                    // update message //
                                    // replace HTML entities in message using replacingOccurrences() //
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                    
                                    // bool for the cityTitleLabel //
                                    hasFoundCity = true
                                }
                            }
                        }
                    }
                }
                
                // handle error cases //
                if message == "" {
                    // something has gone wrong... set message to error //
                    message = "The weather there couldn't be found. Please try again!"
                }
                
                DispatchQueue.main.sync(execute: {
                    // need to use self to access entities outside of task closure //
                    self.resultLabel.text = message
                    
                    if hasFoundCity {
                        // if city was found, display city name //
                        self.cityTitleLabel.text = "Here's the weather for \(self.cityTextField.text!):"
                    }
                })
            }
            // start task //
            task.resume()
        } else {
            // if we can't get valid URL //
            resultLabel.text = "The weather there couldn't be found. Please try again!"
        }
        
        // close keyboard on submit press //
        self.view.endEditing(true)
    }
    
    // Keyboard Functionality //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // close keyboard if tap outside of keyboard //
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close keyboard if tap return //
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

