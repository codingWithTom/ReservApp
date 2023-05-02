//
//  ReservationView.swift
//  ReservApp
//
//  Created by Tomas Trujillo on 2023-04-26.
//

import SwiftUI

extension ReservationOccasion {
  var displayName: String {
    switch self {
    case .anniversary:
      return "Anniversary"
    case .birthday:
      return "Birthday"
    case .other:
      return "Other"
    case .none:
      return "None"
    }
  }
}

struct ReservationView: View {
  @Binding var isPresenting: Bool
  @StateObject private var viewModel = ReservationViewModel()
  @State private var isShowingTable = false
  
  var body: some View {
    Form {
      Section(header: Text("Reservation Name")) {
        TextField("Enter name", text: $viewModel.reservationName)
      }
      
      Section(header: Text("Occasion")) {
        Picker(selection: $viewModel.occasion, label: Text("Occasion")) {
          ForEach(ReservationOccasion.allCases, id: \.self) { ocassion in
            Text(ocassion.displayName)
              .tag(ocassion)
          }
        }
      }
      
      Section(header: Text("Number of Guests")) {
        Stepper(value: $viewModel.numberOfGuests, in: 1...8) {
          Text("Adults: \(viewModel.numberOfGuests)")
        }
      }
      
      Section(header:
                HStack {
        Text("Table")
        Spacer()
        Button(action: { withAnimation { isShowingTable.toggle() }}) {
          Image(systemName: isShowingTable ? "chevron.down" : "chevron.up")
            .foregroundColor(.secondary)
        }
        
      }
      ) {
        if isShowingTable {
          HStack {
            Spacer()
            GuestTableView(numberOfAdults: $viewModel.numberOfGuests)
              .frame(maxWidth: 300)
              .padding(40)
            Spacer()
          }
        }
      }
      
      Section(header: Text("Reservation Date")) {
        DatePicker("Date", selection: $viewModel.reservationDate,
                   displayedComponents: .date)
          .datePickerStyle(.graphical)
      }
      
      Section {
        Button(action: bookReservation) {
          Text("Book Reservation")
        }
      }
    }
    .navigationTitle("Reservation Form")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: {
          self.isPresenting = false
        }) {
          Image(systemName: "chevron.down")
        }
      }
    }
  }
  
  // Function to handle booking the reservation
  private func bookReservation() {
    viewModel.saveReservation()
    isPresenting = false
  }
}

struct ReservationView_Previews: PreviewProvider {
  static var previews: some View {
    ReservationView(isPresenting: .constant(false))
  }
}
