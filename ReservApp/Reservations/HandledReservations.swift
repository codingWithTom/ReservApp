//
//  HandledReservations.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-11-20.
//

import SwiftUI

struct HandledReservations: View {
  @StateObject private var viewModel = HandledReservationsViewModel()
  var body: some View {
    Grid {
      GridRow {
        Text("Name")
          .font(.headline)
        Text("Date")
          .font(.headline)
        Text("Resolution")
          .font(.headline)
      }
      ForEach(viewModel.reservations) { reservation in
        GridRow {
          Text(reservation.name)
          Text(reservation.date, style: .date)
          resoultionIcon(for: reservation)
        }
        .padding()
        
        Divider()
      }
    }
  }
  
  @ViewBuilder
  private func resoultionIcon(for reservation: Reservation) -> some View {
    switch reservation.resolution {
    case .seated:
      Image(systemName: "checkmark.seal.fill")
        .foregroundColor(.green)
    case .noShow:
      Image(systemName: "x.square")
        .foregroundColor(.red)
    case .none:
      EmptyView()
    }
  }
}

#Preview {
  HandledReservations()
}
