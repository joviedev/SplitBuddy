//
//  FoodModel.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import Foundation
import SwiftData

/**
 A model class representing a food item in a bill, including its name, price, and a unique identifier.

 `FoodModel` is used to manage and persist data about food items in a bill, including the name and price of the item. Each food item has a unique identifier (`id`) and is part of the observable data in the app through the `ObservableObject` protocol.

 - Properties:
   - id: A unique identifier for the food item, automatically generated using `UUID`.
   - name: The name of the food item.
   - price: The price of the food item.

 - Conforms To:
   - `ObservableObject`: Allows views to automatically update when this model changes.
 
 - Note: This class uses the `@Model` annotation from `SwiftData` for persistence.
 */

@Model
class FoodModel: ObservableObject {
    /// A unique identifier for the food item, automatically generated using `UUID`.
    @Attribute(.unique)  var id = UUID().uuidString
    
    /// The name of the food item.
    var name = ""
    
    /// The price of the food item.
    var price = 0.0
    
    /**
         Initializes a new instance of `FoodModel`.

         - Parameters:
           - id: A unique identifier for the food item. Defaults to a newly generated `UUID`.
           - name: The name of the food item. Defaults to an empty string.
           - price: The price of the food item. Defaults to `0.0`.

         - Returns: A new `FoodModel` instance initialized with the provided values.
         */
    init(id: String = UUID().uuidString, name: String = "", price: Double = 0.0) {
        self.id = id
        self.name = name
        self.price = price
    }
    
}

/**
 A struct representing a food item in a bill without persistence.

 `Food` stores information about a food item such as its name, price, and whether it is selected. This struct is used for non-persistent data storage and includes additional properties like `perPrice` and `selected`.

 - Properties:
   - id: A unique identifier for the food item.
   - name: The name of the food item.
   - price: The price of the food item.
   - perPrice: The per-person price of the food item.
   - selected: A boolean indicating whether the food item is selected.
 */
struct Food {
    var id = UUID().uuidString
    var name = ""
    var price = 0.0
    var perPrice = 0.0
    var selected = false
    
    init(id: String = UUID().uuidString, name: String = "", price: Double = 0.0,selected: Bool = false) {
        self.id = id
        self.name = name
        self.price = price
        self.selected = selected
    }
    
}
