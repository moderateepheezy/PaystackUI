//
//  PaytackPaymentLauncher.swift
//  PaystackUI
//
//  Created by SimpuMind on 1/22/18.
//

import Foundation
import UIKit
import Stripe
import CreditCardForm
import Paystack

class PaytackPaymentLauncher: NSObject {
    
    let mainBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let cardDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "CREDIT CARD DETAILS"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "images")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: 2)
        button.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pay", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.backgroundColor = .black
        button.layer.cornerRadius = 45 / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let creditCardFormView: CreditCardFormView = {
        let view = CreditCardFormView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let paymentTextField: STPPaymentCardTextField = {
        let ptf = STPPaymentCardTextField()
        ptf.translatesAutoresizingMaskIntoConstraints = false
        ptf.borderWidth = 1
        return ptf
    }()
    
    let blackView = UIView()
    //var checkOutVc: CheckoutVC?
    
    func setupViews(username: String, amount: String){
        
        if let window = UIApplication.shared.keyWindow{
            creditCardFormView.cardHolderString = username
            totalPriceLabel.text = amount
            
            blackView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            //
            //            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(mainBoxView)
            mainBoxView.addSubview(totalPriceLabel)
            mainBoxView.addSubview(cardDetailsLabel)
            mainBoxView.addSubview(paymentTextField)
            mainBoxView.addSubview(creditCardFormView)
            mainBoxView.addSubview(imageView)
            mainBoxView.addSubview(dismissButton)
            mainBoxView.addSubview(payButton)
            
            paymentTextField.delegate = self
            
            mainBoxView.topAnchor.constraint(equalTo: window.topAnchor, constant: 30).isActive = true
            mainBoxView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -30).isActive = true
            mainBoxView.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 20).isActive = true
            mainBoxView.rightAnchor.constraint(equalTo: window.rightAnchor, constant: -20).isActive = true
            mainBoxView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            mainBoxView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: -20).isActive = true
            
            _ = totalPriceLabel.anchor(mainBoxView.topAnchor, left: mainBoxView.leftAnchor, bottom: nil, right: mainBoxView.rightAnchor, topConstant: 45, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 20)
            
            _ = cardDetailsLabel.anchor(totalPriceLabel.bottomAnchor, left: mainBoxView.leftAnchor, bottom: nil, right: mainBoxView.rightAnchor, topConstant: 25, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 20)
            
            creditCardFormView.topAnchor.constraint(equalTo: cardDetailsLabel.bottomAnchor, constant: 25).isActive = true
            creditCardFormView.leftAnchor.constraint(equalTo: mainBoxView.leftAnchor, constant: 30).isActive = true
            creditCardFormView.rightAnchor.constraint(equalTo: mainBoxView.rightAnchor, constant: -30).isActive = true
            creditCardFormView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            _ = paymentTextField.anchor(creditCardFormView.bottomAnchor, left: mainBoxView.leftAnchor, bottom: nil, right: mainBoxView.rightAnchor, topConstant: 20, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 45)
            
            _ = imageView.anchor(paymentTextField.bottomAnchor, left: mainBoxView.leftAnchor, bottom: nil, right: mainBoxView.rightAnchor, topConstant: 15, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 20)
            
            
            payButton.bottomAnchor.constraint(equalTo: mainBoxView.bottomAnchor, constant: -30).isActive = true
            payButton.leftAnchor.constraint(equalTo: mainBoxView.leftAnchor, constant: 30).isActive = true
            payButton.rightAnchor.constraint(equalTo: mainBoxView.rightAnchor, constant: -30).isActive = true
            payButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            _ = dismissButton.anchor(mainBoxView.topAnchor, left: nil, bottom: nil, right: mainBoxView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
            
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
            }, completion: nil)
            
            
            dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            payButton.addTarget(self, action: #selector(handlePayment(button:)), for: .touchUpInside)
        }
        
    }
    
    func handlePayment(button: UIButton){
        let cardParams = PSTCKCardParams.init()
        cardParams.number = paymentTextField.cardNumber
        cardParams.cvc = paymentTextField.cvc
        cardParams.expYear = paymentTextField.expirationYear
        cardParams.expMonth = paymentTextField.expirationMonth
        //        checkOutVc?.handlePaymentWithPaystack(cardParams: cardParams, paymentTextField: paymentTextField, completed: {
        //            self.handleDismiss()
        //        })
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.blackView.removeFromSuperview()
            self.mainBoxView.removeFromSuperview()
            self.paymentTextField.removeFromSuperview()
        }) { (completed: Bool) in
            
        }
    }
}

extension PaytackPaymentLauncher: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationYear, cvc: textField.cvc)
        payButton.isEnabled = paymentTextField.isValid
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingCVC()
    }
}

extension UIView{
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}


