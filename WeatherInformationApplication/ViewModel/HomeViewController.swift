//
//  HomeViewController.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- IBoutlet declarations
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var errorLabelForLatLon: UILabel!
    @IBOutlet weak var getLatAndLongButton: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    //MARK:- Class life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        initialUpdateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.errorLabelForLatLon.isHidden = true
    }
    
    // Inital setup & update UI
    fileprivate func initialUpdateUI() {
        latitudeTextField.text = ""
        longitudeTextField.text = ""
        
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        getLatAndLongButton.layer.borderWidth = 1
        getLatAndLongButton.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK:- UITextfield delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let doubleValueAcceptableSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: doubleValueAcceptableSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    //MARK:- Button Actions
    
    /*
     Method Name : getWeatherDetailsButtonClicked button action
     Purpose     : It call the Weather Details ViewController
     Paramater   : Any
     Return      : None
     */
    @IBAction func getWeatherDetailsButtonClicked(_ sender: Any) {
        
        if(latitudeTextField.text == "" && longitudeTextField.text == ""){
            self.showAlert(title: ErrorMessages.LATLONG_INPUT_MISSING, message: "")
        }else if(latitudeTextField.text == ""){
            self.showAlert(title: ErrorMessages.LATITUDE_INPUT_MISSING, message: "")
        }else if(longitudeTextField.text == ""){
            self.showAlert(title: ErrorMessages.LONGITUDE_INPUT_MISSING, message: "")
        }else{
            let myVC = storyboard?.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as! WeatherDetailsViewController
            myVC.latitude = latitudeTextField.text!
            myVC.longitude = longitudeTextField.text!
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    /*
     Method Name : getLatAndLongFromCity button action
     Purpose     : Its simply call the popup for input city name and provides the latitude & longitude
     Paramater   : Any
     Return      : None
     */
    @IBAction func getLatAndLongFromCity(_ sender: Any) {
        self.promptForCityInput()
    }
    
    /*
     Method Name : getLatAndLong
     Purpose     : Using City name, Its provide the latitude & longitude cordinates for that city
     Paramater   : address
     Return      : None
     */
    func getLatAndLong(address:String){
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            self.errorLabelForLatLon.isHidden = true
            
            if let latitude = lat{
                self.latitudeTextField.text = String(latitude)
            }else{
                self.errorLabelForLatLon.isHidden = false
                self.errorLabelForLatLon.text = ErrorMessages.ERROR_TO_GET_LATLON
            }
            
            if let longitude = lon{
                self.longitudeTextField.text = String(longitude)
            }else{
                self.errorLabelForLatLon.isHidden = false
                self.errorLabelForLatLon.text = ErrorMessages.ERROR_TO_GET_LATLON
            }
        }
    }
    
    /*
     Method Name : promptForCityInput
     Purpose     : Enter City name, Its provide the latitude & longitude cordinates for that city
     Paramater   : None
     Return      : None
     */
    func promptForCityInput() {
        
        let alert = UIAlertController(title: GeneralText.CITY_NAME_REQUEST, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = GeneralText.CITY_NAME_REQUEST
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            
            if let cityName = textField?.text{
                
                if(cityName != ""){
                    self.getLatAndLong(address:cityName)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Method Name : touchesBegan
     Purpose     : Use to make the view or any subview that is the first responder resign
     Paramater   : UITouch & touch event
     Return      : None
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
