//
//  ChatView.swift
//  AppDevFinalProj
//
//  Created by Student on 12/3/23.
//

import SwiftUI



struct ChatView: View {
    @StateObject var chatViewModel = ChatViewModel()
    @State var text = ""

    var body: some View {
        ZStack{
            Color(hex:"#282b30")
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8){
                            ForEach(Array(chatViewModel.messages.enumerated()), id: \.offset) {idx, message in
                                MessageView(message: message)
                                    .id(idx)
                            }
                            .onChange(of:chatViewModel.messages){newValue in
                                scrollView.scrollTo(chatViewModel.messages.count - 1, anchor: .bottom)
                            }
                        }
                        
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .background(Color(hex: "#282b30"))
                }
                HStack {
                    TextField("", text: $text,axis: .vertical)
                        .placeholder(when: text.isEmpty){
                            Text("Whats Up?").foregroundColor(.gray)
                        }
                        .foregroundColor(.white)
                        .padding()
                    
                    ZStack {
                        Button{
                            if text.count > 1{
                                chatViewModel.sendMessage(text:text){ success in
                                    if success{
                                        
                                    }else{
                                        print("error sending message")
                                    }
                                }
                                text = ""
                            }
                        }label:{
                            Text("Send")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(hex:"#7289da"))
                                .cornerRadius(50)
                                .padding(.trailing)
                        }
                    }
                    .padding(.top)
                    .shadow(radius: 2)
                }.background(Color(hex:"#424549"))
            }
        }
        
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
