

import UIKit

class OutputCalculationVC: UIViewController{
    
    var containerView = AlertContainerView()
    var titleLabel = FBTitleLabel(textAlignment: .center)
    var messageLabel = FBSubTitleLabel(textAlignment: .center)
    var textField = FBTextField()
    
    var dismissButten = FBButton()
    var actionButton: FBButton?
    var buttonStackView = UIStackView()
    
    var alertTitle: String?
    var message: String?
    var dismissButtonTitle: String?
    var actionButtonTite: String?
    
    var actionClosure: (()->())?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, actionButtonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.dismissButtonTitle = actionButtonTitle
    }
    
    convenience init(title: String, message: String, actionButtonTitle: String, dismissButtonTitle: String, actionClosure: @escaping ()->()) {
        self.init(title: title, message: message, actionButtonTitle: dismissButtonTitle)
        self.actionButtonTite = actionButtonTitle
        self.actionClosure = actionClosure
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
        configureActionButtons()
        configureMessageLabel()
    }
    
    fileprivate func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? ""
        messageLabel.numberOfLines = 3
        messageLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.bottom.equalTo(dismissButten.snp.top).offset(-12)
        }
    }
    
    fileprivate func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view.snp.centerY)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(220)
            maker.width.equalTo(280)
        }
    }
    
    fileprivate func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = alertTitle ?? "Something went wrong!"
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView.snp.top).offset(padding)
            maker.left.equalTo(containerView.snp.left).offset(padding)
            maker.right.equalTo(containerView.snp.right).offset(-padding)
            maker.height.equalTo(28)
        }
    }
    
    fileprivate func configureActionButtons() {
        if(actionButtonTite == nil){
            containerView.addSubview(dismissButten)
            dismissButten.setTitle(dismissButtonTitle, for: .normal)
            dismissButten.snp.makeConstraints { (maker) in
                maker.height.equalTo(44)
                maker.left.equalTo(containerView.snp.left).offset(padding)
                maker.right.equalTo(containerView.snp.right).offset(-padding)
                maker.bottom.equalTo(containerView.snp.bottom).offset(-padding)
            }
            dismissButten.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        }else{
            
            containerView.addSubview(buttonStackView)
            buttonStackView.snp.makeConstraints { (maker) in
                maker.height.equalTo(44)
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

    }
    
    @objc func dismissButtonPressed(){
        dismiss(animated: true)
    }
    
    @objc func actionButtonPressed(){
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.actionClosure!()
        }
        
    }
    
}


