//
//  GuestTableView.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-05-02.
//

import SwiftUI

struct GuestTableView: View {
  @Binding var numberOfAdults: Int
  
  var body: some View {
    content
      .overlay(guests)
  }
  
  @ViewBuilder
  private var content: some View {
    if numberOfAdults <= 4 {
      rectangularTable
    } else {
      circularTable
    }
  }
  
  private var rectangularTable: some View {
    Rectangle()
      .fill(Color.gray)
      .overlay(
        Rectangle()
          .stroke(
            Color.black,
            style: .init(lineWidth: 5)
          )
      )
      .aspectRatio(.init(width: 1, height: 1), contentMode: .fit)
  }
  
  private var circularTable: some View {
    Circle()
      .fill(Color.gray)
      .overlay(
        Circle()
          .stroke(
            Color.black,
            style: .init(lineWidth: 5)
          )
      )
  }
  
  private var guests: some View {
    GeometryReader { proxy in
      let layout = numberOfAdults > 4 ? AnyLayout(CircularLayout()) : AnyLayout(RectangularLayout())
      layout {
        ForEach(0 ..< numberOfAdults, id: \.self) { _ in
          guest(withColor: .blue, proxy: proxy)
        }
      }
      .animation(.easeIn, value: numberOfAdults)
    }
  }
  
  @ViewBuilder
  private func guest(withColor color: Color, proxy: GeometryProxy) -> some View {
    Circle()
      .fill(color)
      .frame(width: proxy.size.width * 0.25)
  }
}

struct RectangularLayout: Layout {
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    return proposal.replacingUnspecifiedDimensions()
  }
  
  func placeSubviews(in bounds: CGRect,
                     proposal: ProposedViewSize,
                     subviews: Subviews,
                     cache: inout ()) {
    for (index, view) in subviews.enumerated() {
      let viewSize = view.sizeThatFits(proposal)
      let xOffset = CGFloat(index % 2) * (bounds.size.width)
      let yOffset = index > 1 ? (bounds.height - viewSize.height * 2) : 0.0
      let xCoordinate = bounds.minX + xOffset - viewSize.width / 2
      let yCoordinate = bounds.minY + yOffset + viewSize.height / 2
      view.place(at: .init(x: xCoordinate, y: yCoordinate), proposal: proposal)
    }
  }
}

struct CircularLayout: Layout {
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    proposal.replacingUnspecifiedDimensions()
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    for (index, view) in subviews.enumerated() {
      let viewSize = view.sizeThatFits(proposal)
      let radius = bounds.width / 2
      let angle = CGFloat(360 / subviews.count * index) - 90
      let xOffset = radius * cos(angle * .pi / 180)
      let yOffset = radius * sin(angle * .pi / 180)
      let xCoordinate = bounds.midX - viewSize.width / 2 + xOffset
      let yCoordinate = bounds.midY - viewSize.height / 2 + yOffset
      view.place(at: .init(x: xCoordinate, y: yCoordinate), proposal: proposal)
    }
  }
  
  
}

struct GuestTableView_Previews: PreviewProvider {
  static var previews: some View {
    GuestTableView(numberOfAdults: .constant(4))
      .padding(50)
  }
}
