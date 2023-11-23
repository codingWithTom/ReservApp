//
//  Tips.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-11-21.
//

import Foundation
import TipKit

struct ManageReservationTip: Tip {
  var title: Text {
    Text("Manage Your Next Reservation")
      .foregroundStyle(.orange)
  }
  
  var message: Text? {
    Text("Now you can manage your upcoming reservation")
  }
  
  var image: Image? {
    Image(systemName: "bell.fill")
  }
}

struct PastReservationsTip: Tip {
  
  static let handledReservations: Event = Event(id: "handled-reservation")
  
  var title: Text {
    Text("Check Your Reservations")
      .foregroundStyle(.orange)
  }
  
  var message: Text? {
    Text("You can review your past reservation on the new tab")
  }
  
  var image: Image? {
    Image(systemName: "book.fill")
  }
  
  var rules: [Rule] {
    #Rule(Self.handledReservations) {
      $0.donations.count > 2
    }
  }
  
  var actions: [Action] {
    [
      .init {
        Text("Take me there")
      }
    ]
  }
}
