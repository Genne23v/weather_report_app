import UIKit

class WeatherHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var defaults:UserDefaults = UserDefaults.standard
    
    
    //MARK: Outlets
    @IBOutlet weak var weatherHistoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weatherReportFromUserDefault:[WeatherReport]? = defaults.array(forKey: "KEY_WEATHER") as? [WeatherReport]
        
        if let weatherReport = weatherReportFromUserDefault {
            print("Found a value under KEY_WEATHER")
            print(weatherReport)
        } else {
            print("Cannot find a value with key KEY_WEATHER")
            return
        }
        
    }
    
    
    //MARK: TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.weatherReportData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherHistoryTableView.dequeueReusableCell(withIdentifier: "weatherDataCell", for: indexPath) as! WeatherHistoryTableViewCell
        
        let currentWeatherData:WeatherReport = DataSource.shared.weatherReportData[indexPath.row]
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateStyle = DateFormatter.Style.long
        
//        cell.lblCity
        return cell
    }

    

}
