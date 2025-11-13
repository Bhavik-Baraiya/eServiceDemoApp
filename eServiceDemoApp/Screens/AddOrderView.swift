//
//  AddOrderView.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import SwiftUI

struct AddOrderView: View {
    
    @State var orderName: String = ""
    @State var orderDetails: String = ""
    @State var orderStatus: String = "To do"
    let statusList = ["To do","In progress","Completed","Hold","Cancelled","Rejected"]
    
    @Environment(\.dismiss) var popCurrentView
    
    var body: some View {
        VStack {
            NavigationStack {
                Form {
                    orderInputView(
                        headLabelText: "Order Name",
                        placeHolder: "Enter order name",
                        textData: $orderName
                    )
                    
                    orderInputView(
                        headLabelText: "Order Details",
                        placeHolder: "Enter order details",
                        textData: $orderDetails
                    )
                    VStack(alignment: .leading,spacing: 20.0, content: {
                        
                        Picker("Order Status", selection: self.$orderStatus, content: {
                            ForEach(statusList, id: \.self) { status in
                                Text(status)
                            }
                        })
                        .font(.headline)
                        Text("\("Selected order status:") \(self.$orderStatus.wrappedValue)")
                            .font(.subheadline)
                    })
                    
                    bottomActionButtons()
                }
            }
            .navigationTitle("Add Order")
        }
    }
    
    @ViewBuilder
    private func orderInputView(headLabelText: String, placeHolder: String, textData: Binding<String>) -> some View {
        
        VStack(alignment: .leading,spacing: 20.0, content: {
            Text(headLabelText)
                .font(.headline)
            
            TextField(
                placeHolder,
                text: textData,
                axis: .vertical
            )
            .tint(.accentColor)
        })
    }
    
    @ViewBuilder
    private func bottomActionButtons() -> some View {
        
        HStack(alignment:.center) {
            Spacer()
            Button(action: {
                
            }) {
                Text("Add")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10.0)
                            .foregroundColor(Color.primaryThemeColor)
                    })
            }
            .onTapGesture(perform: {
                debugPrint("Add order tapped")
                addOrderAction()
                popCurrentView()
            })
            
            Spacer().frame(width:40)
            
            Button(action: {
                
            }) {
                Text("Cancel")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10.0)
                            .foregroundColor(Color.secondaryThemeColor)
                    })
            }
            .onTapGesture(perform: {
                debugPrint("Cancel tapped")
                popCurrentView()
            })
            Spacer()
        }
    }
    
    private func addOrderAction() {
        
        let orderTable = OrderTable.shared
        
        Task(priority: .background) {
            let orderId = orderTable.insert(order: OrderModel(orderId: 0, name: self.orderName, details: self.orderDetails, status: self.orderStatus))
            if orderId > 0 {
                print("Order inserted")
            }
        }
    }
}

#Preview {
    AddOrderView()
}
