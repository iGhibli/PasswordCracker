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
        
        self.reloadData()
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
                self.alterCAction(tfStr: alterC.textFields?.first?.text)
            }))
            self.present(alterC, animated: true) { }
        }else if indexPath.section == 2 && indexPath.row == 0 {
            // 导出当前密码库
            DispatchQueue.main.async {
                HUD.flash(.label("开发中..."), onView: self.view, delay: 1.5)
            }
        }else if indexPath.section == 2 && indexPath.row == 1 {
            // 导入当前密码库
            DispatchQueue.main.async {
                HUD.flash(.label("开发中..."), onView: self.view, delay: 1.5)
            }
        }
    }
    
    func alterCAction(tfStr: String?) {
        
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: nil, subtitle: "密码库创建中"), onView: self.view)
        }
        
        if let str = tfStr, let count = Int(str) {
            self.createDB(count: count)
        }else {
            DispatchQueue.main.async {
                HUD.flash(.labeledError(title: nil, subtitle: "密码库创建失败"), onView: self.view, delay: 1.5)
            }
        }
    }
    
    func createDB(count: Int) {
        
        // 清空数据库
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch {
            print("error")
        }
        
        
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
            DispatchQueue.main.async {
                self.reloadData()
                HUD.flash(.labeledSuccess(title: nil, subtitle: "密码库创建成功"), onView: self.view, delay: 1.5)
            }
        }else {
            DispatchQueue.main.async {
                HUD.flash(.labeledError(title: nil, subtitle: "密码库创建失败"), onView: self.view, delay: 1.5)
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            let numbers = self.realm.objects(Number.self)
            self.totalNumber.text = "\(numbers.count)个"
            let cfmds = self.realm.objects(Number.self).filter("cfmd == true")
            self.cfmdNumber.text = "\(cfmds.count)个"
            let cfms = self.realm.objects(Number.self).filter("cfmd == false")
            self.cfmNumber.text = "\(cfms.count)个"
        }
    }
    
}

