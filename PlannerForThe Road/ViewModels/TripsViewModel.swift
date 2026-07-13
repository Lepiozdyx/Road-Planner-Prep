import Foundation
import Observation

@Observable
final class TripsViewModel {
    var searchText = ""

    func filtered(_ trips: [Trip]) -> [Trip] {
        guard !searchText.isEmpty else { return trips }
        return trips.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
