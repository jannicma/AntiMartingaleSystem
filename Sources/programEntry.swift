// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Main {
    static func main() async {        
        // Get symbol input from user
        print("Enter trading symbol (e.g., BTC-USDT): ", terminator: "")
        let defaultSymbol = "BTC-USDT"
        let symbolInput = readLine()
        let symbol = (symbolInput != nil && !symbolInput!.isEmpty) ? symbolInput! : defaultSymbol
        
        // Get date input from user
        print("Enter VWAP start time (yyyy-MM-dd HH:mm:ss): ", terminator: "")
        let defaultDateString = "2025-04-03 19:45:00"
        let dateInput = readLine()
        let dateString = (dateInput != nil && !dateInput!.isEmpty) ? dateInput! : defaultDateString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let vwapStartTime = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd HH:mm:ss.")
            return
        }
        
        print("""
            ------------------- Options --------------------
            close [x] = closes the trade it scaled into
            
            ---  ---  ---  ---  ---  ---  ---  ---  ---  ---
            
            """)
        
        let martingaleSystem = MartingaleSystem()
        await martingaleSystem.start(symbol: symbol, vwapStartTime: vwapStartTime)

        while true {
            let input = readLine() ?? ""
            if input == "close" || input == "x" {
                await martingaleSystem.stop()
                break
            }
        }
    }
}

