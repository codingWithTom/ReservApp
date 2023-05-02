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
        self?.reservations = $0
      }
  }
}
