//
//  HomeViewModel.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2024-03-12.
//

import Foundation
import SwiftUI

enum HomeDecorationState {
  case downloaded
  case available
  case selected
  case unavailable
  case downloading
}

@MainActor
final class HomeViewModel: ObservableObject {
  @Published var image: Image? = .init(systemName: "play.house.fill")
  @Published var message: HomeMessage = .init(message: "Welcome to the Home", color: .accent)
  @Published var state: HomeDecorationState = .unavailable
  var halloween: NSBundleResourceRequest
  
  init() {
    halloween = NSBundleResourceRequest(tags: ["halloween"])
  }
  
  func checkState() {
    halloween.conditionallyBeginAccessingResources { isDownloaded in
      if isDownloaded {
        Task { await self.updateSate(.downloaded) }
      } else {
        Task { await self.updateSate(.available) }
      }
    }
  }
  
  func selectedTheme() {
    self.image = Image("HalloCat")
    if let dataAsset = NSDataAsset(name: "SpookyHomeMessage") {
      do {
        let message = try JSONDecoder().decode(HomeMessage.self, from: dataAsset.data)
        self.message = message
      } catch {
        print("Error trying to decode")
      }
    }
    updateSate(.selected)
  }
  
  func downloadTheme() {
    updateSate(.downloading)
    halloween.beginAccessingResources { error in
      guard error == nil else {
        Task { await self.updateSate(.available)}
        return
      }
      Task { await self.updateSate(.downloaded)}
    }
  }
  
  func removeTheme() {
    halloween.endAccessingResources()
  }
  
  private func updateSate(_ state: HomeDecorationState) {
    self.state = state
  }
}
 
