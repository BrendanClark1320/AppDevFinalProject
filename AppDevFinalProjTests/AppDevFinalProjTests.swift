//
//  AppDevFinalProjTests.swift
//  AppDevFinalProjTests
//
//  Created by Student on 12/3/23.
//
import FirebaseAuth
import XCTest
@testable import AppDevFinalProj
import FirebaseFirestore
import FirebaseCoreExtension
import Foundation
import GoogleSignIn
import GoogleSignInSwift


final class AppDevFinalProjTests: XCTestCase {
    class MockAuthManager: AuthManager {
        override func getCurrentUser() -> ChatRoomUser? {
            // Mock a current user for testing
            return ChatRoomUser(uid: "mockUserID", name: "MockUser", email: "mock@loyola.com", photoURL: "photourl.jpg")
        }
    }
    
    class MockDatabaseManager: DatabaseManager {
        var shouldSucceed = true
        override func sendMessageToDatabase(message: Message, completion: @escaping (Bool) -> Void){
            let data = [
                "text": message.text,
                "userUid": message.userUid,
                "photoURL": message.photoURL,
                "createdAt": Timestamp(date:message.createdAt)
            ] as [String : Any]
            messageRef.addDocument(data: data){ error in
                guard error == nil else{
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        override func fetchMessages(completion: @escaping (Result<[Message], FetchMessagesError>)-> Void){
            messageRef.order(by: "createdAt", descending: true).limit(to: 25).getDocuments{[weak self] snapshot, error in
                guard let snapshot = snapshot, let strongSelf = self,error == nil else{
                    completion(.failure(.snapshotError))
                    return
                }
                strongSelf.listenForNewMessagesInDatabase()
                let messages = strongSelf.createMessagesFromFirebaseSnapshot(snapshot: snapshot)
                completion(.success(messages))
            }
        }
    }
    
    func testIsFromCurrentUser() {
        // Arrange
        let currentUserID = "mockUserID"
        let otherUserID = "otherUserID"
        
        // Set up a mock message for testing
        let currentUserMessage = Message(userUid: currentUserID, text: "Test message", photoURL: nil, createdAt: Date())
        let otherUserMessage = Message(userUid: otherUserID, text: "Another message", photoURL: nil, createdAt: Date())
        
        // Act
        // Use the mock AuthManager during testing
        var originalAuthManager = AuthManager.shared
        AuthManager.shared = MockAuthManager()
        
        // Assert
        XCTAssertTrue(currentUserMessage.isFromCurrentUser(), "Message from current user should return true")
        XCTAssertFalse(otherUserMessage.isFromCurrentUser(), "Message from other user should return false")
        
        // Restore the original AuthManager after testing
        AuthManager.shared = originalAuthManager
    }
    
    var databaseManager: DatabaseManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // Initialize the DatabaseManager
        databaseManager = DatabaseManager.shared
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        databaseManager = nil
        try super.tearDownWithError()
    }
    
    
    func testSendMessageToDatabase() throws {
        let mockDatabaseManager = MockDatabaseManager()
        let message = Message(userUid: "ID", text: "test message!", photoURL: "test.com", createdAt: Date())
                
        let expectation = XCTestExpectation(description: "Sending message to database")

        mockDatabaseManager.sendMessageToDatabase(message: message) { success in
            XCTAssertTrue(success)
                    
            expectation.fulfill()
        }
                
        // Wait for the expectation to be fulfilled or timeout
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMessagesSuccess() {
        let mockDatabaseManager = MockDatabaseManager()
        mockDatabaseManager.shouldSucceed = true
        let expectation = XCTestExpectation(description: "Fetching messages")
        mockDatabaseManager.fetchMessages { result in
            switch result {
            case .success(let messages):
                XCTAssertFalse(messages.isEmpty)
            case .failure(let error):
                XCTFail("Fetch messages test failed \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRealTimeUpdates() throws {
        let expectation = XCTestExpectation(description: "Real-time update received")
        
        // Start listening for new messages
        try databaseManager.listenForNewMessagesInDatabase()
        
        // Simulate a new message being added to the database
        let testMessage = Message(userUid: "newUserID", text: "New test message", photoURL: "newTestURL", createdAt: Date())
        databaseManager.sendMessageToDatabase(message: testMessage) { success in
            if success {
                // If the message is successfully sent, fulfill the expectation
                expectation.fulfill()
            } else {
                XCTFail("Failed to send a new message")
            }
        }
        // Wait for an update or timeout
        wait(for: [expectation], timeout: 5.0)
        // Assert based on the received update
    }
    
    
    
    func testPerformanceExample() throws {
        let expectation = XCTestExpectation(description: "Real-time update received")
        
        // Start measuring time
        let startTime = Date()
        
        // Start listening for new messages
        try? databaseManager.listenForNewMessagesInDatabase()
        
        // Simulate a new message being added to the database
        let testMessage = Message(userUid: "newUserID", text: "New test message", photoURL: "newTestURL", createdAt: Date())
        databaseManager.sendMessageToDatabase(message: testMessage) { success in
            if success {
                // If the message is successfully sent, fulfill the expectation
                
                
                // Calculate duration after the message is sent and the expectation is fulfilled
                let endTime = Date()
                let duration = endTime.timeIntervalSince(startTime)
                print("Message sending duration: \(duration) seconds")
                expectation.fulfill()
            } else {
                XCTFail("Failed to send a new message")
            }
        }
        
        
        // Wait for an update or timeout
       
        wait(for: [expectation], timeout: 5.0)
    }
    func testFetchPhotoURL() {
        // Given
        let currentUserID = "UserID"
        
        let currentUser = "mockUser"
        
        let mockMessage = Message(userUid: currentUserID, text: "test message", photoURL: "test.com", createdAt: Date())
        
        XCTAssertEqual(URL(string: "test.com"), mockMessage.fetchPhotoURL())

        
    }
    
        
    

}
