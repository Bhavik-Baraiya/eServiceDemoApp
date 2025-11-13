//
//  Untitled.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import Foundation

struct OrderModel: Identifiable, Hashable {
    var id = UUID()
    var orderId: Int
    var name: String
    var details: String
    var status: String
}
