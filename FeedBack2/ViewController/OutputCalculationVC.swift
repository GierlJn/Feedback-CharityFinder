

import UIKit

class OutputCalculationVC: UIViewController{
    
    var containerView = AlertContainerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    
    
    var donationTextFieldView = DonationTextFieldView()
    
    var dismissButten = FBButton()
    var actionButton: FBButton?
    var buttonStackView = UIStackView()
    
    var alertTitle: String = "Calculate your impact"
    var message: String?
    var dismissButtonTitle: String? = "Cancel"
    var actionButtonTite: String? = "Go"
    
    var actionClosure: (()->())?
    
    var actionContentView = UIView()
    
    let padding: CGFloat = 20

    var output: SimpleImpact!
    
    var enteredAmount: Float = 1.0
    
    let currency = PersistenceManager.retrieveCurrency()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(output: SimpleImpact) {
        self.init()
        self.output = output
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
    }
    
    private func configure(){
        configureContainerView()
        configureTitleLabel()
        configureTextField()
        configureActionButtons()
    }
    
    fileprivate func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view.snp.centerY)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(230)
            maker.width.equalTo(280)
        }
    }
    
    fileprivate func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = alertTitle
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView.snp.top).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(28)
        }
    }
    
    fileprivate func configureTextField(){
        containerView.addSubview(actionContentView)
        actionContentView.addSubview(donationTextFieldView)
        
        actionContentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(80)
        }
        
        donationTextFieldView.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            maker.centerY.equalTo(actionContentView.snp.centerY)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
        }
        donationTextFieldView.currencyLabel.text = currency.symbol
        
    }
    
    fileprivate func configureActionButtons() {
        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (maker) in
            maker.height.equalTo(44)
            maker.top.equalTo(actionContentView.snp.bottom).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(containerView.snp.bottom).offset(-padding)
        }
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        dismissButten.setTitle("Cancel", for: .normal)
        dismissButten.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(dismissButten)
        
        
        actionButton = FBButton()
        actionButton?.setTitle("Go", for: .normal)
        actionButton?.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(actionButton!)
    }
    
    fileprivate func configureExitButton(){
        containerView.addSubview(dismissButten)
        dismissButten.setTitle("Return", for: .normal)
        dismissButten.snp.makeConstraints { (maker) in
            maker.height.equalTo(44)
            maker.top.equalTo(actionContentView.snp.bottom).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(containerView.snp.bottom).offset(-padding)
        }
    }
    
    fileprivate func configureMessageLabel() {
        actionContentView.addSubview(messageLabel)
        actionContentView.layer.borderWidth = 0
        
        let value = output.costPerBeneficiary?.value ?? "1.0"
        var floatValue = Float(value) ?? 1.0
        floatValue = floatValue / currency.relativeValueToPound
        
        let impact = enteredAmount / floatValue
        
        let formatted = String(format: "%.0f", impact)
        
        messageLabel.text = "\(formatted) \(output.name?.formatOutputName(with: currency, wording: .plural) ?? "")"
        messageLabel.numberOfLines = 2
        messageLabel.pinToEdges(of: actionContentView)
    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc func actionButtonPressed(){
        guard let text = donationTextFieldView.textField.text else { return}
        guard !text.isEmpty else { return }
        enteredAmount = Float(String(text)) ?? 1.0
        showImpact()
    }
    
    private func showImpact(){
        titleLabel.text = "Your donation may fund"

        donationTextFieldView.removeFromSuperview()
        configureMessageLabel()
        
        dismissButten.removeFromSuperview()
        buttonStackView.removeFromSuperview()
        configureExitButton()
    }
    
}


extension OutputCalculationVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = donationTextFieldView.textField.text else { return false}
        guard !text.isEmpty else { return false}
        enteredAmount = Float(String(text)) ?? 1.0
        return true
    }
    
    
}
