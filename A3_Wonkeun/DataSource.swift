import Foundation

class DataSource {
    static let shared = DataSource()
    private init() {}
    
    var weatherReportData:[WeatherReport] = []

}
