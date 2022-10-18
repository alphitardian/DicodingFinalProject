//
//  ContentView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "house.fill")
                }
            
            FavoriteView()
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .onAppear {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().backgroundColor = UIColor.clear
            UINavigationBar.appearance().barTintColor = UIColor(named: "MainColor")
            UITabBar.appearance().barTintColor = UIColor(named: "MainColor")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
