//
//  SignInView.swift
//  AppDevFinalProj
//
//  Created by Student on 12/3/23.
//

import SwiftUI

struct SignInView: View {
    @Binding var showSignIn: Bool
    var body: some View {
        VStack(spacing: 60){
            Image("background-realistic-abstract-technology-particle_23-2148431735")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 400, maxHeight: 450, alignment: .top)
                
//                .clipped()
            
            
            Text("Please Sign In Below")
                .padding()
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth:300)
                .multilineTextAlignment(.center)
            
            VStack(spacing:20){
//                Button{
//                    print("apple")
//                }label: {
//                    Text("Sign in with Apple")
//                        .padding()
//                        .foregroundColor(.primary)
//                        .overlay{
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke()
//                                .foregroundColor(.primary)
//                                .frame(width:300)
//                        }
//                }
//                .frame(width:300)
                
                Button{
                    AuthManager.shared.signInWithGoogle{result in
                        switch result{
                        case .success(let user):
                            showSignIn=false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }label: {
                    Text("Sign in with Google")
                        .padding()
                        .foregroundColor(.white)
                        .overlay{
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                                    .foregroundColor(.white)
                                .frame(width:300)
                            }
                            .shadow(color: Color.init(uiColor: .white), radius: 3)
                        }
                }
                .frame(width:300)
            }
            Spacer()
        }
        .background(Color(hex:"#1e2124"))
        .edgesIgnoringSafeArea(.top)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showSignIn: .constant(true))
    }
}
