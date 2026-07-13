import Foundation
import Observation
import SwiftUI

@Observable
final class AppDetails {
    var trips: [Trip] = []
    var checklistTypes: [ChecklistType] = []

    private let tripsKey = "planner.trips"
    private let checklistTypesKey = "planner.checklistTypes"

    init() {
        load()
        if checklistTypes.isEmpty {
            seedDefaultChecklistTypes()
        }
    }

    // MARK: - Trip CRUD

    func addTrip(_ trip: Trip) {
        trips.append(trip)
        saveTrips()
    }

    func updateTrip(_ trip: Trip) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else { return }
        trips[index] = trip
        saveTrips()
    }

    func deleteTrip(id: UUID) {
        trips.removeAll { $0.id == id }
        saveTrips()
    }

    func deleteTrips(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
        saveTrips()
    }

    // MARK: - ChecklistType CRUD

    func addChecklistType(_ type: ChecklistType) {
        checklistTypes.append(type)
        saveChecklistTypes()
    }

    func updateChecklistType(_ type: ChecklistType) {
        guard let index = checklistTypes.firstIndex(where: { $0.id == type.id }) else { return }
        checklistTypes[index] = type
        saveChecklistTypes()
    }

    func deleteChecklistType(id: UUID) {
        checklistTypes.removeAll { $0.id == id }
        trips = trips.map { trip in
            var t = trip
            t.checklistTypeIds.removeAll { $0 == id }
            return t
        }
        saveTrips()
        saveChecklistTypes()
    }

    func addItem(_ item: ChecklistItem, toTypeId typeId: UUID) {
        guard let index = checklistTypes.firstIndex(where: { $0.id == typeId }) else { return }
        checklistTypes[index].items.append(item)
        saveChecklistTypes()
    }

    func toggleItem(id: UUID, inTypeId typeId: UUID) {
        guard let typeIndex = checklistTypes.firstIndex(where: { $0.id == typeId }),
              let itemIndex = checklistTypes[typeIndex].items.firstIndex(where: { $0.id == id }) else { return }
        checklistTypes[typeIndex].items[itemIndex].isPacked.toggle()
        saveChecklistTypes()
    }

    func deleteItem(id: UUID, fromTypeId typeId: UUID) {
        guard let typeIndex = checklistTypes.firstIndex(where: { $0.id == typeId }) else { return }
        checklistTypes[typeIndex].items.removeAll { $0.id == id }
        saveChecklistTypes()
    }

    // MARK: - Stop CRUD

    func addStop(_ stop: Stop, toTripId tripId: UUID) {
        guard let index = trips.firstIndex(where: { $0.id == tripId }) else { return }
        trips[index].stops.append(stop)
        saveTrips()
    }

    func deleteStop(id: UUID, fromTripId tripId: UUID) {
        guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }) else { return }
        trips[tripIndex].stops.removeAll { $0.id == id }
        saveTrips()
    }

    func addPlace(_ place: Place, toStopId stopId: UUID, tripId: UUID) {
        guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }),
              let stopIndex = trips[tripIndex].stops.firstIndex(where: { $0.id == stopId }) else { return }
        trips[tripIndex].stops[stopIndex].places.append(place)
        saveTrips()
    }

    // MARK: - Persistence

    private func load() {
        if let data = UserDefaults.standard.data(forKey: tripsKey),
           let decoded = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decoded
        }
        if let data = UserDefaults.standard.data(forKey: checklistTypesKey),
           let decoded = try? JSONDecoder().decode([ChecklistType].self, from: data) {
            checklistTypes = decoded
        }
    }

    private func saveTrips() {
        if let data = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(data, forKey: tripsKey)
        }
    }

    private func saveChecklistTypes() {
        if let data = try? JSONEncoder().encode(checklistTypes) {
            UserDefaults.standard.set(data, forKey: checklistTypesKey)
        }
    }

    private func seedDefaultChecklistTypes() {
        let defaults: [ChecklistType] = [
            ChecklistType(name: "Sea Trip", emoji: "🏖️"),
            ChecklistType(name: "Mountain Route", emoji: "🏕️"),
            ChecklistType(name: "Winter Travel", emoji: "❄️"),
            ChecklistType(name: "Family Visit", emoji: "👨‍👩‍👧‍👦")
        ]
        checklistTypes = defaults
        saveChecklistTypes()
    }
}
