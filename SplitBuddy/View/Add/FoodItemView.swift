//
//  FoodItemView.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import SwiftUI
import Combine

/**
 A view that displays and edits a food item, including its name and price.

 `FoodItemView` allows users to input and modify the details of a food item, including its name and price. It provides real-time updates to the `food` and `foodsList` bindings. The user can delete the item from the list by tapping a trash icon.

 - Properties:
   - `food`: A binding to the `Food` object being displayed and edited.
   - `foodsList`: A binding to the list of `Food` objects, allowing the item to be removed from the list.
   - `index`: The index of the current `Food` item in the list.
   - `price`: A state variable holding the string representation of the price input, allowing for real-time updates and validation.

 - Example:
 ```swift
 FoodItemView(food: .constant(Food()), foodsList: .constant([]), index: 0)
*/

struct FoodItemView: View {
    /// A binding to the `Food` object being edited.
     @Binding var food: Food
    /// A binding to the list of food items, allowing for removal.
     @Binding var foodsList: [Food]
    /// The index of the current food item in the list.
     var index: NSInteger
    /// A state variable holding the price input as a string for validation and formatting.
     @State var price = ""
    
  
    
    var body: some View {
        HStack(content: {
            // Display the index of the food item.
            Text("\(index)")
                .frame(minWidth: 20,minHeight: 20)
            Spacer().frame(width: 10)
            // TextField for editing the name of the food item.
            TextField("type here", text: $food.name)
                .layoutPriority(999)
            Spacer().frame(width: 10)
            // TextField for editing the price of the food item, with validation.
            TextField("price", text: $price)
                .frame(width: 80)
                .keyboardType(.decimalPad) // Use decimal keyboard for price input.
            // Update the price when the text changes.
                .onChange(of: price) { oldValue, newValue in
                    food.price = Double(price) ?? 0
                }
            // On submission, validate and format the price.
                .onSubmit {
                    price = "\(Double(price) ?? 0)"
                    food.price = Double(price) ?? 0
                }
            
            // Button to remove the food item from the list.
            Button(action: {
                foodsList.remove(at: index)
            }, label: {
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
        })
        // Initialize the price field when the view appears.
        .onAppear(perform: {
            if self.food.price == 0 {
                self.price = ""
            } else {
                // Format the price with 2 decimal places.
                self.price = String(format: "%.2lf", self.food.price)
            }
            
        })
        
        .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
        .background(Color(red: 232/255.0, green: 232/255.0, blue: 232/255.0))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        
    }
}

#Preview {
    FoodItemView(food: .constant(Food()), foodsList: .constant([]), index: 0)
}
