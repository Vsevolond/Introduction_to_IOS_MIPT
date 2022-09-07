//
//  main.swift
//  FirstCourseSecondTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseSecondTaskChecker


let checker = Checker()

func first(arr: [Int]) -> (Int, Int) {
    let even = arr.filter {$0 % 2 == 0}
    let odd = arr.filter {$0 % 2 != 0}
    return (even.count, odd.count)
}


checker.checkFirstFunction(function: first)

func second(arr: [Checker.Circle]) -> [Checker.Circle] {
    var res = arr.reduce([]) {
        $1.color == Checker.Color.white ? $0 + [$1] : $0
    }
    res = arr.reduce(res) {
        $1.color == Checker.Color.black ? $0 + [Checker.Circle(radius: $1.radius * 2, color: $1.color)] : $0
    }
    res = arr.reduce(res) {
        $1.color == Checker.Color.blue ? $0 + [$1] : $1.color == Checker.Color.green ? $0 + [Checker.Circle(radius: $1.radius, color: Checker.Color.blue)] : $0
    }
    return res
}


checker.checkSecondFunction(function: second)

func third(arr : [Checker.EmployeeData]) -> [Checker.Employee] {
    var res = [Checker.Employee]()
    res = arr.reduce(into: []) {
        if let fullName = $1["fullName"], let salary = $1["salary"], let company = $1["company"], $1.count == 3 {
            $0 += [Checker.Employee(fullName: fullName, salary: salary, company: company)]
        }
    }
    return res
}


checker.checkThirdFunction(function: third)

func fourth(arr: [String]) -> [String : [String]] {
    var res = [String : [String]]()
    for name in arr {
        let key = String(name[name.startIndex])
        if res[key] != nil {
            res[key]! += [name]
        } else {
            res[key] = [name]
        }
    }
    res = res.filter {
        $0.value.count >= 2
    }
    for key in res.keys {
        res.updateValue(res[key]!.sorted(by: >), forKey: key)
    }
    return res
}


checker.checkFourthFunction(function: fourth)
