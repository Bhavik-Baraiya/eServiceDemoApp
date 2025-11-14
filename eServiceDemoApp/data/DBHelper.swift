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
    
    func createOrder(order: OrderData) throws {
        print("createOrder called")
        do {
            print("Transaction begin")
            try db.run("BEGIN IMMEDIATE TRANSACTION")
            
            // Insert order
            let insertQuery = orderTable.insert(
                self.orderName <- order.name,
                self.orderDetails <- order.details,
                self.orderStatus <- order.status,
                self.orderDate <- order.date,
                self.productId <- order.productId,
                self.productQuantity <- order.productQuantity
            )
            
            print("Inserting order record")
            try db.run(insertQuery)
            
            // Fetch product quantity safely
            guard let productRow = try db.pluck(productTable.filter(productId == order.productId)) else {
                throw NSError(domain: "DBError", code: 404, userInfo: [NSLocalizedDescriptionKey : "Product not found"])
            }
            
            let currentQty = productRow[productQuantity]
            let newQty = currentQty - order.productQuantity
            
            if newQty < 0 {
                throw NSError(domain: "DBError", code: 400, userInfo: [NSLocalizedDescriptionKey : "Insufficient stock quantity"])
            }
            
            // Update product
            print("Updating product record")
            
            let update = productTable.filter(productId == order.productId).update(
                productQuantity <- newQty
            )
            
            let updated = try db.run(update)
            
            if updated == 0 {
                throw NSError(domain: "DBError", code: 500, userInfo: [NSLocalizedDescriptionKey : "Product update failed"])
            }
            
            print("Transaction committed")
            try db.run("COMMIT")
            print("Order created successfully")
            
        } catch {
            print("Error occurred: \(error.localizedDescription)")
            print("Rolling back transaction…")
            
            do {
                try db.run("ROLLBACK")
            } catch let rollbackError {
                print("Rollback failed: \(rollbackError.localizedDescription)")
            }
            
            throw error   // Pass error back to caller
        }
    }

}
