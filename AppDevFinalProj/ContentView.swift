//
//  ContentView.swift
//  AppDevFinalProj
//
//  Created by Student on 12/3/23.
//

import SwiftUI

struct ContentView: View{
    @State var showSignIn: Bool = true
    
    
    init() {
      // Large Navigation Title
      UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      // Inline Navigation Title
      UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    init(showSignIn: Bool = true){
        self.showSignIn=AuthManager.shared.getCurrentUser() == nil
    }
    
    var body: some View{
        if showSignIn{
            SignInView(showSignIn: $showSignIn)
        }else{
            NavigationStack {
                ZStack {
                    ChatView()
                }
                .navigationTitle("Loyola Chat")
                //.toolbarColorScheme(<#T##colorScheme: ColorScheme?##ColorScheme?#>, for: <#T##ToolbarPlacement...##ToolbarPlacement#>)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement:.navigationBarTrailing){
                        Button{
                            do{
                                try AuthManager.shared.signOut()
                                showSignIn=true
                            } catch{
                                print("error signing Out")
                            }
                        }label: {
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        
    }
}



struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
