//
//  DBHelper.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 14/11/25.
//

import Foundation
import SQLite

class DBHelper {
    static let shared = DBHelper(db: DBManager.shared.getDb())
    
    private let orderTable = Table("orders")
    private let orderId = Expression<Int>("orderId")
    private let orderName = Expression<String>("OrderName")
    private let orderDetails = Expression<String>("orderDetails")
    private let orderStatus = Expression<String>("orderStatus")
    private let orderDate = Expression<Date>("orderDate")
    
    private let productTable = Table("products")
    private let productId = Expression<Int>("productId")
    private let productName = Expression<String>("productName")
    private let productDetails = Expression<String>("productDetails")
    private let productQuantity = Expression<Int>("productQuantity")
    private let productPrice = Expression<Int>("productPrice")
    
    private var db: Connection
    
    init (db: Connection) {
        self.db = db
    }
    
    func createOrder(order : OrderData)  throws {
        print("createOrder called")
            try db.run("BEGIN IMMEDIATE TRANSACTION")
            print("Begin transaction")
            // Insert order records
            let insertQuery = orderTable.insert(
                self.orderName <- order.name,
                self.orderDetails <- order.details,
                self.orderStatus <- order.status,
                self.orderDate <- order.date,
                self.productId <- order.productId,
                self.productQuantity <- order.productQuantity
            )
            try db.run(insertQuery)
            
            //Update product records
            let product = productTable.filter(order.productId == productId)
            let quantity = product[productQuantity]
            let update = product.update(
                productQuantity <- quantity - order.productQuantity
            )
            
            if try db.run(update) > 0 {
                try db.run("COMMIT")
                print("Order created successfully. COMMIT")
            } else {
                try db.run("ROLLBACK")
                print("something went wrong ROLLBACK")
            }
        }
}
