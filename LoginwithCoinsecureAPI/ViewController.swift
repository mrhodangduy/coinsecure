//
//  ViewController.swift
//  LoginwithCoinsecureAPI
//
//  Created by QTS Coder on 8/3/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_RetypePassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        
        if txt_Name.text?.characters.count == 0 || txt_Email.text?.characters.count == 0
        {
            print("Name or Email are required")
        }
       
        else if (txt_Password.text?.characters.count)! < 5 || (txt_RetypePassword.text?.characters.count)! < 5
        {
            print("Password must be greater than 5 characters")
        }
        else
        {
            webService_SingUp()
        }
    }
    
    func webService_SingUp()
    {
        
        let url = URL(string: "https://api.coinsecure.in/v1/signup")
        
        var urlRequest = URLRequest(url: url!)
        
        let parameter = "name=\(txt_Name.text!)&email=\(txt_Email.text!)&password=\(txt_Password.text!)&repeatPassword=\(txt_RetypePassword.text!)"
        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameter.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, respone, error) in
            
            if error != nil
            {
                print(error!)
            }
            else
            {
                if let content = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: content, options: []) as? [String:AnyObject]
                        if let success_key = json?["success"] as? Bool
                        {
                            if success_key == true
                            {
                                DispatchQueue.main.async {
                                    self.displayAlert(nil, "\(String(describing: json?["message"] as! String))")
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    let mess  = json?["message"] as? String
                                    self.displayAlertWarning("Warning", "\(String(describing: mess))")
                                }
                                
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
    
    func displayAlert (_ title:String?, _ mess: String?)
    {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let btn = UIAlertAction(title: "Log In Now", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "gotoLogin", sender: self)

        }
        
        alert.addAction(btn)
        
        self.present(alert, animated: true, completion: nil)
    }
    func displayAlertWarning (_ title:String?, _ mess: String?)
    {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let btn = UIAlertAction(title: "Try Again", style: .default)
        alert.addAction(btn)
        self.present(alert, animated: true, completion: nil)
    }

    
}

