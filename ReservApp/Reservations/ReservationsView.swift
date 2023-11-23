//
//  ReservationsView.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import SwiftUI
import TipKit

struct ReservationsView: View {
  @Environment(\.horizontalSizeClass) private var hClass
  @EnvironmentObject private var appViewModel: AppViewModel
  @StateObject private var viewModel = ReservationsViewModel()
  @State private var showingReservationForm = false
  @State private var isEditingReservation = false
  @State private var cancelReservationToggle = false
  @State private var seatedReservationToggle = false
  @State private var animateButton = false
  private let manageReservationTip = ManageReservationTip()
  private let pastReservationsTip = PastReservationsTip()
  
  var body: some View {
    ScrollView {
      TipView(pastReservationsTip) { _ in
        appViewModel.showPastReservations()
        pastReservationsTip.invalidate(reason: .actionPerformed)
      }
      if let upcomingReservation = viewModel.upcomingReservation {
        HStack(spacing: 100) {
          Text("Upcoming reservation: \(upcomingReservation.name) for \(upcomingReservation.numberOfGuests) guest at \(Text(upcomingReservation.date, style: .time))")
            .phaseAnimator([1.0, 1.5], trigger: animateButton) { view, phase in
              view
                .scaleEffect(x: phase, y: phase)
                .foregroundStyle(phase == 1 ? Color.primary : Color.red)
            } animation: { _ in
                .easeInOut(duration: 1)
                .repeatForever()
            }
          
          Button(action: {
            withAnimation { isEditingReservation.toggle() }
            manageReservationTip.invalidate(reason: .actionPerformed)
          }) {
            Image(systemName: "command.circle.fill")
          }
          .popoverTip(manageReservationTip)
        }
        .padding()
      }
      
      if isEditingReservation {
        reservationButtons
          .padding(.vertical)
      }
      
      reservationList
    }
    .navigationTitle("Reservations")
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation {
          animateButton.toggle()
        }
      }
    }
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
  
  private var reservationButtons: some View {
    HStack(spacing: 40) {
      Button(action: {
        reservationButtonTapped(wasSeated: false)
        cancelReservationToggle.toggle()
      }) {
        VStack {
          Image(systemName: "person.2.slash.fill")
          Text("No show / Canceled")
        }
      }
      .tint(.red)
      .keyframeAnimator(initialValue: ReservationButtonAnimation(), trigger: cancelReservationToggle) { content, value in
        content
          .rotationEffect(value.angle)
          .offset(x: value.horizontalTranslation, y: value.verticalTranslation)
      } keyframes: { _ in
        KeyframeTrack(\.angle) {
          LinearKeyframe(.zero, duration: 0.2)
          SpringKeyframe(.degrees(20), duration: 0.1)
          SpringKeyframe(.degrees(-20), duration: 0.1)
          SpringKeyframe(.zero, duration: 0.1)
          SpringKeyframe(.degrees(-20), duration: 0.1)
          SpringKeyframe(.degrees(20), duration: 0.1)
          SpringKeyframe(.zero, duration: 0.1)
          LinearKeyframe(.degrees(30), duration: 2)
        }
        
        KeyframeTrack(\.horizontalTranslation) {
          LinearKeyframe(0, duration: 0.7)
          CubicKeyframe(-10, duration: 0.2)
          CubicKeyframe(40, duration: 2)
          SpringKeyframe(-800)
        }
      }
      
      Button(action: {
        reservationButtonTapped(wasSeated: true)
        seatedReservationToggle.toggle()
      }) {
        VStack {
          Image(systemName: "person.fill.checkmark")
          Text("Guests seated")
        }
      }
      .tint(.green)
      .keyframeAnimator(initialValue: ReservationButtonAnimation(), trigger: seatedReservationToggle) { content, value in
        content
          .rotationEffect(value.angle)
          .offset(x: value.horizontalTranslation, y: value.verticalTranslation)
      } keyframes: { _ in
        KeyframeTrack(\.horizontalTranslation) {
          LinearKeyframe(0, duration: 0.4)
          LinearKeyframe(60, duration: 0.8)
          LinearKeyframe(120, duration: 0.8)
          LinearKeyframe(250, duration: 0.8)
          SpringKeyframe(800)
        }
        KeyframeTrack(\.verticalTranslation) {
          LinearKeyframe(0, duration: 0.4)
          CubicKeyframe(-20, duration: 0.4)
          CubicKeyframe(0, duration: 0.4)
          CubicKeyframe(-40, duration: 0.4)
          CubicKeyframe(0, duration: 0.4)
          CubicKeyframe(-120, duration: 0.4)
          CubicKeyframe(0, duration: 0.4)
        }
        
        KeyframeTrack(\.angle) {
          LinearKeyframe(.zero, duration: 2.2)
          CubicKeyframe(.degrees(360), duration: 0.4)
        }
      }
    }
  }
  
  private func reservationButtonTapped(wasSeated: Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      PastReservationsTip.handledReservations.sendDonation()
      viewModel.popNextReservation(wasSeated: wasSeated)
      withAnimation { isEditingReservation = false }
    }
  }
  
  private var reservationList: some View {
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

struct ReservationButtonAnimation {
  var horizontalTranslation: Double = 0.0
  var verticalTranslation: Double = 0.0
  var angle: Angle = .zero
}

struct ReservationsView_Previews: PreviewProvider {
  static var previews: some View {
      ReservationsView()
  }
}
