// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Main {
    static func main() async {
        print("Start...")
        
        // Get symbol input from user
        print("Enter trading symbol (e.g., BTC-USDT): ", terminator: "")
        guard let symbol = readLine(), !symbol.isEmpty else {
            print("Invalid symbol.")
            return
        }
        
        // Get date input from user
        print("Enter VWAP start time (yyyy-MM-dd HH:mm:ss): ", terminator: "")
        guard let dateString = readLine(), !dateString.isEmpty else {
            print("Invalid date.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let vwapStartTime = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd HH:mm:ss.")
            return
        }
        
        let martingaleActor = MartingaleActor()
        _ = await martingaleActor.startSystem(symbol: symbol, vwapStartTime: vwapStartTime)
    }
}

