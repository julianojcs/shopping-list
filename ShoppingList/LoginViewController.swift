//
//  LoginViewController.swift
//  ShoppingList
//
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelCopyright: UILabel!
    @IBOutlet weak var buttonSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = Auth.auth().currentUser {
            guard let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") else {return}
            navigationController?.pushViewController(listTableViewController, animated: false)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { result, error in
            guard let user = result?.user else {return}
            self.updateUserAndProceed(user: user)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(
            withEmail: textFieldEmail.text!,
            password: textFieldPassword.text!
        ) {
            result, error in
            if let error = error {
                let authErrorCode = AuthErrorCode.Code(rawValue: error._code)
                switch authErrorCode {
                case .emailAlreadyInUse:
                    print("E-mail already in use!")
                case .weakPassword:
                    print("Weak password!")
                default:
                    print("Erro: \(authErrorCode!)")
                }
            } else {
                print("User successfully created!")
                if let user = result?.user {
                    self.updateUserAndProceed(user: user)
                }
            }
        }
    }
    
    func updateUserAndProceed(user: User) {
        if textFieldName.text!.isEmpty {
            gotoMainScreen()
        } else {
            let request = user.createProfileChangeRequest()
            request.displayName = textFieldName.text!
            request.commitChanges { _ in
                self.gotoMainScreen()
            }
        }
    }
    
    func gotoMainScreen() {
        guard let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") else {return}
        show(listTableViewController, sender: nil)
    }
}

