import UIKit

class WeatherHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var defaults:UserDefaults = UserDefaults.standard
    
    //MARK: Outlets
    @IBOutlet weak var weatherHistoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherHistoryTableView.delegate = self
        weatherHistoryTableView.dataSource = self
        print("WeatherHistoryViewController viewDidLoad")

        self.weatherHistoryTableView.rowHeight = 130

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("WeatherHistoryViewControoler viewDidAppear")
//        let weatherHistoryFromUserDefault:Data? = defaults.data(forKey: "WEATHER_DATA")
        let weatherHistoryFromUserDefault:[WeatherReport]? = defaults.array(forKey: "WEATHER_DATA") as? [WeatherReport]
        print(weatherHistoryFromUserDefault)
        if let weatherHistory = weatherHistoryFromUserDefault {
            print("Found a value under WEATHER_DATA")
            
            do {
                let decoder = JSONDecoder()
//                let weatherHistory = try decoder.decode(WeatherReport.self, from: weatherHistory)
//                print(weatherHistory)
            } catch {
                print("Could not decode WEATHER_DATA")
                print(error)
            }
            
        } else {
            print("Cannot find a value with key WEATHER_DATA")
            return
        }

    }
    
    
    //MARK: TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.weatherHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherHistoryTableView.dequeueReusableCell(withIdentifier: "weatherDataCell", for: indexPath) as! WeatherHistoryTableViewCell
        
        let weatherDataRow:WeatherReport = DataSource.shared.weatherHistoryData[indexPath.row]
        
        let localtimeSplit = weatherDataRow.localTime.split(separator: " ")
        cell.lblCityAndDate.text = "\(weatherDataRow.city) at \(localtimeSplit[1]) on \(localtimeSplit[0])"
        
        let windDirection = Direction(Double(weatherDataRow.windDegree ))
        cell.lblWind.text = "Wind: \(weatherDataRow.windSpeed) kph from \(windDirection)"
        cell.lblTemperature.text = "\(weatherDataRow.temperature)"
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
