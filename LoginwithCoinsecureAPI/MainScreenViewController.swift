//
//  MainScreenViewController.swift
//  LoginwithCoinsecureAPI
//
//  Created by QTS Coder on 8/3/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    var username = UserDefaults().object(forKey: "username") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblWelcome.text = "Welcome \(username)"
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
