import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: Variables
    let geocoder = CLGeocoder()
    var locationManager:CLLocationManager!
    var lat:Double = 0.0
    var lng:Double = 0.0
    var city:String = ""
//    var weatherReport:WeatherReport
    var defaults:UserDefaults = UserDefaults.standard

    //MARK: Outlets
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //IS IT NEEDED?
        locationManager.delegate = self
        
    }

    //MARK: Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        if let lastKnownLocation:CLLocation = locations.first {
            print("Location update received: \(lastKnownLocation.coordinate.latitude), \(lastKnownLocation.coordinate.longitude)")
            
            lat = lastKnownLocation.coordinate.latitude
            lng = lastKnownLocation.coordinate.longitude
        }
        
        let locationToGeocode = CLLocation(latitude: lat, longitude: lng)
        geocoder.reverseGeocodeLocation(locationToGeocode) { (result, error) in
            
            if error != nil {
                print("Error occurred when connecting to geocoding service")
                print(error)
                return
            } else {
                if result == nil {
                    print("Unable to find address")
                    return
                } else {
                    if result!.isEmpty {
                        print("Unable to find address")
                        return
                    } else {
                        let placemark = result!.first
                        print("Address found: \(placemark?.locality), \(placemark?.subLocality)")
                        self.city = placemark?.locality ?? ""
                        
                        self.fetchWeatherData(city: self.city)
                    }
                }
            }
        }
    }
    
    @IBAction func saveReportBtn(_ sender: Any) {
        
        do {
//            let encoder = JSONEncoder()
//            let encodedWeatherReport = try encoder.encode(weatherReport)
//            defaults.set(encodedWeatherReport, forKey: "KEY_WEATHER")
        } catch {
            print("Cannot encode the weahterReport data")
            print(error)
        }
    
    }
    
    func fetchWeatherData(city:String) {
        
        let weatherApiEndpoint = "https://api.weatherapi.com/v1/current.json?key=dbb5a3ccfd784a43b2430206221811&q=\(city)&api=no"
        
        guard let apiUrl = URL(string: weatherApiEndpoint) else {
            print("Could not convert the string endpoint to an URL object")
            return
        }
        
        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            print("weatherApiEndpoint: \(apiUrl)")
            
            if let err = error {
                print("Error occurred while fetching data from api")
                print(err)
                return
            }
            
            if let jsonData = data {
                print("Printing JSON data")
                print(jsonData)
                
                do {
                    let decoder = JSONDecoder()
//                    self.weatherReport
                    let decodedItem:WeatherReport = try decoder.decode(WeatherReport.self, from: jsonData)
                    print("Printing decodedItem")
                    print(decodedItem)
                } catch let error {
                    print("An error occurred during JSON decoding")
                    print(error)
                }
            }
        }.resume()
    }
}

