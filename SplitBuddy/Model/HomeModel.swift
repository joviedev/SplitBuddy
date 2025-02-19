//
//  HomeModel.swift
//  SplitBuddy
//
//  Created by Jovie on 27/8/2024.
//

import Foundation

/**
 A data model representing items on the home screen, each with an icon, title, and associated value.

 `HomeModel` conforms to `Hashable` and `Identifiable` protocols to ensure that each instance is uniquely identifiable and can be used in SwiftUI views like `ForEach`. It includes a unique ID, an icon name, a title, and a value.

 - Properties:
   - id: A unique identifier for the model, automatically generated using `UUID`.
   - icon: A string representing the icon name, which can be used with system images or custom assets.
   - title: The title of the item.
   - value: The value or description associated with the item.

 - Conforms To:
   - `Hashable`: Ensures that each instance can be hashed, useful for lists and sets.
   - `Identifiable`: Provides a unique identifier for use in SwiftUI views.
 */

struct HomeModel: Hashable,Identifiable {
    /// A unique identifier for each item, automatically generated.
    var id: UUID = UUID()
    
    /// The name of the icon representing the item (e.g., "house" for a house icon).
    var icon = ""
    
    /// The title or label for the item (e.g., "Home", "Profile", etc.).
    var title = ""
    
    /// A value associated with the item, such as a description or numerical value.
    var value = ""
}
