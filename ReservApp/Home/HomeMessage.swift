//
//  HomeMessage.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2024-03-12.
//

import Foundation

struct HomeMessage: Decodable {
  enum HomeColor: String, Decodable {
    case accent
    case orange
  }
  let message: String
  let color: HomeColor
}
