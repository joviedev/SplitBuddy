//
//  HistoryEqualItemView.swift
//  SplitBuddy
//
//  Created by Jovie on 27/9/2024.
//

import SwiftUI
/**
 A view that displays an equal bill split item in the history.

 `HistoryEqualItemView` shows the details of a bill where the costs are split equally between participants.
 It displays the bill's date, name, food items, participants' icons, and the total cost per person.
 
 - Properties:
   - billModel: A model representing the bill to be displayed, including details about the bill, food items, and people.
 
 - Example:
 ```swift
 HistoryEqualItemView(billModel: BillModel(name: "Dinner", foods: [FoodModel(name: "Pizza", price: 50)], peoples: [PeopleModel(name: "John", price: 50, icon: "", selected: false, foods: [])], isEqually: true))
*/

struct HistoryEqualItemView: View {
    /// The bill model that contains the data to be displayed in the view.
    let billModel: BillModel
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            // Display the bill's date and name.
            Text(billModel.date, format: .dateTime)
            Text(billModel.name)
            
            // Display the names of the food items in the bill, separated by commas.
            Text(billModel.foods.map({$0.name}).joined(separator: ","))
            
            // Display the icons of all participants in the bill, arranged in a custom layout.
            HStack(content: {
                CustomLayoutView(){
                    ForEach(0..<billModel.peoples.count, id: \.self) { index in
                        Image(billModel.peoples[index].icon)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                .stroke(.white, lineWidth: 2))
                    }
                    
                }
                Spacer().layoutPriority(1000)
            }).frame(height: 50)
            
            // Display the total amount for the bill.
            HStack(alignment: .bottom, spacing: 5, content: {
                Text("Total:")
                Text(String(format: "%.2lf", billModel.foods.reduce(0, {$0+$1.price})))
            })
            
            // Display the amount each person needs to pay, based on the total split equally.
            HStack(alignment: .bottom, spacing: 5, content: {
                Text("Payment per person:")
                Text(String(format: "%.2lf", billModel.foods.reduce(0, {$0+$1.price})/Double(billModel.peoples.count)))
            })
        })
        .padding()
        .background(themeColor12)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
     
    }
}

#Preview {
    // Provides a preview of `HistoryEqualItemView` using a sample `BillModel` with sample data.
    HistoryEqualItemView(billModel: BillModel(name: "title", foods: [FoodModel(name: "milk", price: 100),FoodModel(name: "tofu", price: 120.0),FoodModel(name: "Tax", price: 11)], peoples: [PeopleModel(name: "jovie1", price: 165.5, icon: "", selected: false, foods: []),PeopleModel(name: "jovie2", price: 165.5, icon: "", selected: false, foods: [])], isEqually: true))
    
}

