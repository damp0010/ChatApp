//
//  SignInViewController.swift
//  ChatApp
//
//  Created by 田中　徳充 on 2019/06/09.
//  Copyright © 2019 田中　徳充. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    /*** ここまで追加！ ***/
    override func viewDidLoad() {
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /*** ここから追加！ ***/
    
    //チャット画面への遷移メソッド
    func transitionToChatRoom() {
        performSegue(withIdentifier: "toChatRoom", sender: self)//"toChatRoom"というIDで識別
    }
    
    //Googleサインインに関するデリゲートメソッド
    //signIn:didSignInForUser:withError: メソッドで、Google ID トークンと Google アクセス トークンを
    //GIDAuthentication オブジェクトから取得して、Firebase 認証情報と交換します。
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        //最後に、認証情報を使用して Firebase での認証を行います
        Auth.auth().signInAndRetrieveData(with: credential) { (authDataResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("\nSignin succeeded\n")
            self.transitionToChatRoom()
        }
    }
    
  
    @IBAction func tappedSignOut(_ sender: Any) {
        /* ここから追加 */
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("SignOut is succeeded")
                reloadInputViews()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        
        /* ここまで追加 */}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


