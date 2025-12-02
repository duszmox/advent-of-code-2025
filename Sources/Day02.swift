import Algorithms
import Foundation
struct Day02: AdventDay {
  var data: String

  var entities: [(Int, Int)] {
    data.split(separator: "\n").first!.split(separator: ",").map {
      let parts = $0.split(separator: "-")
      let first = Int(parts[0])!
      let second = Int(parts[1])!
      return (first, second)
    }
  }

  func part1() -> Any {
   var sum = 0
    entities.forEach { (start, end) in
      let log10Start = Int(floor(log10(Double(start))))
      let log10End = Int(floor(log10(Double(end))))
      if log10Start < log10End {
       var log10 = log10Start
        sum += sumOfDupesInRage(log10: log10, start: start)
        log10 += 1
        while log10 < log10End {
          sum += sumOfDupesInRage(log10: log10)
        }
        sum += sumOfDupesInRage(log10: log10End, end: end)
      } else {
        sum += sumOfDupesInRage(log10: log10Start, start: start, end: end)
      }
    }
    
    
    return sum
  }
  
  func sumOfDupesInRage(log10: Int) -> Int {
    guard log10 % 2 == 0 else { return 0 }
    return sumOfDupesInRage(log10: log10, start: Int(pow(10, Double(log10))), end: Int(pow(10, Double(log10 + 1))-1))
  }
  func sumOfDupesInRage(log10: Int, start: Int) -> Int {
    return sumOfDupesInRage(log10: log10, start: start, end: Int(pow(10, Double(log10 + 1))-1))
  }
  
  func sumOfDupesInRage(log10: Int, end: Int) -> Int {
    return sumOfDupesInRage(log10: log10, start: Int(pow(10, Double(log10))), end: end)
  }
  
  func sumOfDupesInRage(log10: Int, start: Int, end: Int) -> Int {
    guard log10 % 2 == 1 else { return 0 }
    var sum = 0
    let (startFirstHalf, startSecondHalf) = splitNumber(start, digits: log10)
    let (endFirstHalf, endSecondHalf) = splitNumber(end, digits: log10)
    let start, end: Int
    switch (startFirstHalf > startSecondHalf, endFirstHalf > endSecondHalf) {
    case (true, true):
      start = startFirstHalf
      end = endFirstHalf - 1
      
      break;
    case (true, false):
      start = startFirstHalf
      end = endFirstHalf
      
      break;
    case (false, true):
      start = startFirstHalf + 1
      end = endFirstHalf - 1
      
      break;
    case (false, false):
      start = startFirstHalf + 1
      end = endFirstHalf
      break;
    }
    (start...end).forEach { val in
      let rep = val*Int(pow(10.0, Double(log10 + 1) / 2)) + val
      sum += rep
    }
    return sum
  }

  func part2() -> Any {
    // I gave up xd I need to study, lets just bruteforce
    var sum = 0
    entities.forEach { (start, end) in
      (start...end).forEach { val in
        if isInvalid(val) {
           sum += val
       }
      }
    }
    return sum
  }
  
  func isInvalid(_ val: Int) -> Bool {
      let s = String(val)
      let n = s.count
      if n < 2 { return false }

      let chars = Array(s)

      for len in 1...(n / 2) {
          if n % len != 0 { continue }
          let repeats = n / len
          if repeats < 2 { continue }

          var isOk = true
          for k in 1..<repeats {
              for i in 0..<len {
                  if chars[i] != chars[k * len + i] {
                    isOk = false
                      break
                  }
              }
              if !isOk { break }
          }

          if isOk {
              return true
          }
      }

      return false
  }
  
  func splitNumber(_ value: Int, digits log10: Int) -> (firstHalf: Int, secondHalf: Int) {
      let halfDigits = Int(Double(log10 + 1) / 2)
      let divisor = Int(pow(10.0, Double(halfDigits)))

      let firstHalf = value / divisor
      let secondHalf = value % divisor

      return (firstHalf, secondHalf)
  }
}
