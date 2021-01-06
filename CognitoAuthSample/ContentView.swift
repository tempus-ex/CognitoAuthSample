//
//  ContentView.swift
//  CognitoAuthSample
//
//  Created by Christopher Brown on 1/6/21.
//

import Amplify
import AmplifyPlugins
import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var errorMessage: String? = nil
    @State private var token: String? = nil
    
    func signIn() {
        errorMessage = nil
        token = nil
        isSigningIn = true
        Amplify.Auth.signOut {_ in
            Amplify.Auth.signIn(username: username, password: password) { result in
                switch result {
                case .success(let outcome):
                    switch outcome.nextStep {
                    case .done:
                        Amplify.Auth.fetchAuthSession {result in
                            let result = result.flatMap{
                                ($0 as! AWSAuthCognitoSession).cognitoTokensResult
                            }
                            switch result {
                            case .success(let tokens):
                                print(tokens.idToken)
                                token = tokens.idToken
                                isSigningIn = false
                            case .failure(let err):
                                errorMessage = "\(err)"
                                isSigningIn = false
                            }
                        }
                    default:
                        errorMessage = "Additional step required: \(outcome.nextStep)"
                        isSigningIn = false
                    }
                case .failure(let err):
                    errorMessage = "\(err)"
                    isSigningIn = false
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if let msg = errorMessage {
                Text(msg)
                    .foregroundColor(Color.red)
            }
            TextField("Username", text: $username, onCommit: signIn)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .disabled(isSigningIn)
            SecureField("Password", text: $password, onCommit: signIn)
                .disabled(isSigningIn)
            Button(action: signIn) {
                Text(isSigningIn ? "Signing in..." : "Sign In")
            }
                .disabled(isSigningIn)
            if let token = token {
                Spacer().frame(height: 20.0)
                Text("Token: \(token)")
                    .font(.system(size: 12))
                    .frame(maxHeight: 200.0)
            }
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
