

import UIKit

protocol OutputCalculationVCDelegate {
    func currencyButtonPressed()
}

class OutputCalculationVC: UIViewController{
    
    var containerView = AlertContainerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    
    
    var donationTextFieldView = DonationTextFieldView()
    
    var dismissButten: FBButton?
    var actionButton: FBButton?
    var buttonStackView = UIStackView()
    
    var alertTitle: String = "Calculate your impact"
    var message: String?
    var dismissButtonTitle: String? = "Cancel"
    var actionButtonTite: String? = "Go"
    
    var outputStackView: UIStackView?
    
    var actionClosure: (()->())?
    
    var actionContentView = UIView()
    
    let padding: CGFloat = 15

    var output: SimpleImpact!
    
    var enteredAmount: Float = 1.0
    
    let currency = PersistenceManager.retrieveCurrency()
    
    var delegate: OutputCalculationVCDelegate?
    
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
        configureActionContentView()
        configureTextField()
        configureActionButtons()
    }
    
    fileprivate func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view.snp.centerY)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(240)
            maker.width.equalTo(280)
        }
    }
    
    fileprivate func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.text = alertTitle
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView.snp.top).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(28)
        }
    }
    
    fileprivate func configureActionContentView(){
        containerView.addSubview(actionContentView)
        
        actionContentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(60)
        }
        
    }
    
    fileprivate func configureTextField(){
        actionContentView.addSubview(donationTextFieldView)

        donationTextFieldView.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            maker.centerY.equalTo(actionContentView.snp.centerY)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
        }
        
        donationTextFieldView.currencyLabel.setTitle(currency.symbol, for: .normal)
        donationTextFieldView.currencyLabel.setTitleColor(.label, for: .normal)
        donationTextFieldView.currencyLabel.addTarget(self, action: #selector(currencyButtonPressed), for: .touchUpInside)
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
        dismissButten = FBButton()
        dismissButten?.setTitle("Cancel", for: .normal)
        dismissButten?.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        if(dismissButten != nil){
            buttonStackView.addArrangedSubview(dismissButten!)
        }
        
        actionButton = FBButton()
        actionButton?.setTitle("Go", for: .normal)
        actionButton?.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        if(actionButton != nil){
            buttonStackView.addArrangedSubview(actionButton!)
        }
        
    }
    
    fileprivate func configureExitButton(){
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
        dismissButten = FBButton()
        
        dismissButten?.setTitle("Return", for: .normal)
        dismissButten?.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        if(dismissButten != nil){
            buttonStackView.addArrangedSubview(dismissButten!)
        }
        
        actionButton = FBButton()
        actionButton?.setTitle("Ok", for: .normal)
        actionButton?.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        if(actionButton != nil){
            buttonStackView.addArrangedSubview(actionButton!)
        }
       
    }
    
    fileprivate func configureMessageLabel() {
        actionContentView.layer.borderWidth = 0
        
        outputStackView = UIStackView()
        let impactNumberLabel = FBTitleLabel(textAlignment: .center)
        let impactNameLabel = FBSubTitleLabel(textAlignment: .center)
        if(outputStackView != nil){
            actionContentView.addSubview(outputStackView!)
            outputStackView?.pinToEdges(of: actionContentView)
        }
        outputStackView?.addArrangedSubview(impactNumberLabel)
        outputStackView?.addArrangedSubview(impactNameLabel)
        outputStackView?.axis = .vertical
        outputStackView?.distribution = .fillEqually
        
        
        let value = output.costPerBeneficiary?.value ?? "1.0"
        var floatValue = Float(value) ?? 1.0
        floatValue = floatValue / currency.relativeValueToPound
        
        let impact = enteredAmount / floatValue
        
        let formatted = String(format: "%.0f", impact)
        
        impactNumberLabel.text = "\(formatted)"
        impactNumberLabel.textColor = .outputColor
        impactNumberLabel.font = UIFont.boldSystemFont(ofSize: 25)
        impactNameLabel.text = "\(output.name?.formatOutputName(with: currency, wording: .plural) ?? "")"
        impactNameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        impactNameLabel.textColor = .label
        impactNameLabel.numberOfLines = 2
        
        //messageLabel.pinToEdges(of: actionContentView)
    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc func backButtonPressed(){
        titleLabel.text = alertTitle
        dismissButten?.removeFromSuperview()
        dismissButten = nil
        actionButton?.removeFromSuperview()
        actionButton = nil
        buttonStackView.removeFromSuperview()
        outputStackView?.removeFromSuperview()
        configureTextField()
        configureActionButtons()
    }
    
    @objc func currencyButtonPressed(){
        delegate?.currencyButtonPressed()
    }
    
    @objc func actionButtonPressed(){
        guard let text = donationTextFieldView.textField.text,
              !text.isEmpty,
              text.isNumeric
        else { return }
        enteredAmount = Float(String(text)) ?? 1.0
        showImpact()
    }
    
    private func showImpact(){
        titleLabel.text = "Your donation may fund"
        donationTextFieldView.removeFromSuperview()
        configureMessageLabel()
        
        dismissButten?.removeFromSuperview()
        dismissButten = nil
        actionButton?.removeFromSuperview()
        actionButton = nil
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
