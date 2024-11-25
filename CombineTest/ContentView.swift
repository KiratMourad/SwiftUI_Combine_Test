//
//  ContentView.swift
//  CombineTest
//
//  Created by Mourad KIRAT on 17/02/2024.
//

import SwiftUI




// ViewModel that fetches data from the API and posts data to the API


// SwiftUI View displaying data from the API
struct ContentView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var addTitle:String = ""
    @FocusState private var isFocused: Bool
    @State private var addBody:String = ""
    @FocusState private var isFocused1: Bool
    @State private var color:String = "#E0FFFF"

    var body: some View {
        
        
        VStack {
            
            HStack {
                Image("image_title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250.0, height:75.0,alignment: .leading)
              
            }.background(Color.init(UIColor(hexString: self.color)))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(10)
        // Vstack 2
            VStack {
                // Title
                Form {
                    Section(header:Text("Add title and body")
                    
                        .foregroundColor(Color.gray)
                        .font(.headline)){
                        
                         if #available(iOS 16.0, *) {
                            
                             TextField("Add title", text: Binding(
                                 get: { addTitle },
                                 set:
                                     { (newValue, _) in
                                         if let _ = newValue.lastIndex(of: "\n") {
                                             isFocused = false
                                         } else {
                                             addTitle = newValue
                                         }
                                     }
                               ), axis: .vertical)
                             .foregroundColor(Color.black)
                             .font(.system(size: 18))
                                 .frame(maxWidth: .infinity, alignment: .leading)
                                 .textFieldStyle(.plain)
                                 .submitLabel(.done)
                                 .focused($isFocused)

                                 .multilineTextAlignment(.leading)
                              
                                 .padding(.leading, 17)
                               
                                
                                
                         }
                  
                    } .listRowBackground(Color.white)
                    Section{
                        if #available(iOS 16.0, *) {
                           
                            TextField("Add Body", text: Binding(
                                get: { addBody },
                                set:
                                    { (newValue, _) in
                                        if let _ = newValue.lastIndex(of: "\n") {
                                            isFocused1 = false
                                        } else {
                                            addBody = newValue
                                        }
                                    }
                              ), axis: .vertical)
                            
                            .font(.system(size: 18))
                            

                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textFieldStyle(.plain)
                                .submitLabel(.done)
                                .focused($isFocused1)

                                .multilineTextAlignment(.leading)
                             
                                .padding(.leading, 17)
                              
                               
                               
                        }
                    } .listRowBackground(Color.white)
                    Section{
                        Button(action: {
                            viewModel.addDataToAPI(title: self.addTitle, body: self.addBody)
                        } ) {
                            HStack(spacing: 10){
                                Text("Create Post")
                                    .foregroundColor(Color.black)
                                   
                                    .font(.system(size: 22))
                            
                            Label("", systemImage: "folder.fill.badge.plus")
                                    .foregroundColor(Color.black)
                                   
                                    .font(.system(size: 22))
                            
                            } .frame(maxWidth: .infinity, alignment: .center)
                        }
                  
                    } .listRowBackground(Color.cyan) // End section
                }.tint( Color.white)
                    .background( Color.black)
                    .scrollContentBackground(.hidden)// End Form
            }.background( Color.init(UIColor(hexString:  "#FCFCFC")))
                .frame(maxWidth: .infinity)
                    .cornerRadius(15)
                    .shadow(color: Color.init(UIColor(hexString: "#000000" )).opacity(0.2), radius: 10.0, x: -10.0, y: -10.0)
                    .padding(10)
                

            Form {
                
                // Section
                ForEach(Array(viewModel.posts.enumerated().reversed()), id: \.element.id) { index, post in
                    
                    Section{
                        VStack(alignment: .leading) {
                            Text("\(index + 1). \(post.title)")
                                .foregroundColor( Color.init(UIColor(hexString: "#F5F5F5" )))
                                .font(.headline)
                                .padding(.bottom, 10)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor( Color.init(UIColor(hexString: "#F5F5F5" )))
                        }
                    } .listRowBackground(Color.black) // End section
                }
            } .tint( Color.white)
                .background( Color.init(UIColor(hexString: self.color )))//
        .scrollContentBackground(.hidden)// End Form
        .onAppear {
            viewModel.fetchPosts()
        }
            
            
   
      

         
          
           

    } // End Vstack
        .background(Color.init(UIColor(hexString: self.color )))//#696969
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
