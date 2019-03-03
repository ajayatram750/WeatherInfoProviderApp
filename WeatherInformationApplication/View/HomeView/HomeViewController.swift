//
//  HomeViewController.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
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

        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        getLatAndLongButton.layer.borderWidth = 1
        getLatAndLongButton.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK:- Button Actions
    
    //This method is used for calling the Weather Details ViewController if user get Lat & Log from Geo
    @IBAction func getWeatherDetailsButtonClicked(_ sender: Any) {
        
        guard let txtLat = latitudeTextField.text, txtLat.count > 0 else {
            self.showAlert(title: ErrorMessages.LATITUDE_INPUT_MISSING, message: "")
            return
        }
        guard let txtLong = longitudeTextField.text, txtLong.count > 0 else {
            self.showAlert(title: ErrorMessages.LONGITUDE_INPUT_MISSING, message: "")
            return
        }
        guard let myVC = storyboard?.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as? WeatherDetailsViewController else {
            return
        }
        myVC.latitude = txtLat
        myVC.longitude = txtLong
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    // Its simply call the popup for input city name and provides the latitude & longitude
    @IBAction func getLatAndLongFromCity(_ sender: Any) {
        self.promptForCityInput()
    }
    
    
    // Using City name, Its provide the latitude & longitude cordinates for that city
    func getLatAndLong(address:String){
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            self.handleGeocodeAddressResponse(placemarks)
        }
    }
    
    func handleGeocodeAddressResponse(_ placemarks: [CLPlacemark]?) {
        
        self.errorLabelForLatLon.isHidden = true
        if let latitude = placemarks?.first?.location?.coordinate.latitude {
            self.latitudeTextField.text = String(latitude)
        } else {
            self.errorLabelForLatLon.isHidden = false
            self.errorLabelForLatLon.text = ErrorMessages.ERROR_TO_GET_LATLON
        }
        if let longitude = placemarks?.first?.location?.coordinate.longitude {
            self.longitudeTextField.text = String(longitude)
        } else {
            self.errorLabelForLatLon.isHidden = false
            self.errorLabelForLatLon.text = ErrorMessages.ERROR_TO_GET_LATLON
        }
    }
    
    //This method is used to enter city or any place name, It's provide the latitude & longitude cordinates for that city
    func promptForCityInput() {
        let alert = UIAlertController(title: GeneralText.CITY_NAME_REQUEST, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = GeneralText.CITY_NAME_REQUEST
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textFields = alert?.textFields, let cityName = textFields[0].text, cityName.count > 0 {
                self.getLatAndLong(address:cityName)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Use to make the view or any subview that is the first responder resign
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

extension HomeViewController: UITextFieldDelegate {
    //MARK:- UITextfield delegate method to allow only numeric
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == string.components(separatedBy: NSCharacterSet(charactersIn:"0123456789.").inverted).joined(separator: "")
    }
}
