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
    private let orderName = Expression<String>("OrderName")
    private let orderDetails = Expression<String>("orderDetails")
    private let orderStatus = Expression<String>("orderStatus")
    
    private var db: Connection
    
    init (db: Connection) {
        self.db = db
        try! db.run(
            orderTable.create(ifNotExists: true) { table in
                table.column(orderId, primaryKey: PrimaryKey.autoincrement)
                table.column(orderName, defaultValue: "")
                table.column(orderDetails, defaultValue: "")
                table.column(orderStatus, defaultValue: "")
            }
        )
    }
    
    func insert(order : OrderModel) -> Int64{
        do {
            let insert = orderTable.insert(
                self.orderName <- order.name,
                self.orderDetails <- order.details,
                self.orderStatus <- order.status
            )
            
            let orderId = try db.run(insert)
            return orderId
        } catch {
            print("error while inserting records:\(error)")
        }
        return 0
    }
    
    func getAllOrders() -> [OrderModel] {
        
        var orderList = [OrderModel]()
        
        for item in try! db.prepare(orderTable) {
            orderList.append(OrderModel(
                orderId: item[orderId],
                name: item[orderName],
                details: item[orderDetails],
                status: item[orderStatus],
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
    
    func update(order: OrderModel) -> Bool {
        do {
            let existingOrder = orderTable.filter(orderId == order.orderId)
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
