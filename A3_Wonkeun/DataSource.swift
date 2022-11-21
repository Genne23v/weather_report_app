import Foundation

class DataSource {
    static let shared = DataSource()
    private init() {}
    
    var weatherDataNow:WeatherReport = WeatherReport()
    var weatherHistoryData:[WeatherReport] = []

}
