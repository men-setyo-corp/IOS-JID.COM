//
//  Layerset.swift
//  JID.COM
//
//  Created by Macbook on 08/10/22.
//

import SwiftUI

struct Layerset: View {
    
    @Binding var isShowModal : Bool
    @State private var isDragging = false
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    @State private var curHeigth: CGFloat = 400
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    var dragPrecent: Double{
        let res = Double((curHeigth - minHeight) / (maxHeight - minHeight))
        return max(0, min(1, res))
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            if isShowModal {
                Color.black
                    .opacity(startOpacity + (endOpacity - startOpacity) * dragPrecent)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowModal = false
                    }
                VStack{
                    ZStack{
                        Capsule()
                            .frame(width: 40, height: 6)
                            .background(Color(UIColor(hexString: "#E8E8E4")))
                    }
                    .frame(height:40)
                    .frame(maxWidth:.infinity)
                    .background(Color.white.opacity(0.00001))
                    .gesture(dragGesture)
                    
                    LayerList()
                    
                    VStack{
                        Button{
                            isShowModal.toggle()
                        }label:{
                            Text("TERAPKAN")
                                .padding(15)
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(hexString: "#FFFFFF")))
                                
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor(hexString: "#390099")))
                        .cornerRadius(50)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
                .frame(height: curHeigth)
                .frame(maxWidth: .infinity)
                .background{
                    RoundedCornersShape(corners: [.topLeft, .topRight], radius: 10)
                        .fill(Color.white)
                }
                .onDisappear{
                    curHeigth = minHeight
                }
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(Animation.easeOut, value: isShowModal)
       
        
    }
    
    
    @State private var prevDragTranslation = CGSize.zero
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                withAnimation(Animation.easeOut){
                    if !isDragging {
                        isDragging = true
                    }
                    let dragAMount = val.translation.height - prevDragTranslation.height
                    if curHeigth > maxHeight || curHeigth < minHeight {
                        curHeigth -= dragAMount / 6
                    }else{
                        curHeigth -= dragAMount
                    }
                    prevDragTranslation = val.translation
                }
            }
            .onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                if curHeigth > maxHeight {
                    curHeigth = maxHeight
                }else if curHeigth < minHeight {
                    curHeigth = minHeight
                }
            }
    }
    
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct Layerset_Previews: PreviewProvider {
    static var previews: some View {
        Layerset(isShowModal: .constant(true))
    }
}
