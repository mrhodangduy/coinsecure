//
//  LoginViewController.swift
//  LoginwithCoinsecureAPI
//
//  Created by QTS Coder on 8/3/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var getcodebtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCode.alpha = 0
        txtPassword.alpha = 0
        loginbtn.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        
        if (txtEmail.text?.isEmpty)!
        {
            displayAlert("Warning", "Missing email", titleAction: "Try again")
        }
        else
        {
            webService_Login_initiate()
        }
    }
    @IBAction func Login(_ sender: UIButton) {
        
        if txtCode.text?.isEmpty != nil && txtPassword.text?.isEmpty != nil
        {
            webService_Login()
        }
        else if (txtCode.text?.isEmpty)! {
            displayAlert("Warning", "Missing code", titleAction: "Try again")
        }
        else
        {
            displayAlert("Warning", "Missing password", titleAction: "Try again")        }
    }
    
    
    func webService_Login_initiate()
    {
        let url = URL(string: "https://api.coinsecure.in/v1/login/initiate")
        var urlRequest = URLRequest(url: url!)
        
        let parameter = "loginID=\(txtEmail.text!)"
        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameter.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, respone, error) in
            
            if error != nil
            {
                print(error!)
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: content, options: []) as? [String: AnyObject]
                        let success_key = json?["success"] as? Bool
                        
                        if success_key == true
                        {
                            
                            DispatchQueue.main.async {
                                print(success_key!)
                                self.displayAlert(nil, "An email has been sent with temporary code. Please copy and paste that code in 'Code field' to continue. Thank you!", titleAction: "Continue")
                                self.txtCode.alpha = 1
                                self.txtPassword.alpha = 1
                                self.loginbtn.alpha = 1
                                self.getcodebtn.alpha = 0
                                
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                let mess = json?["message"] as? String
                                self.displayAlert("Warning", mess!, titleAction: "Try Again")
                                print(mess!)
                            }
                        }
                        
                    }
                    catch
                    {
                        return
                    }
                }
            }
            
        }
        task.resume()
    }
    
    func webService_Login ()
    {
        let url = URL(string: "https://api.coinsecure.in/v1/login")
        var urlRequest = URLRequest(url: url!)
        
        let parameter = "email=\(txtEmail.text!)&token=\(txtCode.text!)&password=\(txtPassword.text!)"
        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameter.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, respone, error) in
            
            if error != nil
            {
                print(error!)
            }
            else
            {
                if let content = data
                {
                    do {
                        let json = try JSONSerialization.jsonObject(with: content, options: []) as? [String:AnyObject]
                        let success_key = json?["success"] as? Bool
                        if success_key == true
                        {
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(self.txtEmail.text!, forKey: "username")
                                self.performSegue(withIdentifier: "gotoMainScreen", sender: self)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                let mess = json?["message"] as? String
                                self.displayAlert(nil, mess!, titleAction: "Try Again")
                            }
                        }
                        
                    } catch
                    {
                        return
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func displayAlert (_ title:String?, _ mess: String?, titleAction:String)
    {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let btn = UIAlertAction(title: titleAction, style: .default)
        alert.addAction(btn)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
