//
//  SettingVC.swift
//  PasswordCracker
//
//  Created by iGhibli on 2021/1/21.
//

import UIKit
import RealmSwift
import PKHUD

class SettingVC: UITableViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var totalNumber: UILabel!
    @IBOutlet weak var cfmNumber: UILabel!
    @IBOutlet weak var cfmdNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numbers = realm.objects(Number.self)
        totalNumber.text = "\(numbers.count)个"
        let cfmds = realm.objects(Number.self).filter("cfmd == true")
        cfmdNumber.text = "\(cfmds.count)个"
        let cfms = realm.objects(Number.self).filter("cfmd == false")
        cfmNumber.text = "\(cfms.count)个"
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // 新建密码库
            let alterC = UIAlertController(title: "创建密码库", message: "请输入要尝试密码的位数？\n(此操作会丢失当前已有密码库！！！)", preferredStyle: .alert)
            alterC.addTextField { (tf) in
                tf.placeholder = "位数"
                tf.keyboardType = .numberPad
            }
            alterC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            alterC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                HUD.show(.progress, onView: self.view)
                if let str = alterC.textFields?.first?.text,
                   let count = Int(str) {
                    self.createDB(count: count)
                }else {
                    HUD.flash(.error, onView: self.view, delay: 1.5)
                }
            }))
            self.present(alterC, animated: true) { }
        }else if indexPath.section == 2 && indexPath.row == 0 {
            // 导出当前密码库
            HUD.flash(.labeledImage(image: UIImage(systemName: "terminal.fill"), title: "开发中...", subtitle: "敬请期待！"), onView: self.view, delay: 1.5)
        }else if indexPath.section == 2 && indexPath.row == 2 {
            // 导入当前密码库
            HUD.flash(.labeledImage(image: UIImage(systemName: "terminal.fill"), title: "开发中...", subtitle: "敬请期待！"), onView: self.view, delay: 1.5)
        }
    }
    
    func createDB(count: Int) {

        var maxStr = ""
        for _ in 0..<count {
            maxStr.append("9")
        }
        
        if let max = Int(maxStr) {
            for num in 0...max {
                
                let formatStr = "%0\(count)d"
                
                let number = Number()
                number.number = String(format: formatStr, num)
                number.cfmd = false
                
                do {
                    try realm.write {
                        realm.add(number)
                    }
                } catch {
                    print("error")
                }
            }
            HUD.flash(.success, onView: self.view, delay: 1.5)
        }else {
            HUD.flash(.error, onView: self.view, delay: 1.5)
        }
    }
}

