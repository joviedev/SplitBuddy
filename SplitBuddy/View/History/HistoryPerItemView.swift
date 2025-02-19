//
//  HistoryPerItemView.swift
//  SplitBuddy
//
//  Created by Jovie on 27/9/2024.
//

import SwiftUI
/**
 A view that displays a per-item bill split in the history.

 `HistoryPerItemView` shows the details of a bill where the costs are split based on the items each participant has consumed.
 It displays the bill's date, name, participants, their corresponding items, and the total cost of the bill.
 
 - Properties:
   - billModel: A model representing the bill to be displayed, including details about the bill, food items, and people.
 
 - Example:
 ```swift
 HistoryPerItemView(billModel: BillModel(name: "Dinner", foods: [FoodModel(name: "Pizza", price: 50)], peoples: [PeopleModel(name: "John", price: 50, icon: "", selected: false, foods: [])], isEqually: false))
*/

struct HistoryPerItemView: View {
    let billModel: BillModel
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            // Display the bill's date and name.
            Text(billModel.date, format: .dateTime)
            Text(billModel.name)
            // Display each participant's details using `builderItemView`, which includes their name and items consumed.
            ForEach(0..<billModel.peoples.count, id: \.self) { index in
                builderItemView(people: billModel.peoples[index])
            }
            
            // Add a visual divider for separation.
            Divider().frame(height: 3)
                .background(themeColor1)
                .padding(10)
            
            // Display the total amount for the bill.
            HStack(content: {
                Text("Total")
                    .padding(.leading, 10)
                Spacer()
                Text(String(format: "%.2lf",billModel.peoples.reduce(0, {$0+$1.price}) )).padding(.trailing,10)
            })
            .padding(.bottom, 5)
        })
        .padding()
        .background(themeColor12)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
     
    }
    
    /**
     A helper function that creates a view for displaying each participant's details and their corresponding items.
     
     - Parameter people: The model representing a participant, including their icon, name, and the items they consumed.
     - Returns: A `View` representing the participant and their payment details.
     */
    
    func builderItemView(people: PeopleModel) -> some View {
        
        return VStack(content: {
            HStack(alignment: .top, spacing: 10, content: {
                // Display the participant's icon
                Image(people.icon)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    .padding(5)
                
                // Display the participant's name and the items they consumed.
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(people.name)
                    Text(people.foods.map({$0.name}).joined(separator: ","))
                })
                Spacer()
                
            })
            .font(Font.system(size: 14, weight: .medium))
           
            // Display the payment amount for the participant.
            HStack(content: {
                Text("Payment amount")
                Spacer()
                Text(String(format: "%.2lf",people.price))
            })
            .padding(.bottom, 5)
            // Add a divider after each participant's section.
            Divider()
        })
        .background(themeColor12)
        
    }
}

#Preview {
    HistoryPerItemView(billModel:BillModel(name: "dsd", foods: [], peoples: [], isEqually: false))
}
