//
//  ExchangeRateMoreView.swift
//  SplitBuddy
//
//  Created by Jovie on 10/10/2024.
//

import SwiftUI
/**
 A view that displays detailed exchange rate information.

 `ExchangeRateMoreView` allows users to select a currency and view its conversion rates against various other currencies. The view includes a picker for selecting the base currency, a button to fetch exchange rates, and a list showing the rates for different currencies. The list items can be long-pressed to highlight a currency and display it with larger text.

 - Properties:
   - firstRate: The selected base currency for which the exchange rates will be fetched (default is "AUD").
   - showAlert: A boolean controlling the display of error alerts.
   - msg: The message to be displayed in the alert.
   - allRateTitleList: A list of currency codes for which the exchange rates will be displayed.
   - allRateValueList: A list of conversion rates corresponding to the `allRateTitleList`.
   - largeIndex: The index of the list item that is highlighted and displayed with larger text when long-pressed.
 
 - Example:
 ```swift
 ExchangeRateMoreView(allRateTitleList: ["USD", "BGN"], allRateValueList: [1.23, 2.03])
*/

struct ExchangeRateMoreView: View {
    /// The selected base currency for which the exchange rates will be fetched (default is "AUD").
    @State var firstRate = "AUD"
    /// A boolean controlling the display of the error alert.
    @State var showAlert = false
    /// The message to be displayed in the error alert.
    @State var msg = ""
    /// A list of currency codes for which the exchange rates will be displayed.
    @State var allRateTitleList: [String] = []
    /// A list of conversion rates corresponding to the `allRateTitleList`.
    @State var allRateValueList: [Double] = []
    /// The index of the list item that is highlighted and displayed with larger text when long-pressed.
    @State var largeIndex: Int?
    var body: some View {
        VStack(content: {
            // Picker for selecting the base currency.
            HStack(content: {
                
                Picker("", selection:$firstRate) {
                    ForEach(0..<AllRateList.count, id: \.self) { index in
                        Text(AllRateList[index])
                            .tag(AllRateList[index])
                    }
                }
                .frame(maxWidth: .infinity)
            })
            .frame(height: 50)
            .padding(8)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            .padding(10)
            
            // Button to trigger fetching of exchange rates.
            Button(action: {
                transferAction()
            }, label: {
                Text("Sure").frame(maxWidth: .infinity)
            })
            .frame(height: 50)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            .padding(30)
            
            // List displaying the exchange rates for different currencies.
            List {
                ForEach(0..<allRateTitleList.count, id: \.self) { index in
                    HStack(content: {
                        Text(allRateTitleList[index])
                        Spacer()
                        Text("1\(firstRate) = ")
                        Text(String(format: "%.2lf\(allRateTitleList[index])", allRateValueList[index]))
                    })
                    .background()
                    .font(Font.system(size:largeIndex == index ? 25 : 16, weight: largeIndex == index ? .bold : .regular))
                    .frame(height: largeIndex == index ? 80 : 44)
                    .gesture(LongPressGesture().onEnded({ bol in
                        largeIndex = index
                        print("bol1:\(bol)")
                    }))
                }
                
            }
            
            Spacer()
        })
        // Show an alert in case of errors or issues with fetching exchange rates.
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(msg))
        })
        .navigationTitle(Text("Exchange rates"))
        .toolbar(.hidden, for: .tabBar)
    }
    
    /**
     Fetches exchange rates for the selected base currency.

     This method calls `ExchangeRatesTools` to fetch exchange rate data for the selected `firstRate`. It updates the `allRateTitleList` and `allRateValueList` with the fetched conversion rates or shows an error alert if the fetch fails.
     */
    func transferAction() {
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
                
                if let conversion_rates = json["conversion_rates"] as? [String:Double] {
                    var allRateTitleListTemp = [String]()
                    var allRateValueListTemp = [Double]()
                    for key in conversion_rates.keys {
                        if let value = conversion_rates[key] {
                            allRateTitleListTemp.append(key)
                            allRateValueListTemp.append(value)
                        }
                    }
                    allRateTitleList = allRateTitleListTemp
                    allRateValueList = allRateValueListTemp
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
    ExchangeRateMoreView(allRateTitleList: ["USD","BGN"],allRateValueList: [1.23, 2.03])
}
