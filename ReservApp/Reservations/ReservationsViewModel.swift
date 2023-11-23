//
//  ReservationsViewModel.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import Foundation
import Combine

final class ReservationsViewModel: ObservableObject {
  struct Dependencies {
    var reservationService: ReservationService = ReservationServiceAdapter.shared
  }
  
  @Published var reservations: [Reservation] = []
  @Published var upcomingReservation: Reservation?
  private var cancellable: AnyCancellable?
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    fetchReservations()
  }
  
  // MARK: - Private Methods
  
  func fetchReservations() {
    cancellable = dependencies.reservationService.reservations
      .receive(on: RunLoop.main)
      .sink { [weak self] in
        let unhandledReservations = $0.filter { $0.resolution == nil }
        self?.upcomingReservation = unhandledReservations.first
        self?.reservations = Array(unhandledReservations.dropFirst())
      }
  }
  
  func popNextReservation(wasSeated: Bool) {
    guard let upcomingReservation else { return }
    dependencies.reservationService.addResolution(wasSeated ? .seated : .noShow, toReservation: upcomingReservation)
  }
}
