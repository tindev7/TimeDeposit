//
//  DepositoCardTableViewCell.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import UIKit

protocol DepositoCardTableViewCellDelegate: AnyObject {
    func openButtonTapped(item: TimeDepositTableCellModel)
}
 
final class DepositoCardTableViewCell: UITableViewCell {

    private lazy var containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CommonColor.titleColor
        label.numberOfLines = 1
//        label.setContentHuggingPriority(UILayoutPriority(900), for: .vertical)
//        label.setContentCompressionResistancePriority(UILayoutPriority(900), for: .vertical)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
//        label.setContentHuggingPriority(UILayoutPriority(850), for: .vertical)
//        label.setContentCompressionResistancePriority(UILayoutPriority(850), for: .vertical)
        
        return label
    }()
    
    private lazy var popularContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        view.isHidden = true
        
        return view
    }()
    
    private lazy var popularLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.text = "Popular"
        
        return label
    }()
    
    private lazy var percentageInterestContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var percentageInterestLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CommonColor.growthColor
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var interestLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.text = "Bunga"
        
        return label
    }()
    
    private lazy var amountContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var amountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CommonColor.titleColor
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var startFromLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.text = "Mulai dari"
        
        return label
    }()
    
    private lazy var openButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.setTitleColor(CommonColor.titleColor, for: .normal)
        button.setTitle("Buka", for: .normal)
        button.addTarget(self, action: #selector(openButtonDidTapped), for: .touchUpInside)
        button.backgroundColor = CommonColor.tintYellowColor
        button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
        
        return button
    }()
    
    private lazy var dividerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    weak var delegate: DepositoCardTableViewCellDelegate?
    
    private var timeDepositModel: TimeDepositTableCellModel?
    
    @objc
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        popularContainerView.layer.cornerRadius = popularContainerView.frame.height / 2.0
        openButton.layer.cornerRadius = openButton.frame.height / 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        popularContainerView.layer.cornerRadius = popularContainerView.frame.height / 2.0
        openButton.layer.cornerRadius = openButton.frame.height / 2.0
    }
    
    func configureCell(timeDepositModel: TimeDepositTableCellModel, isLastCell: Bool) {
        self.timeDepositModel = timeDepositModel
        
        titleLabel.text = timeDepositModel.productName
        descriptionLabel.text = timeDepositModel.marketingPoints.joined(separator: "; ")
        
        popularContainerView.isHidden = !timeDepositModel.isPopular
        
        percentageInterestLabel.text = "\(String(timeDepositModel.rate))% p.a"
        
        amountLabel.text = timeDepositModel.startingAmount.formattedAmount()
        
        dividerView.isHidden = isLastCell
    }
}

// MARK: - Private Functions
private extension DepositoCardTableViewCell {
    func setupViews() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
       ])
        
        containerView.addSubviews([titleLabel, descriptionLabel, popularContainerView, percentageInterestContainerView, amountContainerView, openButton, dividerView])
        popularContainerView.addSubview(popularLabel)
        
        percentageInterestContainerView.addSubviews([percentageInterestLabel, interestLabel])
        
        amountContainerView.addSubviews([amountLabel, startFromLabel])
        
        // Setup subviews of percentageInterestContainerView
        NSLayoutConstraint.activate([
            percentageInterestLabel.topAnchor.constraint(equalTo: percentageInterestContainerView.topAnchor),
            percentageInterestLabel.leadingAnchor.constraint(equalTo: percentageInterestContainerView.leadingAnchor),
            percentageInterestLabel.trailingAnchor.constraint(equalTo: percentageInterestContainerView.trailingAnchor),
            
            interestLabel.topAnchor.constraint(equalTo: percentageInterestLabel.bottomAnchor, constant: 4.0),
            interestLabel.leadingAnchor.constraint(equalTo: percentageInterestContainerView.leadingAnchor),
            interestLabel.trailingAnchor.constraint(equalTo: percentageInterestContainerView.trailingAnchor),
            interestLabel.bottomAnchor.constraint(equalTo: percentageInterestContainerView.bottomAnchor),
        ])
        
        // Setup subviews of amountContainerView
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: amountContainerView.topAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: amountContainerView.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: amountContainerView.trailingAnchor),
            
            startFromLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4.0),
            startFromLabel.leadingAnchor.constraint(equalTo: amountContainerView.leadingAnchor),
            startFromLabel.trailingAnchor.constraint(equalTo: amountContainerView.trailingAnchor),
            startFromLabel.bottomAnchor.constraint(equalTo: amountContainerView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            popularLabel.topAnchor.constraint(equalTo: popularContainerView.topAnchor, constant: 4.0),
            popularLabel.leadingAnchor.constraint(equalTo: popularContainerView.leadingAnchor, constant: 4.0),
            popularLabel.trailingAnchor.constraint(equalTo: popularContainerView.trailingAnchor, constant: -4.0),
            popularLabel.bottomAnchor.constraint(equalTo: popularContainerView.bottomAnchor, constant: -4.0),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            
            popularContainerView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            popularContainerView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            
            percentageInterestContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12.0),
            percentageInterestContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            percentageInterestContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3 - 32.0),
            
            amountContainerView.centerYAnchor.constraint(equalTo: percentageInterestContainerView.centerYAnchor),
            amountContainerView.leadingAnchor.constraint(equalTo: percentageInterestContainerView.trailingAnchor),
            amountContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3 - 32.0),
            
            openButton.centerYAnchor.constraint(equalTo: percentageInterestContainerView.centerYAnchor),
            openButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            
            dividerView.topAnchor.constraint(equalTo: amountContainerView.bottomAnchor, constant: 8.0),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24.0),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24.0),
            dividerView.heightAnchor.constraint(equalToConstant: 1.0),
            
            // Hide on last cell
            dividerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .zero)
       ])
    }
    
    @objc
    func openButtonDidTapped() {
        guard let item: TimeDepositTableCellModel = timeDepositModel else { return }
        delegate?.openButtonTapped(item: item)
    }
}
