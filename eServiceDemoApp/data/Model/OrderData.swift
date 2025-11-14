//
//  Untitled.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import Foundation

struct OrderData:Hashable {
    var id: Int?
    var name: String
    var details: String
    var status: String
    var date: Date
    var productId: Int
    var productQuantity: Int
}
