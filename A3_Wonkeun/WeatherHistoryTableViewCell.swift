import UIKit

class WeatherHistoryTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var lblCityAndDate: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

