

import UIKit

class OutputCalculationVC: UIViewController{
    
    var containerView = AlertContainerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    var textField = FBTextField()
    
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
        
        //configureMessageLabel()
        configureTextField()
        configureActionButtons()
    }
    
    fileprivate func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view.snp.centerY)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(180)
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
        
        dismissButten.setTitle(dismissButtonTitle, for: .normal)
        dismissButten.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(dismissButten)
        
        actionButton = FBButton()
        actionButton?.setTitle(actionButtonTite, for: .normal)
        actionButton?.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(actionButton!)
    }
    
    fileprivate func configureExitButton(){
        containerView.addSubview(dismissButten)
        dismissButten.setTitle("Go", for: .normal)
        dismissButten.snp.makeConstraints { (maker) in
            maker.height.equalTo(44)
            maker.top.equalTo(actionContentView.snp.bottom).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(containerView.snp.bottom).offset(-padding)
        }
    }
    
    fileprivate func configureTextField(){
        containerView.addSubview(actionContentView)
        actionContentView.addSubview(textField)
        
        actionContentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(40)
        }
        
        textField.placeholder = "Enter donation sum"
        textField.keyboardType = .numberPad
        textField.pinToEdges(of: actionContentView)
    }
    
    fileprivate func configureMessageLabel() {
        actionContentView.addSubview(messageLabel)

        
        let value = output.costPerBeneficiary?.value ?? "1.0"
        var floatValue = Float(value) ?? 1.0
        floatValue = floatValue / currency.relativeValueToPound
        
        
        
        let impact = enteredAmount * floatValue
        
        let formatted = String(format: "%.2f", impact)
        
        messageLabel.text = "\(formatted) \(output.name ?? "")"
        messageLabel.numberOfLines = 2
        messageLabel.pinToEdges(of: actionContentView)
    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc func actionButtonPressed(){
        guard let text = textField.text else { return}
        titleLabel.text = "This sum equals"
        
        enteredAmount = Float(String(text)) ?? 1.0
        
        textField.removeFromSuperview()
        configureMessageLabel()
        
        dismissButten.removeFromSuperview()
        buttonStackView.removeFromSuperview()
        configureExitButton()
    }
    
}


extension OutputCalculationVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false}
        enteredAmount = Float(String(text)) ?? 1.0
        return true
    }
    
    
}
