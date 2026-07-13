import Foundation

struct Trip: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var distanceKm: Int
    var travelTime: String
    var description: String = ""
    var checklistTypeIds: [UUID] = []
    var stops: [Stop] = []
    var createdAt: Date = Date()

    func packingProgress(in store: AppDetails) -> Double {
        let types = store.checklistTypes.filter { checklistTypeIds.contains($0.id) }
        let total = types.reduce(0) { $0 + $1.totalCount }
        let packed = types.reduce(0) { $0 + $1.packedCount }
        guard total > 0 else { return 0 }
        return Double(packed) / Double(total)
    }
}
