/*
As you walk through the door, a glowing humanoid shape yells in your direction. "You there! Your state appears to be idle. Come help us repair the corruption in this spreadsheet - if we take another millisecond, we'll have to display an hourglass cursor!"

The spreadsheet consists of rows of apparently-random numbers. To make sure the recovery process is on the right track, they need you to calculate the spreadsheet's checksum. For each row, determine the difference between the largest value and the smallest value; the checksum is the sum of all of these differences.

For example, given the following spreadsheet:

5 1 9 5
7 5 3
2 4 6 8
The first row's largest and smallest values are 9 and 1, and their difference is 8.
The second row's largest and smallest values are 7 and 3, and their difference is 4.
The third row's difference is 6.
In this example, the spreadsheet's checksum would be 8 + 4 + 6 = 18.

What is the checksum for the spreadsheet in your puzzle input?
*/

func inputData() -> [[Int]] {
    return stringsFromFile(named: "input")
        .map{ $0.split(separator: " ").map{ Int($0)! }}
        .filter{ $0.count > 0}
}

func checkrow1(_ row: [Int]) -> Int
{
    let minmax = row.reduce((Int.max,Int.min)) {
            (acc,i) in
            return (min(acc.0,i), max(acc.1,i))
        }
    return minmax.1 - minmax.0
}

func checksum1(_ rows: [[Int]]) -> Int
{
    return rows.map(checkrow1).reduce(0) {
        (acc, sum) in
        return acc + sum
    }
}

public func part1() -> Int {
    return checksum1(inputData())
}
/*
checkrow1([5, 1, 9, 5])
8 == checkrow1([5, 1, 9, 5])
4 == checkrow1([7, 5, 3])
6 == checkrow1([2, 4, 6, 8])
18 == checksum1([[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]])
*/
