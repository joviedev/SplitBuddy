//
//  SplitBuddyApp.swift
//  SplitBuddy
//
//  Created by Jovie on 27/8/2024.
//

import SwiftUI
import SwiftData
import UIKit

/**
 The main entry point for the SplitBuddy application.

 `SplitBuddyApp` defines the core structure of the application, including its data management and user interface. It uses a shared `ModelContainer` to handle the core data models (`BillModel`, `FoodModel`, and `PeopleModel`) and ensures that data is persisted. The app's UI is defined using a `WindowGroup` and `ContentView`, which is the root view of the app.

 - Properties:
   - sharedModelContainer: A `ModelContainer` instance that manages the core data models and supports persistent storage.
 
 - Example:
 ```swift
 SplitBuddyApp()
*/

@main
struct SplitBuddyApp: App {
    
    /**
     A shared `ModelContainer` that manages the app’s core data models.
     - The container is initialized with a schema containing `BillModel`, `FoodModel`, and `PeopleModel`.
     - The container supports persistent storage to ensure that data is saved to disk rather than being kept in memory only.
     */
    
    var sharedModelContainer: ModelContainer = {
        /// Schema defines the structure of the models used in the app.
        let schema = Schema([
            BillModel.self,     /// BillModel represents bills
            FoodModel.self,     /// FoodModel represents food items, for bill splitting
            PeopleModel.self,   /// PeopleModel represents individuals participating in the bill split.
        ])
        /// Configuration to determine how models are stored. It supports persistent storage (not limited to in-memory use)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        /// Initialize and return the ModelContainer for the specified schema.
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            /// If the container fails to initialize, terminate with an error message.
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    /**
     The main scene of the application that defines the user interface (UI).
     
     - The app uses a `WindowGroup` to manage the root view, which is `ContentView`.
     - The `sharedModelContainer` is passed to the view to ensure consistent access to the app's core data models.
     - The view is set to display in light mode using `.environment(\.colorScheme, .light)`.
     */
    
    var body: some Scene {
        WindowGroup {
            /// ContentView is the root view, and it uses the shared ModelContainer.
            ContentView()
                .modelContainer(sharedModelContainer)
                /// Set light mode for this view
                .environment(\.colorScheme, .light)
        }
    }
}

/// Extension to SwiftUI's View for taking a snapshot (screenshot) of a view.
public extension View {
    /**
     Captures a snapshot of the view and returns it as a `UIImage`.

     - Parameters:
       - scale: An optional scale factor for the snapshot. The default is `3`. If no scale is provided, the device's screen scale is used.
     - Returns: An optional `UIImage` representing the snapshot of the view.
     */
    
    @MainActor
    func snapshot(scale: CGFloat? = 3) -> UIImage? {
        // Create an `ImageRenderer` to convert the view content into an image.
        let renderer = ImageRenderer(content: self)
        // Set the rendering scale, defaulting to the device screen scale.
        renderer.scale = scale ?? UIScreen.main.scale
        // Return the resulting `UIImage`.
        return renderer.uiImage
    }
}

///  It sets up the foundational structure of SplitBuddy application, defining how the app manages its data, handles its lifecycle, and interacts with its views.
