//
//  CarauselView.swift
//  JID.COM
//
//  Created by Macbook on 05/10/22.
//

import SwiftUI

struct CarauselView: View {
    
    @GestureState private var dragState = DragStat.inactive
    @State var carauselLocation = 0
    @State var isAnimating = true
    
    var itemHeight: CGFloat
    var views: [AnyView]
    
    private func onDragEnded(drag: DragGesture.Value){
        print("drag ended")
        let dragThreshold:CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carauselLocation = carauselLocation - 1
        }else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold){
            carauselLocation = carauselLocation + 1
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    ForEach(0..<10){i in
                        VStack{
                            Spacer()
                            self.views[i]
                            .frame(width: 300, height: self.getHeight(i))
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                                .shadow(radius: 8)
                            .opacity(self.getOpacity(i))
                            .offset(x: self.getOffset(i))
                            .animation(Animation.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: 0)
                            Spacer()
                        }
                    }
                }
                .gesture(
                    
                    DragGesture()
                        .updating($dragState){ drag, state, transaction in
                            isAnimating = false
                            isAnimating.toggle()
                            state = .dargging(translation: drag.translation)
                        }
                    .onEnded(onDragEnded)
                )
                Text("\(relativeLoc() + 1) /\(views.count)")
                
                Spacer()
                
            }
        }
    }
    
    func getHeight(_ i:Int)->CGFloat{
        if i == relativeLoc(){
            return itemHeight
        }else{
            return itemHeight - 100
        }
    }
    
    func relativeLoc()->Int{
        return ((views.count * 10000) + carauselLocation) % views.count
    }

    func getOpacity(_ i: Int) -> Double{
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) - views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) - views.count == relativeLoc()
        {
            return 1
        }else{
            return 0
        }
    }
    
    func getOffset(_ i:Int)->CGFloat{
        if (i) == relativeLoc(){
            return self.dragState.translation.width
        }else if (i) == relativeLoc() + 1 || (relativeLoc() == views.count - i && i == 0){
            return self.dragState.translation.width + (300 + 20)
        }else if (i) == relativeLoc() - 1 || (relativeLoc() == 0 && (i) == views.count - 1){
            return self.dragState.translation.width - (300 + 20)
        }else if (i) == relativeLoc() + 2 || (relativeLoc() == views.count-i && i == 1) || (relativeLoc() == views.count-2 && i == 0){
            return self.dragState.translation.width + (2 * (300 + 20))
        }else if (i) == relativeLoc() - 2 || (relativeLoc() == i && i == views.count - 1) || (relativeLoc() == 0 && 1 == views.count - 2){
            return self.dragState.translation.width - (2 * (300 + 200))
        }else if (i) == relativeLoc() + 3 || (relativeLoc() == views.count - 1 && i == 2) || (relativeLoc() == views.count - 3 && i == 1 || (relativeLoc() == views.count - 3 && i == 0)){
            return self.dragState.translation.width + (3 * (300 + 20))
        }else if (i) == relativeLoc() - 3 || (relativeLoc() == 2 && i == views.count - 1) ||
                    (relativeLoc() == 1 && i == views.count-2) || (relativeLoc() == 0 && i == views.count-3){
            return self.dragState.translation.width - (3 * (300 - 20))
        }else{
            return 10000
        }
    }
    
}

enum DragStat{
    case inactive
    case dargging(translation: CGSize)
    
    var translation: CGSize {
        switch self{
        case .inactive:
            return .zero
        case .dargging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self{
        case .inactive:
            return false
        case .dargging:
            return true
        }
    }
    
}


