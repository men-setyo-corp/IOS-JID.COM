//
//  BackgroungImg.swift
//  JID.COM
//
//  Created by Macbook on 15/09/22.
//

extension CctvPage {
    
    private var backgroundImage: some View {
        ZStack {
            Image(city.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
            LinearGradient(
                gradient: Gradient(colors: [Color(white: 0, opacity: 0.75), .clear]),
                startPoint: .topLeading,
                endPoint: UnitPoint(x: 0.4, y: 1.0)
            )
        }
    }
}
