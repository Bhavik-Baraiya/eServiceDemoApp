//
//  OrderView.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 13/11/25.
//

import SwiftUI

struct OrderView: View {
    
    @State var orderName: String = ""
    @State var orderDetails: String = ""
    @State var orderStatus: String = "To do"
    let statusList = ["To do","In progress","Completed","Hold","Cancelled","Rejected"]
    var order: OrderData
    @Environment(\.dismiss) var popCurrentView
    
    var body: some View {
        VStack {
            NavigationStack {
                Form {
                    orderInputView(
                        headLabelText: "Order Name",
                        placeHolder: order.name,
                        textData: $orderName
                    )
                    
                    orderInputView(
                        headLabelText: "Order Details",
                        placeHolder: order.details,
                        textData: $orderDetails
                    )
                    VStack(alignment: .leading,spacing: 20.0, content: {
                        
                        Picker("Order Status", selection: self.$orderStatus, content: {
                            ForEach(statusList, id: \.self) { status in
                                Text(status)
                            }
                        })
                        .font(.headline)
                        Text("\("Selected order status:") \(order.status)")
                            .font(.subheadline)
                    })
                    
                    bottomActionButtons()
                }
            }
            .navigationTitle("Order details")
            .toolbarTitleDisplayMode(.inline)
            .onAppear(perform: {
                $orderName.wrappedValue = order.name
                $orderDetails.wrappedValue = order.details
                $orderStatus.wrappedValue = order.status
            })
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
                Text("Update")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10.0)
                            .foregroundColor(Color.primaryThemeColor)
                    })
            }
            .onTapGesture(perform: {
                debugPrint("Update order tapped")
                updateOrder()
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
    
    func updateOrder() {
        let updatedOrder = OrderData(id: 0, name: $orderName.wrappedValue, details: $orderDetails.wrappedValue, status: $orderStatus.wrappedValue, date: .now, productId: 0, productQuantity: 0)
        let isUpdated = OrderTable.shared.update(order: updatedOrder)
        if(isUpdated) {
            debugPrint("Order updated successfully")
        }
    }
}

#Preview {
    OrderView(order:OrderData(id: 0, name: "", details: "", status: "", date: .now, productId: 0, productQuantity: 0))
}
