import Algorithms
import Foundation

struct Day06: AdventDay {

  init(data: String) {
    self.data = data
    var lines: [String] = data.split(separator: "\n").map(String.init)
    var lastLine = lines.popLast()!
    var currOp: (String, Int)? = (String(lastLine.removeFirst()), 0)
    for _ in 1...lastLine.count - 1 {
      let char = String(lastLine.removeFirst())
      guard char != " " else {
        currOp = (currOp!.0, currOp!.1 + 1)
        continue
      }
      operators.append(currOp!)
      currOp = (String(char), 0)
    }
    currOp = (currOp!.0, currOp!.1 + 2)
    operators.append(currOp!)
    numbers = {
      var cols: [[String]] = []
      var offset: Int = 0
      for (_, prefix) in operators {
        var col: [String] = []
        for line in lines {
          let num = line.prefix(offset + prefix).suffix(prefix)
          col.append(String(num))
        }
        offset += col.first!.count + 1
        cols.append(col)
      }
      return cols
    }()

  }
  var data: String

  var entities: Any? { nil }
  var operators: [(String, Int)] = []
  var numbers: [[String]]?

  func part1() -> Any {
    var result: Int = 0
    for (idx, op) in operators.enumerated() {
      var col: [Int] = []
      for num in numbers![idx] {
        col.append(Int(num.trimming(while: { $0.isWhitespace }))!)
      }
      result += doOp(op.0, arr: col)
    }
    return result
  }

  func part2() -> Any {
    var result: Int = 0
    let numbers = self.numbers!
    for (idx, op) in operators.enumerated() {
      var row = numbers[idx].map({ $0.compactMap { $0 } }).transposed()
      row = row.map({ $0.compactMap { $0 == " " ? nil : $0 } })
      let nums: [Int] = row.map({
        Int(String($0))!
      })

      result += doOp(op.0, arr: nums)

    }
    return result
  }

  func doOp(_ op: String, arr: [Int]) -> Int {
    switch op {
    case "+":
      return arr.reduce(0, +)
    case "*":
      return arr.reduce(1, *)
    default:
      return 0
    }
  }

}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
  // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
  func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
    guard let firstRow = self.first else { return [] }
    return firstRow.indices.map { index in
      self.map { $0[index] }
    }
  }
}
