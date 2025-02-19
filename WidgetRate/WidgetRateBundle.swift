//
//  WidgetRateBundle.swift
//  WidgetRate
//
//  Created by Jovie on 11/10/2024.
//

import WidgetKit
import SwiftUI

/**
 A widget bundle that contains the `WidgetRate` widget.

 `WidgetRateBundle` is the entry point for defining and grouping one or more widgets for the app. In this case, it includes a single widget, `WidgetRate`, which displays exchange rate information or any other relevant data for the user in a widget format.

 This widget bundle conforms to the `WidgetBundle` protocol, and the body contains the widget to be displayed.

 - Example:
 ```swift
 WidgetRateBundle()
*/

@main
struct WidgetRateBundle: WidgetBundle {
    var body: some Widget {
        WidgetRate()
    }
}
