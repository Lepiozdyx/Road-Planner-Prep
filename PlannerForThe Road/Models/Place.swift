import Foundation

struct Place: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
}
