//
//  Message.swift
//  AppDevFinalProj
//
//  Created by Student on 12/3/23.
//

import Foundation

struct Message: Decodable, Identifiable, Equatable, Hashable{
    
    enum MessageError: Error{
        case noPhotoURL
    }
    
    let id = UUID()
    let userUid: String
    let text: String
    let photoURL: String?
    let createdAt: Date
    
    func isFromCurrentUser() -> Bool {
        guard let currUser = AuthManager.shared.getCurrentUser() else{
            return false
        }
        
        if currUser.uid == userUid{
            return true
        }
        else {
            return false
        }
    }
    
    func fetchPhotoURL() -> URL? {
        guard let photoURLString = photoURL, let url = URL(string: photoURLString) else{
            return nil
        }
        return url
    }
    
}
