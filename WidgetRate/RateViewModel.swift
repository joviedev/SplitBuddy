//
//  RateViewModel.swift
//  SplitBuddy
//
//  Created by Jovie on 11/10/2024.
//

import UIKit
import Foundation

/**
 A view model that observes and manages the exchange rate data.

 `RateViewModel` is a simple class that conforms to the `ObservableObject` protocol, allowing it to be used in SwiftUI for state management. The class contains a `@Published` property, `rate`, which holds the current exchange rate value. This property can be observed by SwiftUI views, and the views will automatically update when the `rate` value changes.

 - Properties:
   - `rate`: A `Double` representing the current exchange rate. This property is published, meaning any changes will notify the observing SwiftUI views to update.

 - Example:
 ```swift
 @StateObject var rateViewModel = RateViewModel()

 Text("Current rate: \(rateViewModel.rate)")
*/
class RateViewModel: ObservableObject {
    /// The published property for the exchange rate. When updated, it triggers UI changes in observing SwiftUI views.
    @Published var rate = 0.0
    
}
