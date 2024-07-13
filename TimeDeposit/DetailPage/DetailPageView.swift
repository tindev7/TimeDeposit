//
//  DetailPageView.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import SwiftUI

struct DetailPageView: View {
    @ObservedObject
    private var viewModel: DetailPageViewModel
    
    @State
    private var amountText: String = ""
    
    @State
    private var interestAmount: String = "Rp. 0"
    
    @State
    private var amountPillSelectionHeight: CGFloat = .zero
    
    @State private var isChecked: Bool = false
    
    init(viewModel: DetailPageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(spacing: .zero) {
                    createTitleName(productName: "Deposito")
                    createPercentageInterestLabel(percentage: String(viewModel.dependency.timeDepositDetail.rate))
                    createDescriptionLabel()
                }
                .background(.white)
                
                VStack(spacing: .zero) {
                    createEnterAmountLabel()
                    createAmountTextField()
                    createMinimumDepositLabel()
                    createAmountPillSelectionView()
                    createDeadlineLabel()
                    createDashedLine()
                    createInterestView(interestAmount: interestAmount)
                }
                .background(.white)
                
                VStack(spacing: .zero) {
                    createRolloverView(rolloverOption: "Pokok")
                }
                .background(.white)
            }
            .background(UIColor.systemGray5.suiColor)
            
            createContinueButtonWithTermConditionView()
        }
    }
}

// MARK: - View Private Functions
private extension DetailPageView {
    @ViewBuilder
    func createTitleName(productName: String) -> some View {
        Text(productName)
            .font(.title3.weight(.bold))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16.0)
            .padding(.top, 16.0)
    }
    
    @ViewBuilder
    func createPercentageInterestLabel(percentage: String) -> some View {
        HStack(spacing: 16.0) {
            HStack(spacing: 2.0) {
                Text("\(percentage)%")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(CommonColor.growthColor.suiColor)
                Text("p.a")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(CommonColor.growthColor.suiColor)
            }
            
            Text("1 bulan")
                .font(.callout)
                .foregroundStyle(CommonColor.titleColor.suiColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16.0)
        .padding(.top, 16.0)
    }
    
    @ViewBuilder
    func createDescriptionLabel() -> some View {
        Text("Suka bunga saat ini akan dihitung berdasarkan suku bunga dasar + suku bunga tambahan")
            .font(.caption)
            .foregroundStyle(CommonColor.subtitleColor.suiColor)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment:  .leading)
            .padding(.horizontal, 16.0)
            .padding(.top, 8.0)
            .padding(.bottom, 16.0)
    }
    
    @ViewBuilder
    func createEnterAmountLabel() -> some View {
        Text("Masukkan jumlah deposito")
            .font(.callout.weight(.bold))
            .foregroundStyle(.black)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment:  .leading)
            .padding(.horizontal, 16.0)
            .padding(.top, 16.0)
    }
    
    @ViewBuilder
    func createAmountTextField() -> some View {
        TextField("Enter amount", text: $amountText)
            .keyboardType(.numberPad)
            .keyboardType(.numberPad)
            .padding(.all, 8.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3.weight(.bold))
            .cornerRadius(6.0)
            .overlay(
                RoundedRectangle(cornerRadius: 6.0)
                    .stroke(UIColor.systemGray3.suiColor, lineWidth: 1)
            )
            .padding(.horizontal, 16.0)
            .padding(.top, 8.0)
            .onChange(of: amountText) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    amountText = filtered
                    
                    let timeDepositDetail: TimeDepositTableCellModel = viewModel.dependency.timeDepositDetail
                    
                    let rate: Float = Float(timeDepositDetail.rate) / 100
                    let amount: Float = (Float(filtered) ?? .zero) * rate
                    interestAmount = "Rp \(formatAmount(Int(amount)))"
                }
            
                if let filteredAmountOnly = Int(filtered) {
                    amountText = "Rp \(formatAmount(filteredAmountOnly))"
                }
                
                
            }
    }
    
    @ViewBuilder
    func createMinimumDepositLabel() -> some View {
        Text("Minimum Deposito Rp. 100.000")
            .font(.caption)
            .foregroundStyle(CommonColor.subtitleColor.suiColor)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment:  .leading)
            .padding(.horizontal, 16.0)
            .padding(.top, 8.0)
            .padding(.bottom, 16.0)
    }
    
    @ViewBuilder
    func createAmountPillSelectionView() -> some View {
        AmountPillView(
            amountSelected: $amountText, 
            amountPillList: ["1000000", "5000000", "10000000", "20000000", "50000000", "100000000", "500000000"], 
            heightPillView: $amountPillSelectionHeight
        )
        .frame(height: amountPillSelectionHeight)
        .padding(.horizontal, 16.0)
    }
    
    @ViewBuilder
    func createDeadlineLabel() -> some View {
        HStack(spacing: 2.0) {
            Text("Jatuh tempo:")
                .font(.caption)
                .foregroundStyle(CommonColor.subtitleColor.suiColor)
            
            Text("\(formatCurrentDate())")
                .font(.caption)
                .foregroundStyle(CommonColor.titleColor.suiColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8.0)
        .padding(.horizontal, 16.0)
    }
    
    @ViewBuilder
    func createDashedLine() -> some View {
        HorizontalDashedDividerView()
            .padding(.horizontal, 16.0)
            .padding(.top, 16.0)
            .padding(.bottom, 8.0)
    }
    
    @ViewBuilder
    func createInterestView(interestAmount: String) -> some View {
        HStack(spacing: .zero) {
            Text("Estimasi bunga")
                .font(.callout)
                .foregroundStyle(CommonColor.subtitleColor.suiColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(interestAmount)
                .font(.callout.weight(.bold))
                .foregroundStyle(CommonColor.titleColor.suiColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16.0)
        .padding(.bottom, 16.0)
    }
    
    @ViewBuilder
    func createRolloverView(rolloverOption: String) -> some View {
        HStack(alignment: .center, spacing: .zero) {
            Text("Opsi Rollover")
                .font(.callout)
                .foregroundStyle(CommonColor.subtitleColor.suiColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(rolloverOption)
                .font(.callout)
                .foregroundStyle(CommonColor.titleColor.suiColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Image("ic_chevron_right")
                .frame(width: 6.0, height: 6.0)
                .padding(.leading, 8.0)
        }
        .padding(.horizontal, 16.0)
        .padding(.vertical, 16.0)
    }
    
    @ViewBuilder
    func createContinueButtonWithTermConditionView() -> some View {
        VStack(spacing: 20.0) {
            Button(action: {
                // TODO: navigate to payment page
            }) {
                Text("Buka Sekarang")
                    .font(.system(size: 12).weight(.bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .background(
                        CommonColor.tintYellowColor.suiColor
                            .cornerRadius(99)
                            .frame(height: 40.0)
                    )
                    .padding(.top, 16.0)
                    .padding(.horizontal, 16.0)
            }
            
            HStack(spacing: 4.0) {
                Toggle(isOn: $isChecked) {
                    Text("")
                }
                .toggleStyle(CheckboxToggleStyle())
                
                Text("Saya telah membaca dan menyetujui")
                    .font(.caption)
                
                Text("Deposito Flexi TnC")
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .allowsHitTesting(true)
                    .onTapGesture {
                        viewModel.openTnc()
                    }
            }
        }
        .background(UIColor.systemGray5.suiColor)
    }
    
    func formatCurrentDate() -> String {
        guard let deadlineDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return "" } // Hardcoded 1 days from current date
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: deadlineDate)
    }
    
    func formatAmount(_ number: Int) -> String {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: {
                configuration.isOn.toggle()
                configuration.$isOn.wrappedValue = configuration.isOn
            }) {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
