//
//  ContentView.swift
//  SplitBuddy
//
//  Created by Jovie on 27/8/2024.
//

import SwiftUI

/**
 The main view that contains a `TabView` with four tabs: Home, Group, Exchange Rates, and History.

 This view manages tab navigation for different sections of the app and integrates subviews like `HomeView`, `ExchangeRateView`, and `HistoryView`.

 - Properties:
    - selTabIndex: A state variable that keeps track of the currently selected tab index.
 */

struct ContentView: View {
   // var icons = ["calendar","message","figure.walk","music.note"]
    /// A state variable to store the index of the currently selected tab.
    @State var selTabIndex = 0
    var body: some View {
        /**
                 A `TabView` displaying four different sections:
                 
                 1. **Home**: Displays the home view.
                 2. **Group**: Displays a placeholder for group-related functionality.
                 3. **Rate**: Shows the exchange rates via the `ExchangeRateView`.
                 4. **History**: Displays the history of bills using the `HistoryView`.

                 Each tab has a corresponding image and label.
                 */
        TabView(selection: $selTabIndex, content: {
            HomeView(tabIndex: $selTabIndex)
                .tabItem {
                    Image(systemName: "house")
                    Text("home")
                }
                .tag(0)
            
            // Displays the ExchangeRateView
            ExchangeRateView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Rate")
                }
                .tag(1)
            
            // Displays the HistoryView
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
                .tag(2)
        })
//        VStack {
//            Spacer().frame(height: 200)
//            CustomLayout{
//
//                ForEach(icons, id: \.self) {
//                    item in
//                    Circle()
//                        .frame(width: 44)
//                        .overlay(Image(systemName: item).foregroundColor(.white))
//
//                }
//            }
//        }
        
    }
}

/**
 Provides a preview of `ContentView` using a model container for the `BillModel` in memory.
 */
#Preview {
    ContentView()
        .modelContainer(for:BillModel.self,inMemory: true)
}

/**
 A custom layout struct that arranges subviews in a diagonal pattern.

 `CustomLayout` uses a `Layout` protocol to manually manage the placement of subviews based on the index, applying custom logic to determine their positions.

 - Methods:
   - `sizeThatFits`: Calculates the size required to fit the subviews based on the provided proposal.
   - `placeSubviews`: Places each subview at a specific point in the layout.

 # Topics
 ## Layout
 - ``sizeThatFits(proposal:subviews:cache:)``
 - ``placeSubviews(in:proposal:subviews:cache:)``
 */

struct CustomLayout: Layout {
    /**
         Calculates the size that best fits the provided `Subviews` based on the proposal.
         
         - Parameters:
           - proposal: The proposed view size.
           - subviews: The list of subviews contained within the layout.
           - cache: A placeholder for cached layout information (not used here).

         - Returns: The best-fit size for the layout.
         */
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    /**
         Places each subview in the layout according to a diagonal pattern, offset by an index-based calculation.

         - Parameters:
           - bounds: The bounding rectangle in which the subviews are to be placed.
           - proposal: The proposed size for each subview.
           - subviews: The array of subviews to be placed.
           - cache: A placeholder for cached layout information (not used here).

         Each subview is placed in a `CGPoint` that shifts diagonally based on its index, and it's centered horizontally in the available bounds.
         */
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (index, subview) in subviews.enumerated() {
            
            var point = CGPoint(x: 50 * index, y: 50 * index)
                //.applying(CGAffineTransform(rotationAngle: 4))
            point.x += bounds.midX// Adjust horizontally based on the midpoint of the bounds.
            
            point.y += bounds.minY// Adjust vertically starting from the top of the bounds.
            
            print(point)// Log the point to the console for debugging purposes.
            
            subview.place(at: point, proposal: .unspecified)
           // subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
    
    
}
