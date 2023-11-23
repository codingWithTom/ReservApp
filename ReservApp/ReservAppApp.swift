//
//  ReservAppApp.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import SwiftUI
import TipKit

enum AppDestinations {
  case upcoming
  case past
}

final class AppViewModel: ObservableObject {
  @Published var destination: AppDestinations? = .upcoming
  
  func showPastReservations() {
    withAnimation { destination = .past }
  }
}

@main
struct ReservAppApp: App {
  @StateObject var viewModel = AppViewModel()
  
  init() {
    try? Tips.resetDatastore()
    try? Tips.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      sidebar
        .environmentObject(viewModel)
    }
  }
  
  private var sidebar: some View {
    NavigationSplitView {
      List(selection: $viewModel.destination) {
        NavigationLink(value: AppDestinations.upcoming) {
          Label("Reservations", systemImage: "plus")
        }
          
        NavigationLink(value: AppDestinations.past) {
          Label("Past Reservations", systemImage: "minus")
        }
      }
      .listStyle(.sidebar)
    } detail: {
      if viewModel.destination == .past {
        HandledReservations()
      } else {
        ReservationsView()
      }
    }
  }
}
