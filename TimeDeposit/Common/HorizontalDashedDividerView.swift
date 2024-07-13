//
//  HorizontalDashedDividerView.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import SwiftUI

public struct HorizontalDashedDividerView: View {
    public var body: some View {
        HorizontalLine()
            .stroke(UIColor.systemGray4.suiColor, style: StrokeStyle(lineWidth: 1, dash: [4.4]))
            .frame(height: 1)
    }
}

fileprivate struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path: Path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        // horizontal line
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

#Preview {
    HorizontalDashedDividerView()
}
