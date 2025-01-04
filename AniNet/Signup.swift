//
//  ContentView.swift
//  AniNet
//
//  Created by Adam May on 1/2/25.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignInCoordinator: NSObject, ASAuthorizationControllerPresentationContextProviding, ObservableObject {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

struct Signup: View {
    @State private var authError: String?
    @State private var navigateToProfile = false
    @StateObject private var signInCoordinator = SignInCoordinator()
    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            VStack {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            guard let identityToken = appleIDCredential.identityToken else {
                                print("Unable to fetch identity token")
                                return
                            }
                            let tokenString = String(data: identityToken, encoding: .utf8) ?? ""
                            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: "")
                            
                            Auth.auth().signIn(with: firebaseCredential) { authResult, error in
                                if let error = error {
                                    print("Firebase sign in error: \(error.localizedDescription)")
                                    self.authError = error.localizedDescription
                                    return
                                }
                                
                                if let user = authResult?.user {
                                    checkUserInFirestore(uid: user.uid) { exists in
                                        if !exists {
                                            saveUserToFirestore(user: user)
                                        }
                                        self.navigateToProfile = true
                                    }
                                }
                            }
                        default:
                            break
                        }
                    case .failure(let error):
                        authError = error.localizedDescription
                        print("Authorization failed: \(error.localizedDescription)")
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(width: 200, height: 50)
                .cornerRadius(25)
                
                if let authError = authError {
                    Text("Authorization failed: \(authError)")
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                NavigationLink(destination: Profile().navigationBarBackButtonHidden(true), isActive: $navigateToProfile) {
                    EmptyView()
                }
            }
            .onAppear {
                // Check if user is already authenticated
                if let currentUser = Auth.auth().currentUser {
                    checkUserInFirestore(uid: currentUser.uid) { exists in
                        if exists {
                            self.navigateToProfile = true
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func saveUserToFirestore(user: User) {
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? ""
        ]
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error saving user to Firestore: \(error.localizedDescription)")
            } else {
                print("User successfully saved to Firestore")
            }
        }
    }
    
    private func checkUserInFirestore(uid: String, completion: @escaping (Bool) -> Void) {
        let usersRef = db.collection("users").document(uid)
        usersRef.getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

#Preview {
    Signup()
}
