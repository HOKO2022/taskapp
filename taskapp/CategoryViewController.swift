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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        category = Category()

        let allCategory = realm.objects(Category.self)
        if allCategory.count != 0 {
            category.id = allCategory.max(ofProperty: "id")! + 1
        }
    }
    
    @IBAction func enter(_ sender: Any) {
        var singleCategory = true //同じ名前のカテゴリであるかを判定
        for category in categoryArray{
            if(category.name == self.categoryTextField.text){
                singleCategory = false
            }
        }
        if(self.categoryTextField.text != "" && singleCategory){
            try! realm.write {
                self.category.name = self.categoryTextField.text!
                self.realm.add(self.category, update: .modified)
            }
            self.categoryTextField.text = ""
        }
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
