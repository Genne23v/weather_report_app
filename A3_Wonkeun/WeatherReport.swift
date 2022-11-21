import Foundation

struct WeatherReport: Codable {
    static var idGenerator:Int = 0
    var id:Int = 0
    var city:String = ""
    var localTime:String = ""
    var windSpeed:Double = 0.0
    var windDegree:Int = 0
    var temperature:Double = 0
    
    init() {}
    
    enum RootKeys: String, CodingKey {
        case id
        case location = "location"
        case weather = "current"
    }
    
    enum LocationKeys: String, CodingKey {
        case city = "name"
        case localTime = "localtime"
    }
    
    enum WeatherKeys: String, CodingKey {
        case windSpeed = "wind_kph"
        case windDegree = "wind_degree"
        case temperature = "feelslike_c"
    }
    
    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: RootKeys.self)
        try rootContainer.encode(id, forKey: RootKeys.id)
        
        var locationContainer = rootContainer.nestedContainer(keyedBy: LocationKeys.self, forKey: RootKeys.location)
        var weatherContainer = rootContainer.nestedContainer(keyedBy: WeatherKeys.self, forKey: RootKeys.weather)
        
        try locationContainer.encode(city, forKey: LocationKeys.city)
        try locationContainer.encode(localTime, forKey: LocationKeys.localTime)
        try weatherContainer.encode(windSpeed, forKey: WeatherKeys.windSpeed)
        try weatherContainer.encode(windDegree, forKey: WeatherKeys.windDegree)
        try weatherContainer.encode(temperature, forKey: WeatherKeys.temperature)
    }
    
    init(from decoder:Decoder) throws {
        let response = try decoder.container(keyedBy: RootKeys.self)
        let location = try decoder.container(keyedBy: LocationKeys.self)
        let weather = try decoder.container(keyedBy: WeatherKeys.self)
        
        let locationContainer = try response.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        city = try locationContainer.decode(String.self, forKey: .city)
        localTime = try locationContainer.decode(String.self, forKey: .localTime)
        
        let weatherContainer = try response.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
        windSpeed = try weatherContainer.decode(Double.self, forKey: .windSpeed)
        windDegree = try weatherContainer.decode(Int.self, forKey: .windDegree)
        temperature = try weatherContainer.decode(Double.self, forKey: .temperature)
    }
}
