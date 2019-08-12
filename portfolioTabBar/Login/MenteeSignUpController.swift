//
//  MenteeSignUpController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 20/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

class MenteeSignUpController: UIViewController {
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideKeyboardWhenTappedArroun()

        initLayout()
        
    }

    @IBAction func phoneButtonPressed(_ sender: UIButton) {

        guard let phoneNumber = phoneNumberTF.text else {return}
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, err) in
            if err == nil {
                print("Succes: \(String(describing: verificationID))")
                guard let verifyID = verificationID else {return}
                UserDefaults.standard.set(verifyID,forKey: "verificationID")
                UserDefaults.standard.synchronize()
            } else {
                print("Unable to Secret Verification Code from Firebase", err?.localizedDescription as Any)
            }
        }
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        guard let otpNumber = otpTextField.text else {return}
        guard let phoneNumber = phoneNumberTF.text else {return}
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else {return}
        
        handleSignUp()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpNumber)
        
        Auth.auth().currentUser?.link(with: credential) { (user,err) in
            if err == nil {
                guard let uid = user?.user.uid else {return}
                Database.database().reference().child("users").child(uid).updateChildValues(["phoneNumber":phoneNumber])
                print("Anonymous account successfully upgraded", user as Any)
                DispatchQueue.main.async {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Error upgrading anonymous account", err as Any)
            }
            
        }
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x58C1F9)
        
        pwCheckTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        pwTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        emailTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        nameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        phoneNumberTF.setBorderColor(width: 0.5, color: myColor, corner: 5)
        otpTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
    }
    
    @objc private func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let username = nameTextField.text else { return }
        guard let password = pwTextField.text else { return }
        guard let passwordCheck = pwCheckTextField.text else { return }
        emailTextField.isUserInteractionEnabled = false
        nameTextField.isUserInteractionEnabled = false
        pwTextField.isUserInteractionEnabled = false
        pwCheckTextField.isUserInteractionEnabled = false
        
        if password == passwordCheck {
            Auth.auth().createMentee(withEmail: email, username: username, password: password) { (err) in
                if err != nil {
                    self.resetInputFields()
                    return
                }
   
            }
        } else {
            let alertController = UIAlertController(title: "회원가입 실패", message:
                "패스워드가 일치하지 않습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            resetInputFields()
        }

    }
    
    private func resetInputFields() {
        emailTextField.text = ""
        nameTextField.text = ""
        pwTextField.text = ""
        pwCheckTextField.text = ""
        
        emailTextField.isUserInteractionEnabled = true
        nameTextField.isUserInteractionEnabled = true
        pwTextField.isUserInteractionEnabled = true
        pwCheckTextField.isUserInteractionEnabled = true

    }
    
}

//MARK: - UITextFieldDelegate

extension MenteeSignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
