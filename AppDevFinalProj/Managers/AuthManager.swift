//
//  AuthManager.swift
//  AppDevFinalProj
//
//  Created by Student on 12/3/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct ChatRoomUser{
    let uid: String
    let name:String
    let email: String?
    let photoURL: String?
}

enum GoogleSignInError: Error{
    case unableToGrabTopVC
    case signInPresentationError
    case authSignInError
}

class AuthManager{
    static var shared = AuthManager()
    
    let auth = Auth.auth()
    
    func getCurrentUser() -> ChatRoomUser?{
        guard let authUser = auth.currentUser else {
            return nil
        }
        return ChatRoomUser(uid: authUser.uid, name: authUser.displayName ?? "Unknown", email: authUser.email, photoURL: authUser.photoURL?.absoluteString)
    }
    
    func signInWithGoogle(completion: @escaping (Result<ChatRoomUser, GoogleSignInError >) -> Void){
        let clientID = "1074768621378-604drr4pc5u2c6d224rlsjo4023nqtkh.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let topVC = UIApplication.getTopViewController() else{
            completion(.failure(.unableToGrabTopVC))
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [unowned self] result, error in
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  error == nil
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            auth.signIn(with:credential){result, error in
                guard let result = result, error == nil else{
                    completion(.failure(.authSignInError))
                    return
                }
                
                let user = ChatRoomUser(uid:result.user.uid, name: result.user.displayName ?? "Unknown", email: result.user.email, photoURL: result.user.photoURL?.absoluteString)
                completion(.success(user))
            }
        }
        
    }
    
    func signOut() throws{
        try auth.signOut()
    }
    
}



extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
