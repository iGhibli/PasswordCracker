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
    @IBOutlet weak var cfmdNumber: UILabel!
    @IBOutlet weak var cfmNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // 新建密码库
            let alterC = UIAlertController(title: "重置密码库", message: "将密码库重置为初始状态\n(此操作会丢失当前已确认密码！！！)", preferredStyle: .alert)
            alterC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            alterC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                if let defaultURL = Realm.Configuration.defaultConfiguration.fileURL,
                   let bundleURL = Bundle.main.path(forResource: "default", ofType: "realm") {
                    do {
                        try FileManager.default.removeItem(at: defaultURL)
                        try FileManager.default.copyItem(at: URL(fileURLWithPath: bundleURL), to: defaultURL)
                        self.reloadData()
                    } catch {
                        print(error)
                    }
                }
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

