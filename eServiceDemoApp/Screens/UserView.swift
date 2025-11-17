//
//  UserView.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 17/11/25.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        VStack(alignment:.leading,spacing: 20, content: {
            Circle()
                .foregroundStyle(.tertiary)
                .frame(width: 150, height: 150)
            
            Text("User name")
                .font(.headline)
            
            Text("Bio")
                .font(.subheadline)

        })
    }
}

#Preview {
    UserView()
}
