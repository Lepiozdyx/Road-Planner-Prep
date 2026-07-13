import Foundation

struct Stop: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var distanceFromStart: Int
    var places: [Place] = []
}
