

import UIKit

protocol OutputCalculationVCDelegate {
    func currencyButtonPressed()
}

class OutputCalculationVC: UIViewController{
    
    var containerView = AlertContainerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    
    var actionContentView = ActionContentView()
    
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    
    var buttonStackView = UIStackView()
    var dismissButten: FBButton?
    var actionButton: FBButton?
    
    let padding: CGFloat = 15
    var output: SimpleImpact!
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
        configureActionContentView()
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
        titleLabel.text = "Calculate your impact"
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
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc func backButtonPressed(){
        titleLabel.text = "Calculate your impact"
        dismissButten?.removeFromSuperview()
        dismissButten = nil
        actionButton?.removeFromSuperview()
        actionButton = nil
        buttonStackView.removeFromSuperview()
        actionContentView.outputStackView?.removeFromSuperview()
        actionContentView.configureTextField()
        configureActionButtons()
    }
    
    @objc func actionButtonPressed(){
        guard let text = actionContentView.donationTextField.textField.text,
              !text.isEmpty,
              text.isNumeric
        else { return }
        actionContentView.enteredAmount = Float(String(text)) ?? 1.0
        showImpact()
    }
    
    private func showImpact(){
        titleLabel.text = "Your donation may fund"
        actionContentView.donationTextField.removeFromSuperview()
        actionContentView.configureImpactStackView  (output: output)
        
        dismissButten?.removeFromSuperview()
        dismissButten = nil
        actionButton?.removeFromSuperview()
        actionButton = nil
        buttonStackView.removeFromSuperview()
        
        configureExitButton()
    }
    
}


