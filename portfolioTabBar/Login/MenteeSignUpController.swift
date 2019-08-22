//
//  MenteeSignUpController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 20/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

class MenteeSignUpController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var plusPhotoButton: UIButton!
    var flag:Bool = false
    
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideKeyboardWhenTappedArroun()

        initLayout()
        
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
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
    
    
    @IBAction func plusPhotoButtomPressed(_ sender: UIButton) {
        handlePlusPhoto()
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
                let who = "Mentee User"
                Database.database().reference().child("users").child(uid).updateChildValues(["phoneNumber":phoneNumber])
                Database.database().reference().child("users").child(uid).child("who").setValue(who)
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
        guard let nickname = nicknameTextField.text else { return }
        guard let password = pwTextField.text else { return }
        guard let passwordCheck = pwCheckTextField.text else { return }
        emailTextField.isUserInteractionEnabled = false
        nameTextField.isUserInteractionEnabled = false
        nicknameTextField.isUserInteractionEnabled = false
        pwTextField.isUserInteractionEnabled = false
        pwCheckTextField.isUserInteractionEnabled = false
        
        signUpFlag()
                
        if password == passwordCheck && self.flag == true {
            Auth.auth().createMentee(withEmail: email, username: username, nickname: nickname, password: password, profileImage: profileImage) { (err) in
                if err != nil {
//                    self.resetInputFields()
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

        emailTextField.isUserInteractionEnabled = true
        nameTextField.isUserInteractionEnabled = true
        nicknameTextField.isUserInteractionEnabled = true
        pwTextField.isUserInteractionEnabled = true
        pwCheckTextField.isUserInteractionEnabled = true

    }
    
    func signUpFlag() {
        if nameTextField.text != "" && emailTextField.text != "" && pwTextField.text != "" && pwCheckTextField.text != "" && phoneNumberTF.text != "" && otpTextField.text != "" && nicknameTextField.text != "" {
            self.flag = true
        } else {
            let alertController = UIAlertController(title: "회원가입 실패", message:
                "작성하지 않은 항목이 있습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            resetInputFields()
            self.flag = false
        }
    }
    
}

//MARK: - UITextFieldDelegate

extension MenteeSignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UIImagePickerControllerDelegate
extension MenteeSignUpController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImage = originalImage
        }
        plusPhotoButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        plusPhotoButton.layer.borderWidth = 0.5
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
