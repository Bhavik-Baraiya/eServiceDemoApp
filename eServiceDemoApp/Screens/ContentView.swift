//
//  ContentView.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(Color.primaryThemeColor)
                Spacer()
                
                NavigationLink(destination: AddOrderView()) {
                    Text("Add Order")
                        .frame(width:190)
                        .font(.headline)
                        .padding()
                        .background(Color.primaryThemeColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: OrderListView(orders: [OrderModel(orderId: 0, name: "", details: "", status: "")])) {
                    Text("View Orders")
                        .frame(width:190)
                        .font(.headline)
                        .padding()
                        .background(Color.primaryThemeColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                Text("Welcome to eService")
                    .foregroundColor(Color.secondaryThemeColor)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Color.secondaryThemeColor)
        }
    }
}

#Preview {
    ContentView()
}
