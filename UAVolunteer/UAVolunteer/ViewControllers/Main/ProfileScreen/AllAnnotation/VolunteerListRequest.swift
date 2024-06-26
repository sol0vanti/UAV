import Foundation

struct VolunteerListRequest: Identifiable {
    var id: String
    var name: String
    var business: String
    var type: String
    var logoSet: Bool
}
