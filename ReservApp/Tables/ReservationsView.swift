//
//  ReservationsView.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import SwiftUI

struct ReservationsView: View {
  @StateObject private var viewModel = ReservationsViewModel()
  @State private var showingReservationForm = false
  
  var body: some View {
    List(viewModel.reservations) { reservation in
      VStack(alignment: .leading) {
        Text(reservation.name)
          .font(.headline)
        Text("Date: \(reservation.date), Guests: \(reservation.numberOfGuests), Occasion: \(reservation.occasion.displayName)")
          .foregroundColor(.secondary)
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
}

struct ReservationsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationSplitView {
      List {
        Label("Reservations", systemImage: "plus")
      }
      .listStyle(.sidebar)
    } detail: {
      ReservationsView()
    }
  }
}
