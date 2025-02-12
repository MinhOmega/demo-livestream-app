import Foundation

class SettingsConfig {
    static let share = SettingsConfig()
    
    var userId: String = ""
    var avatar: String = ""
    var name: String = ""
    var followCount: Int = 0
    var fansCount: Int = 0
} 