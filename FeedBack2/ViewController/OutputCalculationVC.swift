

import UIKit

protocol OutputCalculationVCDelegate{
    func currencyButtonPressedFromOutputCalculationVC()
    func saveDonationTriggered(enteredAmount: Float)
}

final class OutputCalculationVC: UIViewController{
    
    var containerView = AlertContainerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    
    var actionContentView = ActionContentView()
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    var buttonStackView = UIStackView()
    
    let padding: CGFloat = 15
    var output: SimpleImpact!
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
        configureButtonStackView()
        configureInitialButtons()
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
        actionContentView.delegate = self
        actionContentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(60)
        }
    }
    
    fileprivate func configureButtonStackView() {
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
    }
    
    fileprivate func configureInitialButtons() {
        let dismissButten = FBButton()
        dismissButten.setTitle("Cancel", for: .normal)
        dismissButten.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(dismissButten)
        
        let actionButton = FBButton()
        actionButton.setTitle("Go", for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(actionButton)
    }
    
    fileprivate func configureExitButtons(){
        let dismissButten = FBButton()
        dismissButten.setTitle("Return", for: .normal)
        dismissButten.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(dismissButten)
        
        let saveButton = FBButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(saveButton)
        
        let actionButton = FBButton()
        actionButton.setTitle("Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        buttonStackView.addArrangedSubview(actionButton)
    }
    
    fileprivate func showInitialState() {
        titleLabel.text = "Calculate your impact"
        removeButtons()
        actionContentView.outputStackView.removeFromSuperview()
        actionContentView.configureTextField()
        configureInitialButtons()
    }
    
    fileprivate func showResultState(){
        titleLabel.text = "Your donation may fund"
        removeButtons()
        actionContentView.donationTextField.removeFromSuperview()
        actionContentView.configureImpactStackView(output: output)
        configureExitButtons()
    }
    
    fileprivate func removeButtons(){
        for subview in buttonStackView.arrangedSubviews{
            subview.removeFromSuperview()
        }
    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc func backButtonPressed(){
        showInitialState()
    }
    
    @objc func saveButtonPressed(){
        delegate?.saveDonationTriggered(enteredAmount: actionContentView.enteredAmount)
    }
    
    @objc func actionButtonPressed(){
        guard let text = actionContentView.donationTextField.textField.text,
              !text.isEmpty,
              text.isNumeric else { return }
        actionContentView.enteredAmount = Float(String(text)) ?? 1.0
        showResultState()
    }
}

extension OutputCalculationVC: ActionContentViewDelegate{
    func currencyButtonPressed() {
        delegate?.currencyButtonPressedFromOutputCalculationVC()
    }
}


