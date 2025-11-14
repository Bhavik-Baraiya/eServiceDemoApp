//
//  OrderListView.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import SwiftUI

struct OrderListView: View {
    
    let orderTable = OrderTable.shared
    @State var orders: [OrderData]
    
    var body: some View {
        NavigationStack {
            if(orders.count > 0) {
                List {
                    ForEach (self.orders, id: \.self) { order in
                        NavigationLink(destination: OrderView(order:order)) {
                            Text("\(String(describing: order.id))       \(order.name)")
                        }
                        .font(.headline.italic())
                        .padding([.top,.bottom],10)
                        .padding([.leading,.trailing], 40)
                        .listRowSpacing(0)
                        .listRowBackground(Color.white)
                    }
                    .onDelete(perform:removeOrder)
                    .listRowSpacing(0)
                    .listRowInsets(EdgeInsets())
                    
                }
                .padding(0)
                .background(Color.white.opacity(0.3))
            } else {
                ContentUnavailableView("No orders found", image: "")
            }
        }
        .navigationTitle("Orders")
        .toolbarTitleDisplayMode(.large)
        .onAppear(perform: {
            getOrders()
        })
    }
    
    func getOrders() {
        Task(priority: .background) {
            self.orders = orderTable.getAllOrders()
            if orders.count > 0 {
                print("Order list available\(orders)")
            }
        }
    }
    
    func removeOrder(at offsets: IndexSet) {
        for index in offsets {
            guard let orderIdToDelete = orders[index].id else { return }
            let isDeleted = OrderTable.shared.delete(orderId: orderIdToDelete)
            if(isDeleted) {
                debugPrint("Order updated successfully")
            }
        }
        orders.remove(atOffsets: offsets)
    }
}

#Preview {
    OrderListView(orders: [OrderData(id: 0, name: "", details: "", status: "", date: .now, productId: 0, productQuantity: 0)])
}
