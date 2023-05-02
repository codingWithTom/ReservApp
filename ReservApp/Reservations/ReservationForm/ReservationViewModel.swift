//
//  ReservationViewModel.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import Foundation

final class ReservationViewModel: ObservableObject {
  struct Dependencies {
    var reservationService: ReservationService = ReservationServiceAdapter.shared
  }
  
  @Published var numberOfGuests = 1
  @Published var occasion: ReservationOccasion = .none
  @Published var reservationName = ""
  @Published var reservationDate = Date()
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func saveReservation() {
    let reservation = Reservation(
      name: reservationName,
      date: reservationDate,
      numberOfGuests: numberOfGuests,
      occasion: occasion
    )
    dependencies.reservationService.saveReservation(reservation)
  }
}
