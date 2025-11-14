//
//  Order.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import Foundation
import SQLite

class OrderTable {
    
    static let shared = OrderTable(db: DBManager.shared.getDb())
    
    private let orderTable = Table("orders")
    private let orderId = Expression<Int>("orderId")
    private let orderName = Expression<String>("orderName")
    private let orderDetails = Expression<String>("orderDetails")
    private let orderStatus = Expression<String>("orderStatus")
    private let orderDate = Expression<Date>("orderDate")
    private let productId = Expression<Int>("productId")
    private let productQuantity = Expression<Int>("productQuantity")
    
    private var db: Connection
    
    init (db: Connection) {
        self.db = db
        try! db.run(
            orderTable.create(ifNotExists: true) { table in
                table.column(orderId, primaryKey: PrimaryKey.autoincrement)
                table.column(orderName, defaultValue: "")
                table.column(orderDetails, defaultValue: "")
                table.column(orderStatus, defaultValue: "")
                table.column(orderDate, defaultValue: Date())
                table.column(productId, defaultValue: -1)
                table.column(productQuantity, defaultValue: -1)
            }
        )
    }
    
    func insert(order : OrderData) -> Int64{
        do {
            let insert = orderTable.insert(
                self.orderName <- order.name,
                self.orderDetails <- order.details,
                self.orderStatus <- order.status,
                self.orderDate <- order.date,
                self.productId <- order.productId,
                self.productQuantity <- order.productQuantity
            )
            
            let orderId = try db.run(insert)
            return orderId
        } catch {
            print("error while inserting records:\(error)")
        }
        return 0
    }
    
    func getAllOrders() -> [OrderData] {
        
        var orderList = [OrderData]()
        
        for item in try! db.prepare(orderTable) {
            orderList.append(OrderData(
                id: item[orderId],
                name: item[orderName],
                details: item[orderDetails],
                status: item[orderStatus],
                date: item[orderDate],
                productId: item[productId],
                productQuantity: item[productQuantity]
            ))
        }
        return orderList
    }
    
    func delete(orderId id: Int) -> Bool {
        do {
            let order = orderTable.filter(orderId == id)
            if try db.run(order.delete()) > 0 {
                print("Order deleted successfully.")
                return true
            } else {
                print("Order not found.")
            }
        } catch {
            print("Error while deleting order: \(error)")
        }
        return false
    }
    
    func update(order: OrderData) -> Bool {
        do {
            
            guard let orderid = order.id else { return false }
            
            let existingOrder = orderTable.filter(orderId == orderid)
            let update = existingOrder.update(
                orderName <- order.name,
                orderDetails <- order.details,
                orderStatus <- order.status
            )
            
            if try db.run(update) > 0 {
                print("Order updated successfully.")
                return true
            } else {
                print("Order not found.")
            }
        } catch {
            print("Error while updating order: \(error)")
        }
        return false
    }
}
