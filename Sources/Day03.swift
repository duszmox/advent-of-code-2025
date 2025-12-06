import Algorithms

struct Day03: AdventDay {
  var data: String

  var banks: [String] {
    data.split(separator: "\n").map {
      String($0)
    }
  }

  func part1() -> Any {
    var sum = 0
    banks.forEach { bank in
      sum += biggestJoltage(bank)
    }
    return sum
  }

  func part2() -> Any {
    var sum = 0
    banks.forEach { bank in
      sum += biggest12Joltage(bank)
    }
    return sum
  }

  func biggestJoltage(_ bank: String) -> Int {
    var dp: [(Int, Int)] = []
    bank.enumerated().forEach { idx, joltStr in
      let jolt = Int(String(joltStr)) ?? 0
      guard idx > 0 else {
        dp.append((jolt, -1))
        return
      }
      let (prevA, prevB) = dp[idx - 1]
      guard idx < bank.count - 1 else {
        if prevB < jolt {
          dp.append((prevA, jolt))
        } else {
          dp.append((prevA, prevB))
        }
        return
      }

      if jolt > prevA {
        dp.append((jolt, -1))
      } else if prevB == -1 || prevB < jolt {
        dp.append((prevA, jolt))
      } else {
        dp.append((prevA, prevB))
      }

    }

    let (lastA, lastB) = dp.last!
    if lastB == -1 {
      fatalError("this shouldn't be possible \(dp.last ?? (-1, -1))")
    }

    return lastA * 10 + lastB
  }

  func biggest12Joltage(_ bank: String) -> Int {
    var dp: [[Int]] = []
    bank.enumerated().forEach { idx, joltStr in
      let jolt = Int(String(joltStr)) ?? 0
      guard idx > 0 else {
        dp.append([jolt])
        return
      }
      let prev = dp[idx - 1]
      if prev.count < 12 {
        dp.append(prev + [jolt])
        return
      }
      var max = prev
      var maxInt = joltArrToInt(prev)
      prev.enumerated().forEach { off, v in
        var prevArr = prev
        prevArr.remove(at: off)
        let localInt = joltArrToInt(prevArr + [jolt])
        if localInt > maxInt {
          max = prevArr + [jolt]
          maxInt = localInt
        }
      }
      dp.append(max)
    }

    let last = dp.last!
    let maxInt = joltArrToInt(last)

    return maxInt
  }

  func joltArrToInt(_ arr: [Int]) -> Int {
    arr.reduce(0) { $0 * 10 + $1 }
  }
}
