//
//  HomeItemView.swift
//  SplitBuddy
//
//  Created by Jovie on 27/8/2024.
//

import SwiftUI
/**
 A view that displays a single home screen action item.

 `HomeItemView` shows a row that contains an icon, title, and description for an action the user can take. This component is used to represent different features like creating a bill, viewing exchange rates, or accessing history in the app's home screen.

 - Properties:
   - homeModel: A `HomeModel` object representing the action to be displayed, including its icon, title, and description.
 
 - Example:
 ```swift
 HomeItemView(homeModel: HomeModel(icon: "plus", title: "Create Bill", value: "Add your bill manually"))
 */

struct HomeItemView: View {
    /// The model object that holds the icon, title, and value for this home item.
    var homeModel = HomeModel()
    var body: some View {
        HStack(content: {
            // Spacer for padding before the icon.
            Spacer().frame(width: 10)
            // Display the icon for the home action.
            Image(systemName: homeModel.icon)
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundStyle(Color.blue)
            // Display the title and value (description) for the home action.
            VStack(alignment: .leading, spacing: 5, content: {
                Text(homeModel.title)
                    .foregroundStyle(Color.black)
                    .bold()
                Text(homeModel.value)
                    .foregroundStyle(Color.black)
                    .fontWeight(.regular)
            })
           
            Spacer() // Spacer to push content to the left.
        })
        .frame(height: 70)
        .background(Color.init(red: 232/255.0, green: 232/255.0, blue: 232/255.0))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        
    }
}


#Preview {
    HomeItemView() 
}
