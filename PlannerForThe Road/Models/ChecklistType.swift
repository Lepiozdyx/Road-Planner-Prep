import Foundation

struct ChecklistType: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var emoji: String
    var items: [ChecklistItem] = []

    var packedCount: Int { items.filter(\.isPacked).count }
    var totalCount: Int { items.count }
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(packedCount) / Double(totalCount)
    }
}
