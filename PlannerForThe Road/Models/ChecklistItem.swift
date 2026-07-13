import Foundation

struct ChecklistItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var quantity: Int
    var isPacked: Bool = false
    var photoData: Data?
}
