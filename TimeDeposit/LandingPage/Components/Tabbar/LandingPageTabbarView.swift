//
//  LandingPageTabbarView.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 08/07/24.
//

import SwiftUI

struct LandingPageTabbarView: View {
    @ObservedObject
    private var viewModel: LandingPageTabbarViewModel
    
    init(viewModel: LandingPageTabbarViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if !viewModel.productGroupNames.isEmpty {
            HStack(spacing: 8.0) {
                ForEach(0..<viewModel.productGroupNames.count, id:\.self) { index in
                    createTabbarView(index: index, tabName: viewModel.productGroupNames[index])
                }
            }
        }
    }
}

// MARK: - View Builder
private extension LandingPageTabbarView {
    
    @ViewBuilder
    func createTabbarView(index: Int, tabName: String) -> some View {
        let isSelected: Bool = viewModel.selectedIndex == index
        HStack(alignment: .center) {
            Text(tabName)
                .font(isSelected ? .subheadline.weight(.bold) : .subheadline)
                .lineLimit(1)
                .foregroundColor(isSelected ? CommonColor.titleColor.suiColor : CommonColor.subtitleColor.suiColor)
                .padding(.bottom, 16.0)
        }
        .overlay(alignment: .bottom) {
            GeometryReader { proxy in
                if index == viewModel.selectedIndex {
                    RoundedRectangle(cornerRadius: 2)
                        
                        .fill(CommonColor.tintYellowColor.suiColor)
                        .frame(width: 28.0, height: 3.0, alignment: .center)
                        .offset(x: proxy.size.width / 2 - 14, y: 26)
                        
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onTapGesture {
            viewModel.tabbarDidTapped(index: index)
        }
    }
}
