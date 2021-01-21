//
//  commonFunction.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/21.
//

import Foundation

func LOG(_ msg: Any, file: String = #file, line: Int = #line, function: String = #function) {
    
    #if DEBUG
    
    let fileName = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    
    print("[\(fileName):\(line)] \(funcName) \(msg)")
    
    #endif
}
