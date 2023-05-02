//
//  ReservationsView.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import SwiftUI

struct ReservationsView: View {
  @Environment(\.horizontalSizeClass) private var hClass
  @StateObject private var viewModel = ReservationsViewModel()
  @State private var showingReservationForm = false
  
  var body: some View {
    ScrollView {
      Grid {
        GridRow {
          Text("Name")
            .font(.headline)
          Text("Date")
            .font(.headline)
          if hClass == .regular {
            Text("Time")
              .font(.headline)
          }
          Text("# Guests")
            .font(.headline)
            .gridCellColumns(2)
        }
        ForEach(viewModel.reservations) { reservation in
          GridRow {
            Text(reservation.name)
            Text(reservation.date, style: .date)
              .gridCellColumns(
                reservation.occasion == .none && hClass == .compact ? 2 : 1
              )
            if hClass == .regular {
              Text(reservation.date, style: .time)
            }
            Text("\(reservation.numberOfGuests)")
            if reservation.occasion != .none || hClass == .regular {
              occasionIcon(for: reservation)
            }
          }
          .padding()
          
          Divider()
        }
      }
    }
    .navigationTitle("Reservations")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          self.showingReservationForm = true
        }) {
          Image(systemName: "plus")
        }
      }
    }
    .sheet(isPresented: $showingReservationForm) {
      NavigationView {
        ReservationView(isPresenting: $showingReservationForm)
      }
    }
  }
  
  @ViewBuilder
  private func occasionIcon(for reservation: Reservation) -> some View {
    switch reservation.occasion {
    case .birthday:
      Image(systemName: "hands.sparkles")
        .foregroundColor(.indigo)
    case .anniversary:
      Image(systemName: "flame.fill")
        .foregroundColor(.orange)
    case .other:
      Image(systemName: "move.3d")
        .foregroundColor(.cyan)
    case .none:
      EmptyView()
    }
  }
}

struct ReservationsView_Previews: PreviewProvider {
  static var previews: some View {
      ReservationsView()
  }
}
