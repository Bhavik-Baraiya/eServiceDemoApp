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
                
                NavigationLink(destination: OrderListView(orders: [OrderData(id: 0, name: "", details: "", status: "", date: .now, productId: 0, productQuantity: 0)])) {
                    Text("View Orders")
                        .frame(width:190)
                        .font(.headline)
                        .padding()
                        .background(Color.primaryThemeColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action:{
                    self.loadProducts()
                }
                ){
                    Text("Load products")
                }
                
                Button(action:{
                    self.performDBLock()
                }
                ){
                    Text("Perform DBLOCK")
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
    
    func loadProducts() {
        let productTable = ProductTable.shared
        for product in products {
            let productId = productTable.insert(product: product)
            print("Inserted product with ID: \(productId)")
        }
    }
    
    func performDBLock() {
        let productTable = ProductTable.shared
        let productTable1 = ProductTable.shared
        
        DispatchQueue.global(qos: .background).async(execute: {
            
            print("Inserting record on product table")
            for product in products {
                let productId = productTable.insert(product: product)
                print("Inserted product with ID: \(productId)")
            }
            
        })
        
        DispatchQueue.global(qos: .background).async(execute: {
            
            print("Updating record on product table")
            let productList = productTable1.getProductList()
            for product in productList {
                let isUpdated = productTable1.update(product: product)
                print("Updated \(isUpdated) product with ID:\(String(describing: product.id))")
            }
        })
    }
}

#Preview {
    ContentView()
}
