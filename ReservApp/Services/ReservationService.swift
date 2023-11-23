//
//  ReservationService.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import Foundation
import Combine

struct Reservation: Identifiable {
  enum Resolution {
    case seated
    case noShow
  }
  var id: String { "\(name)\(date.description)"}
  let name: String
  let date: Date
  let numberOfGuests: Int
  let occasion: ReservationOccasion
  var resolution: Resolution?
}

enum ReservationOccasion: CaseIterable {
  case anniversary
  case birthday
  case other
  case none
}

protocol ReservationService {
  var reservations: AnyPublisher<[Reservation], Never> { get }
  func saveReservation(_: Reservation)
  func addResolution(_ resolution: Reservation.Resolution, toReservation reservation: Reservation)
}

final class ReservationServiceAdapter: ReservationService {
  static let shared = ReservationServiceAdapter()
  var reservations: AnyPublisher<[Reservation], Never> {
    reservationSubject.eraseToAnyPublisher()
  }
  private var reservationSubject = CurrentValueSubject<[Reservation], Never>([])
  
  private init() {
    setInitialData()
  }
  
  func saveReservation(_ reservation: Reservation) {
    var reservations = reservationSubject.value
    reservations.append(reservation)
    reservationSubject.value = reservations
  }
  
  func addResolution(_ resolution: Reservation.Resolution, toReservation reservation: Reservation) {
    var reservations = reservationSubject.value
    guard let index = reservations.firstIndex(where: { $0.id == reservation.id }) else { return }
    var newReservation = reservation
    newReservation.resolution = resolution
    reservations[index] = newReservation
    reservationSubject.value = reservations
  }
}

private extension ReservationServiceAdapter {
  func setInitialData() {
    reservationSubject.value = [
      Reservation(name: "John Doe", date: Date(), numberOfGuests: 4, occasion: .birthday),
      Reservation(name: "Jane Smith", date: Date().addingTimeInterval(86400), numberOfGuests: 2, occasion: .anniversary),
      Reservation(name: "Bob Johnson", date: Date().addingTimeInterval(172800), numberOfGuests: 8, occasion: .other),
      Reservation(name: "John Appleseed", date: Date().addingTimeInterval(827812), numberOfGuests: 5, occasion: .none),
      Reservation(name: "Jane Doe", date: Date().addingTimeInterval(1027812), numberOfGuests: 6, occasion: .birthday)
    ]
  }
}
