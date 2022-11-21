import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: Variables
    let geocoder = CLGeocoder()
    var locationManager:CLLocationManager!
    var lat:Double = 0.0
    var lng:Double = 0.0
    var city:String = ""
    var defaults:UserDefaults = UserDefaults.standard

    //MARK: Outlets
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var locationSymbol: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //Reload location data when entering from another tab
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    
    //MARK: Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        if let lastKnownLocation:CLLocation = locations.first {
            print("Location update received: \(lastKnownLocation.coordinate.latitude), \(lastKnownLocation.coordinate.longitude)")
            
            lat = lastKnownLocation.coordinate.latitude
            lng = lastKnownLocation.coordinate.longitude
        }
        
        //Reverse geocoding from latitude, longitude retreived from device
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
                        
                        //Fetch new weather data using city
                        self.fetchWeatherData(city: self.city)
                    }
                }
            }
        }
    }
    
    @IBAction func saveReportBtn(_ sender: Any) {
        //Add current weather data to an array
        DataSource.shared.weatherHistoryData.append(DataSource.shared.weatherDataNow)
        
        do {
            //Save all WeatherReport to UserDefaults
            WeatherReport.saveAllWeatherReports(allWeatherReports: DataSource.shared.weatherHistoryData)
            print("Data saved to UserDefaults")
        } catch {
            print("Could not save weahter data to UserDefaults")
            print(error)
        }
    }
    
    func fetchWeatherData(city:String) {
        
        //Replace empty spaces in city name to avoid fetch error
        let cityEncoded = city.replacingOccurrences(of: " ", with: "%20")
        
        let weatherApiEndpoint = "https://api.weatherapi.com/v1/current.json?key=dbb5a3ccfd784a43b2430206221811&q=\(cityEncoded)&api=no"
        
        guard let apiUrl = URL(string: weatherApiEndpoint) else {
            print("Could not convert the string endpoint to an URL object")
            print(weatherApiEndpoint)
            
            //Indicate weather info fetch was not successful on the screen
            self.lblDateTime.text = "____-__-__ __:__"
            self.lblLocation.text = "Can't find the location"
            self.lblTemperature.text = "__._ °C"
            self.lblWindSpeed.text = "___._ kph"
            self.lblWindDirection.text = "From ___"
            
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
                
                do {
                    //Decode fetched data and store it to singleton data
                    let decoder = JSONDecoder()
                    let decodedItem:WeatherReport = try decoder.decode(WeatherReport.self, from: jsonData)
                    print("Printing decodedItem")
                    print(decodedItem)
                    DataSource.shared.weatherDataNow = decodedItem
                    
                    //Update the view
                    self.updateWeatherView()
                } catch let error {
                    print("An error occurred during JSON decoding")
                    print(error)
                }
            }
        }.resume()
        
    }
    
    //Update view function
    func updateWeatherView() {
        let currentWeatherData:WeatherReport = DataSource.shared.weatherDataNow
        
        self.lblDateTime.text = currentWeatherData.localTime
        self.lblLocation.text = currentWeatherData.city
        self.lblTemperature.text = "\(currentWeatherData.temperature) °C"
        self.lblWindSpeed.text = "\(currentWeatherData.windSpeed) kph"
        let windDirection = Direction(Double(currentWeatherData.windDegree ))
        self.lblWindDirection.text = "From \(windDirection)"
    }
    
}

//MARK: Helper extension
enum Direction: String, CaseIterable {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
}

//Helper function to get a direction using wind degree
extension Direction: CustomStringConvertible {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self = Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
    }
    var description: String { rawValue.uppercased() }
}

extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}

