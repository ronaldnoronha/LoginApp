//
//  ContentView.swift
//  LoginApp
//
//  Created by Noronha, Ronald on 25/4/2023.
//

import SwiftUI

struct Response: Codable {
    let country: String
}

class LoginManager: ObservableObject {
    @Published var isLoggedIn = false
    @State var country: String?
    
    func login() async throws {
        let url = URL(string: "http://130.41.233.29:8080/login?name=ron&password=hey")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(Response.self, from: data)
        country = result.country
    }
}


struct ContentView: View {
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        if let country = loginManager.country, loginManager.isLoggedIn {
            LoggedInView(country: country)
        } else {
            LoginView(loginManager: loginManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct LoginView: View {
    @ObservedObject var loginManager : LoginManager
    
    var body: some View {
        Button("login") {
            Task {
                try await loginManager.login()
            }
        }
    }
}

struct LoggedInView: View {
    var country: String
    var body: some View {
        Text("\(country.capitalized)")
    }
}
