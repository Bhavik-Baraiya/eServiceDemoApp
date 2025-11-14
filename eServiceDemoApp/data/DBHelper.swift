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
        print("Transaction begin")
        try db.run("BEGIN IMMEDIATE TRANSACTION")
        
        // Insert order records
        let insertQuery = orderTable.insert(
            self.orderName <- order.name,
            self.orderDetails <- order.details,
            self.orderStatus <- order.status,
            self.orderDate <- order.date,
            self.productId <- order.productId,
            self.productQuantity <- order.productQuantity
        )
        print("Inserting product record")
        try db.run(insertQuery)
        
        //Update product records
        var quantity = 0
        for item in try! db.prepare(productTable) {
            if(item[productId] == order.productId) {
                quantity = item[productQuantity]
            }
        }
        let qun = quantity - order.productQuantity
        let product = productTable.filter(order.productId == productId)
        let update = product.update(
            productQuantity <- qun
        )
        
        print("Updating product record")
        if try db.run(update) > 0 {
            print("Transaction committed")
            try db.run("COMMIT")
            print("Order created successfully")
        } else {
            print("something went wrong")
            print("Transaction rollbacked")
            try db.run("ROLLBACK")
        }
    }
}
