//
//  HomeView.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2024-03-12.
//

import SwiftUI

struct HomeView: View {
  @StateObject var viewModel = HomeViewModel()
  var body: some View {
    VStack {
      content
      Spacer()
      homeMessage
      Spacer()
    }
    .onAppear { viewModel.checkState() }
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case .downloaded:
      Button(action: { viewModel.selectedTheme() }) {
        HStack {
          Text("Select")
          Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(Color.green)
        }
      }
    case .available:
      Button(action: { viewModel.downloadTheme() }) {
        Image(systemName: "arrow.down.heart")
      }
    case .selected:
      Button(action: { viewModel.removeTheme() }) {
        HStack {
          Text("Delete")
          Image(systemName: "x.circle")
        }
      }
      .foregroundStyle(Color.red)
    case .unavailable:
      Text("New themes coming soon")
    case .downloading:
      ProgressView()
    }
  }
  
  private var homeMessage: some View {
    VStack {
      Text(viewModel.message.message)
        .foregroundStyle(viewModel.message.color == .orange ? Color.orange : Color.accentColor )
      if let image = viewModel.image {
        image
          .resizable()
          .frame(width: 300, height: 300)
      }
      
    }
  }
}

#Preview {
  HomeView()
}
