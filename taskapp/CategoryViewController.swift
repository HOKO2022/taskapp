//
//  CategoryViewController.swift
//  taskapp
//
//  Created by HOKO on 2022/02/23.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    var category: Category!
    
    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "id", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        categoryTextField.text = ""
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }*/
    
    @IBAction func enter(_ sender: Any) {
        category = Category()
        let allCategory = realm.objects(Category.self)
        if allCategory.count != 0 {
            category.id = allCategory.max(ofProperty: "id")! + 1
        }
        
        var singleCategory = true //同じ名前のカテゴリであるかを判定
        for category in categoryArray{
            if(category.name == self.categoryTextField.text){
                singleCategory = false
            }
        }
        if(self.categoryTextField.text == ""){
            showAlert(titleText: "カテゴリの登録に失敗しました",
                      messageText:"カテゴリ名を入力してください。")
        } else if(singleCategory) {
            try! realm.write {
                self.category.name = self.categoryTextField.text!
                self.realm.add(self.category, update: .modified)
            }
            showAlert(titleText: "カテゴリの登録に成功しました",
                      messageText:"カテゴリ「" + self.categoryTextField.text! + "」を登録しました。")
            self.categoryTextField.text = ""
        } else {
            showAlert(titleText: "カテゴリの登録に失敗しました",
                      messageText:"カテゴリ「" + self.categoryTextField.text! + "」は既に存在しています。")
        }
    }
    
    private func showAlert(titleText title: String, messageText message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
