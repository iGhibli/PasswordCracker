//
//  Number.swift
//  PasswordCracker
//
//  Created by iGhibli on 2021/1/21.
//

import Foundation
import RealmSwift

class Number: Object {
    @objc dynamic var number = ""
    @objc dynamic var time: String = {
        Date().timeStamp
    }()
    @objc dynamic var cfmd = false
}

extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
