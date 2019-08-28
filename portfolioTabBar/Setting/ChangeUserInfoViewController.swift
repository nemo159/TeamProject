//
//  ChangeUserInfoViewController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 28/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

class ChangeUserInfoViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var valueTextView: [UITextView]!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var plusPhotoButton: UIButton!
    
    var users = [User]() //allUser
    var user: User? //User
    var doubleCheckFlag:Bool = false
    private var profileImage: UIImage?
    var ref:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        userInfo()
    }
    
    @IBAction func plusPhotoButtonPressed(_ sender: UIButton) {
        handlePlusPhoto()
    }
    
    @IBAction func doubleCheckedButtonPressed(_ sender: UIButton) {
        if self.nicknameTextField.text == "" {
            let alertController = UIAlertController(title: "중복확인", message:
                "별명을 입력해 주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.doubleCheckFlag = false
        }
        fetchAllUsers()
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let nickname = nicknameTextField.text else { return }
        guard let uid = user?.uid else { return }
        if doubleCheckFlag {
            ref.child("users").child(uid).updateChildValues(["nickname": nickname])
            self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "정보변경 실패", message:
                "별명을 확인해 주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.doubleCheckFlag = false
            self.resetInputFields()
            return
        }
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x58C1F9)
        //Button
        plusPhotoButton.setBorderColor(width: 0.5, color: myColor, corner: 140 / 2)
        //textView
        for i in 0..<3 {
            valueTextView[i].setBorderColor(width: 0.5, color: myColor)
        }
        //textField
        nicknameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        pwTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        pwCheckTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func resetInputFields() {
        nicknameTextField.isUserInteractionEnabled = true
        pwTextField.isUserInteractionEnabled = true
        pwCheckTextField.isUserInteractionEnabled = true
    }
    
    func userInfo() {
        if Auth.auth().currentUser != nil {
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid ?? "None"
            Database.database().fetchUser(withUID: uid, completion: {(user) in
                self.user = user
                let url = URL(string: (user.profileImageUrl)!)
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    self.plusPhotoButton.setImage(image, for: .normal)
                }catch let err {
                    print("Error : \(err.localizedDescription)")
                }
                self.nicknameTextField.placeholder = user.nickname
            })
        }
    }
    
    func fetchAllUsers() {
        Database.database().fetchAllUsers(includeCurrentUser: false, completion: { (users) in
            self.users = users
            
            if users.count == 0 {
                let alertController = UIAlertController(title: "중복확인", message:
                    "사용가능한 별명입니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
                self.doubleCheckFlag = true
            }
            
            for idx in 0 ..< users.count {
                if users[idx].nickname == self.nicknameTextField.text {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "중복된 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    self.resetInputFields()
                    self.doubleCheckFlag = false
                } else {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "사용가능한 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    self.doubleCheckFlag = true
                }
            }
        }) { (_) in
            print("Fetch Users Err in FollowTableView")
        }
    }
}

//MARK: - UITextFieldDelegates
extension ChangeUserInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UIImagePickerControllerDelegate
extension ChangeUserInfoViewController: UIImagePickerControllerDelegate {
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
