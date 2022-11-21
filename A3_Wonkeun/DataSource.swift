import Foundation

class DataSource {
    static let shared = DataSource()
    private init() {}
    
    //Single weather report to store current weather
    var weatherDataNow:WeatherReport = WeatherReport()
    //Array of weather reports to display in history screen
    var weatherHistoryData:[WeatherReport] = []

}
