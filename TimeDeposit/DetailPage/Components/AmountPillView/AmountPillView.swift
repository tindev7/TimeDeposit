//
//  AmountPillView.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import SwiftUI

public struct AmountPillView: View {
    @Binding
    var totalHeight: CGFloat
    
    @Binding
    var amountSelected: String
    
    var amountPillList: [String] = []
    
    init(
        amountSelected: Binding<String>,
        amountPillList: [String],
        heightPillView: Binding<CGFloat>
    ) {
        _amountSelected = amountSelected
        self.amountPillList = amountPillList
        
        _totalHeight = heightPillView
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                createPrideBadgeContent(in: geometry)
            }
        }
        .frame(minHeight: 28.0, maxHeight: totalHeight)
    }
}

// MARK: - View Builder Private Functions
private extension AmountPillView {
    @ViewBuilder
    func createPrideBadgeContent(in geo: GeometryProxy) -> some View {
        var width: CGFloat = .zero
        var height: CGFloat = .zero

        ZStack(alignment: .topLeading) {
            ForEach(amountPillList.indices, id: \.self) { index in
                createAmountPillView(amountString: amountPillList[index])
                    .padding([.trailing, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geo.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        
                        let result: CGFloat = width
                        if index == amountPillList.count - 1 {
                            width = 0 //last item
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result: CGFloat = height
                        if index == amountPillList.count - 1 {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(GeometryReader { geo in
            Color.clear
                .onAppear {
                    let rect: CGRect = geo.frame(in: .local)
                    totalHeight = rect.size.height
                }
        })
    }
    
    @ViewBuilder
    func createAmountPillView(amountString: String) -> some View {
        HStack(spacing: 4.0) {
            Text(formatAmount(Int(amountString) ?? 0))
                .font(.caption)
                .foregroundStyle(CommonColor.titleColor.suiColor)
                .lineLimit(nil)
        }
        .padding(.all, 4.0)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
        .overlay(
            RoundedRectangle(cornerRadius: 6.0)
                .stroke(UIColor.systemGray3.suiColor, lineWidth: 1)
        )
        .allowsHitTesting(true)
        .onTapGesture {
            amountSelected = amountString
        }
    }
    
    func formatAmount(_ number: Int) -> String {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "Rp \(formatter.string(from: NSNumber(value: number)) ?? "")"
    }
}
