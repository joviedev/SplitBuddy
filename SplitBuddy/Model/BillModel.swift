//
//  BillModel.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import Foundation
import SwiftData

/**
 A model class representing a bill, including the associated foods, people involved, and other details.

 `BillModel` is used to manage and persist bill-related data such as the bill name, the list of foods, the people associated with the bill, the date, and whether the bill is split equally among participants.

 - Properties:
   - name: The name of the bill (e.g., the title or identifier).
   - foods: An array of `FoodModel` representing the items on the bill.
   - peoples: An array of `PeopleModel` representing the participants in the bill.
   - date: The date when the bill was created or occurred.
   - isEqually: A boolean indicating if the bill is split equally among all participants.
 
 - Note: This class uses the `@Model` annotation from `SwiftData` for persistence.
 */


@Model
class BillModel{
    /// The name of the bill (e.g., "Dinner at Restaurant").
    var name = ""
    
    /// The list of food items included in the bill, represented as an array of `FoodModel`.
    var foods: [FoodModel] = []
    
    /// The list of people involved in the bill, represented as an array of `PeopleModel`.
    var peoples: [PeopleModel] = []
    
    /// The date when the bill was created or when the event took place.
    var date: Date = Date()
    
    /// A boolean indicating if the bill is split equally among participants. Default is `true`.
    var isEqually = true
    /**
         Initializes a new instance of `BillModel`.

         - Parameters:
           - name: The name of the bill (e.g., "Office Lunch").
           - foods: An array of `FoodModel` objects representing the items on the bill.
           - peoples: An array of `PeopleModel` objects representing the participants in the bill.
           - date: The date when the bill occurred. Defaults to the current date.
           - isEqually: A boolean indicating if the bill is split equally. Defaults to `true`.

         - Returns: A new `BillModel` instance initialized with the provided values.
         */
    init(name:String, foods: [FoodModel], peoples: [PeopleModel],date:Date = Date(), isEqually: Bool) {
        self.name = name
        self.foods = foods
        self.peoples = peoples
        self.date = date
        self.isEqually = isEqually
    }
}

/**
 A simple struct representing a bill without persistence.

 Similar to `BillModel`, this struct stores information about a bill, including the foods, participants, and the date. It is a non-persistent data model and can be used when persistence is not required.

 - Properties:
   - name: The name of the bill.
   - foods: An array of `Food` representing the items on the bill.
   - peoples: An array of `People` representing the participants in the bill.
   - date: The date when the bill was created.
   - isEqually: A boolean indicating if the bill is split equally among participants.
 */
struct Bill {
    /// The name of the bill (e.g., "Brunch with Friends").
    var name = ""
    
    /// The list of food items included in the bill, represented as an array of `Food`.
    var foods: [Food] = []
    
    /// The list of people involved in the bill, represented as an array of `People`.
    var peoples: [People] = []
    
    /// The date when the bill was created or when the event took place.
    var date: Date = Date()
    
    /// A boolean indicating if the bill is split equally among participants. Default is `true`.
    var isEqually = true
}

