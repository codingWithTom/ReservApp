//
//  ReservAppApp.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import SwiftUI

@main
struct ReservAppApp: App {
  var body: some Scene {
    WindowGroup {
      sidebar
    }
  }
  
  private var sidebar: some View {
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
