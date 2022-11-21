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
    
    //Reload the table when entering from Weather Today tab
    override func viewDidAppear(_ animated: Bool) {
        print("WeatherHistoryViewControoler viewDidAppear")
        print(DataSource.shared.weatherHistoryData.count)
        
        DataSource.shared.weatherHistoryData = WeatherReport.getAllWeatherReports
        self.weatherHistoryTableView.reloadData()
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
        cell.lblTemperature.text = "\(weatherDataRow.temperature) °C"
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
