//
//  PayPerResultView.swift
//  SplitBuddy
//
//  Created by Jovie on 25/9/2024.
//

import SwiftUI

/**
 A view that presents the result of splitting a bill among multiple people based on selected food items.

 `PayPerResultView` calculates and displays how much each person needs to pay based on the selected food items. It allows users to either go back or save the bill. The result can also be shared as an image.

 - Properties:
   - `title`: The title of the bill being split.
   - `peopleList`: A list of people involved in the bill split.
   - `totalPrice`: The total amount to be paid for the bill.
   - `showAlert`: A state variable that controls whether an alert is displayed.
   - `isSuccessAlert`: A state variable that determines if the alert shows a success or error message.
   - `showShareSheet`: A state variable that controls the display of the share sheet.
   - `shareImage`: An optional `Image` that holds the snapshot of the result, ready for sharing.

 - Example:
 ```swift
 PayPerResultView(title: "Dinner Bill", peopleList: [People(name: "John", ...)], totalPrice: 100.0)
 */
struct PayPerResultView: View {
    /// Access the environment's model context for saving the bill data.
    @Environment(\.modelContext) private var modelContext
    /// Access the environment's dismiss action for navigating back.
    @Environment(\.dismiss) var dismiss
    /// The title of the bill.
    let title : String
    /// The list of people involved in the bill split.
    let peopleList: [People]
    /// The total price of the bill.
    let totalPrice: Double
    /// Controls the display of alerts for save actions.
    @State var showAlert = false
    /// Determines whether the alert is for a success or error message.
    @State var isSuccessAlert = true
    /// Controls whether the share sheet is displayed.
    @State var showShareSheet = false
    /// Holds the snapshot image for sharing.
    @State var shareImage: Image?
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            // A progress bar indicating the current step in the process.
            ProgressView(value: 5/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)
                .padding(15)
            // Title for the current step.
            Text("Step \(5): Assign Payer")
                .font(.title)
                .padding(.leading, 15)
            // Scroll view that displays the content of the split.
            ScrollView {
                PayPerResultContentView(peopleList: peopleList, totalPrice: totalPrice,title: title)
            }
            
            // Bottom buttons for "Back" and "Save" actions.
            BottomView
        })
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Sunnary"))
        // Display success or error alert based on the save action.
        .alert(isPresented: $showAlert, content: {
            if isSuccessAlert {
                Alert(title:  Text("Save success"), message: nil, dismissButton: Alert.Button.default(Text("OK"), action: {
                    dismiss()
                }))
            } else {
                Alert(title: Text("Save error"))
            }
            
        })
        // Toolbar for sharing the image of the result.
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if let shareImage {
                    ShareLink(item: shareImage, preview: SharePreview("My image", image: shareImage))
                }
                //ShareLink(item: "https://www.appcoda.com")
                
            }
        })
        // Create a snapshot of the content to be shared when the view appears.
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let image = PayPerResultContentView(peopleList: peopleList, totalPrice: totalPrice,title: title).snapshot()
                shareImage = Image(uiImage: image!)
                //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }
            
        })
    }
    
    /// A view that contains the "Back" and "Save" buttons
    var BottomView: some View {
        
        HStack(alignment: .center, content: {
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Text("Back")
                    .frame(width: 150, height: 40, alignment: .center)
                    .background(Color(red: 207/255.0, green: 214/255.0, blue: 200/255.0))
                    .foregroundStyle(Color.black)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            })
            
            Spacer().frame(width: 15)
            Button(action: {
                saveData()
            }, label: {
                Text("Save")
                    .frame(width: 150, height: 40, alignment: .center)
                    .background(themeColor1)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            })
            Spacer()
        })
    }
    
    /** Saves the bill data to the model context.
     This method calculates how much each person needs to pay based on the selected food items. The calculated data is then saved to the model context. If the save is successful, a success alert is shown. Otherwise, an error alert is displayed.
     */
    func saveData() {
        
        let peopleModelList: [PeopleModel] =  peopleList.map { people in
            var price:Double = 0
            
            let foods = people.foods.filter({$0.selected})
            let otherPeopleList = peopleList.filter({$0.id != people.id})
            /** Saves the bill data to the model context.
             This method calculates how much each person needs to pay based on the selected food items. The calculated data is then saved to the model context. If the save is successful, a success alert is shown. Otherwise, an error alert is displayed. */
            
            for (index1, food) in foods.enumerated() {
                var payPeople = 1
                for (_, otherPeople) in otherPeopleList.enumerated() where otherPeople.foods.contains(where: {$0.id == food.id && $0.selected}){
                    payPeople += 1
                    break
                }
                price += (foods[index1].price / Double(payPeople))
            }
            let foodModelList = people.foods.map({FoodModel(id: UUID().uuidString, name: $0.name, price: $0.price)})
            return PeopleModel(id: people.id, name: people.name, price: price, icon: people.icon, selected: people.selected, foods: foodModelList)
        }
        
        let bill = BillModel(name: title, foods: [], peoples: peopleModelList, isEqually: false)
        modelContext.insert(bill)
        do {
            try modelContext.save()
            showAlert.toggle()
            isSuccessAlert = true
        } catch  {
            print(error.localizedDescription)
            showAlert.toggle()
            isSuccessAlert = false
        }
        
    }
}

#Preview {
    NavigationStack {
        PayPerResultView(title:"title", peopleList:
                            [People(name: "jovie1", price: 0, icon: "a1", selected: false, foods: [Food(id:"1",name: "beef", price: 10,selected: true),Food(id:"2",name: "beef2", price: 20),Food(id:"3",name: "beef3", price: 30, selected: true)]),
                             
                             People(name: "jovie2", price: 0, icon: "a10", selected: true, foods: [Food(id:"1",name: "beef", price: 10,selected: true),Food(id:"2",name: "beef2", price: 20, selected: true),Food(id:"3",name: "beef3", price: 30)])], totalPrice: 100.0)
    }
}
/** A view that displays a summary of the people involved in the bill and their respective payment amounts.

PayPerResultContentView shows how much each person owes based on the food items they selected. It provides a detailed breakdown of the items and their associated prices.

Properties:

peopleList: A list of people involved in the bill split.
totalPrice: The total amount of the bill.
title: The title of the bill. 
*/

struct PayPerResultContentView: View {
    let peopleList: [People]
    let totalPrice: Double
    var title:String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text("Summary: \(title)")
                .padding(.bottom,10)
            ForEach(0..<peopleList.count, id: \.self) { index in
                builderItemView(people: peopleList[index])
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            Divider()
                .frame(height: 3)
                .background(themeColor1)
                .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
            
            HStack(content: {
                Text("Total")
                    .padding(.leading, 10)
                Spacer()
                Text(String(format: "%.2lf",totalPrice)).padding()
                    .padding(.trailing, 10)
            })
            .padding(0)
            Spacer().frame(height: 30)
        }).padding()
            .frame(width: UIScreen.main.bounds.width)
        
        
    }
    
    /** Builds a view for displaying a person's name, selected food items, and their payment amounts.
     This function calculates how much a person should pay for each food item they selected and creates a view to display that information.

     Parameter people: A People object representing a person and their selected food items.

     Returns: A view that shows the person's selected food items and the total amount they owe.
     */
    func builderItemView(people: People) -> some View {
        var foods = people.foods.filter({$0.selected})
        let otherPeopleList = peopleList.filter({$0.id != people.id})
        
        for (index1, food) in foods.enumerated() {
            var payPeople = 1
            for (_, otherPeople) in otherPeopleList.enumerated() where otherPeople.foods.contains(where: {$0.id == food.id && $0.selected}){
                payPeople += 1
                break
            }
            foods[index1].perPrice = foods[index1].price / Double(payPeople)
        }
        
        return VStack(content: {
            HStack(alignment: .top, spacing: 10, content: {
                Image(people.icon)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    .padding(5)
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(people.name)
                        .font(Font.system(size: 18, weight: .medium))
                        .padding(3)
                    ForEach(0..<foods.count, id: \.self) { index in
                        HStack(content: {
                            Text(foods[index].name)
                            
                            Spacer()
                            Text(String(format: "%.2lf", foods[index].perPrice))
                        })
                    }
                })
                
                
            })
            .font(Font.system(size: 14, weight: .medium))
            Divider().frame(height: 3)
            
                .background(themeColor1)
                .padding(10)
            
            HStack(content: {
                Text("Total")
                    .padding(.leading, 10)
                Spacer()
                Text(String(format: "%.2lf",foods.reduce(0, {$0+$1.perPrice}) )).padding(.trailing,10)
            })
            .padding(.bottom, 5)
        })
        .background(themeColor12)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        
        
    }
}
