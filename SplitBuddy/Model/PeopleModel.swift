//
//  PeopleModel.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import Foundation
import SwiftData

/**
 A model class representing a person involved in a bill, including their associated foods and other details.

 `PeopleModel` is used to manage and persist data about individuals in a bill, such as their name, the amount they owe (price), and their selected status. This class also maintains a relationship with the `FoodModel` to track which foods are associated with the individual.

 - Properties:
   - id: A unique identifier for the person, automatically generated using `UUID`.
   - name: The name of the person.
   - price: The total price the person owes.
   - icon: A string representing the person's icon, such as an avatar or symbol.
   - selected: A boolean indicating whether the person is currently selected (this attribute is ephemeral, meaning it is not stored).
   - foods: An array of `FoodModel` objects representing the foods associated with the person.

 - Note: This class uses the `@Model` annotation from `SwiftData` for persistence. The `selected` attribute is marked as ephemeral, meaning it is not stored in persistent storage.
 */

@Model
class PeopleModel {
    /// A unique identifier for the person, automatically generated using `UUID`.
    @Attribute(.unique) var id: String = UUID().uuidString
    
    /// The name of the person involved in the bill.
    var name = ""
    /// The total amount the person owes for their share of the bill.
    var price = 0.0
    /// A string representing the icon or avatar of the person.
    var icon = ""
    
    /// A boolean indicating whether the person is selected. This value is not stored persistently.
    @Attribute(.ephemeral) var selected = false // no store
    
    
    //@Relationship(deleteRule: .nullify, inverse: \FoodModel.people)
    /// An array of `FoodModel` representing the foods associated with this person.
    var foods:[FoodModel] = []
    
    /**
         Initializes a new instance of `PeopleModel`.

         - Parameters:
           - id: A unique identifier for the person. Defaults to a newly generated `UUID`.
           - name: The name of the person. Defaults to an empty string.
           - price: The total price the person owes. Defaults to 0.0.
           - icon: A string representing the person's icon or avatar. Defaults to an empty string.
           - selected: A boolean indicating if the person is selected. Defaults to `false`.
           - foods: An array of `FoodModel` representing the foods associated with the person.

         - Returns: A new `PeopleModel` instance initialized with the provided values.
         */
    init(id: String = UUID().uuidString, name: String = "", price: Double = 0.0, icon: String = "", selected: Bool = false, foods: [FoodModel]) {
        self.id = id
        self.name = name
        self.price = price
        self.icon = icon
        self.selected = selected
        self.foods = foods
    }

}

/**
 A simple struct representing a person involved in a bill, without persistence.

 `People` stores information about a person such as their name, the price they owe, and whether they are selected, but it does not persist this data. It is suitable for temporary storage or non-persistent data.

 - Properties:
   - id: A unique identifier for the person.
   - name: The name of the person.
   - price: The total amount the person owes for their share of the bill.
   - icon: A string representing the person's icon.
   - selected: A boolean indicating if the person is selected (this is non-persistent).
   - foods: An array of `Food` representing the foods associated with the person.
 */
struct People{
    var id: String = UUID().uuidString
    var name = ""
    var price = 0.0
    var icon = ""
    var selected = false // no store
    var foods:[Food] = []
}
