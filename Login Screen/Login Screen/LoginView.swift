//
//  ContentView.swift
//  Login Screen
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
    let auth: Auth
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}

struct LoginView: View {
    
    @State var loginMode = true
    @State var statusMessage = ""
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text(loginMode ? "Sign In" : "Sign Up")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 120, alignment: .leading)
                        .padding(.trailing, 215)
                    
                    Picker(selection: $loginMode, label: Text("")) {
                        Text("Sign In").tag(true)
                        Text("Sign Up").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .background(Color.gray)
                        .frame(width: 345, height: 40)
                        .cornerRadius(30)
                    
                    EmailText()
                    TextField(" name@example.com", text: $email)
                        .frame(width: 345, height: /*@START_MENU_TOKEN@*/40.0/*@END_MENU_TOKEN@*/)
                        .background(Color.white)
                        .cornerRadius(5.0)
                    
                    PasswordText()
                    SecureField(" ****************", text: $password)
                        .frame(width: 345, height: /*@START_MENU_TOKEN@*/40.0/*@END_MENU_TOKEN@*/)
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Button {
                        doAction()
                    } label: {
                        HStack {
                            Text(loginMode ? "Sign In" : "Create Account")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 345, height: 45)
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                    }
                    Button(action:{FirebaseManager.shared.auth.sendPasswordReset(withEmail: email) { (error) in
                    }}) {
                        ForgotButtonContent()
                    }
                    Text(self.statusMessage)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func doAction(){
        if loginMode {
            loginUser()
        } else {
            createUser()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.statusMessage = "Failed to login user: \(err)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.statusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
    
    private func createUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.statusMessage = "Failed to create user: \(err)"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.statusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            verifyUser()
        }
    }
    public func verifyUser() {
        if FirebaseManager.shared.auth.currentUser != nil && !FirebaseManager.shared.auth.currentUser!.isEmailVerified {
            FirebaseManager.shared.auth.currentUser!.sendEmailVerification(completion: { (error) in
                
            })
        }
        else {
            
        }
    }
}

struct EmailText : View {
    var body: some View {
        return Text("Email")
            .foregroundColor(.white)
            .padding(.trailing, 300)
            .offset(x: 0, y: 7)
    }
}
    
struct PasswordText : View {
    var body: some View {
        return Text("Password")
            .foregroundColor(.white)
            .padding(.trailing, 269)
            .offset(x: 0, y: 7)
    }
}

struct ForgotButtonContent : View {
    var body: some View {
        return Text("Forgot Password?")
            .foregroundColor(.gray)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
