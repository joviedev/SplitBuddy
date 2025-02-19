//
//  AddPeopleView.swift
//  SplitBuddy
//
//  Created by Jovie on 31/8/2024.
//

import SwiftUI

/**
 A view that allows users to add a person with a custom name and profile picture.

 `AddPeopleView` provides a user interface for entering a person's name and selecting an avatar from a set of predefined images. Once the data is validated, the person is saved, and the view is dismissed. The selected image and name are passed back via a completion handler (`sureHander`).

 - Properties:
   - `peopleList`: A binding to the list of people, allowing the view to check for duplicate names.
   - `peopleName`: A state variable to hold the name entered by the user.
   - `showAlert`: A state variable controlling the display of alerts for invalid input.
   - `alertText`: A string containing the message shown in the alert.
   - `dismiss`: An environment variable used to dismiss the current view.
   - `showHeadView`: A state variable that toggles the display of the image selection sheet.
   - `imageName`: A state variable holding the name of the selected image.
   - `sureHander`: A callback that passes the selected image name and person’s name when the user saves the person.

 - Example:
 ```swift
 AddPeopleView(peopleList: .constant([]))
 */

struct AddPeopleView: View {
    /// A binding to the list of people, allowing checks for duplicate names.
    @Binding var peopleList: [People]
    /// A state variable to hold the name of the person entered by the user
    @State private var peopleName: String = ""
    /// A state variable to control the display of alerts for invalid input.
    @State private var showAlert = false
    /// A string containing the message shown in the alert.
    @State private var alertText = ""
    /// An environment variable used to dismiss the current view.
    @Environment(\.dismiss) private var dismiss
    /// A state variable that toggles the display of the image selection sheet.
    @State private var showHeadView = false
    /// A state variable that holds the name of the selected image.
    @State private var imageName = ""
    /// A callback that passes the selected image name and person’s name when the user saves the person.
    var sureHander : ((_ imageName: String, _ name: String) -> ())?
    var body: some View {
        VStack(alignment: .leading,spacing: 20,content: {
            // Section to select a profile image by tapping.
            HStack(content: {
                Text("head")
                    .frame(width: 100)
                
                Image(imageName.count > 0 ? imageName : "photo")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                // Show the image selection view when tapped.
                    .onTapGesture {
                        showHeadView.toggle()
                    }
                
            })
            
            HStack(content: {
                // TextField for the user to input the person's name.
                Text("Name")
                    .frame(width: 100)
                TextField("PeopleName", text: $peopleName)
                    .textFieldStyle(.roundedBorder)
                
            })
            Spacer().frame(height: 50)
            HStack(alignment: .center,content: {
                Spacer()
                // Save button to trigger data validation and save the input.
                Button(action: {
                    print("click button")
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
            
            Spacer()
        })
        .sheet(isPresented: $showHeadView, content: {
            // Show the image selection view when showHeadView is toggled.
            SelectHeadView(selectHander: { imageName in
                self.imageName = imageName
            })
        })
        .padding(30)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertText))
        })
    }
    

    /** Saves the person's data after validating that the image and name are not empty and that the name is unique.
     If any validation fails, an alert is shown. If all checks pass, the selected image and name are passed to the sureHander closure and the view is dismissed.
     */
    func saveData()  {
        if imageName.isEmpty {
            showAlert.toggle()
            alertText = "head is empty"
            return
        }
        // Check if the name is entered, otherwise show an alert.
        if peopleName.isEmpty {
            showAlert.toggle()
            alertText = "Please input all input"
            return
        }
        // Check for duplicate names in the peopleList.
        if peopleList.contains(where: {$0.name == peopleName}) {
            showAlert.toggle()
            alertText = "There is already an identical name"
            return
        }
        

        // Pass the selected image and name to the callback handler.
        sureHander?(imageName,peopleName)
        // Dismiss the view after saving.
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddPeopleView(peopleList: .constant([]))
    }
    
}
