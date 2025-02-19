//
//  ExchangeRateView.swift
//  SplitBuddy
//
//  Created by Jovie on 10/10/2024.
//

import SwiftUI
/**
 A view that displays an exchange rate calculator for currency conversion.

 `ExchangeRateView` allows users to input an amount in one currency and convert it to another currency based on the current exchange rate. The view features a text field for entering the amount, pickers to select the currencies, and a button to perform the conversion. It also includes error handling for invalid conversions, such as when the two currencies are the same.

 - Properties:
   - firstAmount: The amount of the first currency (default is "100").
   - secondAmount: The converted amount in the second currency (default is an empty string).
   - firstRate: The currency code for the first currency (default is "AUD").
   - secondRate: The currency code for the second currency (default is "USD").
   - showAlert: A boolean controlling the display of error alerts.
   - msg: The message to be displayed in the alert.
   - showMore: A boolean that controls navigation to more detailed exchange rate information.
 
 - Example:
 ```swift
 ExchangeRateView()
*/

struct ExchangeRateView: View {
    /// The amount of the first currency to be converted.
    @State var firstAmount = "100"
    /// The converted amount in the second currency.
    @State var secondAmount = ""
    /// The selected currency code for the first currency.
    @State var firstRate = "AUD"
    /// The selected currency code for the second currency.
    @State var secondRate = "USD"
    /// A boolean controlling the display of the error alert.
    @State var showAlert = false
    /// The message to be displayed in the error alert.
    @State var msg = ""
    /// A boolean that controls navigation to the detailed exchange rate view.
    @State var showMore = false
    
    var body: some View {
        NavigationStack {
            VStack(content: {
                // Display the transfer calculator title.
                Text("Transfer calculator")
                // Input field for the first currency amount and a picker to select the currency.
                HStack(content: {
                    TextField("", text: $firstAmount)
                        .foregroundStyle(Color.white)
                        .keyboardType(.decimalPad)
                    Picker("", selection:$firstRate) {
                        ForEach(0..<AllRateList.count, id: \.self) { index in
                            Text(AllRateList[index])
                                .tag(AllRateList[index])
                        }
                    }
                })
                .frame(height: 50)
                .padding(8)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                .padding(10)
                
                // Input field for the second currency amount (disabled) and a picker to select the currency.
                HStack(content: {
                    TextField("", text: $secondAmount)
                        .foregroundStyle(Color.white)
                        .disabled(true)
                    Picker("", selection:$secondRate) {
                        ForEach(0..<AllRateList.count, id: \.self) { index in
                            Text(AllRateList[index])
                                .tag(AllRateList[index])
                        }
                    }
                    //.pickerStyle(SegmentedPickerStyle())
                })
                .frame(height: 50)
                .padding(8)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                .padding(10)
                
                // Button to perform the transfer calculation.
                Button(action: {
                    transferAction()
                }, label: {
                    Text("Transfer").frame(maxWidth: .infinity)
                })
                
                .frame(height: 50)
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                .padding(30)
                
                Spacer()
            })
            // Show an alert if the two currencies are the same or if an error occurs during the transfer.
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(msg))
            })
            // Add a toolbar item to navigate to more exchange rate details.
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showMore.toggle()
                    }, label: {
                        Text("More")
                    })
                }
            })
            // Navigate to the `ExchangeRateMoreView` when the "More" button is pressed.
            .navigationDestination(isPresented: $showMore) {
                ExchangeRateMoreView()
                //ExchangeRateMoreView(allRateTitleList: ["USD","BGN"],allRateValueList: [1.23, 2.03])
            }
        }
    }
    
    /**
     Performs the exchange rate conversion.

     This method fetches the exchange rates from `ExchangeRatesTools` and calculates the converted amount based on the selected currencies and input amount. If the two selected currencies are the same, an error alert is triggered.
     */
    
    func transferAction() {
        if firstRate == secondRate {
            showAlert.toggle()
            msg = "It can't be the same"
            return
        }
        ExchangeRatesTools.shared.getExchangeRates(for: firstRate) { result in
            switch result {
            case .success(let json):
                print("Exchange Rate Data: \(json)")
                guard let result = json["result"] as? String else
                    {
                    return
                }
                if result != "success" {
                    showAlert.toggle()
                    msg = (json["error-type"] as? String) ?? "unknown-code"
                    return
                }
           
                if let conversion_rates = json["conversion_rates"] as? [String:Double],
                   let value = conversion_rates[secondRate] {
                    let firstValue = Double(self.firstAmount) ?? 0
                    self.secondAmount = String(format: "%.2lf", value*firstValue)
                } else {
                    showAlert.toggle()
                    msg =  "unknown-code"
                }
                
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                showAlert.toggle()
                msg = error.localizedDescription
            }
        }
    
    }
}

#Preview {
    ExchangeRateView()
}



