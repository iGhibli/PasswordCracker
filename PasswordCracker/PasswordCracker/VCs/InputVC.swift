//
//  InputVC.swift
//  PasswordCracker
//
//  Created by iGhibli on 2021/1/20.
//

import UIKit
import SnapKit
import RealmSwift

class InputVC: UIViewController {

    let realm = try! Realm()
    var currentNumber: Number?
    
    lazy var pwInputView: SPayPassWordView = {
        let pw = SPayPassWordView()
        pw.lenght = 5
        pw.borderColor = .link
        pw.borderRadius = 8.0
        pw.borderWidth = 2.0
        pw.delegate = self
        return pw
    }()
    
    lazy var tipLabel: UILabel = {
        let tip = UILabel()
        tip.isHidden = true
        tip.font = UIFont.systemFont(ofSize: 12.0)
        return tip
    }()
    
    lazy var inputButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("录入", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(inputAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "自主录入"
        print("Realm file path: " + Realm.Configuration.defaultConfiguration.fileURL!.absoluteString)
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .done, target: self, action:#selector(showSettingVC))
        navigationItem.rightBarButtonItem = barButtonItem
        
        view.addSubview(pwInputView)
        
        pwInputView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-100)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
        
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pwInputView.snp.top).offset(-5)
        }
        
        view.addSubview(inputButton)
        inputButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pwInputView.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
    }
    
    func inputEnabledChange(isEnabled: Bool, with msg: String) {
        if isEnabled {
            tipLabel.text = msg
            tipLabel.textColor = .green
            tipLabel.isHidden = false
            inputButton.backgroundColor = .link
            inputButton.isUserInteractionEnabled = true
        }else {
            tipLabel.text = msg
            tipLabel.textColor = .red
            tipLabel.isHidden = false
            inputButton.backgroundColor = .gray
            inputButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func inputAction(sender: UIButton) {
        do {
            try realm.write {
                if let tmp = currentNumber {
                    tmp.cfmd = true
                }
            }
            
            self.inputEnabledChange(isEnabled: false, with: "此密码已录入成功!")
        } catch {
            print(error)
        }
    }
    
    @objc func showSettingVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVCID")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pwInputView.textField.resignFirstResponder()
    }

}

extension InputVC: SPayPassWordViewDelegate {
    func cleanInput() {
        self.inputEnabledChange(isEnabled: false, with: "")
    }
    
    func entryComplete(password: String) {
        print("entryComplete" + password)
        // 从数据库里查询是否已经存在
        let results = realm.objects(Number.self).filter("number == %@", password)
        for result in results {
            if result.cfmd {
                self.inputEnabledChange(isEnabled: false, with: "此密码已经尝试过!")
            }else {
                self.inputEnabledChange(isEnabled: true, with: "")
                currentNumber = result
            }
        }
    }
    
}
