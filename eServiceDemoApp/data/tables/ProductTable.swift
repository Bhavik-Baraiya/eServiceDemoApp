//
//  PrdouctTable.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 13/11/25.
//

import Foundation
import SQLite

class ProductTable {
    
    static let shared = ProductTable(db: DBManager.shared.getDb())
    
    private let productTable = Table("products")
    private let productId = Expression<Int>("productId")
    private let productName = Expression<String>("productName")
    private let productDetails = Expression<String>("productDetails")
    private let productQuantity = Expression<Int>("productQuantity")
    private let productPrice = Expression<Double>("productPrice")
    
    private var db: Connection
    
    init (db: Connection) {
        self.db = db
        try! db.run(
            productTable.create(ifNotExists: true) { table in
                table.column(productId, primaryKey: PrimaryKey.autoincrement)
                table.column(productName, defaultValue: "")
                table.column(productDetails, defaultValue: "")
                table.column(productQuantity, defaultValue: 0)
                table.column(productPrice, defaultValue: 0)
            }
        )
    }
    
    func insert(product : Product) -> Int64{
        do {
            let insert = productTable.insert(
                self.productName <- product.name,
                self.productDetails <- product.details,
                self.productQuantity <- product.quantity,
                self.productPrice <- product.price
            )
            
            let productId = try db.run(insert)
            return productId
        } catch {
            print("error while inserting records:\(error)")
        }
        return 0
    }
    
    func getProductList() -> [Product] {
        var productList = [Product]()
        
        for item in try! db.prepare(productTable) {
            productList.append(Product(
                id: item[productId],
                name: item[productName],
                details: item[productDetails],
                quantity: item[productQuantity],
                price: item[productPrice]))
        }
        return productList
    }
    
    func update(product: Product) -> Bool {
        do {
            
            guard let productid = product.id else { return false }
            
            let existingProduct = productTable.filter(productId == productid)
            let update = existingProduct.update(
                productQuantity <- product.quantity+1,
            )
            
            if try db.run(update) > 0 {
                print("Product updated successfully.")
                return true
            } else {
                print("Product not found.")
            }
        } catch {
            print("Error while updating Product: \(error)")
        }
        return false
    }
}
