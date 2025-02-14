//
//  myNavi.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI


struct myNavi: View {
    var body: some View {
        TabView {
            First()
                .tabItem{
                    Image(systemName: "1.square")
                }
            Second()
                .tabItem{
                    Image(systemName: "2.square")
                }
            Third()
                .tabItem{
                    Image(systemName: "3.square")
                }
        }
    }//:Body
}//:ContentView




struct First: View {
    
    
    var body: some View {
        NavigationView {
            HStack {
                Button(action: {
                    let appearance = UINavigationBarAppearance()
                    appearance.backgroundColor = UIColor(.red)
                    UINavigationBar.appearance().barTintColor = UIColor(.red)
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().compactAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }, label: {
                    Text("red")
                })//:Button
                Button(action: {
                    let appearance = UINavigationBarAppearance()
                    appearance.backgroundColor = UIColor(.blue)
                    UINavigationBar.appearance().barTintColor = UIColor(.blue)
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().compactAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }, label: {
                    Text("blue")
                })//:Button
            }
            
                .toolbar(content: {
                    ToolbarItem(placement: .principal, content: {
                        Text("Hello World 1")
                    })
                })
        }//:NavView
    }
    
}





struct Second: View {
    var body: some View {
            NavigationView {
                ScrollView {
                    Text("Don't use .appearance()!")
                }
                .navigationBarTitle("Try it!", displayMode: .inline)
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = .green
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                })
            }
        .navigationViewStyle(StackNavigationViewStyle())
        }
}








struct Third: View {
    @State var navigationBackground: UIColor = UIColor(.gray)
    
    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                
                Button(action: {
                    navigationBackground = UIColor(.purple)
                }, label: {
                    Text("purple")
                        .foregroundColor(.purple)
                })//:Button
                
                Spacer()
                
                Button(action: {
                    navigationBackground = UIColor(.black)
                }, label: {
                    Text("black")
                        .foregroundColor(.black)
                })//:Button
                
                Spacer()
            }
            
                .toolbar(content: {
                    ToolbarItem(placement: .principal, content: {
                        Text("Hello World 1")
                    })
                })
                
        }//:NavView
        .navigationBarColor(backgroundColor: navigationBackground, titleColor: UIColor(.red))
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    myNavi()
}
