//
//  ReservationService.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import Foundation
import Combine

struct Reservation: Identifiable {
  var id: String { "\(name)\(date.description)"}
  let name: String
  let date: Date
  let numberOfGuests: Int
  let occasion: ReservationOccasion
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
}

private extension ReservationServiceAdapter {
  func setInitialData() {
    reservationSubject.value = [
      Reservation(name: "John Doe", date: Date(), numberOfGuests: 4, occasion: .birthday),
      Reservation(name: "Jane Smith", date: Date().addingTimeInterval(86400), numberOfGuests: 2, occasion: .anniversary),
      Reservation(name: "Bob Johnson", date: Date().addingTimeInterval(172800), numberOfGuests: 8, occasion: .other)
    ]
  }
}
