//
//  BillResultView.swift
//  SplitBuddy
//
//  Created by Jovie on 29/8/2024.
//

import SwiftUI

/**
 The final view in the bill creation process, displaying the summary of the bill including food items, people involved, and the total cost (including tax).

 `BillResultView` provides a complete summary of the bill and allows the user to save the bill data. It also allows sharing the bill via an image of the result.

 - Properties:
   - title: A `String` representing the bill title.
   - foodsList: A list of `Food` items included in the bill.
   - peopleList: A list of `People` who will split the bill.
   - tax: A `Double` representing the tax percentage applied to the bill.
   - shareImage: An optional `Image` that is generated for sharing the bill.
   - showAlert: A `State` boolean that controls the display of success or error alerts when saving the bill.
   - isSuccessAlert: A `State` boolean that determines whether the alert is a success or error alert.
 */

struct BillResultView: View {
    let title : String/// The title of the bill.
    let foodsList: [Food]/// A list of Food items included in the bill.
    var peopleList: [People] = []/// A list of People involved in the bill.
    @Environment(\.modelContext) private var modelContext/// Used to access the environment's model context for saving data.
    @Environment(\.dismiss) var dismiss/// Used to dismiss the current view.
    @State var shareImage: Image?/// Holds the image that will be generated and shared.
    @State var showAlert = false/// Controls whether an alert should be shown (for success or error).
    @State var isSuccessAlert = true/// Determines whether the alert is a success or error message.
    var tax: Double/// The tax percentage applied to the total bill.
    init(title: String,foodsList: [Food], peopleList: [People],tax:Double) {
        self.tax = tax
        self.title = title
        self.foodsList = foodsList.filter({$0.name.count > 0 && $0.price > 0 })
        self.peopleList = peopleList
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            // Displays a progress view showing the user is on the last step (5/5).
            ProgressView(value: 5/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)
            
            Text("Step \(5): Buddies Bill Details")
                .font(.title)
            
            // Displays the bill summary using a separate view.
            ScrollView {
                BillResultContentView(foodsList: foodsList,peopleList: peopleList,tax: tax)
            }
            BottomView// A view containing "Back" and "Save" buttons.
        })
        .padding(15)
        .navigationTitle(Text("Summary"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert, content: {
            if isSuccessAlert {
                Alert(title:  Text("Save success"), message: nil, dismissButton: Alert.Button.default(Text("OK"), action: {
                    dismiss()
                }))
            } else {
                Alert(title: Text("Save error"))
            }
            
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if let shareImage {
                    ShareLink(item: shareImage, preview: SharePreview("My image", image: shareImage))
                }
            }
        })
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let image = BillResultContentView(foodsList: foodsList,peopleList: peopleList,tax: tax).snapshot()
                shareImage = Image(uiImage: image!)
               // UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }
            
        })
    }
    
    /** A view that contains "Back" and "Save" buttons.

    The "Back" button dismisses the current view, and the "Save" button saves the bill data to persistent storage. */
    
    var BottomView: some View {
        HStack(alignment: .center, content: {
            Spacer()
            // Button to go back to the previous view.
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
            // Button to save the bill data.
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
    
    /** Saves the bill data to persistent storage, including the food items and people involved.

    This function creates a BillModel instance and saves it to the model context. If the save is successful, a success alert is shown. If there is an error, an error alert is displayed. */
    
    func saveData()  {
        let totalPrice = foodsList.reduce(0, {$0+$1.price})
        
        var foods = foodsList.map({FoodModel(name: $0.name, price: $0.price)})
        foods.append(FoodModel(name: "Tax", price: totalPrice * tax/100.0 / Double(foodsList.count)))
        let peoples = peopleList.map({PeopleModel(id: $0.id, name: $0.name, price: $0.price, icon: $0.icon, selected: $0.selected, foods: [])})
        
        
        let model = BillModel(name: title,foods: foods, peoples: peoples,isEqually: true)
        do {
            modelContext.insert(model)
            try modelContext.save()
            showAlert.toggle()
            isSuccessAlert = true
        } catch  {
            showAlert.toggle()
            isSuccessAlert = false
            print(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        BillResultView(title: "cole",foodsList: [Food(name: "beef dansb dbab ", price: 12.00),Food(name: "beef", price: 12.00),Food()], peopleList: [People(name: "lucy", price: 0, icon: "a20"),People(name: "lucy", price: 0, icon: "a2"),People(name: "lucy", price: 0, icon: "a3")],tax: 20)
    }
    
}

/**
 A view that displays the details of the bill, including the food items, the tax, and the people involved in splitting the bill.

 `BillResultContentView` is a reusable view that shows the breakdown of the total bill, the tax percentage, and the amount each person will pay.

 - Properties:
   - foodsList: A list of `Food` items in the bill.
   - peopleList: A list of `People` who are splitting the bill.
   - tax: A `Double` representing the tax percentage applied to the bill.
 */

struct BillResultContentView: View{
    let foodsList: [Food]/// The list of food items in the bill.
    var peopleList: [People] = []/// The list of people involved in splitting the bill.
    let tax:Double/// The tax percentage applied to the bill.
    var body: some View {
     
         VStack(content: {
             VStack(alignment: .leading,spacing: 10 ,content: {
                 Text("Summary: Aru Melbourne")
                 // Displays the list of food items and their prices.
                 ForEach(0..<foodsList.count, id: \.self) { index in
                     HStack(alignment: .top, content: {
                         Text(foodsList[index].name)
                         Spacer()
                         Text(String(format: "%.2lf", foodsList[index].price))
                     })
                 }
                 
                 Spacer().frame(height: 10)
                 
                 // Displays the tax percentage.
                 HStack(content: {
                     Text("Tax")
                         .fontWeight(.bold)
                     Spacer()
                     Text(String(format: "%.2lf%%", tax))
                         .fontWeight(.bold)
                 })
                 .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                 
                 // Displays the total amount including tax.
                 HStack(content: {
                     Text("Total")
                         .fontWeight(.bold)
                     Spacer()
                     Text(String(format: "%.2lf", foodsList.reduce(0, {$0+$1.price}) * (tax/100.0 + 1)))
                         .fontWeight(.bold)
                 })
             })
             .padding(15)
             .background(themeColor12)
              
             Divider()
                 .frame(height: 3)
                 .background(themeColor1)
             
             // Section displaying the people involved in paying the bill.
             HStack(content: {
                 Text("People Paying")
                 Spacer()
             })
             .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
             ForEach(0..<peopleList.count, id: \.self) { index in
                 HStack(alignment: .center, content: {
                     Image(peopleList[index].icon)
                         .resizable()
                         .frame(width: 40, height: 40, alignment: .center)
                         .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                     Text(peopleList[index].name)
                         .frame(minWidth: 120, alignment: .leading)
                     Spacer()
                     Text(String(format: "%.2lf", peopleList[index].price))
                         .layoutPriority(1000)
                 })
                 .frame(height: 60)
                 .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                 .background(Color.init(red: 189/255.0, green: 199/255.0, blue: 176/255.0))
                 .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30, height: 30)))
             }
         })
         .padding()
        
        
    }
}
