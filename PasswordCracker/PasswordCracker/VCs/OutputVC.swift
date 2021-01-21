//
//  OutputVC.swift
//  PasswordCracker
//
//  Created by iGhibli on 2021/1/20.
//

import UIKit
import SnapKit
import RealmSwift

class OutputVC: UIViewController {

    let realm = try! Realm()
    
    var numbers: Results<Number>?
    
    lazy var collection: UICollectionView = {
        let layout = NumbersCVFLayout.init()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(NumbersCell.self, forCellWithReuseIdentifier: NumbersCell.reuseIdentifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var getButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.backgroundColor = .link
        bt.setTitle("获取", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        bt.layer.masksToBounds = true
        bt.layer.cornerRadius = 8.0
        bt.addTarget(self, action: #selector(getNumbers(sender:)), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "随机获取"
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "command.circle"), style: .done, target: self, action:#selector(showSettingVC))
        navigationItem.rightBarButtonItem = barButtonItem
        
        view.addSubview(getButton)
        getButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-65)
            make.height.equalTo(45)
        }
        
        view.addSubview(collection)
        
        collection.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(getButton.snp.top).offset(-5)
        }
        
    }
    
    @objc func getNumbers(sender: UIButton) {
        // todo: 取数据
        numbers = realm.objects(Number.self).filter("cfmd == false")
        collection.reloadData()
    }
    
    @objc func showSettingVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVCID")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OutputVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumbersCell.reuseIdentifier, for: indexPath) as! NumbersCell
        cell.titleLabel.text = ""
        if numbers?.count ?? 0 > indexPath.item {
            if let num = numbers?[indexPath.item] {
                cell.titleLabel.text = num.number
                cell.titleLabel.textColor = num.cfmd ? .lightGray:.black
            }
        }
        return cell
    }
}

extension OutputVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if numbers?.count ?? 0 > indexPath.item {
            if let num = numbers?[indexPath.item] {
                do {
                    try realm.write {
                        num.cfmd = true
                    }
                    let cell = collection.cellForItem(at: indexPath) as! NumbersCell
                    cell.titleLabel.textColor = .lightGray
                } catch {
                    print(error)
                }
            }
        }
    }
}
